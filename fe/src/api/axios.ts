/**
 * Archivo: api/axios.ts
 * Descripción: Instancia de Axios configurada con la URL base de la API e interceptores.
 * ¿Para qué? Centralizar la configuración HTTP para todo el frontend.
 */

import axios from "axios";

const API_URL = import.meta.env.VITE_API_URL || "http://localhost:8000";

const api = axios.create({
  baseURL: API_URL,
  headers: {
    "Content-Type": "application/json",
  },
  timeout: 10000,
});

// Interceptor de request — agrega el token JWT automáticamente
api.interceptors.request.use(
  (config) => {
    const token = sessionStorage.getItem("access_token");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Interceptor de response — maneja errores HTTP de forma centralizada
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response) {
      const data = error.response.data;

      if (error.response.status === 422 && Array.isArray(data.detail)) {
        const messages = data.detail.map(
          (err: { msg: string }) => err.msg
        );
        error.message = messages.join(". ");
      } else if (typeof data.detail === "string") {
        error.message = data.detail;
      }
    } else if (error.request) {
      error.message = "No se pudo conectar con el servidor";
    }
    return Promise.reject(error);
  }
);

export default api;
