#!/usr/bin/env tsx
import fs from "fs";
import path from "path";

interface BrandArgs {
  name: string;
  description?: string;
  darkLogo?: string;
  lightLogo?: string;
}

function parseArgs(): BrandArgs {
  const args = process.argv.slice(2);
  const result: Record<string, string> = {};
  for (const arg of args) {
    const [k, ...rest] = arg.split("=");
    const v = rest.join("=");
    if (k && v) result[k.replace(/^--/, "")] = v;
  }
  if (!result.name) {
    console.error(
      "Missing --name=NewBrand. Example: pnpm --filter bytebot-ui brand:update -- --name=MyBrand --description=Desc --darkLogo=/logo_white.svg --lightLogo=/logo_dark.svg"
    );
    process.exit(1);
  }
  return {
    name: result.name,
    description: result.description,
    darkLogo: result.darkLogo,
    lightLogo: result.lightLogo,
  };
}

function updateLayoutMetadata(uiRoot: string, name: string, description?: string) {
  const file = path.join(uiRoot, "src/app/layout.tsx");
  if (!fs.existsSync(file)) return;
  const code = fs.readFileSync(file, "utf8");
  const updated = code
    .replace(/title:\s*"[^"]+"/, `title: "${name}"`)
    .replace(/description:\s*"[^"]+"/, `description: "${description ?? name}"`);
  fs.writeFileSync(file, updated, "utf8");
}

function updateLogoComponent(uiRoot: string, name: string, darkLogo?: string, lightLogo?: string) {
  const file = path.join(uiRoot, "src/components/layout/Logo.tsx");
  if (!fs.existsSync(file)) return;
  let code = fs.readFileSync(file, "utf8");
  code = code.replace(/alt\s*=\s*"[^"]+"/g, `alt="${name} Logo"`);
  if (darkLogo) {
    code = code.replace(/"\/alohagamebot_transparent_logo_white\.svg"/g, `"${darkLogo}"`);
  }
  if (lightLogo) {
    code = code.replace(/"\/alohagamebot_transparent_logo_dark\.svg"/g, `"${lightLogo}"`);
  }
  fs.writeFileSync(file, code, "utf8");
}

function copyIfProvided(uiRoot: string, darkLogo?: string, lightLogo?: string) {
  const pubDir = path.join(uiRoot, "public");
  if (!fs.existsSync(pubDir)) fs.mkdirSync(pubDir, { recursive: true });

  const copyOne = (srcPath: string | undefined, destName: string) => {
    if (!srcPath) return;
    const absSrc = path.isAbsolute(srcPath) ? srcPath : path.join(process.cwd(), srcPath);
    const dest = path.join(pubDir, destName);
    fs.copyFileSync(absSrc, dest);
  };

  copyOne(darkLogo, "alohagamebot_transparent_logo_white.svg");
  copyOne(lightLogo, "alohagamebot_transparent_logo_dark.svg");
}

function main() {
  const args = parseArgs();
  const uiRoot = path.join(__dirname, "..");
  updateLayoutMetadata(uiRoot, args.name, args.description);
  updateLogoComponent(uiRoot, args.name, args.darkLogo, args.lightLogo);
  copyIfProvided(uiRoot, args.darkLogo, args.lightLogo);
  console.log("Brand updated:", args);
}

main();


