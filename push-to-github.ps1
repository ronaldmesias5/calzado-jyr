Param(
  [string]$Message = "Actualización: cambios locales",
  [string]$RemoteUrl = "https://github.com/ronaldmesias5/calzado-jyr.git"
)

Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)

function Ensure-Git() {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git no está instalado o no está en PATH. Instala Git desde https://git-scm.com/."
    exit 1
  }
}

Ensure-Git

$branch = (& git rev-parse --abbrev-ref HEAD).Trim()
if (-not $branch) { $branch = "main" }

Write-Host "Branch actual: $branch"

Write-Host "Staging de todos los cambios..." -ForegroundColor Cyan
git add -A

Write-Host "Commit con mensaje: $Message" -ForegroundColor Cyan
try {
  git commit -m "$Message" | Out-Host
} catch {
  Write-Host "No se creó commit (posiblemente no hay cambios). Continuando..." -ForegroundColor Yellow
}

$origin = (& git remote get-url origin 2>$null).Trim()
if (-not $origin) {
  Write-Host "No hay remote 'origin'. Añadiendo: $RemoteUrl" -ForegroundColor Yellow
  git remote add origin $RemoteUrl
}

Write-Host "Haciendo pull --rebase desde origin/$branch (si existe)..." -ForegroundColor Cyan
git pull --rebase origin $branch 2>$null | Out-Host

Write-Host "Pushing a origin/$branch..." -ForegroundColor Green
try {
  git push -u origin $branch | Out-Host
  Write-Host "Push completado." -ForegroundColor Green
} catch {
  Write-Error "Error haciendo push. Revisa credenciales o el estado del repositorio. Puedes probar: git push origin $branch --force (con precaución)."
}
