/**
 * tps.ts — generation speed (tok/s) + TTFT in the footer status line.
 *
 * Speedometer: 6 equal bands of 25 tok/s (<25, <50, <75, <100, <125, <150),
 * 3 segments per band = 18 cells, full bar at 150 tok/s. Fill is continuous
 * within a band (position of the current speed inside the band), animated:
 * the bar fills and drains smoothly, never jumps. Bar + number are colored
 * by the band's theme token while generating, dim otherwise.
 *
 * After the message ends the bar drains to zero while the number freezes
 * at the final value: `N tok/s  TTFT Xs`.
 *
 * pi version tested: 1.4.0 (@earendil-works/pi-coding-agent package.json).
 *
 * Field names verified against the real sources (pi-ai src/types.ts 0.82.x,
 * /usr/lib/pi/docs/extensions.md, /usr/lib/pi/docs/session-format.md,
 * /usr/lib/pi/docs/json.md):
 *
 *   AssistantMessage.usage (the only usage shape) =
 *     { input, output, cacheRead, cacheWrite, cacheWrite1h?, reasoning?, totalTokens,
 *       cost: { input, output, cacheRead, cacheWrite, total } }
 *     - output tokens field is `usage.output`.
 *     - `usage.reasoning?` is a SUBSET of `usage.output` (already included),
 *       NOT a separate bucket. So output speed = usage.output.
 *
 *   message_update event:
 *     - event.message = the ACCUMULATED assistant message (usage grows in place
 *       while streaming). Same object as event.assistantMessageEvent.partial.
 *     - event.assistantMessageEvent = token-by-token delta:
 *       { type: "text_delta" | "thinking_delta" | "toolcall_delta" | ..., delta: string, ... }.
 *       No token counter in the delta — only text. So mid-stream tokens come from
 *       event.message.usage.output when the provider reports them, else from an
 *       estimate over accumulated delta text.
 *     - toolcall_delta streams the tool-call ARGUMENTS: they are generated
 *       tokens, part of usage.output, and must be counted like text.
 *
 *   ctx.ui.setStatus(key: string, text: string | undefined): undefined clears.
 *   ANSI-colored statusText survives the footer render (verified against the
 *   1.4.0 binary: statuses are pushed raw, truncateToWidth is ANSI-aware).
 *   ctx.ui.theme (TUI mode) exposes fg()/style() with semantic tokens.
 *   ctx.hasUI === false in -p / json modes (guard all setStatus calls).
 *   TTFT start: "before_provider_request" fires right before the HTTP request is
 *     sent (once per LLM call); fallback is the agent_start timestamp.
 *
 * Burst guard: tps = tokens / (lastByte - firstByte) assumes token-by-token
 * streaming. Proxies and batched local servers can flush the whole SSE
 * response within a few ms, which collapses the denominator and produces
 * absurd numbers (verified: 60 tok in a 17 ms flush -> 3500+ tok/s). When all
 * deltas land inside BURST_SPAN_MS, the request window (send -> end) is used
 * instead: it understates speed (includes TTFT) but never lies upward.
 *
 * What can break on update: any rename of usage.output, the message_update /
 * before_provider_request event names, or setStatus signature.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const STATUS_KEY = "tps";
const FALLBACK_CHARS_PER_TOKEN = 4.0;
// Deltas arriving within this window mean the stream was buffered/batched
// somewhere between the model and us: flush time, not generation time.
const BURST_SPAN_MS = 50;

// ---- speedometer -----------------------------------------------------------

// Band upper edges (tok/s): 6 equal bands of 25, full bar at 150.
const BAND_EDGES = [25, 50, 75, 100, 125, 150];
const SEG_PER_BAND = 3;
const BAR_CELLS = BAND_EDGES.length * SEG_PER_BAND;

// Animation: display value eases toward the target every tick;
// drain is faster than rise (the tail should not linger).
const TICK_MS = 200;
const RISE = 0.3;
const FALL = 0.4;

// Color per band; index = number of edges the speed has passed.
const BAND_COLORS = ["error", "warning", "muted", "accent", "success", "success"];
const BAND_BOLD = [false, false, false, false, false, true];

function bandIndex(tps: number): number {
  let i = 0;
  while (i < BAND_EDGES.length && tps >= BAND_EDGES[i]) i++;
  return Math.min(i, BAND_EDGES.length - 1); // >=120 stays in the last band
}

/**
 * Target fill (0..BAR_CELLS): 3 segments per band, continuous inside the
 * band — the position of the speed between the band edges.
 */
