/**
 * Archivo: components/ui/Button.tsx
 * Descripción: Botón reutilizable con estado de carga.
 * ¿Para qué? Estandarizar todos los botones del sistema con los colores de CALZADO J&R.
 */

import { useState } from "react";

interface ButtonProps {
  children: React.ReactNode;
  type?: "button" | "submit" | "reset";
  fullWidth?: boolean;
  isLoading?: boolean;
  disabled?: boolean;
  variant?: "primary" | "secondary";
  onClick?: () => void;
}

export function Button({
  children,
  type = "button",
  fullWidth = false,
  isLoading = false,
  disabled = false,
  variant = "primary",
  onClick,
}: ButtonProps) {
  const [isHovered, setIsHovered] = useState(false);

  const baseClasses =
    "btn-shimmer rounded-lg px-6 py-3 text-sm font-semibold transition-colors duration-200 disabled:cursor-not-allowed disabled:opacity-60 relative overflow-hidden";

  const variantClasses =
    variant === "primary"
      ? "bg-[#1e3a8a] text-white hover:bg-[#1e40af]"
      : "border border-gray-300 bg-white text-gray-700 hover:bg-gray-50";

  const widthClass = fullWidth ? "w-full" : "";

  return (
    <>
      <style>{`
        @keyframes shimmerHover {
          0% { transform: translateX(-100%); }
          100% { transform: translateX(100%); }
        }
        .button-shimmer-effect {
          position: absolute;
          left: 0;
          top: 0;
          height: 100%;
          width: 100%;
          background: linear-gradient(120deg, transparent 0%, #FFD700 50%, transparent 100%);
          opacity: 0.6;
          animation: shimmerHover 0.6s infinite;
        }
      `}</style>
      <button
        type={type}
        disabled={isLoading || disabled}
        onClick={onClick}
        onMouseEnter={() => setIsHovered(true)}
        onMouseLeave={() => setIsHovered(false)}
        className={`${baseClasses} ${variantClasses} ${widthClass}`}
      >
        {isHovered && <div className="button-shimmer-effect" />}
        <span className="relative z-10">
          {isLoading ? (
            <span className="flex items-center justify-center gap-2">
              <svg
                className="h-4 w-4 animate-spin"
                viewBox="0 0 24 24"
                fill="none"
              >
                <circle
                  className="opacity-25"
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  strokeWidth="4"
                />
                <path
                  className="opacity-75"
                  fill="currentColor"
                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
                />
              </svg>
              Procesando...
            </span>
          ) : (
            children
          )}
        </span>
      </button>
    </>
  );
}
