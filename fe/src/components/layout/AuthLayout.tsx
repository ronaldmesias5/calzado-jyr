import { ThemeToggle } from "@/components/ui/ThemeToggle";
import { BrandLogo } from "@/components/ui/BrandLogo";

interface AuthLayoutProps { children: React.ReactNode; title: string; subtitle?: string }

export function AuthLayout({ children, title, subtitle }: AuthLayoutProps) {
  return (
    <div style={{ position: 'fixed', inset: 0 }} className="bg-gray-50 dark:bg-gray-950">
      <div className="flex items-center justify-center w-full h-full">
        <div className="w-full max-w-md px-4">
          <div className="mx-auto">
            <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 sm:p-8">
              <div className="mb-6 text-center">
                <BrandLogo className="mx-auto h-20 mb-2" alt="CALZADO J&R" />
                <div className="text-lg font-bold text-gray-900 dark:text-white">CALZADO J&amp;R</div>
              </div>

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
  );
}
