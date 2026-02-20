interface AlertProps { type?: 'error' | 'success' | 'info'; message: string; onClose?: () => void }

export function Alert({ type = 'info', message, onClose }: AlertProps) {
  const base = 'rounded-md p-3 text-sm';
  const styles: Record<string,string> = {
    error: 'bg-red-50 text-red-700',
    success: 'bg-green-50 text-green-700',
    info: 'bg-blue-50 text-blue-700',
  };
  return (
    <div className={`${base} ${styles[type]}`} role="alert">
      <div className="flex justify-between items-start">
        <div>{message}</div>
        {onClose && (<button onClick={onClose} className="ml-4 text-sm font-medium">Cerrar</button>)}
      </div>
    </div>
  );
}
