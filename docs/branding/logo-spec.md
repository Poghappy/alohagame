## AlohaGameBot 前端 Logo/品牌替换规范（2025-10 版）

本规范参照 Next.js 15 Metadata API、现代浏览器图标规范与常见社媒 OG 标准，指导如何在 `packages/bytebot-ui` 中完成品牌替换。

### 1. 资源命名与路径

- 主 Logo（明/暗主题自动切换，优先 SVG）：
  - 浅色主题（深色图形）：`packages/bytebot-ui/public/alohagamebot_transparent_logo_dark.svg`
  - 深色主题（浅色图形）：`packages/bytebot-ui/public/alohagamebot_transparent_logo_white.svg`
- Favicon：`packages/bytebot-ui/public/favicon.svg`
- Apple Touch Icon（可选，180×180 PNG）：`packages/bytebot-ui/public/apple-touch-icon.png`
- Open Graph 图（1200×630 PNG）：`packages/bytebot-ui/public/og.png`

说明：保持上述文件名即可无代码改动替换 Logo；若需自定义文件名，请同步更新 `src/components/layout/Logo.tsx` 与 `src/components/layout/Header*.tsx` 的 `src`。

### 2. 组件使用规范

- 统一使用 `src/components/layout/Logo.tsx` 提供的 `Logo` 组件。
- 保留「挂载后渲染」以避免水合不一致：
  - 当未挂载时渲染占位 `<div className="h-8 w-[110px]" />`。
- `next/image` 参数：
  - `priority`：true（首屏）
  - `sizes`：`(max-width: 640px) 96px, (max-width: 1024px) 128px, 160px`
  - `alt`：使用品牌名，例如 `AlohaGameBot Logo`

### 3. Next.js 15 Metadata 配置要点

在 `src/app/layout.tsx`：

- `export const metadata: Metadata = { ... }`
  - `title` 使用对象形式，支持模板：`{ default, template }`
  - `icons`：包含 `icon`(svg)、`shortcut`、`apple`（如有）
  - `openGraph`：`title/description/url/siteName/images(1200×630)`
  - `twitter`：`card: summary_large_image`，与 OG 对齐
  - `metadataBase`：设置站点基址用于生成绝对 URL
- `export const viewport: Viewport`：配置 `themeColor`（明/暗两套）

### 4. 设计尺寸与文件建议

- SVG：优先，确保路径干净、无内嵌位图；图标边界留出 8–12% 安全区。
- PNG 备选：
  - `og.png`：1200×630，< 400KB，透明或纯色背景均可。
  - `apple-touch-icon.png`：180×180，避免细线与渐变。
- Favicon（SVG）：
  - 使用方形底或圆角矩形（建议 `rx=56`）以便在暗色主题下对比充分。

### 5. 文件替换步骤（推荐）

1) 导出两份主 Logo：
   - `alohagamebot_transparent_logo_dark.svg`（浅色主题用深色图）
   - `alohagamebot_transparent_logo_white.svg`（深色主题用浅色图）
2) 覆盖 `packages/bytebot-ui/public/` 同名文件。
3) 覆盖 `favicon.svg`、(可选) `apple-touch-icon.png`、`og.png`。
4) 运行/预览：`npm run dev`，检查首屏与切换主题显示。

### 6. 代码位置总览（如需自定义）

- 组件：
  - `src/components/layout/Logo.tsx`
  - `src/components/layout/HeaderSSR.tsx`
  - `src/components/layout/HeaderClient.tsx`
- 元数据：
  - `src/app/layout.tsx`（`metadata`、`viewport`）

### 7. 质量检查清单

- [ ] 明/暗主题下 Logo 对比度达标（WCAG AA）。
- [ ] `alt` 文本准确，品牌名称一致。
- [ ] 首屏 `Largest Contentful Paint` 未因过大图像受损（SVG 优先）。
- [ ] Favicon 在浏览器标签、移动主屏均清晰可辨。
- [ ] OG/Twitter 分享卡片显示正确标题与图像。

### 8. 相关脚本（可选）

- `packages/bytebot-ui/scripts/brand-update.ts`：批量替换 `Logo` 引用与 `public/` 文件。
- `packages/bytebot-ui/scripts/change-logo.js`：示例脚本，演示从旧路径到新路径的替换。

---

维护人：Cursor AI Assistant  · 更新时间：2025-10

