import { useEffect, useState } from 'react';

/**
 * Hook to detect if browser extensions are modifying the DOM
 * This helps prevent hydration mismatches caused by extensions
 */
export function useBrowserExtensions() {
  const [hasExtensions, setHasExtensions] = useState(false);
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
    
    // Check for common browser extensions that modify DOM
    const checkForExtensions = () => {
      // Check for translation extensions
      const translationElements = document.querySelectorAll('[data-google-translate]');
      if (translationElements.length > 0) {
        setHasExtensions(true);
        return;
      }

      // Check for ad blockers
      const adBlockElements = document.querySelectorAll('[data-adblock]');
      if (adBlockElements.length > 0) {
        setHasExtensions(true);
        return;
      }

      // Check for password managers
      const passwordElements = document.querySelectorAll('[data-1password]');
      if (passwordElements.length > 0) {
        setHasExtensions(true);
        return;
      }

      // Check for other common extensions
      const extensionElements = document.querySelectorAll('[data-extension], [data-browser-extension]');
      if (extensionElements.length > 0) {
        setHasExtensions(true);
        return;
      }
    };

    // Run check after a short delay to allow extensions to load
    const timeoutId = setTimeout(checkForExtensions, 100);

    return () => clearTimeout(timeoutId);
  }, []);

  return { hasExtensions, isClient };
}