function fillFor(tps: number): number {
  if (!(tps > 0)) return 0;
  let lower = 0;
  for (let i = 0; i < BAND_EDGES.length; i++) {
    const upper = BAND_EDGES[i];
    if (tps < upper) {
      return SEG_PER_BAND * i + ((tps - lower) / (upper - lower)) * SEG_PER_BAND;
    }
    lower = upper;
  }
  return BAR_CELLS;
}

function speedBar(fill: number): string {
  const n = Math.max(0, Math.min(BAR_CELLS, Math.round(fill)));
  return "█".repeat(n) + "░".repeat(BAR_CELLS - n);
}

/** One animation step toward the target; snaps when close enough. */
function nextFill(display: number, target: number): number {
  const diff = target - display;
  if (Math.abs(diff) < 0.05) return target;
  return display + diff * (diff > 0 ? RISE : FALL);
}

// ---- pure helpers (self-tested below) -------------------------------------

function computeTps(tokens: number, genMs: number): number {
  if (!(genMs > 0) || !Number.isFinite(tokens) || !Number.isFinite(genMs))
    return 0;
  return (tokens * 1000) / genMs;
}

/**
 * Generation window for one assistant message.
 * - No deltas seen: whole request window (send -> end), else 0 (unmeasurable).
 * - Deltas spread over >= BURST_SPAN_MS: first delta -> end (excludes TTFT).
 * - Deltas bunched inside BURST_SPAN_MS (buffered flush): whole request
 *   window. Measuring the flush would claim 10000+ tok/s; the full window
 *   includes TTFT, so it understates — the safe direction.
 */
function genWindowMs(
  firstDeltaAt: number,
  lastDeltaAt: number,
  endAt: number,
  reqAt: number,
): number {
  if (!(firstDeltaAt > 0)) {
    return reqAt > 0 ? Math.max(1, endAt - reqAt) : 0;
  }
  if (lastDeltaAt - firstDeltaAt < BURST_SPAN_MS) {
    return Math.max(1, endAt - (reqAt > 0 ? reqAt : firstDeltaAt));
  }
  return Math.max(1, endAt - firstDeltaAt);
}

function calibrateCharsPerToken(
  current: number,
  textChars: number,
  output: number,
): number {
  if (output > 0 && textChars > 0) return textChars / output;
  return current;
}

// ---- extension ------------------------------------------------------------

