import { useState } from 'react'

function FallbackLogo() {
  return (
    <svg className="brand-logo" viewBox="0 0 300 120" xmlns="http://www.w3.org/2000/svg" role="img">
      <rect width="100%" height="100%" fill="transparent" />
      <text x="50%" y="42%" dominantBaseline="middle" textAnchor="middle" fontSize="18" fill="#0f172a" fontWeight="700">CALZADO</text>
      <text x="50%" y="70%" dominantBaseline="middle" textAnchor="middle" fontSize="28" fill="#b45309" fontWeight="800">J&amp;R</text>
    </svg>
  )
}

export default function Login() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState(false)
  const [showFallbackLogo, setShowFallbackLogo] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)
    try {
      const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      })

      if (!res.ok) {
        const data = await res.json().catch(() => ({}))
        throw new Error(data?.detail || 'Credenciales incorrectas')
      }

      const data = await res.json()
      if (data?.access_token) {
        localStorage.setItem('access_token', data.access_token)
      }
      setSuccess(true)
    } catch (err: any) {
      setError(err?.message || 'Error desconocido')
    } finally {
      setLoading(false)
    }
  }

  function handleLogout() {
    localStorage.removeItem('access_token')
    setSuccess(false)
    setEmail('')
    setPassword('')
  }

  if (success) {
    return (
      <div className="login-page">
        <div className="login-card">
          {showFallbackLogo ? <FallbackLogo /> : <img src="/logo.png" alt="Calzado J&R" className="brand-logo" onError={() => setShowFallbackLogo(true)} />}
          <h2>Bienvenido</h2>
          <p className="read-the-docs">Has iniciado sesión correctamente (demo).</p>
          <button className="btn-submit" onClick={handleLogout}>Cerrar sesión</button>
        </div>
      </div>
    )
  }

  return (
    <div className="login-page">
      <div className="login-card">
        {showFallbackLogo ? <FallbackLogo /> : <img src="/logo.png" alt="Calzado J&R" className="brand-logo" onError={() => setShowFallbackLogo(true)} />}
        <h2>Iniciar sesión</h2>
        <form onSubmit={handleSubmit} className="login-form">
          <label>
            Correo
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              placeholder="nombre@correo.com"
            />
          </label>

          <label>
            Contraseña
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              placeholder="********"
            />
          </label>

          <button type="submit" disabled={loading} className="btn-submit">
            {loading ? 'Ingresando…' : 'Entrar'}
          </button>

          <button
            type="button"
            className="btn-demo"
            onClick={() => {
              localStorage.setItem('access_token', 'demo-token')
              setSuccess(true)
            }}
          >
            Ver demo
          </button>

          {error && <div className="form-error">{error}</div>}
        </form>
      </div>
    </div>
  )
}
