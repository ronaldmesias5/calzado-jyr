/**
 * Archivo: types/auth.ts
 * Descripción: Tipos e interfaces TypeScript para el sistema de autenticación.
 * ¿Para qué? Definir contratos de datos entre frontend y backend.
 */

// ════════════════════════════════════════
// 📥 Tipos de REQUEST
// ════════════════════════════════════════

export interface RegisterRequest {
  email: string;
  full_name: string;
  phone?: string;
  identity_document?: string;
  business_name?: string;
  password: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface ChangePasswordRequest {
  current_password: string;
  new_password: string;
}

export interface ForgotPasswordRequest {
  email: string;
}

export interface ResetPasswordRequest {
  token: string;
  new_password: string;
}

export interface RefreshTokenRequest {
  refresh_token: string;
}

// ════════════════════════════════════════
// 📤 Tipos de RESPONSE
// ════════════════════════════════════════

export interface UserResponse {
  id: string;
  email: string;
  full_name: string;
  phone: string | null;
  identity_document: string | null;
  is_active: boolean;
  is_validated: boolean;
  role_name: string | null;
  business_name: string | null;
  occupation: string | null;
  created_at: string;
  updated_at: string;
}

export interface TokenResponse {
  access_token: string;
  refresh_token: string;
  token_type: string;
}

export interface MessageResponse {
  message: string;
}

// ════════════════════════════════════════
// 🔧 Tipos internos del frontend
// ════════════════════════════════════════

export interface AuthState {
  user: UserResponse | null;
  accessToken: string | null;
  refreshToken: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
}

export interface AuthContextType extends AuthState {
  login: (data: LoginRequest) => Promise<void>;
  register: (data: RegisterRequest) => Promise<void>;
  logout: () => void;
  changePassword: (data: ChangePasswordRequest) => Promise<void>;
  forgotPassword: (data: ForgotPasswordRequest) => Promise<void>;
  resetPassword: (data: ResetPasswordRequest) => Promise<void>;
}

export interface ApiError {
  detail: string | ValidationError[];
}

export interface ValidationError {
  loc: (string | number)[];
  msg: string;
  type: string;
}