export default function (pi: ExtensionAPI) {
  let lastCtx: any = null;
  let timer: ReturnType<typeof setTimeout> | null = null;

  // run-level
  let agentStartAt = 0;
  let reqSentAt = 0; // timestamp of the last before_provider_request

  // per-assistant-message
  let streaming = false;
  let msgReqAt = 0; // request-send time for the current message
  let firstTokenAt = 0;
  let lastDeltaAt = 0;
  let ttftMs: number | null = null;
  let textChars = 0; // accumulated delta chars (text + thinking + toolcall args)
  let usageOutput = 0; // latest real counter from usage.output
  let charsPerToken = FALLBACK_CHARS_PER_TOKEN;

  // animation state (survives messages: bar eases between requests)
  let displayFill = 0; // smoothed fill, 0..BAR_CELLS
  let draining = false; // message ended, bar easing to zero
  let finalTps = 0; // frozen speed shown while draining
  let finalTtft = ""; // frozen TTFT text shown while draining

  const isRecord = (v: unknown): v is Record<string, unknown> =>
    typeof v === "object" && v !== null && !Array.isArray(v);

  const setStatus = (text: string | undefined) => {
    if (!lastCtx?.hasUI) return;
    try {
      lastCtx.ui.setStatus(STATUS_KEY, text);
    } catch {
      // no UI / rpc no-op: ignore
    }
  };

  const stopTimer = () => {
    if (timer !== null) {
      clearTimeout(timer);
      timer = null;
    }
  };

  const fmt = (n: number, d = 1) => (Number.isFinite(n) ? n.toFixed(d) : "0");

  /** theme-style helper; falls back to plain text when no theme (print mode). */
  const paint = (text: string, fg?: string, bold?: boolean): string => {
    const theme = lastCtx?.ui?.theme;
    if (!theme) return text;
    if (fg) return theme.style(text, { fg, bold });
    return theme.fg("dim", text);
  };

  const outputTokens = () =>
    usageOutput > 0 ? usageOutput : Math.round(textChars / charsPerToken);

  const ttftText = () =>
    ttftMs == null ? "" : `TTFT ${fmt(ttftMs / 1000)}s`;

  const render = () => {
    if (streaming) {
      if (firstTokenAt === 0) {
        // waiting for the first token: bar (whatever it holds) + TTFT, dim
        const elapsed = Date.now() - (msgReqAt || agentStartAt || Date.now());
        setStatus(
          [
            paint(speedBar(displayFill)),
            paint(`TTFT ${fmt(elapsed / 1000)}s`),
          ].join(" "),
        );
        return;
      }
      const genMs = genWindowMs(firstTokenAt, lastDeltaAt, Date.now(), msgReqAt);
      const tps = computeTps(outputTokens(), genMs);
      const bi = bandIndex(tps);
      const parts = [
        paint(speedBar(displayFill), BAND_COLORS[bi], BAND_BOLD[bi]),
        paint(`${fmt(tps)} tok/s`, BAND_COLORS[bi], BAND_BOLD[bi]),
      ];
      const ttft = ttftText();
      if (ttft) parts.push(paint(ttft));
      setStatus(parts.join(" "));
    } else if (draining) {
      const parts = [
        paint(speedBar(displayFill)),
        paint(`${fmt(finalTps)} tok/s`),
      ];
      if (finalTtft) parts.push(paint(finalTtft));
      setStatus(parts.join(" "));
    }
  };

  const startTimer = () => {
    stopTimer();
    const tick = () => {
      if (!streaming && !draining) {
        timer = null;
        return;
      }
      const target = streaming
        ? fillFor(
            firstTokenAt === 0
              ? 0
              : computeTps(
                  outputTokens(),
                  genWindowMs(firstTokenAt, lastDeltaAt, Date.now(), msgReqAt),
                ),
          )
        : 0;
      displayFill = nextFill(displayFill, target);
      if (draining && !streaming && displayFill <= 0.001) {
        draining = false;
        timer = null;
        // final frame: empty bar + frozen avg — render directly,
        // render() skips non-draining non-streaming states.
        const parts = [paint(speedBar(0)), paint(`${fmt(finalTps)} tok/s`)];
        if (finalTtft) parts.push(paint(finalTtft));
        setStatus(parts.join(" "));
        return;
      }
      render();
      timer = setTimeout(tick, TICK_MS);
    };
    timer = setTimeout(tick, TICK_MS);
  };

  // Tool-call arguments are generated tokens too: count them like text.
  const deltaText = (evt: unknown): string => {
    if (!isRecord(evt)) return "";
    if (
      evt.type === "text_delta" ||
      evt.type === "thinking_delta" ||
      evt.type === "toolcall_delta"
    ) {
      return typeof evt.delta === "string" ? evt.delta : "";
    }
    return "";
  };

  const contentText = (msg: unknown): string => {
    if (!isRecord(msg) || !Array.isArray(msg.content)) return "";
    let out = "";
    for (const block of msg.content) {
      if (!isRecord(block)) continue;
      if (block.type === "text" && typeof block.text === "string")
        out += block.text;
      else if (block.type === "thinking" && typeof block.thinking === "string")
        out += block.thinking;
    }
    return out;
  };

  const readUsageOutput = (msg: unknown): number => {
    if (!isRecord(msg)) return 0;
    const u = isRecord(msg.usage) ? msg.usage : null;
    return u && typeof u.output === "number" ? u.output : 0;
  };

  const finalize = (msg: unknown, stopReason: string) => {
    if (stopReason === "aborted" || stopReason === "error") {
      streaming = false;
      draining = false;
      setStatus(undefined); // Esc / abort: clear, don't stick
      return;
    }

    const output = readUsageOutput(msg);
    charsPerToken = calibrateCharsPerToken(charsPerToken, textChars, output);

    const endAt = Date.now();
    const reqAt = msgReqAt || agentStartAt;
    const genMs = genWindowMs(firstTokenAt, lastDeltaAt, endAt, reqAt);
    const tokens = output > 0 ? output : Math.round(textChars / charsPerToken);
    finalTps = computeTps(tokens, genMs);
    finalTtft = ttftText();

    // Finished: number freezes, bar slowly drains to zero.
    streaming = false;
    draining = true;
    startTimer();
  };

  pi.on("agent_start", async (_event, ctx) => {
    lastCtx = ctx;
    agentStartAt = Date.now();
    reqSentAt = 0;
    streaming = true;
    draining = false;
    msgReqAt = 0;
    firstTokenAt = 0;
    lastDeltaAt = 0;
    ttftMs = null;
    textChars = 0;
    usageOutput = 0;
    startTimer();
  });

  pi.on("before_provider_request", (_event, ctx) => {
    lastCtx = ctx;
    reqSentAt = Date.now();
  });

  pi.on("message_start", async (event, ctx) => {
    lastCtx = ctx;
    const msg = event?.message;
    if (!isRecord(msg) || msg.role !== "assistant") return;
    streaming = true;
    draining = false;
    msgReqAt = reqSentAt || Date.now();
    firstTokenAt = 0;
    lastDeltaAt = 0;
    ttftMs = null;
    textChars = 0;
    usageOutput = 0;
  });

  pi.on("message_update", async (event, ctx) => {
    lastCtx = ctx;
    const msg = event?.message;
    if (!isRecord(msg) || msg.role !== "assistant") return;
    if (!streaming) streaming = true;

    const u = readUsageOutput(msg);
    if (u > 0) usageOutput = u; // real counter, when provider reports mid-stream

    const delta = deltaText(event?.assistantMessageEvent);
    if (delta.length > 0) {
      lastDeltaAt = Date.now();
      if (firstTokenAt === 0) {
        firstTokenAt = lastDeltaAt;
        ttftMs = firstTokenAt - msgReqAt;
      }
      textChars += delta.length;
    } else {
      // Fallback: accumulated content length (event.message.content is accumulated).
      const acc = contentText(msg);
      if (acc.length > textChars) textChars = acc.length;
    }
  });

  pi.on("message_end", async (event, ctx) => {
    lastCtx = ctx;
    const msg = event?.message;
    if (!isRecord(msg) || msg.role !== "assistant") return;
    finalize(msg, typeof msg.stopReason === "string" ? msg.stopReason : "");
  });

  pi.on("agent_settled", async (_event, ctx) => {
    lastCtx = ctx;
    // Aborted without a final message_end: clear the stale live number.
    if (streaming) setStatus(undefined);
    streaming = false;
    // Keep the timer alive while the bar is still draining to zero.
    if (!draining) stopTimer();
  });

  pi.on("session_shutdown", async (_event, ctx) => {
    lastCtx = ctx;
    streaming = false;
    draining = false;
    stopTimer();
    setStatus(undefined);
  });
}

