Param(
  [switch]$NoBrowser
)

Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)

Function Ensure-Command($name) {
  return (Get-Command $name -ErrorAction SilentlyContinue) -ne $null
}

if (-not (Ensure-Command pnpm)) {
  if (Ensure-Command npm) {
    Write-Host "pnpm no encontrado. Instalando pnpm globalmente..." -ForegroundColor Yellow
    npm i -g pnpm
  } else {
    Write-Error "npm no encontrado. Instala Node.js y npm desde https://nodejs.org/ antes de continuar."
    exit 1
  }
}

if (-not (Test-Path node_modules)) {
  Write-Host "Instalando dependencias..." -ForegroundColor Cyan
  pnpm install
}

Write-Host "Iniciando servidor de desarrollo en una nueva ventana de PowerShell..." -ForegroundColor Green
Start-Process powershell -ArgumentList ('-NoExit','-Command','pnpm dev')

if (-not $NoBrowser) {
  Start-Sleep -Seconds 2
  Write-Host "Abriendo navegador en http://localhost:5173/login" -ForegroundColor Green
  Start-Process "http://localhost:5173/login"
}
