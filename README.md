<div align="center">

<img src="LOGO_WIRED.png" alt="WiredNet Logo" width="110"/>

# WiredNet Toolkit

**Herramienta de soporte técnico para Windows**  
Diagnóstico de red · Reparación de conexión · Reparación de Windows

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-2D9CDB?style=flat-square&logo=powershell&logoColor=white)](https://microsoft.com/powershell)
[![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D4?style=flat-square&logo=windows&logoColor=white)](https://microsoft.com/windows)
[![Licencia](https://img.shields.io/badge/uso-interno-1F2937?style=flat-square)](#)
[![Versión](https://img.shields.io/badge/versión-2.0-2D9CDB?style=flat-square)](#)

---

### Ejecutar con un solo comando

```powershell
irm "https://raw.githubusercontent.com/Alex8amz/Wired-fix/main/WiredNet_GUI.ps1" | iex
```

> Abre PowerShell (no necesita ser administrador — la herramienta lo solicita sola) y pega el comando.

</div>

---

## ¿Qué es WiredNet Toolkit?

WiredNet Toolkit es una interfaz gráfica construida en PowerShell + WPF pensada para técnicos de soporte. Agrupa en un solo lugar los comandos de diagnóstico y reparación más usados en campo, sin necesidad de recordar sintaxis ni abrir múltiples terminales.

Diseñada y mantenida por **WiredNet** — empresa de soporte técnico, cableado estructurado y cámaras de seguridad en Barranquilla, Colombia.

---

## Funciones

### 🔍 Diagnóstico de Red
Revisa el estado de la red y la conectividad del equipo en tiempo real.

| Herramienta | Descripción |
|---|---|
| `ipconfig /all` | Ver todos los adaptadores y su configuración |
| `netstat -ano` | Conexiones activas y procesos asociados |
| `arp -a` | Tabla ARP (IPs y MACs de la red local) |
| `route print` | Tabla de enrutamiento completa |
| Ping | Prueba de conectividad a un host o IP |
| Tracert | Rastreo de ruta hasta el destino |
| Nslookup | Consulta de resolución DNS |
| Test-NetConnection | Prueba si un puerto específico está abierto |
| Redes Wi-Fi guardadas | Lista de perfiles Wi-Fi en el equipo |
| Escanear Wi-Fi | Redes disponibles cercanas con BSSID |
| Puertos en escucha | Lista de puertos TCP activos con proceso |
| Prueba de velocidad | Velocidad de descarga en Mbps (sin apps externas) |

---

### 🔧 Reparación de Red
Soluciona los problemas de conexión más comunes sin salir de la herramienta.

| Herramienta | Descripción |
|---|---|
| Habilitar DHCP | Activa IP y DNS automáticos en el adaptador |
| Liberar / Renovar IP | `ipconfig /release` y `/renew` |
| Limpiar caché DNS | `ipconfig /flushdns` |
| Reseteo total de red | Release + Renew + FlushDNS + RegisterDNS |
| Reiniciar Winsock | `netsh winsock reset` |
| Reiniciar pila TCP/IP | `netsh int ip reset` |
| Restablecer Firewall | `netsh advfirewall reset` |
| Restablecer Proxy | `netsh winhttp reset proxy` |
| DNS de Google | Configura `8.8.8.8` / `8.8.4.4` |
| DNS de Cloudflare | Configura `1.1.1.1` / `1.0.0.1` |
| Restaurar DNS automático | Vuelve a DNS por DHCP |
| Reiniciar adaptador | Deshabilita y vuelve a habilitar el adaptador |

---

### 🛠️ Reparación de Windows
Repara archivos del sistema y libera espacio en disco.

| Herramienta | Descripción |
|---|---|
| SFC | `sfc /scannow` — repara archivos del sistema |
| DISM | `RestoreHealth` — repara la imagen de Windows |
| CHKDSK | Verifica integridad del disco (con aviso si es C:) |
| Limpiar temporales | Elimina `%TEMP%` y `C:\Windows\Temp` |
| Reiniciar servicios | Reinicia los servicios DHCP y DNS |

---

## Capturas

> La interfaz corre sobre WPF con tema oscuro, consola en vivo y navegación por pestañas.

```
┌─────────────────────────────────────────────────────────────────┐
│  [Logo]  WiredNet              [Diagnóstico] [Red] [Windows] [ℹ]│
│          Soporte Técnico · Diagnóstico y Reparación de Red      │
├─────────────────────────────────────────────────────────────────┤
│  DIAGNÓSTICO DE RED                                             │
│  Revisa el estado de la red y la conectividad del equipo.       │
│                                                                 │
│  [ipconfig /all]  [netstat]  [arp -a]  [route print]  ...      │
│  Host/IP: [8.8.8.8]  [Ping]  [Tracert]                         │
├─────────────────────────────────────────────────────────────────┤
│  ● Listo.                                    [Limpiar Consola]  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ >>> ipconfig /all                                         │  │
│  │ Adaptador LAN: 192.168.1.45 · Gateway: 192.168.1.1       │  │
│  │ --- Finalizado ---                                        │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Instalación y uso

### ▶ Opción 1 — Ejecución directa (recomendada)

No requiere instalar nada. Abre **PowerShell** y ejecuta:

```powershell
irm "https://raw.githubusercontent.com/Alex8amz/Wired-fix/main/WiredNet_GUI.ps1" | iex
```

La herramienta se descarga en memoria, solicita permisos de administrador y abre la interfaz.

---

### ▶ Opción 2 — Uso local (clonar el repositorio)

```powershell
git clone https://github.com/Alex8amz/Wired-fix.git
cd Wired-fix
.\Iniciar_WiredNet_GUI.bat
```

---

## Requisitos

- Windows 10 / 11
- PowerShell 5.1 o superior *(incluido por defecto en Windows)*
- Conexión a internet *(solo para la ejecución directa y la prueba de velocidad)*
- Permisos de administrador *(la herramienta los solicita automáticamente)*

---

## Estructura del repositorio

```
Wired-fix/
├── WiredNet_GUI.ps1            # Script principal — interfaz y lógica completa
├── Iniciar_WiredNet_GUI.bat    # Lanzador para uso local
├── LOGO_WIRED.png              # Logo de la empresa
└── README.md                   # Este archivo
```

---

## Tecnologías

- **PowerShell 5.1** — lógica, comandos de red y sistema
- **WPF (Windows Presentation Foundation)** — interfaz gráfica con XAML embebido
- **Start-Job + DispatcherTimer** — ejecución en segundo plano sin congelar la UI
- **Invoke-WebRequest** — descarga remota del logo al ejecutar vía `irm | iex`

---

## Sobre WiredNet

**WiredNet** es una empresa de soporte técnico especializada en redes, cableado estructurado y sistemas de seguridad para empresas en Barranquilla, Colombia.

🌐 [wire-net-web.vercel.app](https://wire-net-web.vercel.app)

---

<div align="center">

Hecho con ☕ y PowerShell · WiredNet © 2025

</div>
