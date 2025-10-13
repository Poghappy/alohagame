### Bytebot UI 品牌与 Logo 更换指南

#### 一键替换命令
在 `packages/bytebot-ui` 目录下执行（或在仓库根目录用 pnpm filter 指定）：

```bash
pnpm --filter bytebot-ui brand:update -- \
  --name="YourBrand" \
  --description="Your brand description" \
  --darkLogo="/absolute/or/relative/path/logo_white.svg" \
  --lightLogo="/absolute/or/relative/path/logo_dark.svg"
```

- `--name`：品牌名称（会写入 `src/app/layout.tsx` 的 `metadata.title`）
- `--description`：品牌描述（会写入 `metadata.description`，未提供时与 name 相同）
- `--darkLogo`：深色主题下使用的浅色图（目标文件名：`public/alohagamebot_transparent_logo_white.svg`）
- `--lightLogo`：浅色主题下使用的深色图（目标文件名：`public/alohagamebot_transparent_logo_dark.svg`）

脚本会：
- 覆盖 UI 的品牌名称与描述
- 更新 `Logo.tsx` 的 `alt` 文案
- 如果提供了 logo 路径，将复制并覆盖为当前 UI 使用的两个 svg 文件名

#### 相关文件
- `src/app/layout.tsx`：页面 `Metadata`（title/description）
- `src/components/layout/Logo.tsx`：Logo 组件，深浅主题自动切换
- `public/alohagamebot_transparent_logo_dark.svg`
- `public/alohagamebot_transparent_logo_white.svg`

#### 注意
- 建议提供 SVG 矢量 logo，保证在不同分辨率下清晰
- 若沿用默认文件名，UI 无需改动即可生效
- 若自定义不同文件名，请配合修改 `Logo.tsx` 中的路径（脚本已尝试自动替换）

# 🎨 Logo 更换指南

## ⚠️ 重要提醒

在更换 logo 时，需要特别注意避免 Next.js 水合错误。以下是详细的注意事项和最佳实践。

## 🔍 问题根源

当 logo 从条件渲染（`mounted` 状态控制）改为直接渲染时，会触发水合错误：

### 修改前（安全）：
```tsx
{mounted ? (
  <Image src={logoUrl} alt="Logo" />
) : (
  <div className="h-8 w-[110px]" /> // 占位符
)}
```

### 修改后（可能有问题）：
```tsx
<Image src={logoUrl} alt="Logo" />
```

## 🛡️ 防止水合错误的方法

### 方法 1：保持条件渲染（推荐）
```tsx
export function Header() {
  const [mounted, setMounted] = useState(false);
  
  useEffect(() => {
    setMounted(true);
  }, []);

  return (
    <header>
      {mounted ? (
        <Image src={logoUrl} alt="Logo" />
      ) : (
        <div className="h-8 w-[110px]" />
      )}
    </header>
  );
}
```

### 方法 2：使用 suppressHydrationWarning
```tsx
<Image 
  src={logoUrl} 
  alt="Logo" 
  suppressHydrationWarning 
/>
```

### 方法 3：使用 ClientOnly 组件
```tsx
import { ClientOnly } from '../common/ClientOnly';

<ClientOnly fallback={<div className="h-8 w-[110px]" />}>
  <Image src={logoUrl} alt="Logo" />
</ClientOnly>
```

## 📋 更换 Logo 的步骤

### 1. 准备阶段
- [ ] 确认新 logo 文件已准备好
- [ ] 检查 logo 尺寸和格式
- [ ] 准备深色和浅色版本（如果需要）

### 2. 安全更换步骤
```bash
# 1. 备份当前 Header 组件
cp src/components/layout/HeaderSSR.tsx src/components/layout/HeaderSSR.tsx.backup

# 2. 更新 logo 路径
# 在 HeaderSSR.tsx 中修改：
# 从："/alohagamebot_transparent_logo_white.svg"
# 到："/your-new-logo-white.svg"

# 3. 测试水合错误
npm run dev
# 检查浏览器控制台是否有水合错误
```

### 3. 验证步骤
- [ ] 检查深色主题下的 logo 显示
- [ ] 检查浅色主题下的 logo 显示
- [ ] 检查浏览器控制台是否有水合错误
- [ ] 检查页面加载性能
- [ ] 测试不同浏览器和扩展环境

## 🎯 最佳实践

### ✅ 推荐做法

1. **保持条件渲染**
```tsx
{mounted ? <Image src={logoUrl} /> : <div className="logo-placeholder" />}
```

2. **使用 suppressHydrationWarning**
```tsx
<Image src={logoUrl} suppressHydrationWarning />
```

