interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> { fullWidth?: boolean; isLoading?: boolean; variant?: 'primary' | 'secondary'; size?: 'sm' | 'md' }

export function Button({ children, fullWidth, isLoading, variant = 'primary', size = 'md', ...rest }: ButtonProps) {
  const base = 'inline-flex items-center justify-center rounded-lg font-semibold focus:outline-none disabled:opacity-70 disabled:cursor-not-allowed';
  const sizes: Record<string,string> = { sm: 'px-3 py-1.5 text-sm', md: 'px-4 py-2 text-sm' };
  // Use CSS variables for brand colors so it's consistent across the app
  const variants: Record<string,string> = {
    primary: 'btn-flash text-white bg-[var(--brand)] hover:bg-[var(--brand-dark)] focus-visible:ring-4 focus-visible:ring-[var(--brand)]/20',
    secondary: 'bg-gray-100 text-gray-800 hover:bg-gray-200'
  };

  return (
    <button className={`${base} ${sizes[size]} ${variants[variant]} ${fullWidth ? 'w-full' : ''}`} {...rest}>
      {isLoading ? 'Cargando…' : children}
    </button>
  );
}
