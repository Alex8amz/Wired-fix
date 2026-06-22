# ============================================================
#  WiredNet - Interfaz Grafica de Soporte Tecnico (WPF)
#  Organizacion visual inspirada en WinUtil (Chris Titus Tech)
# ============================================================

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml

# ---------- Autoelevacion a administrador ----------
function Test-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p  = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# URL del instalador de una linea (irm | iex). Se actualiza el placeholder al subir a GitHub.
$wiredNetRemoteUrl = "https://raw.githubusercontent.com/Alex8amz/Wired-fix/main/WiredNet_GUI.ps1"

if (-not (Test-Admin)) {
    try {
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = "powershell.exe"
        if ($PSCommandPath) {
            # Ejecucion local: relanzar el mismo archivo .ps1 como administrador
            $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
        } else {
            # Ejecucion remota (irm | iex): relanzar el mismo comando de descarga, ya como administrador
            $cmdRemoto = "irm '$wiredNetRemoteUrl' | iex"
            $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -Command `"$cmdRemoto`""
        }
        $psi.Verb = "runas"
        [System.Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        [System.Windows.MessageBox]::Show(
            "Esta herramienta necesita permisos de administrador para funcionar correctamente.",
            "WiredNet") | Out-Null
    }
    exit
}

$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { $null }

# URL "raw" del logo en GitHub (se usa solo si el script corre remoto, vía irm/iex)
$logoUrlRemoto = "https://raw.githubusercontent.com/Alex8amz/Wired-fix/main/LOGO_WIRED.png"

if ($scriptDir) {
    # Ejecucion local: el logo deberia estar junto al .ps1
    $logoPath = Join-Path $scriptDir "LOGO_WIRED.png"
} else {
    # Ejecucion remota (irm | iex): no hay carpeta local, se descarga a TEMP
    $logoPath = Join-Path $env:TEMP "WiredNet_LOGO.png"
    if (-not (Test-Path $logoPath)) {
        try {
            Invoke-WebRequest -Uri $logoUrlRemoto -OutFile $logoPath -UseBasicParsing -ErrorAction Stop
        } catch {
            $logoPath = $null
        }
    }
}

# ============================================================
#  XAML de la interfaz
# ============================================================
[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="WiredNet - Soporte Tecnico"
        Height="820" Width="1100" MinHeight="680" MinWidth="950"
        WindowStartupLocation="CenterScreen"
        Background="#0D1117"
        FontFamily="Segoe UI">
    <Window.Resources>
        <Style x:Key="ActionButtonStyle" TargetType="Button">
            <Setter Property="Background" Value="#1F2937"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderBrush" Value="#2D9CDB"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="14,10"/>
            <Setter Property="Margin" Value="0,0,10,10"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="HorizontalContentAlignment" Value="Center"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Center"
                                               VerticalAlignment="Center"
                                               Margin="{TemplateBinding Padding}"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#2D9CDB"/>
                    <Setter Property="Foreground" Value="Black"/>
                </Trigger>
                <Trigger Property="IsEnabled" Value="False">
                    <Setter Property="Opacity" Value="0.4"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="TabButtonStyle" TargetType="Button">
            <Setter Property="Background" Value="#1F2937"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="18,10"/>
            <Setter Property="Margin" Value="6,0,0,0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Center"
                                               VerticalAlignment="Center"
                                               Margin="{TemplateBinding Padding}"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="ActionButtonStyleBase" TargetType="Button" BasedOn="{StaticResource ActionButtonStyle}"/>

        <Style x:Key="SmallButtonStyle" TargetType="Button" BasedOn="{StaticResource ActionButtonStyle}">
            <Setter Property="Padding" Value="10,5"/>
            <Setter Property="Margin" Value="10,0,0,0"/>
            <Setter Property="FontSize" Value="11"/>
        </Style>

        <Style x:Key="InputStyle" TargetType="TextBox">
            <Setter Property="Background" Value="#1F2937"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderBrush" Value="#2D9CDB"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="6,5"/>
            <Setter Property="CaretBrush" Value="White"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
        </Style>

        <Style x:Key="LabelStyle" TargetType="TextBlock">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Width" Value="80"/>
        </Style>

        <Style x:Key="SectionTitleStyle" TargetType="TextBlock">
            <Setter Property="Foreground" Value="#2D9CDB"/>
            <Setter Property="FontSize" Value="17"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Margin" Value="0,0,0,4"/>
        </Style>

        <Style x:Key="SectionSubtitleStyle" TargetType="TextBlock">
            <Setter Property="Foreground" Value="#7C8A99"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Margin" Value="0,0,0,18"/>
        </Style>
    </Window.Resources>

    <Grid Background="#0D1117">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="300"/>
        </Grid.RowDefinitions>

        <Border Grid.Row="0" Background="#0D1B2A" Padding="22,14" BorderBrush="#1B2733" BorderThickness="0,0,0,2">
            <DockPanel>
                <StackPanel Orientation="Horizontal" VerticalAlignment="Center" DockPanel.Dock="Left">
                    <Border CornerRadius="12" Background="#0A141F" Padding="6" Margin="0,0,16,0"
                            BorderBrush="#2D9CDB" BorderThickness="1">
                        <Image x:Name="imgLogo" Width="64" Height="64"
                               RenderOptions.BitmapScalingMode="HighQuality"/>
                    </Border>
                    <StackPanel VerticalAlignment="Center">
                        <TextBlock Text="WiredNet" FontSize="28" FontWeight="Bold" Foreground="#2D9CDB"/>
                        <TextBlock Text="Soporte Tecnico · Diagnostico y Reparacion de Red" Foreground="#8A96A3" FontSize="12"/>
                    </StackPanel>
                </StackPanel>
                <WrapPanel HorizontalAlignment="Right" VerticalAlignment="Center">
                    <Button x:Name="btnTabDiag" Content="Diagnostico" Style="{StaticResource TabButtonStyle}"/>
                    <Button x:Name="btnTabRed" Content="Reparacion de Red" Style="{StaticResource TabButtonStyle}"/>
                    <Button x:Name="btnTabWin" Content="Reparacion Windows" Style="{StaticResource TabButtonStyle}"/>
                    <Button x:Name="btnTabInfo" Content="WiredNet" Style="{StaticResource TabButtonStyle}"/>
                </WrapPanel>
            </DockPanel>
        </Border>

        <Grid Grid.Row="1" Margin="22,18">
            <ScrollViewer x:Name="scrollDiag" VerticalScrollBarVisibility="Auto" Visibility="Visible">
                <StackPanel>
                    <TextBlock Text="DIAGNOSTICO DE RED" Style="{StaticResource SectionTitleStyle}"/>
                    <TextBlock Text="Revisa el estado de la red y la conectividad del equipo." Style="{StaticResource SectionSubtitleStyle}"/>
                    <WrapPanel>
                        <Button x:Name="btnIpconfig" Content="Ver Adaptadores de Red (ipconfig /all)" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnNetstat" Content="Ver Conexiones Activas (netstat)" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnArp" Content="Ver Tabla ARP" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnRoute" Content="Ver Tabla de Enrutamiento" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnWifiPerfiles" Content="Ver Redes Wi-Fi Guardadas" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnWifiEscanear" Content="Escanear Redes Wi-Fi Cercanas" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnVelocidad" Content="Probar Velocidad de Internet" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnPuertosAbiertos" Content="Ver Puertos en Escucha" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                    </WrapPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,10,0,0">
                        <TextBlock Text="Host / IP:" Style="{StaticResource LabelStyle}"/>
                        <TextBox x:Name="txtPingHost" Text="8.8.8.8" Width="150" Style="{StaticResource InputStyle}"/>
                        <Button x:Name="btnPing" Content="Probar Ping" Width="150" Margin="10,0,0,0" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,10,0,0">
                        <TextBlock Text="Host / IP:" Style="{StaticResource LabelStyle}"/>
                        <TextBox x:Name="txtTracertHost" Text="8.8.8.8" Width="150" Style="{StaticResource InputStyle}"/>
                        <Button x:Name="btnTracert" Content="Rastrear Ruta" Width="150" Margin="10,0,0,0" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,10,0,0">
                        <TextBlock Text="Dominio:" Style="{StaticResource LabelStyle}"/>
                        <TextBox x:Name="txtDominio" Text="google.com" Width="150" Style="{StaticResource InputStyle}"/>
                        <Button x:Name="btnNslookup" Content="Consultar DNS" Width="150" Margin="10,0,0,0" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,10,0,0">
                        <TextBlock Text="Host / Puerto:" Style="{StaticResource LabelStyle}"/>
                        <TextBox x:Name="txtTestHost" Text="google.com" Width="150" Style="{StaticResource InputStyle}"/>
                        <TextBox x:Name="txtTestPuerto" Text="443" Width="60" Margin="6,0,0,0" Style="{StaticResource InputStyle}"/>
                        <Button x:Name="btnTestPuerto" Content="Probar Puerto (Test-NetConnection)" Width="260" Margin="10,0,0,0" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </StackPanel>
            </ScrollViewer>

            <ScrollViewer x:Name="scrollRed" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                <StackPanel>
                    <TextBlock Text="REPARACION DE RED" Style="{StaticResource SectionTitleStyle}"/>
                    <TextBlock Text="Soluciona problemas comunes de conexion sin salir de la herramienta." Style="{StaticResource SectionSubtitleStyle}"/>
                    <StackPanel Orientation="Horizontal" Margin="0,0,0,16">
                        <TextBlock Text="Adaptador:" Style="{StaticResource LabelStyle}"/>
                        <ComboBox x:Name="cmbAdaptador" Width="260" Margin="0,0,10,0"
                                  Background="#1F2937" Foreground="White" BorderBrush="#2D9CDB" BorderThickness="1" Padding="6,4"/>
                        <Button x:Name="btnRefrescarAdaptadores" Content="Actualizar Lista" Width="140" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                    <WrapPanel>
                        <Button x:Name="btnDhcp" Content="Habilitar DHCP" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnLiberar" Content="Liberar IP" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnRenovar" Content="Renovar IP" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnFlushDns" Content="Limpiar Cache DNS" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnResetTotal" Content="Reseteo Total de Red" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnWinsock" Content="Reiniciar Winsock" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnTcpIpReset" Content="Reiniciar Pila TCP/IP" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnFirewallReset" Content="Restablecer Firewall" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnProxyReset" Content="Restablecer Proxy" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnDnsGoogle" Content="Usar DNS de Google (8.8.8.8)" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnDnsCloudflare" Content="Usar DNS de Cloudflare (1.1.1.1)" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnDnsAutomatico" Content="Restaurar DNS Automatico (DHCP)" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnRestartAdaptador" Content="Reiniciar Adaptador Seleccionado" Width="460" Style="{StaticResource ActionButtonStyle}"/>
                    </WrapPanel>
                </StackPanel>
            </ScrollViewer>

            <ScrollViewer x:Name="scrollWin" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                <StackPanel>
                    <TextBlock Text="REPARACION DE WINDOWS" Style="{StaticResource SectionTitleStyle}"/>
                    <TextBlock Text="Repara archivos del sistema y libera espacio en disco." Style="{StaticResource SectionSubtitleStyle}"/>
                    <WrapPanel>
                        <Button x:Name="btnSfc" Content="Reparar Archivos de Sistema (SFC)" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnDism" Content="Reparar Imagen de Windows (DISM)" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnTemporales" Content="Limpiar Archivos Temporales" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnReiniciarServicios" Content="Reiniciar Servicios de Red (DHCP/DNS)" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                    </WrapPanel>
                    <StackPanel Orientation="Horizontal" Margin="0,10,0,0">
                        <TextBlock Text="Unidad:" Style="{StaticResource LabelStyle}"/>
                        <TextBox x:Name="txtUnidad" Text="C:" Width="80" Style="{StaticResource InputStyle}"/>
                        <Button x:Name="btnChkdsk" Content="Verificar Disco (CHKDSK)" Width="220" Margin="10,0,0,0" Style="{StaticResource ActionButtonStyle}"/>
                    </StackPanel>
                </StackPanel>
            </ScrollViewer>

            <ScrollViewer x:Name="scrollInfo" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                <StackPanel>
                    <TextBlock Text="WiredNet" FontSize="28" FontWeight="Bold" Foreground="#2D9CDB" Margin="0,0,0,8"/>
                    <TextBlock Text="Soporte tecnico, cableado estructurado y camaras de seguridad para empresas en Barranquilla." Foreground="#A0AAB4" TextWrapping="Wrap" Width="480" FontSize="13" Margin="0,0,0,22"/>
                    <Button x:Name="btnSitioWeb" Content="Visitar Sitio Web" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                    <Border Height="1" Background="#1B2733" Margin="0,30,0,16" Width="480" HorizontalAlignment="Left"/>
                    <TextBlock Text="Herramienta de soporte v2.0 · Personalizada para WiredNet" Foreground="#6B7785" FontSize="11"/>
                </StackPanel>
            </ScrollViewer>
        </Grid>

        <Border Grid.Row="2" Background="#0D1B2A" Padding="16,12" BorderBrush="#1B2733" BorderThickness="0,2,0,0">
            <DockPanel>
                <DockPanel DockPanel.Dock="Top" LastChildFill="False" Margin="0,0,0,8">
                    <StackPanel Orientation="Horizontal" DockPanel.Dock="Left">
                        <Ellipse x:Name="ledStatus" Width="9" Height="9" Fill="#2D9CDB" Margin="0,0,8,0" VerticalAlignment="Center"/>
                        <TextBlock x:Name="lblStatus" Text="Listo." Foreground="#C7D0D9" FontWeight="SemiBold" VerticalAlignment="Center"/>
                    </StackPanel>
                    <Button x:Name="btnLimpiarConsola" DockPanel.Dock="Right" Content="Limpiar Consola" Style="{StaticResource SmallButtonStyle}"/>
                </DockPanel>
                <TextBox x:Name="txtConsole"
                         Background="#050505" Foreground="#5DD8FF"
                         FontFamily="Consolas" FontSize="13"
                         IsReadOnly="True" TextWrapping="NoWrap"
                         VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Auto"
                         AcceptsReturn="True" BorderThickness="1" BorderBrush="#1F2937"/>
            </DockPanel>
        </Border>
    </Grid>
</Window>
'@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# ---------- Referencias a controles ----------
$imgLogo                  = $window.FindName("imgLogo")
$btnTabDiag                = $window.FindName("btnTabDiag")
$btnTabRed                 = $window.FindName("btnTabRed")
$btnTabWin                 = $window.FindName("btnTabWin")
$btnTabInfo                = $window.FindName("btnTabInfo")
$scrollDiag                = $window.FindName("scrollDiag")
$scrollRed                 = $window.FindName("scrollRed")
$scrollWin                 = $window.FindName("scrollWin")
$scrollInfo                = $window.FindName("scrollInfo")
$btnIpconfig               = $window.FindName("btnIpconfig")
$btnNetstat                = $window.FindName("btnNetstat")
$btnArp                    = $window.FindName("btnArp")
$btnRoute                  = $window.FindName("btnRoute")
$btnWifiPerfiles           = $window.FindName("btnWifiPerfiles")
$btnWifiEscanear           = $window.FindName("btnWifiEscanear")
$btnVelocidad              = $window.FindName("btnVelocidad")
$btnPuertosAbiertos        = $window.FindName("btnPuertosAbiertos")
$txtPingHost               = $window.FindName("txtPingHost")
$btnPing                   = $window.FindName("btnPing")
$txtTracertHost            = $window.FindName("txtTracertHost")
$btnTracert                = $window.FindName("btnTracert")
$txtDominio                = $window.FindName("txtDominio")
$btnNslookup               = $window.FindName("btnNslookup")
$txtTestHost               = $window.FindName("txtTestHost")
$txtTestPuerto             = $window.FindName("txtTestPuerto")
$btnTestPuerto             = $window.FindName("btnTestPuerto")
$cmbAdaptador              = $window.FindName("cmbAdaptador")
$btnRefrescarAdaptadores   = $window.FindName("btnRefrescarAdaptadores")
$btnDhcp                   = $window.FindName("btnDhcp")
$btnLiberar                = $window.FindName("btnLiberar")
$btnRenovar                = $window.FindName("btnRenovar")
$btnFlushDns               = $window.FindName("btnFlushDns")
$btnResetTotal             = $window.FindName("btnResetTotal")
$btnWinsock                = $window.FindName("btnWinsock")
$btnTcpIpReset             = $window.FindName("btnTcpIpReset")
$btnFirewallReset          = $window.FindName("btnFirewallReset")
$btnProxyReset             = $window.FindName("btnProxyReset")
$btnDnsGoogle              = $window.FindName("btnDnsGoogle")
$btnDnsCloudflare          = $window.FindName("btnDnsCloudflare")
$btnDnsAutomatico          = $window.FindName("btnDnsAutomatico")
$btnRestartAdaptador       = $window.FindName("btnRestartAdaptador")
$btnSfc                    = $window.FindName("btnSfc")
$btnDism                   = $window.FindName("btnDism")
$txtUnidad                 = $window.FindName("txtUnidad")
$btnChkdsk                 = $window.FindName("btnChkdsk")
$btnTemporales             = $window.FindName("btnTemporales")
$btnReiniciarServicios     = $window.FindName("btnReiniciarServicios")
$btnSitioWeb               = $window.FindName("btnSitioWeb")
$lblStatus                 = $window.FindName("lblStatus")
$ledStatus                 = $window.FindName("ledStatus")
$btnLimpiarConsola         = $window.FindName("btnLimpiarConsola")
$txtConsole                = $window.FindName("txtConsole")

# ---------- Cargar el logo real ----------
if ($logoPath -and (Test-Path $logoPath)) {
    try {
        $bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
        $bitmap.BeginInit()
        $bitmap.UriSource = New-Object System.Uri($logoPath, [System.UriKind]::Absolute)
        $bitmap.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
        $bitmap.EndInit()
        $imgLogo.Source = $bitmap
        $window.Icon = $bitmap
    } catch {}
}

# ---------- Estado global ----------
$script:isRunning = $false
$script:job = $null
$script:timer = $null
$accentBrush   = New-Object System.Windows.Media.SolidColorBrush ([System.Windows.Media.Color]::FromRgb(45,156,219))
$panelAltBrush = New-Object System.Windows.Media.SolidColorBrush ([System.Windows.Media.Color]::FromRgb(31,41,55))
$ledReadyBrush   = New-Object System.Windows.Media.SolidColorBrush ([System.Windows.Media.Color]::FromRgb(45,156,219))
$ledRunningBrush = New-Object System.Windows.Media.SolidColorBrush ([System.Windows.Media.Color]::FromRgb(245,166,35))

$script:actionButtons = @(
    $btnIpconfig, $btnNetstat, $btnArp, $btnRoute, $btnWifiPerfiles, $btnWifiEscanear, $btnVelocidad, $btnPuertosAbiertos,
    $btnPing, $btnTracert, $btnNslookup, $btnTestPuerto,
    $btnRefrescarAdaptadores, $btnDhcp, $btnLiberar, $btnRenovar, $btnFlushDns, $btnResetTotal,
    $btnWinsock, $btnTcpIpReset, $btnFirewallReset, $btnProxyReset,
    $btnDnsGoogle, $btnDnsCloudflare, $btnDnsAutomatico, $btnRestartAdaptador,
    $btnSfc, $btnDism, $btnChkdsk, $btnTemporales, $btnReiniciarServicios,
    $btnSitioWeb
)

function Set-UIState {
    param([bool]$Enabled)
    foreach ($b in $script:actionButtons) { $b.IsEnabled = $Enabled }
}

function Invoke-WiredNetCommand {
    param(
        [string]$Title,
        [scriptblock]$ScriptBlock,
        [object[]]$ArgumentList = @()
    )
    if ($script:isRunning) {
        [System.Windows.MessageBox]::Show("Espere a que termine la operacion actual.", "WiredNet") | Out-Null
        return
    }
    $script:isRunning = $true
    Set-UIState $false
    $lblStatus.Text = "Ejecutando: $Title..."
    $ledStatus.Fill = $ledRunningBrush
    $txtConsole.AppendText(">>> $Title`r`n")
    $txtConsole.ScrollToEnd()

    $script:job = Start-Job -ScriptBlock $ScriptBlock -ArgumentList $ArgumentList

    $script:timer = New-Object System.Windows.Threading.DispatcherTimer
    $script:timer.Interval = [TimeSpan]::FromMilliseconds(400)
    $script:timer.Add_Tick({
        $out = Receive-Job -Job $script:job
        if ($out) {
            foreach ($line in $out) { $txtConsole.AppendText("$line`r`n") }
            $txtConsole.ScrollToEnd()
        }
        if ($script:job.State -ne 'Running') {
            $script:timer.Stop()
            $remaining = Receive-Job -Job $script:job
            if ($remaining) { foreach ($line in $remaining) { $txtConsole.AppendText("$line`r`n") } }
            Remove-Job -Job $script:job -Force
            $txtConsole.AppendText("--- Finalizado ---`r`n`r`n")
            $txtConsole.ScrollToEnd()
            $lblStatus.Text = "Listo."
            $ledStatus.Fill = $ledReadyBrush
            $script:isRunning = $false
            Set-UIState $true
        }
    })
    $script:timer.Start()
}

# ---------- Navegacion entre pestañas ----------
$panels = @{ diag = $scrollDiag; red = $scrollRed; win = $scrollWin; info = $scrollInfo }
$tabs   = @{ diag = $btnTabDiag; red = $btnTabRed; win = $btnTabWin; info = $btnTabInfo }

function Show-Panel {
    param([string]$Name)
    foreach ($k in $panels.Keys) {
        $panels[$k].Visibility = if ($k -eq $Name) { 'Visible' } else { 'Collapsed' }
    }
    foreach ($k in $tabs.Keys) {
        if ($k -eq $Name) {
            $tabs[$k].Background = $accentBrush
            $tabs[$k].Foreground = [System.Windows.Media.Brushes]::Black
        } else {
            $tabs[$k].Background = $panelAltBrush
            $tabs[$k].Foreground = [System.Windows.Media.Brushes]::White
        }
    }
}

$btnTabDiag.Add_Click({ Show-Panel "diag" })
$btnTabRed.Add_Click({ Show-Panel "red" })
$btnTabWin.Add_Click({ Show-Panel "win" })
$btnTabInfo.Add_Click({ Show-Panel "info" })

# ---------- Eventos: Diagnostico ----------
$btnIpconfig.Add_Click({
    Invoke-WiredNetCommand -Title "ipconfig /all" -ScriptBlock { ipconfig /all }
})
$btnNetstat.Add_Click({
    Invoke-WiredNetCommand -Title "netstat -ano" -ScriptBlock { netstat -ano }
})
$btnArp.Add_Click({
    Invoke-WiredNetCommand -Title "arp -a" -ScriptBlock { arp -a }
})
$btnRoute.Add_Click({
    Invoke-WiredNetCommand -Title "route print" -ScriptBlock { route print }
})
$btnWifiPerfiles.Add_Click({
    Invoke-WiredNetCommand -Title "netsh wlan show profiles" -ScriptBlock {
        netsh wlan show profiles
    }
})
$btnWifiEscanear.Add_Click({
    Invoke-WiredNetCommand -Title "netsh wlan show networks" -ScriptBlock {
        netsh wlan show networks mode=bssid
    }
})
$btnVelocidad.Add_Click({
    Invoke-WiredNetCommand -Title "Prueba de velocidad" -ScriptBlock {
        # Descarga un archivo de prueba y mide el tiempo, sin depender de servicios de terceros con API key
        $url = "https://speed.cloudflare.com/__down?bytes=25000000"
        $destino = Join-Path $env:TEMP "wirednet_speedtest.tmp"
        try {
            $inicio = Get-Date
            Invoke-WebRequest -Uri $url -OutFile $destino -UseBasicParsing
            $fin = Get-Date
            $segundos = ($fin - $inicio).TotalSeconds
            $bytes = (Get-Item $destino).Length
            $mbps = [math]::Round((($bytes * 8) / $segundos) / 1MB, 2)
            "Descarga: $([math]::Round($bytes/1MB,1)) MB en $([math]::Round($segundos,2)) s"
            "Velocidad aproximada: $mbps Mbps"
        } catch {
            "No se pudo completar la prueba de velocidad: $($_.Exception.Message)"
        } finally {
            Remove-Item $destino -Force -ErrorAction SilentlyContinue
        }
    }
})
$btnPuertosAbiertos.Add_Click({
    Invoke-WiredNetCommand -Title "Puertos en escucha" -ScriptBlock {
        Get-NetTCPConnection -State Listen |
            Sort-Object LocalPort |
            Select-Object LocalAddress, LocalPort, OwningProcess |
            Format-Table -AutoSize | Out-String -Width 200
    }
})
$btnPing.Add_Click({
    $hostVal = $txtPingHost.Text
    if ([string]::IsNullOrWhiteSpace($hostVal)) { $hostVal = "8.8.8.8" }
    Invoke-WiredNetCommand -Title "ping $hostVal" -ScriptBlock { param($h) ping -n 4 $h } -ArgumentList $hostVal
})
$btnTracert.Add_Click({
    $hostVal = $txtTracertHost.Text
    if ([string]::IsNullOrWhiteSpace($hostVal)) { $hostVal = "8.8.8.8" }
    Invoke-WiredNetCommand -Title "tracert $hostVal" -ScriptBlock { param($h) tracert $h } -ArgumentList $hostVal
})
$btnNslookup.Add_Click({
    $domVal = $txtDominio.Text
    if ([string]::IsNullOrWhiteSpace($domVal)) { $domVal = "google.com" }
    Invoke-WiredNetCommand -Title "nslookup $domVal" -ScriptBlock { param($d) nslookup $d } -ArgumentList $domVal
})
$btnTestPuerto.Add_Click({
    $hostVal = $txtTestHost.Text
    $puertoVal = $txtTestPuerto.Text
    if ([string]::IsNullOrWhiteSpace($hostVal)) { $hostVal = "google.com" }
    if ([string]::IsNullOrWhiteSpace($puertoVal)) { $puertoVal = "443" }
    Invoke-WiredNetCommand -Title "Test-NetConnection $hostVal -Port $puertoVal" -ScriptBlock {
        param($h, $p)
        Test-NetConnection -ComputerName $h -Port [int]$p | Format-List
    } -ArgumentList $hostVal, $puertoVal
})

# ---------- Eventos: Reparacion de Red ----------
function Refresh-Adapters {
    $cmbAdaptador.Items.Clear()
    try {
        $nombres = Get-NetAdapter | Sort-Object Name | Select-Object -ExpandProperty Name
        foreach ($n in $nombres) { [void]$cmbAdaptador.Items.Add($n) }
        if ($cmbAdaptador.Items.Count -gt 0) { $cmbAdaptador.SelectedIndex = 0 }
    } catch {
        [System.Windows.MessageBox]::Show("No se pudo obtener la lista de adaptadores.", "WiredNet") | Out-Null
    }
}
$btnRefrescarAdaptadores.Add_Click({ Refresh-Adapters })

$btnDhcp.Add_Click({
    $adaptador = $cmbAdaptador.SelectedItem
    if (-not $adaptador) { [System.Windows.MessageBox]::Show("Seleccione un adaptador primero.", "WiredNet") | Out-Null; return }
    Invoke-WiredNetCommand -Title "Habilitar DHCP en $adaptador" -ScriptBlock {
        param($a)
        netsh interface ip set address name="$a" source=dhcp
        netsh interface ip set dns name="$a" source=dhcp
        "DHCP habilitado en $a"
    } -ArgumentList $adaptador
})

$btnLiberar.Add_Click({
    $adaptador = $cmbAdaptador.SelectedItem
    Invoke-WiredNetCommand -Title "ipconfig /release" -ScriptBlock {
        param($a) if ($a) { ipconfig /release "$a" } else { ipconfig /release }
    } -ArgumentList $adaptador
})

$btnRenovar.Add_Click({
    $adaptador = $cmbAdaptador.SelectedItem
    Invoke-WiredNetCommand -Title "ipconfig /renew" -ScriptBlock {
        param($a) if ($a) { ipconfig /renew "$a" } else { ipconfig /renew }
    } -ArgumentList $adaptador
})

$btnFlushDns.Add_Click({
    Invoke-WiredNetCommand -Title "ipconfig /flushdns" -ScriptBlock { ipconfig /flushdns }
})

$btnResetTotal.Add_Click({
    Invoke-WiredNetCommand -Title "Reseteo total de red" -ScriptBlock {
        ipconfig /release
        ipconfig /renew
        ipconfig /flushdns
        ipconfig /registerdns
        "Reseteo total completado"
    }
})

$btnWinsock.Add_Click({
    Invoke-WiredNetCommand -Title "netsh winsock reset" -ScriptBlock {
        netsh winsock reset
        "Reinicie el equipo para aplicar los cambios."
    }
})

$btnTcpIpReset.Add_Click({
    Invoke-WiredNetCommand -Title "netsh int ip reset" -ScriptBlock {
        netsh int ip reset
        "Reinicie el equipo para aplicar los cambios."
    }
})

$btnFirewallReset.Add_Click({
    Invoke-WiredNetCommand -Title "netsh advfirewall reset" -ScriptBlock { netsh advfirewall reset }
})

$btnProxyReset.Add_Click({
    Invoke-WiredNetCommand -Title "netsh winhttp reset proxy" -ScriptBlock { netsh winhttp reset proxy }
})

$btnDnsGoogle.Add_Click({
    $adaptador = $cmbAdaptador.SelectedItem
    if (-not $adaptador) { [System.Windows.MessageBox]::Show("Seleccione un adaptador primero.", "WiredNet") | Out-Null; return }
    Invoke-WiredNetCommand -Title "DNS de Google en $adaptador" -ScriptBlock {
        param($a)
        netsh interface ip set dns name="$a" static 8.8.8.8 primary
        netsh interface ip add dns name="$a" 8.8.4.4 index=2
        "DNS de Google (8.8.8.8 / 8.8.4.4) configurado en $a"
    } -ArgumentList $adaptador
})

$btnDnsCloudflare.Add_Click({
    $adaptador = $cmbAdaptador.SelectedItem
    if (-not $adaptador) { [System.Windows.MessageBox]::Show("Seleccione un adaptador primero.", "WiredNet") | Out-Null; return }
    Invoke-WiredNetCommand -Title "DNS de Cloudflare en $adaptador" -ScriptBlock {
        param($a)
        netsh interface ip set dns name="$a" static 1.1.1.1 primary
        netsh interface ip add dns name="$a" 1.0.0.1 index=2
        "DNS de Cloudflare (1.1.1.1 / 1.0.0.1) configurado en $a"
    } -ArgumentList $adaptador
})

$btnDnsAutomatico.Add_Click({
    $adaptador = $cmbAdaptador.SelectedItem
    if (-not $adaptador) { [System.Windows.MessageBox]::Show("Seleccione un adaptador primero.", "WiredNet") | Out-Null; return }
    Invoke-WiredNetCommand -Title "DNS automatico en $adaptador" -ScriptBlock {
        param($a)
        netsh interface ip set dns name="$a" source=dhcp
        "DNS automatico (DHCP) restaurado en $a"
    } -ArgumentList $adaptador
})

$btnRestartAdaptador.Add_Click({
    $adaptador = $cmbAdaptador.SelectedItem
    if (-not $adaptador) { [System.Windows.MessageBox]::Show("Seleccione un adaptador primero.", "WiredNet") | Out-Null; return }
    Invoke-WiredNetCommand -Title "Reiniciar adaptador $adaptador" -ScriptBlock {
        param($a)
        netsh interface set interface "$a" admin=disable
        Start-Sleep -Seconds 3
        netsh interface set interface "$a" admin=enable
        "Adaptador $a reiniciado"
    } -ArgumentList $adaptador
})

# ---------- Eventos: Reparacion de Windows ----------
$btnSfc.Add_Click({
    Invoke-WiredNetCommand -Title "sfc /scannow" -ScriptBlock { sfc /scannow }
})

$btnDism.Add_Click({
    Invoke-WiredNetCommand -Title "DISM RestoreHealth" -ScriptBlock {
        DISM /Online /Cleanup-Image /ScanHealth
        DISM /Online /Cleanup-Image /RestoreHealth
    }
})

$btnChkdsk.Add_Click({
    $unidad = $txtUnidad.Text
    if ([string]::IsNullOrWhiteSpace($unidad)) { $unidad = "C:" }

    $unidadSistema = $env:SystemDrive
    if ($unidad.TrimEnd('\') -ieq $unidadSistema.TrimEnd('\')) {
        $resp = [System.Windows.MessageBox]::Show(
            "La unidad $unidad es la unidad del sistema. CHKDSK no puede revisarla mientras Windows esta en uso y se debe programar para el proximo reinicio." + "`r`n`r`n" +
            "Desea programar la verificacion para el proximo reinicio?",
            "WiredNet - CHKDSK",
            [System.Windows.MessageBoxButton]::YesNo)
        if ($resp -eq [System.Windows.MessageBoxResult]::Yes) {
            Invoke-WiredNetCommand -Title "chkdsk $unidad /f /r (al reiniciar)" -ScriptBlock {
                param($u)
                # echo Y envia la confirmacion sin depender de la entrada interactiva del job
                cmd.exe /c "echo Y| chkdsk $u /f /r"
            } -ArgumentList $unidad
        }
        return
    }

    Invoke-WiredNetCommand -Title "chkdsk $unidad" -ScriptBlock {
        param($u)
        cmd.exe /c "echo Y| chkdsk $u /f /r"
    } -ArgumentList $unidad
})

$btnTemporales.Add_Click({
    Invoke-WiredNetCommand -Title "Limpieza de temporales" -ScriptBlock {
        Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
        "Limpieza completada"
    }
})

$btnReiniciarServicios.Add_Click({
    Invoke-WiredNetCommand -Title "Reiniciar servicios de red" -ScriptBlock {
        Restart-Service -Name Dhcp -Force -ErrorAction SilentlyContinue
        Restart-Service -Name Dnscache -Force -ErrorAction SilentlyContinue
        "Servicios reiniciados"
    }
})

# ---------- Eventos: WiredNet ----------
$btnSitioWeb.Add_Click({
    Start-Process "https://wire-net-web.vercel.app"
})

$btnLimpiarConsola.Add_Click({ $txtConsole.Clear() })

# ---------- Inicio ----------
$window.Add_ContentRendered({
    Show-Panel "diag"
    Refresh-Adapters
})

[void]$window.ShowDialog()
