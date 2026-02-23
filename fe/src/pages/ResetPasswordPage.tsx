/**
 * Archivo: pages/ResetPasswordPage.tsx
 * Descripción: Página para restablecer la contraseña con un token de recuperación.
 * ¿Para qué? Completar el flujo de forgot password.
 */

import { useState } from "react";
import { Link, useSearchParams } from "react-router-dom";
import { Lock, KeyRound } from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { AuthLayout } from "@/components/layout/AuthLayout";
import { InputField } from "@/components/ui/InputField";
import { Button } from "@/components/ui/Button";
import { Alert } from "@/components/ui/Alert";

export function ResetPasswordPage() {
  const { resetPassword } = useAuth();
  const [searchParams] = useSearchParams();
  const token = searchParams.get("token") || "";

  const [formData, setFormData] = useState({
    new_password: "",
    confirmPassword: "",
  });
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData((prev) => ({ ...prev, [e.target.name]: e.target.value }));
    setError(null);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setSuccess(null);

    if (!token) {
      setError("Token de recuperación no encontrado en la URL.");
      return;
    }

    if (formData.new_password !== formData.confirmPassword) {
      setError("Las contraseñas no coinciden");
      return;
    }

    setIsLoading(true);

    try {
      await resetPassword({ token, new_password: formData.new_password });
      setSuccess("Contraseña restablecida exitosamente. Ya puedes iniciar sesión.");
    } catch (err) {
      const message =
        err instanceof Error ? err.message : "Error al restablecer la contraseña";
      setError(message);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <AuthLayout
      title="Restablecer contraseña"
      subtitle="Ingresa tu nueva contraseña"
    >
      {error && (
        <div className="mb-4">
          <Alert type="error" message={error} onClose={() => setError(null)} />
        </div>
      )}

      {success && (
        <div className="mb-4">
          <Alert type="success" message={success} />
        </div>
      )}

      {!success && (
        <form onSubmit={handleSubmit} noValidate>
          <InputField
            label="Nueva contraseña"
            name="new_password"
            type="password"
            value={formData.new_password}
            placeholder="Mínimo 8 caracteres"
            autoComplete="new-password"
            autoFocus
            icon={<Lock className="h-5 w-5" />}
            onChange={handleChange}
          />

          <InputField
            label="Confirmar contraseña"
            name="confirmPassword"
            type="password"
            value={formData.confirmPassword}
            placeholder="Repite tu contraseña"
            autoComplete="new-password"
            icon={<KeyRound className="h-5 w-5" />}
            onChange={handleChange}
          />

          <Button type="submit" fullWidth isLoading={isLoading}>
            Restablecer contraseña
          </Button>
        </form>
      )}

      <p className="mt-6 text-center">
        <Link
          to="/login"
          className="text-sm font-medium text-[#1e40af] hover:text-[#1e3a8a]"
        >
          Volver al inicio de sesión
        </Link>
      </p>
    </AuthLayout>
  );
}
