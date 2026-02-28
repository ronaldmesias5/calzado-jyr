/**
 * Archivo: pages/LoginPage.tsx
 * Descripción: Página de inicio de sesión de CALZADO J&R.
 * ¿Para qué? Permitir que usuarios registrados se autentiquen en el sistema.
 */

import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { Mail, Lock } from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { AuthLayout } from "@/components/layout/AuthLayout";
import { InputField } from "@/components/ui/InputField";
import { Button } from "@/components/ui/Button";
import { Alert } from "@/components/ui/Alert";

export function LoginPage() {
  const navigate = useNavigate();
  const { login } = useAuth();

  const [formData, setFormData] = useState({ email: "", password: "" });
  const [rememberMe, setRememberMe] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData((prev) => ({ ...prev, [e.target.name]: e.target.value }));
    setError(null);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setIsLoading(true);

    try {
      await login(formData);
      navigate("/dashboard", { replace: true });
    } catch (err) {
      const message =
        err instanceof Error ? err.message : "Error al iniciar sesión";
      setError(message);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <AuthLayout
      title="Iniciar sesión"
      subtitle="Ingresa tus credenciales para acceder a tu panel"
    >
      {error && (
        <div className="mb-4">
          <Alert type="error" message={error} onClose={() => setError(null)} />
        </div>
      )}

      <form onSubmit={handleSubmit} noValidate>
        <InputField
          label="Correo electrónico"
          name="email"
          type="email"
          value={formData.email}
          placeholder="correo@ejemplo.com"
          autoComplete="email"
          autoFocus
          icon={<Mail className="h-5 w-5" />}
          onChange={handleChange}
        />

        <InputField
          label="Contraseña"
          name="password"
          type="password"
          value={formData.password}
          placeholder="••••••••"
          autoComplete="current-password"
          icon={<Lock className="h-5 w-5" />}
          onChange={handleChange}
        />

        <div className="mb-6 flex items-center justify-between">
          <label className="flex items-center gap-2 cursor-pointer">
            <input
              type="checkbox"
              checked={rememberMe}
              onChange={(e) => setRememberMe(e.target.checked)}
              className="h-4 w-4 rounded border-gray-300 accent-[#1e3a8a] cursor-pointer"
            />
            <span className="text-sm text-gray-600">Recuérdame</span>
          </label>
          <Link
            to="/forgot-password"
            className="text-sm text-[#1e40af] hover:text-[#1e3a8a]"
          >
            ¿Olvidaste tu contraseña?
          </Link>
        </div>

        <Button type="submit" fullWidth isLoading={isLoading}>
          Iniciar sesión
        </Button>
      </form>

      <p className="mt-6 text-center text-sm text-gray-600">
        ¿No tienes cuenta?{" "}
        <Link
          to="/register"
          className="font-medium text-[#1e40af] hover:text-[#1e3a8a]"
        >
          Crear cuenta
        </Link>
      </p>
    </AuthLayout>
  );
}
