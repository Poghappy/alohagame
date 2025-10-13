import dynamic from 'next/dynamic';
import { ReactNode } from 'react';

interface NoSSRProps {
  children: ReactNode;
}

/**
 * NoSSR component that prevents server-side rendering
 * Useful for components that cause hydration mismatches
 */
export function NoSSR({ children }: NoSSRProps) {
  return <div suppressHydrationWarning>{children}</div>;
}

/**
 * Dynamic component that only renders on client side
 */
export const DynamicNoSSR = dynamic(() => Promise.resolve(NoSSR), {
  ssr: false,
});
