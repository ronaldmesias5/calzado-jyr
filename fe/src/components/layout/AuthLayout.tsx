/**
 * Archivo: components/layout/AuthLayout.tsx
 * Descripción: Layout para páginas de autenticación (login, register, forgot, reset).
 * ¿Para qué? Proveer el diseño personalizado de CALZADO J&R con header, footer y card centrado.
 * ¿Impacto? Todas las páginas de auth tienen el mismo diseño consistente.
 */

import { Link } from "react-router-dom";

interface AuthLayoutProps {
  children: React.ReactNode;
  title: string;
  subtitle?: string;
}

export function AuthLayout({ children, title, subtitle }: AuthLayoutProps) {
  return (
    <div className="flex min-h-screen flex-col bg-[#f9fafb]">
      {/* ════════════════════════════════════════ */}
      {/* Header con logo y enlace de login */}
      {/* ════════════════════════════════════════ */}
      <header className="border-b border-gray-200 bg-white">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-3">
          <Link to="/" className="flex items-center gap-2">
            <img
              src="/logo.jpg"
              alt="CALZADO J&R - Águila"
              className="h-10 w-10 object-contain"
            />
            <span className="font-bold" style={{ color: '#FFD700', fontFamily: 'Montserrat, sans-serif', letterSpacing: 1, fontSize: '1.1rem' }}>CALZADO J&R</span>
          </Link>
          <Link
            to="/login"
            className="px-4 py-2 rounded-md bg-[#1e40af] text-white font-semibold text-sm shadow relative overflow-hidden"
            style={{ textDecoration: 'none' }}
          >
            <span className="relative z-10">Iniciar sesión</span>
            <span
              className="absolute left-0 top-0 h-full w-full"
              style={{
                background: 'linear-gradient(120deg, transparent 0%, #FFD700 50%, transparent 100%)',
                opacity: 0.7,
                transform: 'translateX(-100%)',
                animation: 'shine 1.5s infinite'
              }}
            />
          </Link>
          <style>{`
            @keyframes shine {
              0% { transform: translateX(-100%); }
              60% { transform: translateX(120%); }
              100% { transform: translateX(120%); }
            }
          `}</style>
        </div>
      </header>

      {/* ════════════════════════════════════════ */}
      {/* Contenido principal centrado */}
      {/* ════════════════════════════════════════ */}
      <main className="flex flex-1 items-center justify-center px-4 py-12">
        <div className="w-full max-w-md">
          <div className="rounded-xl border border-[#1e40af] bg-white p-6 shadow-sm sm:p-8">
            <div className="mb-6">
              <h2 className="text-xl font-bold text-gray-900">{title}</h2>
              {subtitle && (
                <p className="mt-1 text-sm text-gray-500">{subtitle}</p>
              )}
            </div>
            {children}
          </div>
        </div>
      </main>

      {/* ════════════════════════════════════════ */}
      {/* Footer con información de contacto */}
      {/* ════════════════════════════════════════ */}
      <footer className="border-t border-gray-200 bg-white py-4 text-center">
        <p className="text-sm text-gray-500">
          CALZADO J&R - Calidad y Estilo a tu Alcance
        </p>
        <p className="text-xs text-gray-400">
          Bogotá, Colombia | Tel: +57 601 234 5678
        </p>
      </footer>
    </div>
  );
}
