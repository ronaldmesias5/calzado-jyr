import { Link } from "react-router-dom";
import { ThemeToggle } from "@/components/ui/ThemeToggle";
import { BrandLogo } from "@/components/ui/BrandLogo";

interface AuthLayoutProps { children: React.ReactNode; title: string; subtitle?: string }

export function AuthLayout({ children, title, subtitle }: AuthLayoutProps) {
  return (
    <div style={{ position: 'fixed', inset: 0 }} className="bg-gray-50 dark:bg-gray-950">
      <header className="border-b border-gray-200 bg-white px-4 py-3 dark:border-gray-800 dark:bg-gray-900">
        <div className="mx-auto max-w-6xl flex items-center justify-between gap-2">
          <div className="flex items-center gap-2">
            <BrandLogo className="h-8" alt="CALZADO J&R" />
            <span className="font-bold text-gray-900 dark:text-white hidden sm:inline">CALZADO J&amp;R</span>
          </div>
          <Link to="/login" className="text-sm font-medium text-blue-600 dark:text-blue-400 whitespace-nowrap">
            Iniciar sesión
          </Link>
        </div>
      </header>
      
      <div className="overflow-y-auto w-full" style={{ height: 'calc(100% - 112px)' }}>
        <div className="flex items-center justify-center min-h-full py-6">
          <div className="w-full max-w-md px-4">
            <div className="mx-auto">
              <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 sm:p-8">
                <div className="mb-4">
                  <h2 className="text-xl font-semibold text-gray-900 dark:text-white">{title}</h2>
                  {subtitle && <p className="mt-1 text-sm text-gray-600 dark:text-gray-400">{subtitle}</p>}
                </div>

                {children}
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <footer className="border-t border-gray-200 bg-white px-4 py-3 dark:border-gray-800 dark:bg-gray-900 flex items-center justify-center">
        <div className="mx-auto max-w-6xl text-center text-xs text-gray-600 dark:text-gray-400">
          <div className="mb-1">
            <p className="font-semibold">CALZADO J&R - Calidad y Estilo a tu Alcance</p>
            <p className="mt-1">Bogotá, Colombia | Tel: +57 601 234 5678</p>
          </div>
          <div className="mt-1 pt-1 border-t border-gray-300 dark:border-gray-700">
            <p>&copy; {new Date().getFullYear()} CALZADO J&R. Todos los derechos reservados.</p>
          </div>
        </div>
      </footer>
    </div>
  );
}
