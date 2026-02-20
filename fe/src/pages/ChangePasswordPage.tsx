import { useState } from "react";
import { useAuth } from "@/hooks/useAuth";
import { InputField } from "@/components/ui/InputField";
import { Button } from "@/components/ui/Button";
import { Alert } from "@/components/ui/Alert";

export function ChangePasswordPage() {
  const { changePassword } = useAuth();
  const [formData, setFormData] = useState({ current_password: "", new_password: "", confirmPassword: "" });
  const [errors, setErrors] = useState<Record<string,string>>({});
  const [generalError, setGeneralError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => { setFormData((prev) => ({ ...prev, [e.target.name]: e.target.value })); setErrors((prev) => ({ ...prev, [e.target.name]: "" })); setGeneralError(null); };

  const validate = (): boolean => {
    const newErrors: Record<string,string> = {};
    if (formData.new_password.length < 8) newErrors.new_password = 'Mínimo 8 caracteres';
    if (formData.new_password !== formData.confirmPassword) newErrors.confirmPassword = 'Las contraseñas no coinciden';
    setErrors(newErrors); return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => { e.preventDefault(); setGeneralError(null); setSuccess(null); if (!validate()) return; setIsLoading(true); try { await changePassword({ current_password: formData.current_password, new_password: formData.new_password }); setSuccess('Contraseña cambiada exitosamente'); setFormData({ current_password:'', new_password:'', confirmPassword:'' }); } catch (err) { const message = err instanceof Error ? err.message : 'Error al cambiar contraseña'; setGeneralError(message); } finally { setIsLoading(false); } };

  return (
    <div className="max-w-md">
      <h1 className="text-xl font-semibold mb-4">Cambiar contraseña</h1>
      {success && <Alert type="success" message={success} />}
      {generalError && <Alert type="error" message={generalError} onClose={() => setGeneralError(null)} />}
      <form onSubmit={handleSubmit}>
        <InputField label="Contraseña actual" name="current_password" type="password" value={formData.current_password} onChange={handleChange} />
        <InputField label="Nueva contraseña" name="new_password" type="password" value={formData.new_password} onChange={handleChange} />
        <InputField label="Confirmar nueva contraseña" name="confirmPassword" type="password" value={formData.confirmPassword} onChange={handleChange} />
        <div className="mt-4"><Button type="submit" fullWidth isLoading={isLoading}>Cambiar contraseña</Button></div>
      </form>
    </div>
  );
}
