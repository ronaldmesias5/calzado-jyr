# Calzado J&R - Guía Rápida de Ejecución

## Requisitos
- Docker y Docker Compose instalados

## Pasos para ejecutar el proyecto

1. Clona el repositorio:
   ```sh
   git clone https://github.com/ronaldmesias5/calzado-jyr.git
   cd calzado-jyr
   ```

2. Copia el archivo de entorno:
   ```sh
   cp .env.example .env
   # Edita los valores si es necesario
   ```

3. (Opcional, pero recomendado) Borra volúmenes previos para una base de datos limpia:
   ```sh
   docker compose down -v
   ```

4. Levanta todos los servicios:
   ```sh
   docker compose up -d
   ```

5. Accede a la app:
   - Frontend: http://localhost:5173
   - Backend/API: http://localhost:8000

---

**Notas:**
- Si es la primera vez, la base de datos y los datos iniciales se crean automáticamente.
- Si cambias el archivo SQL, repite el paso 3 para regenerar la base de datos.