// ---- self-check (TPS_SELFTEST=1 node tps.ts) -------------------------------
if (process.env.TPS_SELFTEST === "1") {
  const assert = (cond: boolean, label: string) => {
    if (cond) {
      console.log(`ok: ${label}`);
    } else {
      console.error(`FAIL: ${label}`);
      process.exitCode = 1;
    }
  };

  assert(computeTps(0, 1000) === 0, "zero tokens -> 0 tps");
  assert(computeTps(100, 0) === 0, "zero time -> 0 tps");
  assert(Math.abs(computeTps(50, 2000) - 25) < 1e-9, "50 tok / 2s = 25 tps");
  assert(calibrateCharsPerToken(4.0, 0, 10) === 4.0, "no text keeps ratio");
  assert(calibrateCharsPerToken(4.0, 100, 0) === 4.0, "no output keeps ratio");
  assert(
    Math.abs(calibrateCharsPerToken(4.0, 400, 100) - 4.0) < 1e-9,
    "400 chars / 100 tok = 4.0",
  );
  assert(
    Math.abs(calibrateCharsPerToken(4.0, 300, 100) - 3.0) < 1e-9,
    "300 chars / 100 tok = 3.0",
  );

  // genWindowMs: trickle (deltas spread out) -> first-delta window
  assert(genWindowMs(1000, 2000, 2010, 500) === 1010, "trickle: end - first delta");
  // burst: all deltas inside BURST_SPAN_MS -> whole request window, not the flush
  assert(genWindowMs(1000, 1010, 1015, 500) === 515, "burst: end - request send");
  // burst without request time -> first delta (best available anchor)
  assert(genWindowMs(1000, 1010, 1015, 0) === 15, "burst, no reqAt: end - first delta");
  // no deltas at all (pure tool-call msg / accumulated content) -> request window
  assert(genWindowMs(0, 0, 1000, 400) === 600, "no deltas: end - request send");
  // no deltas, no request time -> unmeasurable, tps stays 0
  assert(genWindowMs(0, 0, 1000, 0) === 0, "nothing measured -> 0");
  // burst that would have produced absurd tps now stays sane:
  // 60 tokens over a 5 ms flush with request at t=500
  assert(
    computeTps(60, genWindowMs(1500, 1505, 1510, 500)) < 200,
    "burst flush no longer yields 10000+ tok/s",
  );

  assert(bandIndex(0) === 0 && bandIndex(24.9) === 0, "<25 -> band 0 (error)");
  assert(bandIndex(25) === 1 && bandIndex(49.9) === 1, "25-50 -> band 1 (warning)");
  assert(bandIndex(50) === 2 && bandIndex(74.9) === 2, "50-75 -> band 2 (muted)");
  assert(bandIndex(75) === 3 && bandIndex(99.9) === 3, "75-100 -> band 3 (accent)");
  assert(bandIndex(100) === 4 && bandIndex(124.9) === 4, "100-125 -> band 4 (success)");
  assert(bandIndex(125) === 5 && bandIndex(140) === 5, "125-150 -> band 5 (success bold)");
  assert(bandIndex(150) === 5 && bandIndex(500) === 5, "150+ stays in the last band");

  // continuous fill: 3 segments per band, position inside the band
  assert(fillFor(0) === 0, "0 tps -> 0 fill");
  assert(fillFor(-5) === 0, "negative tps -> 0 fill");
  assert(Math.abs(fillFor(12.5) - 1.5) < 1e-9, "half of band 0 -> 1.5");
  assert(Math.abs(fillFor(25) - 3) < 1e-9, "25 tps -> 3 fill");
  assert(Math.abs(fillFor(37.5) - 4.5) < 1e-9, "half of band 1 -> 4.5");
  assert(Math.abs(fillFor(50) - 6) < 1e-9, "50 tps -> 6 fill");
  assert(Math.abs(fillFor(75) - 9) < 1e-9, "75 tps -> 9 fill");
  assert(Math.abs(fillFor(100) - 12) < 1e-9, "100 tps -> 12 fill");
  assert(Math.abs(fillFor(112.5) - 13.5) < 1e-9, "half of band 4 -> 13.5");
  assert(Math.abs(fillFor(125) - 15) < 1e-9, "125 tps -> 15 fill");
  assert(Math.abs(fillFor(137.5) - 16.5) < 1e-9, "half of band 5 -> 16.5");
  assert(fillFor(150) === BAR_CELLS, "150 tps -> full");
  assert(fillFor(500) === BAR_CELLS, "500 tps -> full");

  // 18-cell bar
  assert(BAR_CELLS === 18, "6 bands x 3 segments = 18 cells");
  assert(speedBar(0) === "░".repeat(18), "bar empty");
  assert(speedBar(18) === "█".repeat(18), "bar full");
  assert(speedBar(6) === "██████" + "░".repeat(12), "bar 6/18");
  assert(speedBar(-3) === speedBar(0), "bar clamps below 0");
  assert(speedBar(99) === speedBar(18), "bar clamps above full");
  assert(speedBar(6.4) === speedBar(6), "bar rounds fill");

  // animation easing: moves toward the target, snaps when close
  assert(nextFill(0, 0) === 0, "no diff -> stays");
  const up = nextFill(0, 18);
  assert(up > 0 && up < 18, "rise moves toward target");
  const down = nextFill(18, 0);
  assert(down < 18 && down > 0, "drain moves toward zero");
  assert(18 - down > 18 - up, "drain step is larger than rise step");
  assert(nextFill(17.98, 18) === 18, "snaps when close");
  assert(nextFill(0.02, 0) === 0, "snaps to zero when close");
}
