import { Link } from "react-router-dom";
import { useAuth } from "@/hooks/useAuth";

export function Navbar() {
  const { user, logout } = useAuth();
  return (
    <header className="border-b border-gray-200 bg-white px-4 py-3 dark:border-gray-800 dark:bg-gray-900">
      <div className="mx-auto max-w-6xl flex items-center justify-between">
        <Link to="/dashboard" className="flex items-center gap-2 font-bold">
          <img src="/logo.png" alt="CALZADO J&R" className="h-8" />
          <span>CALZADO J&amp;R</span>
        </Link>
        <div className="flex items-center gap-4">
          <span className="text-sm text-gray-600 dark:text-gray-300">{user?.full_name}</span>
          <button className="text-sm text-red-600" onClick={logout}>Cerrar sesión</button>
        </div>
      </div>
    </header>
  );
}
