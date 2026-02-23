"""
Módulo: utils/email.py
Descripción: Utilidades para envío de emails (recuperación de contraseña).
¿Para qué? Enviar enlaces de recuperación de contraseña al email del usuario.
¿Impacto? Sin configuración SMTP válida, se imprime el enlace en la consola (desarrollo).
"""

from app.config import settings


async def send_password_reset_email(email: str, token: str) -> None:
    """Envía un email de recuperación de contraseña.

    En desarrollo, imprime el enlace en la consola del servidor.
    En producción, se enviaría por SMTP real.
    """
    reset_url = f"{settings.FRONTEND_URL}/reset-password?token={token}"

    # En desarrollo, imprimir en consola en lugar de enviar email real
    print("=" * 60)
    print(f"📧 EMAIL DE RECUPERACIÓN DE CONTRASEÑA")
    print(f"   Para: {email}")
    print(f"   Enlace: {reset_url}")
    print("=" * 60)

    # TODO: Implementar envío real con aiosmtplib en producción
    # from aiosmtplib import send
    # message = MIMEText(f"Haz clic en el siguiente enlace: {reset_url}")
    # message["From"] = settings.MAIL_FROM
    # message["To"] = email
    # message["Subject"] = "CALZADO J&R — Recuperación de contraseña"
    # await send(message, hostname=settings.MAIL_SERVER, port=settings.MAIL_PORT)
