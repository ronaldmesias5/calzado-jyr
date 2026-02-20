export interface RegisterRequest { email: string; full_name: string; password: string }
export interface LoginRequest { email: string; password: string }
export interface ChangePasswordRequest { current_password: string; new_password: string }
export interface ForgotPasswordRequest { email: string }
export interface ResetPasswordRequest { token: string; new_password: string }
export interface RefreshTokenRequest { refresh_token: string }

export interface UserResponse { id: string; email: string; full_name: string; is_active: boolean; created_at: string; updated_at: string }
export interface TokenResponse { access_token: string; refresh_token: string; token_type: string }
export interface MessageResponse { message: string }

export interface AuthState { user: UserResponse | null; accessToken: string | null; refreshToken: string | null; isAuthenticated: boolean; isLoading: boolean }
export interface AuthContextType extends AuthState { login: (data: LoginRequest) => Promise<void>; register: (data: RegisterRequest) => Promise<void>; logout: () => void; changePassword: (data: ChangePasswordRequest) => Promise<void>; forgotPassword: (data: ForgotPasswordRequest) => Promise<void>; resetPassword: (data: ResetPasswordRequest) => Promise<void> }

export interface ApiError { detail: string | ValidationError[] }
export interface ValidationError { loc: (string | number)[]; msg: string; type: string }
