/**
 * HTTP/2 для запросов к моделям и прочего https-трафика pi.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

interface BunFetchInit extends RequestInit {
	protocol?: string;
}

export default function (pi: ExtensionAPI) {
	const orig = globalThis.fetch.bind(globalThis);
	// последние запросы для проверки через /http2
	const log: { url: string; h2: boolean; ok: boolean }[] = [];

	const patched = async (
		input: RequestInfo | URL,
		init?: BunFetchInit,
	): Promise<Response> => {
		const url =
			typeof input === "string"
				? input
				: input instanceof URL
					? input.href
					: input instanceof Request
						? input.url
						: String(input);
		if (url.startsWith("https://") && !init?.protocol) {
			try {
				const res = await orig(input, { ...init, protocol: "http2" });
				log.push({ url: url.split("?")[0]!, h2: true, ok: res.ok });
				if (log.length > 20) log.shift();
				return res;
			} catch (e) {
				// ALPN-отказ от h2 выглядит как ConnectionRefused до отправки тела
				if ((e as { code?: string }).code === "ConnectionRefused") {
					const res = await orig(input, init);
					log.push({ url: url.split("?")[0]!, h2: false, ok: res.ok });
					if (log.length > 20) log.shift();
					return res;
				}
				throw e;
			}
		}
		return orig(input, init);
	};

	globalThis.fetch = patched as typeof globalThis.fetch;

	pi.registerCommand("http2", {
		description: "Show recent fetches through the h2 wrapper",
		handler: async (_name, ctx) => {
			if (log.length === 0) {
				ctx.ui.notify("No fetches intercepted yet", "info");
				return;
			}
			ctx.ui.notify(
				log
					.map((e) => `${e.h2 ? "h2" : "h1"} ${e.ok ? "ok" : "err"} ${e.url}`)
					.join("\n"),
				"info",
			);
		},
	});
}
