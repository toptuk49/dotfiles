import type { Plugin } from "@opencode-ai/plugin";

const fileURL = new URL("../rules/commit-rules.md", import.meta.url);

export const CommitRulesPlugin: Plugin = async ({ client }) => {
  const rules = await Bun.file(fileURL).text();
  return {
    "experimental.chat.system.transform": async (input, output) => {
      if (input.sessionID === undefined) return;
      const { data } = await client.session.get({
        path: { id: input.sessionID },
      });
      if (!data?.agent) return;
      if (data.agent !== "build") return;
      output.system?.push(`Instructions from: ${fileURL.pathname}\n${rules}`);
    },
  };
};
