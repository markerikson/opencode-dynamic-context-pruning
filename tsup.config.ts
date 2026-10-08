import { defineConfig } from "tsup"

export default defineConfig({
    entry: ["index.ts"],
    format: ["esm"],
    dts: false,
    clean: true,
    sourcemap: true,
    // jsonc-parser: fixes its broken ESM imports. @opencode-ai/plugin: the vendored
    // build is loaded by path, where no package install provides it.
    noExternal: ["jsonc-parser", "@opencode-ai/plugin"],
})