3. **添加加载状态**
```tsx
const [logoLoaded, setLogoLoaded] = useState(false);
```

4. **优化图片加载**
```tsx
<Image 
  src={logoUrl} 
  alt="Logo"
  priority
  onLoad={() => setLogoLoaded(true)}
/>
```

### ❌ 避免的做法

1. **不要直接替换条件渲染**
```tsx
// ❌ 错误：直接替换
<Image src={logoUrl} />

// ✅ 正确：保持条件渲染
{mounted ? <Image src={logoUrl} /> : <div />}
```

2. **不要忽略水合警告**
```tsx
// ❌ 错误：忽略警告
console.log('Hydration warning ignored');

// ✅ 正确：使用 suppressHydrationWarning
<Image suppressHydrationWarning />
```

## 🔧 常见问题解决

### 问题 1：Logo 闪烁
**原因**：服务器端和客户端渲染不一致
**解决**：
```tsx
const [mounted, setMounted] = useState(false);

useEffect(() => {
  setMounted(true);
}, []);

return (
  <div className="logo-container">
    {mounted ? (
      <Image src={logoUrl} alt="Logo" />
    ) : (
      <div className="logo-placeholder" />
    )}
  </div>
);
```

### 问题 2：主题切换时 logo 不更新
**原因**：主题状态在服务器端和客户端不同步
**解决**：
```tsx
const { resolvedTheme } = useTheme();
const [mounted, setMounted] = useState(false);

useEffect(() => {
  setMounted(true);
}, []);

if (!mounted) {
  return <div className="logo-placeholder" />;
}

return (
  <Image 
    src={resolvedTheme === "dark" ? darkLogo : lightLogo}
    alt="Logo"
  />
);
```

### 问题 3：浏览器扩展干扰
**原因**：翻译扩展修改 DOM
**解决**：
```tsx
<Image 
  src={logoUrl} 
  alt="Logo"
  suppressHydrationWarning
/>
```

## 📊 测试清单

### 功能测试
- [ ] 深色主题 logo 显示正确
- [ ] 浅色主题 logo 显示正确
- [ ] 主题切换时 logo 更新
- [ ] 页面刷新后 logo 正常显示

### 性能测试
- [ ] Logo 加载时间合理
- [ ] 无布局偏移（CLS）
- [ ] 无水合错误

### 兼容性测试
- [ ] Chrome 浏览器
- [ ] Firefox 浏览器
- [ ] Safari 浏览器
- [ ] 移动端浏览器
- [ ] 有翻译扩展的环境

## 🚨 紧急回滚

如果更换 logo 后出现严重问题：

```bash
# 1. 恢复备份文件
cp src/components/layout/HeaderSSR.tsx.backup src/components/layout/HeaderSSR.tsx

# 2. 重启开发服务器
npm run dev

# 3. 检查是否恢复正常
```

## 📝 总结

更换 logo 时最重要的原则：
1. **保持条件渲染**或使用 `suppressHydrationWarning`
2. **充分测试**各种主题和浏览器环境
3. **准备回滚方案**以防出现问题
4. **监控水合错误**并及时修复

记住：预防胜于治疗！在更换 logo 前就考虑好水合问题，可以避免很多麻烦。

# 🎨 Logo 更换指南

## ⚠️ 重要提醒

在更换 logo 时，需要特别注意避免 Next.js 水合错误。以下是详细的注意事项和最佳实践。

## 🔍 问题根源

当 logo 从条件渲染（`mounted` 状态控制）改为直接渲染时，会触发水合错误：

### 修改前（安全）：
```tsx
{mounted ? (
  <Image src={logoUrl} alt="Logo" />
) : (
  <div className="h-8 w-[110px]" /> // 占位符
)}
```

### 修改后（可能有问题）：
```tsx
<Image src={logoUrl} alt="Logo" />
```

## 🛡️ 防止水合错误的方法

### 方法 1：保持条件渲染（推荐）
```tsx
export function Header() {
  const [mounted, setMounted] = useState(false);
  
  useEffect(() => {
    setMounted(true);
  }, []);

  return (
    <header>
      {mounted ? (
        <Image src={logoUrl} alt="Logo" />
      ) : (
        <div className="h-8 w-[110px]" />
      )}
    </header>
  );
}
```

### 方法 2：使用 suppressHydrationWarning
```tsx
<Image 
  src={logoUrl} 
  alt="Logo" 
  suppressHydrationWarning 
/>
```

### 方法 3：使用 ClientOnly 组件
```tsx
import { ClientOnly } from '../common/ClientOnly';

<ClientOnly fallback={<div className="h-8 w-[110px]" />}>
  <Image src={logoUrl} alt="Logo" />
</ClientOnly>
```

