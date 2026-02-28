/**
 * Archivo: pages/RegisterPage.tsx
 * Descripción: Página de registro de clientes de CALZADO J&R.
 * ¿Para qué? Permitir que nuevos clientes creen una cuenta.
 * ¿Impacto? La cuenta queda pendiente de validación por el administrador.
 */

import { useState } from "react";
import { Link } from "react-router-dom";
import { User, Mail, Lock, KeyRound } from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { AuthLayout } from "@/components/layout/AuthLayout";
import { InputField } from "@/components/ui/InputField";
import { Button } from "@/components/ui/Button";
import { Alert } from "@/components/ui/Alert";
import { TermsModal } from "@/components/ui/TermsModal";

export function RegisterPage() {
  const { register } = useAuth();

  const [formData, setFormData] = useState({
    full_name: "",
    email: "",
    password: "",
    confirmPassword: "",
  });
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [acceptedTerms, setAcceptedTerms] = useState(false);
  const [showTerms, setShowTerms] = useState(false);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData((prev) => ({ ...prev, [e.target.name]: e.target.value }));
    setError(null);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setSuccess(null);

    // Validar que las contraseñas coincidan
    if (formData.password !== formData.confirmPassword) {
      setError("Las contraseñas no coinciden");
      return;
    }

    // Validar aceptación de términos
    if (!acceptedTerms) {
      setError("Debes aceptar los términos y condiciones para continuar");
      return;
    }

    setIsLoading(true);

    try {
      await register({
        full_name: formData.full_name,
        email: formData.email,
        password: formData.password,
      });
      setSuccess(
        "Cuenta creada exitosamente. Pendiente de validación por el administrador."
      );
      setFormData({ full_name: "", email: "", password: "", confirmPassword: "" });
      setAcceptedTerms(false);
    } catch (err) {
      const message =
        err instanceof Error ? err.message : "Error al crear la cuenta";
      setError(message);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <>
      {showTerms && <TermsModal onClose={() => setShowTerms(false)} />}
    <AuthLayout
      title="Crear cuenta"
      subtitle="Completa tus datos para registrarte"
    >
      {error && (
        <div className="mb-4">
          <Alert type="error" message={error} onClose={() => setError(null)} />
        </div>
      )}

      {success && (
        <div className="mb-4">
          <Alert
            type="success"
            message={success}
            onClose={() => setSuccess(null)}
          />
        </div>
      )}

      <form onSubmit={handleSubmit} noValidate>
        <InputField
          label="Nombre completo"
          name="full_name"
          type="text"
          value={formData.full_name}
          placeholder="Ronald Guerrero"
          autoComplete="name"
          autoFocus
          icon={<User className="h-5 w-5" />}
          onChange={handleChange}
        />

        <InputField
          label="Correo electrónico"
          name="email"
          type="email"
          value={formData.email}
          placeholder="correo@ejemplo.com"
          autoComplete="email"
          icon={<Mail className="h-5 w-5" />}
          onChange={handleChange}
        />

        <InputField
          label="Contraseña"
          name="password"
          type="password"
          value={formData.password}
          placeholder="Mínimo 8 caracteres"
          autoComplete="new-password"
          icon={<Lock className="h-5 w-5" />}
          onChange={handleChange}
          onPaste={(e) => e.preventDefault()}
          onCopy={(e) => e.preventDefault()}
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
          onPaste={(e) => e.preventDefault()}
          onCopy={(e) => e.preventDefault()}
        />

        {/* Checkbox de términos y condiciones */}
        <div className="mb-5">
          <label className="flex items-start gap-3 cursor-pointer">
            <input
              type="checkbox"
              checked={acceptedTerms}
              onChange={(e) => {
                setAcceptedTerms(e.target.checked);
                setError(null);
              }}
              className="mt-0.5 h-4 w-4 shrink-0 rounded border-gray-300 accent-[#1e3a8a] cursor-pointer"
            />
            <span className="text-sm text-gray-600">
              He leído y acepto los{" "}
              <button
                type="button"
                onClick={() => setShowTerms(true)}
                className="font-medium text-[#1e40af] underline hover:text-[#1e3a8a]"
              >
                Términos y Condiciones
              </button>{" "}
              de CALZADO J&R
            </span>
          </label>
        </div>

        <Button type="submit" fullWidth isLoading={isLoading} disabled={!acceptedTerms}>
          Crear cuenta
        </Button>
      </form>

      <p className="mt-6 text-center text-sm text-gray-600">
        ¿Ya tienes cuenta?{" "}
        <Link
          to="/login"
          className="font-medium text-[#1e40af] hover:text-[#1e3a8a]"
        >
          Iniciar sesión
        </Link>
      </p>
    </AuthLayout>
    </>
  );
}
