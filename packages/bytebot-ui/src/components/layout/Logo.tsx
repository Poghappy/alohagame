import React, { useState, useEffect } from 'react';
// Use native <img> for SVG logos to avoid Next.js image optimization/hydration
// issues for vector assets. This keeps server/client rendering deterministic.
import { useTheme } from 'next-themes';

interface LogoProps {
  className?: string;
  width?: number;
  height?: number;
  alt?: string;
}

/**
 * 安全的 Logo 组件，防止水合错误
 * 使用条件渲染确保服务器端和客户端一致性
 */
export function Logo({ 
  className = "h-8 w-auto", 
  width = 100, 
  height = 30, 
  alt = "AlohaGameBot Logo" 
}: LogoProps) {
  const { resolvedTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  // 服务器端渲染占位符，避免水合错误
  if (!mounted) {
    return <div className={`${className} bg-gray-200 animate-pulse`} />;
  }

  // 客户端渲染实际 logo — 使用 <img> 渲染 svg 更加稳健，避免 Next.js 的
  // 图像优化对 SVG 的光栅化和潜在的水合差异。
  // Prefer PNG assets (so user-provided PNGs are used). If the PNG isn't
  // present the `onError` handler will swap to the existing SVG path.
  const pngSrc =
    resolvedTheme === 'dark'
      ? '/alohagamebot_transparent_logo_white.png'
      : '/alohagamebot_transparent_logo_dark.png';
  const svgSrc =
    resolvedTheme === 'dark'
      ? '/alohagamebot_transparent_logo_white.svg'
      : '/alohagamebot_transparent_logo_dark.svg';

  return (
    // width/height 保持属性以帮助布局；className 保留 Tailwind 尺寸
    <img
      src={pngSrc}
      alt={alt}
      width={width}
      height={height}
      className={className}
      onError={(e) => {
        // Fallback to SVG if PNG not available or failed to load
        if (e.currentTarget.src !== svgSrc) {
          e.currentTarget.src = svgSrc;
        }
      }}
    />
  );
}

/**
 * 简化版 Logo 组件，使用 suppressHydrationWarning
 * 适用于确定不会有水合问题的场景
 */
export function LogoSimple({ 
  className = "h-8 w-auto", 
  width = 100, 
  height = 30, 
  alt = "AlohaGameBot Logo" 
}: LogoProps) {
  const { resolvedTheme } = useTheme();

  const logoSrc =
    resolvedTheme === 'dark'
      ? '/alohagamebot_transparent_logo_white.svg'
      : '/alohagamebot_transparent_logo_dark.svg';

  return <img src={logoSrc} alt={alt} width={width} height={height} className={className} suppressHydrationWarning />;
}