## 📋 更换 Logo 的步骤

### 1. 准备阶段
- [ ] 确认新 logo 文件已准备好
- [ ] 检查 logo 尺寸和格式
- [ ] 准备深色和浅色版本（如果需要）

### 2. 安全更换步骤
```bash
# 1. 备份当前 Header 组件
cp src/components/layout/HeaderSSR.tsx src/components/layout/HeaderSSR.tsx.backup

# 2. 更新 logo 路径
# 在 HeaderSSR.tsx 中修改：
# 从："/alohagamebot_transparent_logo_white.svg"
# 到："/your-new-logo-white.svg"

# 3. 测试水合错误
npm run dev
# 检查浏览器控制台是否有水合错误
```

### 3. 验证步骤
- [ ] 检查深色主题下的 logo 显示
- [ ] 检查浅色主题下的 logo 显示
- [ ] 检查浏览器控制台是否有水合错误
- [ ] 检查页面加载性能
- [ ] 测试不同浏览器和扩展环境

## 🎯 最佳实践

### ✅ 推荐做法

1. **保持条件渲染**
```tsx
{mounted ? <Image src={logoUrl} /> : <div className="logo-placeholder" />}
```

2. **使用 suppressHydrationWarning**
```tsx
<Image src={logoUrl} suppressHydrationWarning />
```

3. **添加加载状态**
```tsx
const [logoLoaded, setLogoLoaded] = useState(false);
```

4. **优化图片加载**
```tsx
<Image 
  src={logoUrl} 
  alt="Logo"
  priority
  onLoad={() => setLogoLoaded(true)}
/>
```

### ❌ 避免的做法

1. **不要直接替换条件渲染**
```tsx
// ❌ 错误：直接替换
<Image src={logoUrl} />

// ✅ 正确：保持条件渲染
{mounted ? <Image src={logoUrl} /> : <div />}
```

2. **不要忽略水合警告**
```tsx
// ❌ 错误：忽略警告
console.log('Hydration warning ignored');

// ✅ 正确：使用 suppressHydrationWarning
<Image suppressHydrationWarning />
```

## 🔧 常见问题解决

### 问题 1：Logo 闪烁
**原因**：服务器端和客户端渲染不一致
**解决**：
```tsx
const [mounted, setMounted] = useState(false);

useEffect(() => {
  setMounted(true);
}, []);

return (
  <div className="logo-container">
    {mounted ? (
      <Image src={logoUrl} alt="Logo" />
    ) : (
      <div className="logo-placeholder" />
    )}
  </div>
);
```

### 问题 2：主题切换时 logo 不更新
**原因**：主题状态在服务器端和客户端不同步
**解决**：
```tsx
const { resolvedTheme } = useTheme();
const [mounted, setMounted] = useState(false);

useEffect(() => {
  setMounted(true);
}, []);

if (!mounted) {
  return <div className="logo-placeholder" />;
}

return (
  <Image 
    src={resolvedTheme === "dark" ? darkLogo : lightLogo}
    alt="Logo"
  />
);
```

### 问题 3：浏览器扩展干扰
**原因**：翻译扩展修改 DOM
**解决**：
```tsx
<Image 
  src={logoUrl} 
  alt="Logo"
  suppressHydrationWarning
/>
```

## 📊 测试清单

### 功能测试
- [ ] 深色主题 logo 显示正确
- [ ] 浅色主题 logo 显示正确
- [ ] 主题切换时 logo 更新
- [ ] 页面刷新后 logo 正常显示

### 性能测试
- [ ] Logo 加载时间合理
- [ ] 无布局偏移（CLS）
- [ ] 无水合错误

### 兼容性测试
- [ ] Chrome 浏览器
- [ ] Firefox 浏览器
- [ ] Safari 浏览器
- [ ] 移动端浏览器
- [ ] 有翻译扩展的环境

## 🚨 紧急回滚

如果更换 logo 后出现严重问题：

```bash
# 1. 恢复备份文件
cp src/components/layout/HeaderSSR.tsx.backup src/components/layout/HeaderSSR.tsx

# 2. 重启开发服务器
npm run dev

# 3. 检查是否恢复正常
```

## 📝 总结

更换 logo 时最重要的原则：
1. **保持条件渲染**或使用 `suppressHydrationWarning`
2. **充分测试**各种主题和浏览器环境
3. **准备回滚方案**以防出现问题
4. **监控水合错误**并及时修复

记住：预防胜于治疗！在更换 logo 前就考虑好水合问题，可以避免很多麻烦。
