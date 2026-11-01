/**
 * AGENTS.local.md Extension
 *
 * Loads AGENTS.local.md from the project root alongside AGENTS.md and
 * appends it to the system prompt's project_instructions section.
 * Meant for personal, gitignored workflow instructions.
 */

import { execFileSync } from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function localAgents(pi: ExtensionAPI) {
	let warned = false;

	pi.on("before_agent_start", (event, ctx) => {
		let content: string;
		try {
			content = fs.readFileSync(path.join(ctx.cwd, "AGENTS.local.md"), "utf8").trim();
		} catch {
			return;
		}

		// Guard the file's purpose: it should never reach the repo.
		if (!warned) {
			try {
				execFileSync("git", ["check-ignore", "-q", "AGENTS.local.md"], { cwd: ctx.cwd });
			} catch {
				warned = true;
				ctx.ui.notify("AGENTS.local.md is not in .gitignore — add it to avoid committing it.", "warning");
			}
		}

		const sections = event.systemPromptOptions.sections;
		const block = `<project_instructions path="AGENTS.local.md">\n${content}\n</project_instructions>`;
		sections.project_instructions = sections.project_instructions
			? `${sections.project_instructions}\n${block}`
			: block;
	});
}
