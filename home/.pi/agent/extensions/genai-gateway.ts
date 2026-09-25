import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { getBuiltinModels } from "@earendil-works/pi-ai/providers/all";

type GatewayConfig = {
  name?: string;
  baseUrl: string;
  baseUrlEnv?: string;
  api?: string;
  apiKeyEnv?: string;
  models: string[];
  aliases?: Record<string, string>;
};

function expandHome(path: string): string {
  return path === "~" ? homedir() : path.replace(/^~\//, `${homedir()}/`);
}

function readJson(path: string): unknown {
  return JSON.parse(readFileSync(expandHome(path), "utf8"));
}

function loadConfig(): GatewayConfig {
  const path = process.env.GENAI_GATEWAY_CONFIG
    ? expandHome(process.env.GENAI_GATEWAY_CONFIG)
    : `${homedir()}/.pi/agent/genai-gateway.json`;

  try {
    const config = readJson(path) as GatewayConfig;
    config.baseUrl = process.env[config.baseUrlEnv ?? "GENAI_GATEWAY_BASE_URL"] ?? config.baseUrl;
    if (!config.baseUrl || !Array.isArray(config.models)) {
      throw new Error(`baseUrl (or $${config.baseUrlEnv ?? "GENAI_GATEWAY_BASE_URL"}) and models are required`);
    }
    return config;
  } catch (error) {
    throw new Error(`Unable to load GenAI Gateway config at ${path}: ${String(error)}`);
  }
}

function apiKey(config: GatewayConfig): string {
  return process.env[config.apiKeyEnv ?? "GENAI_GATEWAY_PAT"] ?? "";
}

// Reuse Pi's model-specific limits and thinking controls, not one GPT-5
// profile for every model. This only reads the bundled catalog (no network).
const metadata = new Map(getBuiltinModels("openai").map((m) => [m.id, m]));

function model(id: string, aliases: Record<string, string>) {
  const baseId = aliases[id] ?? id.replace(/-\d{4}-\d{2}-\d{2}$/, "");
  const source = metadata.get(id) ?? metadata.get(baseId);
  if (!source) throw new Error(`Missing Pi model metadata for ${id}`);

  return {
    id,
    name: id === source.id ? source.name : `${source.name} (${id})`,
    reasoning: source.reasoning,
    thinkingLevelMap: source.thinkingLevelMap,
    input: source.input,
    // Gateway prices are not supplied by the support table; zero means unknown.
    cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
    contextWindow: source.contextWindow,
    maxTokens: source.maxTokens,
  };
}

export default function (pi: ExtensionAPI) {
  const config = loadConfig();
  const aliases = config.aliases ?? {};

  pi.registerProvider("genai-gateway", {
    name: config.name ?? "GenAI Gateway",
    baseUrl: config.baseUrl,
    apiKey: apiKey(config),
    api: config.api ?? "openai-responses",
    models: config.models.map((id) => model(id, aliases)),
  });
}
