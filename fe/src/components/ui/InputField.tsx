import { useState, useEffect, useRef, type ReactNode } from "react";
import { Eye, EyeOff } from "lucide-react";

interface InputFieldProps { label: string; name: string; type?: string; error?: string; value: string; placeholder?: string; autoComplete?: string; icon?: ReactNode; onChange: (e: React.ChangeEvent<HTMLInputElement>) => void; autoFocus?: boolean }

export function InputField({ label, name, type = "text", error, value, placeholder, autoComplete, icon, onChange, autoFocus }: InputFieldProps) {
  const [showPassword, setShowPassword] = useState(false);
  const inputRef = useRef<HTMLInputElement | null>(null);

  useEffect(() => {
    if (autoFocus && inputRef.current) {
      try {
        inputRef.current.focus();
        if (inputRef.current.value) inputRef.current.select();
      } catch (e) {
        // ignore
      }
    }
  }, [autoFocus]);
  const isPassword = type === "password";
  const inputType = isPassword ? (showPassword ? "text" : "password") : type;

  return (
    <div className="mb-4">
      <label htmlFor={name} className="mb-1 block text-sm font-medium text-gray-700 dark:text-gray-300">{label}</label>
      <div className="relative">
        {icon && <div className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 dark:text-gray-500">{icon}</div>}
        <input ref={inputRef} id={name} name={name} type={inputType} value={value} placeholder={placeholder} autoComplete={autoComplete} onChange={onChange} aria-invalid={!!error} aria-describedby={error ? `${name}-error` : undefined} className={`block w-full rounded-lg border ${icon ? "pl-10" : "px-3"} ${isPassword ? "pr-10" : icon ? "pr-3" : ""} py-2.5 text-sm transition-colors duration-200 placeholder:text-gray-400 focus:outline-none focus:ring-2 dark:bg-gray-800 dark:text-gray-100 dark:placeholder:text-gray-500 ${error ? "border-red-500 focus:border-red-500 focus:ring-red-500/20 dark:border-red-400 dark:focus:ring-red-400/20" : "border-gray-300 focus:border-blue-500 focus:ring-blue-500/20 dark:border-gray-600 dark:focus:border-blue-400 dark:focus:ring-blue-400/20"}` } />
        {isPassword && (<button type="button" onClick={() => setShowPassword(!showPassword)} className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200" aria-label={showPassword ? "Ocultar contraseña" : "Mostrar contraseña"}>{showPassword ? <EyeOff className="h-5 w-5" aria-hidden="true" /> : <Eye className="h-5 w-5" aria-hidden="true" />}</button>)}
      </div>
      {error && <p id={`${name}-error`} className="mt-1 text-sm text-red-600 dark:text-red-400" role="alert">{error}</p>}
    </div>
  );
}
