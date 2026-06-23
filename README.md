<div align="center">

<img src="LOGO_WIRED.png" alt="WiredNet Logo" width="110"/>

# WiredNet Toolkit

**Herramienta de soporte técnico para Windows**  
Diagnóstico de red · Diagnóstico del sistema · Reparación de red · Reparación de Windows · Reparación Rápida

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-2D9CDB?style=flat-square&logo=powershell&logoColor=white)](https://microsoft.com/powershell)
[![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D4?style=flat-square&logo=windows&logoColor=white)](https://microsoft.com/windows)
[![Licencia](https://img.shields.io/badge/uso-interno-1F2937?style=flat-square)](#)
[![Versión](https://img.shields.io/badge/versión-3.0-2D9CDB?style=flat-square)](#)

---

### Ejecutar con un solo comando

```powershell
irm "https://raw.githubusercontent.com/Alex8amz/Wired-fix/main/WiredNet_GUI.ps1" | iex
```

> Abre PowerShell (no necesita ser administrador — la herramienta lo solicita sola) y pega el comando.

</div>

---

## ¿Qué es WiredNet Toolkit?

WiredNet Toolkit es una interfaz gráfica construida en PowerShell + WPF pensada para técnicos de soporte. Agrupa en un solo lugar los comandos de diagnóstico y reparación más usados en campo, organizados en **6 pestañas**, sin necesidad de recordar sintaxis ni abrir múltiples terminales.

Diseñada y mantenida por **WiredNet** — empresa de soporte técnico, cableado estructurado y cámaras de seguridad en Barranquilla, Colombia.

---

## Funciones

### 🔍 Diagnóstico de Red
Revisa el estado de la red y la conectividad del equipo en tiempo real.

| Herramienta | Descripción |
|---|---|
| `ipconfig /all` | Todos los adaptadores y su configuración completa |
| `netstat -ano` | Conexiones activas y proceso asociado a cada puerto |
| `arp -a` | Tabla ARP — IPs y MACs de la red local |
| `route print` | Tabla de enrutamiento completa |
| Ping | Prueba de conectividad hacia cualquier host o IP |
| Tracert | Rastreo de ruta hasta el destino |
| Consultar DNS | Resolución DNS de cualquier dominio (`nslookup`) |
| Probar Puerto | `Test-NetConnection` — verifica si un puerto está abierto |
| Redes Wi-Fi Guardadas | Lista de perfiles Wi-Fi almacenados en el equipo |
| Escanear Wi-Fi Cercanas | Redes disponibles con canal, señal y BSSID |
| Puertos en Escucha | Lista de puertos TCP activos con proceso dueño |
| Probar Velocidad Internet | Descarga de prueba — mide Mbps sin apps externas |

---

### 💻 Diagnóstico del Sistema *(nuevo en v3.0)*
Información completa del hardware, software y estado del equipo.

| Herramienta | Descripción |
|---|---|
| Info del Sistema | OS, versión, CPU, RAM total y libre, dominio, usuario |
| Espacio en Discos | Uso por unidad: total, usado (%), libre |
| Último Reinicio | Fecha y hora del último boot y tiempo encendido |
| Uso Actual CPU / RAM / Disco | Porcentaje de uso en tiempo real |
| Top Procesos por CPU/RAM | Los 5 procesos que más consumen recursos |
| Programas al Inicio (Startup) | Lista de programas que arrancan con Windows |
| Estado de Drivers | Inventario de controladores instalados |
| Drivers con Errores | Solo los drivers con código de error activo |
| Errores Críticos (24h) | Eventos críticos del Event Log de las últimas 24h |
| Advertencias del Sistema (24h) | Advertencias del Event Log de las últimas 24h |
| Actualizaciones Pendientes | Lista de Windows Updates sin instalar |
| Temperatura del Sistema | Temperatura del CPU via WMI |
| Estado de Batería | Ciclos, capacidad, porcentaje y estado de carga |
| Estado del Antivirus | Nombre y estado del antivirus instalado |
| 📄 Exportar Reporte Completo | Genera un `.txt` en el Escritorio con toda la info del sistema |

---

### 🔧 Reparación de Red
Soluciona los problemas de conexión más comunes sin salir de la herramienta.

| Herramienta | Descripción |
|---|---|
| Habilitar DHCP | Activa IP y DNS automáticos en el adaptador seleccionado |
| Liberar IP | `ipconfig /release` en el adaptador seleccionado |
| Renovar IP | `ipconfig /renew` en el adaptador seleccionado |
| Limpiar caché DNS | `ipconfig /flushdns` |
| Reseteo total de red | Release + Renew + FlushDNS + RegisterDNS |
| Reiniciar Winsock | `netsh winsock reset` |
| Reiniciar pila TCP/IP | `netsh int ip reset` |
| Restablecer Firewall | `netsh advfirewall reset` |
| Restablecer Proxy | `netsh winhttp reset proxy` |
| DNS de Google | Configura `8.8.8.8` / `8.8.4.4` en adaptadores activos |
| DNS de Cloudflare | Configura `1.1.1.1` / `1.0.0.1` en adaptadores activos |
| Restaurar DNS automático | Vuelve a DNS por DHCP |
| Reiniciar adaptador | Deshabilita y vuelve a habilitar el adaptador seleccionado |

---

### 🛠️ Reparación de Windows
Repara el sistema operativo, servicios y libera espacio en disco.

| Herramienta | Descripción |
|---|---|
| SFC /scannow | Verifica y repara archivos de sistema corruptos |
| DISM RestoreHealth | Repara la imagen de Windows (ScanHealth + RestoreHealth) |
| Reparar Windows Update | Detiene servicios WU, limpia caché y los reinicia |
| Limpiar caché Windows Update | Elimina `SoftwareDistribution\Download` |
| Forzar Políticas de Grupo | `gpupdate /force` |
| Reparar Microsoft Store | `wsreset.exe` |
| Reiniciar Servicio Impresora | Vacía la cola del Spooler y lo reinicia |
| Reiniciar Servicios de Red | Reinicia `Dhcp` y `Dnscache` |
| Limpiar Archivos Temporales | Elimina `%TEMP%` y `C:\Windows\Temp` |
| Limpiar Prefetch | Elimina archivos de `C:\Windows\Prefetch` |
| Limpiar Miniaturas (Thumbnails) | Limpia la caché de miniaturas del explorador |
| Limpiar Reportes de Error (WER) | Elimina logs de errores del usuario y del sistema |
| Verificar Disco (CHKDSK) | `chkdsk /f /r` en la unidad indicada |

---

### ⚡ Reparación Rápida *(nuevo en v3.0)*
Soluciones automatizadas de un clic para los problemas más comunes en campo.

**Diagnóstico**

| Fix | Qué hace |
|---|---|
| ⚡ Diagnóstico Rápido Completo | Revisa ping, DNS, gateway y velocidad en un solo paso |

**Problemas de Red**

| Fix | Qué hace |
|---|---|
| 🌐 Sin Acceso a Internet | Reseteo Winsock + TCP/IP + DNS + DHCP — prueba ping al final |
| ⚠ Conflicto de IP | Libera y renueva IP con pausa entre pasos |
| 🔍 DNS no Resuelve Dominios | Configura DNS de Google + limpia caché DNS |
| 📶 Wi-Fi Conectado Sin Internet | Reinicia adaptador Wi-Fi + limpia DNS + reinicia DHCP |
| 🐢 Internet Lento | Limpia DNS, restablece proxy, aplica DNS Cloudflare, mide velocidad |

**Problemas de Windows**

| Fix | Qué hace |
|---|---|
| 🐢 Sistema Lento | Limpia temporales + prefetch + miniaturas + WER + papelera. Muestra top 5 procesos por RAM |
| 🔄 Windows Update Roto | Detiene WU, limpia caché, vuelve a registrar DLLs críticas, reinicia servicios |
| 🖨 Impresora No Funciona | Detiene Spooler, vacía cola de impresión, reinicia servicio |
| 🔴 Archivos del Sistema Corruptos | Ejecuta SFC + DISM ScanHealth + DISM RestoreHealth en secuencia |
| 🧹 Limpieza Total del Equipo | Temporales + prefetch + miniaturas + WER + papelera + caché WU |
| 🔑 Verificar Activación Windows | Consulta estado de licencia con clave parcial |

---

## Capturas

> La interfaz corre sobre WPF con tema oscuro, consola en vivo y navegación por 6 pestañas.

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  [Logo]  WiredNet   [🔍 Diag Red] [💻 Sistema] [🔧 Red] [🛠 Win] [⚡ Fix] │
│          Soporte Técnico · Diagnóstico y Reparación de Red                  │
├──────────────────────────────────────────────────────────────────────────────┤
│  DIAGNÓSTICO DE RED                                                          │
│  Revisa el estado de la red y la conectividad del equipo.                   │
│                                                                              │
│  [ipconfig /all] [netstat] [arp -a] [route print] [Wi-Fi] [Velocidad] ...  │
│  Host/IP: [8.8.8.8]  [Ping]  [Tracert]                                      │
│  Dominio: [google.com]  [Consultar DNS]                                      │
│  Host:Puerto: [google.com] [443]  [Probar Puerto]                           │
├──────────────────────────────────────────────────────────────────────────────┤
│  ● Listo.                                              [Limpiar]            │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │ >>> ipconfig /all                                                    │   │
│  │ Adaptador Ethernet: 192.168.1.45 · Gateway: 192.168.1.1             │   │
│  │ --- Finalizado ---                                                   │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Instalación y uso

### ▶ Opción 1 — Ejecución directa (recomendada)

No requiere instalar nada. Abre **PowerShell** y ejecuta:

```powershell
irm "https://raw.githubusercontent.com/Alex8amz/Wired-fix/main/WiredNet_GUI.ps1" | iex
```

La herramienta se descarga en memoria, descarga el logo desde GitHub automáticamente, solicita permisos de administrador y abre la interfaz.

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
- Conexión a internet *(solo para ejecución directa, prueba de velocidad y fixes de red)*
- Permisos de administrador *(la herramienta los solicita automáticamente)*

---

## Estructura del repositorio

```
Wired-fix/
├── Iniciar_WiredNet_GUI.bat    # Lanzador para uso local (doble clic)
├── LOGO_WIRED.png              # Logo de WiredNet
├── README.md                   # Este archivo
└── WiredNet_GUI.ps1            # Script principal — interfaz y lógica completa
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
