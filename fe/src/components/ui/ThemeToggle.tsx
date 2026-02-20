import { useEffect, useState } from "react";

export function ThemeToggle() {
  const [theme, setTheme] = useState<'light'|'dark'>(() => (document.documentElement.classList.contains('dark') ? 'dark' : 'light'));
  useEffect(() => { document.documentElement.classList.toggle('dark', theme === 'dark'); }, [theme]);
  return (
    <button onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')} className="rounded px-2 py-1 border">{theme === 'dark' ? 'Light' : 'Dark'}</button>
  );
}
