# WiredNet - Herramienta de Soporte Técnico

Interfaz gráfica (WPF/PowerShell) para diagnóstico y reparación de red y
de Windows, pensada para técnicos de soporte. Incluye autoelevación a
administrador, ejecución de comandos en segundo plano con consola en
vivo, y una sección de información de la empresa.

![WiredNet](LOGO_WIRED.png)

## Uso rápido (sin instalar nada)

Abre **PowerShell** en Windows y pega:

```powershell
irm "https://raw.githubusercontent.com/Alex8amz/Wired-fix/main/WiredNet_GUI.ps1" | iex
```

Acepta el aviso de permisos de administrador (UAC) y espera a que abra
la ventana de WiredNet.

> Para los pasos de publicación y configuración de esta URL, ver
> [`PUBLICAR_EN_GITHUB.md`](PUBLICAR_EN_GITHUB.md).

## Uso local (clonando el repositorio)

```powershell
git clone https://github.com/TU_USUARIO/TU_REPOSITORIO.git
cd TU_REPOSITORIO
.\Iniciar_WiredNet_GUI.bat
```

## Funciones

### Diagnóstico de Red
- Ver adaptadores de red (`ipconfig /all`)
- Ver conexiones activas (`netstat`)
- Ping y Tracert a un host/IP
- Consulta DNS (`nslookup`)

### Reparación de Red
- Habilitar DHCP, liberar/renovar IP
- Limpiar caché DNS
- Reseteo total de red
- Reiniciar Winsock, pila TCP/IP, firewall, proxy
- Reiniciar un adaptador específico

### Reparación de Windows
- SFC (`sfc /scannow`)
- DISM (`RestoreHealth`)
- Verificación de disco (CHKDSK), con manejo especial si es la unidad
  del sistema (se programa para el próximo reinicio)
- Limpieza de archivos temporales
- Reinicio de servicios DHCP/DNS

## Estructura del repositorio

```
.
├── WiredNet_GUI.ps1            # Script principal (interfaz + lógica)
├── Iniciar_WiredNet_GUI.bat    # Lanzador para uso local
├── LOGO_WIRED.png              # Logo de la empresa
├── README.md                   # Este archivo
└── PUBLICAR_EN_GITHUB.md       # Guía de publicación / instalación remota
```

## Requisitos

- Windows 10/11
- PowerShell 5.1 o superior (incluido por defecto en Windows)
- Permisos de administrador (la herramienta los solicita automáticamente)

## Licencia / Uso

Herramienta interna de **WiredNet** — soporte técnico, cableado
estructurado y cámaras de seguridad para empresas en Barranquilla.
