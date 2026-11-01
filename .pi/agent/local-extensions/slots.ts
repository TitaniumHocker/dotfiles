/**
 * slots.ts — a slot machine that spins in the footer status line on every
 * agent request. Reels spin while the agent works and settle one-by-one
 * when the run finishes. Three matching reels blink the win line (warning
 * color) a few times, then hold it lit until the next request.
 *
 * Hooks (same surface as tps.ts, pi 0.82.1):
 *   pi.on("agent_start", (event, ctx))   — fires once per user request
 *   pi.on("agent_settled", (event, ctx)) — fires when the run is done
 *   ctx.ui.setStatus(key, text|undefined) — footer extension-status slot
 *   ctx.hasUI === false in -p / json modes (guard all setStatus calls)
 *
 * Auto-discovered: drop in ~/.pi/agent/extensions/.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const STATUS_KEY = "slots";
const SPIN_MS = 90; // reel cycle cadence while the agent is working
const SETTLE_STEP_MS = 150; // stagger between reel stops on settle
const FLASH_MS = 350; // blink cadence on a win
const FLASH_COUNT = 10; // blinks before holding the win line lit

const SYMBOLS = ["🍒", "🍋", "🍊", "🍇", "🔔", "⭐", "💎", "🍀"];

const rand = (): string => SYMBOLS[Math.floor(Math.random() * SYMBOLS.length)]!;

export default function (pi: ExtensionAPI) {
  let lastCtx: any = null;
  let timer: ReturnType<typeof setTimeout> | null = null;

  let reels: string[] = [SYMBOLS[0]!, SYMBOLS[0]!, SYMBOLS[0]!];
  let stopped: boolean[] = [true, true, true];
  let final: string[] = ["", "", ""];
  let settleStart = 0;
  let flashesLeft = 0;
  let flashOn = false;

  const setStatus = (text: string | undefined) => {
    if (!lastCtx?.hasUI) return;
    try {
      lastCtx.ui.setStatus(STATUS_KEY, text);
    } catch {
      // no UI / rpc no-op: ignore
    }
  };

  const themed = (color: string, text: string): string => {
    try {
      return lastCtx?.ui?.theme?.fg?.(color, text) ?? text;
    } catch {
      return text;
    }
  };

  const stopTimer = () => {
    if (timer !== null) {
      clearTimeout(timer);
      timer = null;
    }
  };

  const tick = () => {
    // Lock reels whose settle time has elapsed (reel i settles at i*SETTLE_STEP_MS).
    if (settleStart > 0) {
      const elapsed = Date.now() - settleStart;
      for (let i = 0; i < 3; i++) {
        if (!stopped[i] && elapsed >= SETTLE_STEP_MS * i) {
          stopped[i] = true;
          reels[i] = final[i]!;
        }
      }
    }
    // Advance still-spinning reels.
    for (let i = 0; i < 3; i++) {
      if (!stopped[i]) reels[i] = rand();
    }
    setStatus(`🎰 ${reels.map((r) => `[${r}]`).join("")}`);

    if (stopped.every(Boolean)) {
      timer = null;
      const win = !!final[0] && final[0] === final[1] && final[1] === final[2];
      if (win) {
        flashesLeft = FLASH_COUNT;
        flashOn = false;
        flashStep();
      }
      return;
    }
    timer = setTimeout(tick, SPIN_MS);
  };

  // Win: blink the settled line a few times, then hold it lit.
  const flashStep = () => {
    const line = `🎰 ${final.map((r) => `[${r}]`).join("")}`;
    if (flashesLeft <= 0) {
      setStatus(themed("warning", line));
      timer = null;
      return;
    }
    flashesLeft--;
    flashOn = !flashOn;
    setStatus(flashOn ? themed("warning", line) : undefined);
    timer = setTimeout(flashStep, FLASH_MS);
  };

  pi.on("agent_start", async (_event, ctx) => {
    lastCtx = ctx;
    stopTimer();
    final = [rand(), rand(), rand()];
    stopped = [false, false, false];
    reels = [rand(), rand(), rand()];
    settleStart = 0;
    setStatus(undefined);
    tick();
  });

  pi.on("agent_settled", async (_event, ctx) => {
    lastCtx = ctx;
    settleStart = Date.now();
    // tick keeps running and locks reels as time elapses.
  });

  pi.on("session_shutdown", async (_event, ctx) => {
    lastCtx = ctx;
    stopTimer();
    setStatus(undefined);
  });
}
