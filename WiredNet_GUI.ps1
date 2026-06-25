#  WiredNet - Interfaz Grafica de Soporte Tecnico (WPF)


Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml

# ---------- Autoelevacion a administrador ----------
function Test-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p  = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

$wiredNetRemoteUrl = "https://raw.githubusercontent.com/Alex8amz/Wired-fix/main/WiredNet_GUI.ps1"

if (-not (Test-Admin)) {
    try {
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = "powershell.exe"
        if ($PSCommandPath) {
            $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
        } else {
            $cmdRemoto = "irm '$wiredNetRemoteUrl' | iex"
            $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -Command `"$cmdRemoto`""
        }
        $psi.Verb = "runas"
        [System.Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        [System.Windows.MessageBox]::Show("Esta herramienta necesita permisos de administrador.", "WiredNet") | Out-Null
    }
    exit
}

$scriptDir      = if ($PSScriptRoot) { $PSScriptRoot } else { $null }
$logoUrlRemoto  = "https://raw.githubusercontent.com/Alex8amz/Wired-fix/main/LOGO_WIRED.png"

if ($scriptDir) {
    $logoPath = Join-Path $scriptDir "LOGO_WIRED.png"
} else {
    $logoPath = Join-Path $env:TEMP "WiredNet_LOGO.png"
    if (-not (Test-Path $logoPath)) {
        try { Invoke-WebRequest -Uri $logoUrlRemoto -OutFile $logoPath -UseBasicParsing -ErrorAction Stop }
        catch { $logoPath = $null }
    }
}

# ============================================================
#  XAML
# ============================================================
[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="WiredNet - Soporte Tecnico"
        Height="860" Width="1150" MinHeight="700" MinWidth="980"
        WindowStartupLocation="CenterScreen"
        Background="#0D1117" FontFamily="Segoe UI">
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
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"
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

        <Style x:Key="AutoFixButtonStyle" TargetType="Button">
            <Setter Property="Background" Value="#1a2a1a"/>
            <Setter Property="Foreground" Value="#4ade80"/>
            <Setter Property="BorderBrush" Value="#4ade80"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="14,12"/>
            <Setter Property="Margin" Value="0,0,10,10"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="HorizontalContentAlignment" Value="Center"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"
                                              Margin="{TemplateBinding Padding}"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#4ade80"/>
                    <Setter Property="Foreground" Value="#0D1117"/>
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
            <Setter Property="Padding" Value="16,10"/>
            <Setter Property="Margin" Value="5,0,0,0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"
                                              Margin="{TemplateBinding Padding}"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

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
            <Setter Property="Width" Value="90"/>
        </Style>

        <Style x:Key="SectionTitleStyle" TargetType="TextBlock">
            <Setter Property="Foreground" Value="#2D9CDB"/>
            <Setter Property="FontSize" Value="16"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Margin" Value="0,0,0,4"/>
        </Style>

        <Style x:Key="SectionSubtitleStyle" TargetType="TextBlock">
            <Setter Property="Foreground" Value="#7C8A99"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Margin" Value="0,0,0,14"/>
        </Style>

        <Style x:Key="GroupBoxStyle" TargetType="Border">
            <Setter Property="Background" Value="#111827"/>
            <Setter Property="BorderBrush" Value="#1F2937"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="CornerRadius" Value="6"/>
            <Setter Property="Padding" Value="16,12"/>
            <Setter Property="Margin" Value="0,0,0,14"/>
        </Style>

        <Style x:Key="DarkComboBoxStyle" TargetType="ComboBox">
            <Setter Property="Background" Value="#1C2130"/>
            <Setter Property="Foreground" Value="#D0D8E8"/>
            <Setter Property="BorderBrush" Value="#00C8FF"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Height" Value="32"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ComboBox">
                        <Grid>
                            <ToggleButton x:Name="PART_ToggleButton"
                                          IsChecked="{Binding IsDropDownOpen, Mode=TwoWay, RelativeSource={RelativeSource TemplatedParent}}"
                                          Focusable="False" ClickMode="Press">
                                <ToggleButton.Template>
                                    <ControlTemplate TargetType="ToggleButton">
                                        <Border Background="{Binding Background, RelativeSource={RelativeSource AncestorType=ComboBox}}"
                                                BorderBrush="{Binding BorderBrush, RelativeSource={RelativeSource AncestorType=ComboBox}}"
                                                BorderThickness="1" CornerRadius="4">
                                            <Grid>
                                                <Grid.ColumnDefinitions>
                                                    <ColumnDefinition Width="*"/>
                                                    <ColumnDefinition Width="28"/>
                                                </Grid.ColumnDefinitions>
                                                <Path Grid.Column="1" Data="M 0 0 L 6 6 L 12 0 Z"
                                                      Fill="#00C8FF" Width="10" Height="5"
                                                      HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                            </Grid>
                                        </Border>
                                    </ControlTemplate>
                                </ToggleButton.Template>
                            </ToggleButton>
                            <ContentPresenter x:Name="ContentSite"
                                              Content="{TemplateBinding SelectionBoxItem}"
                                              IsHitTestVisible="False"
                                              Margin="10,0,30,0"
                                              VerticalAlignment="Center"
                                              HorizontalAlignment="Left"
                                              TextBlock.Foreground="#D0D8E8"/>
                            <Popup x:Name="PART_Popup"
                                   IsOpen="{TemplateBinding IsDropDownOpen}"
                                   AllowsTransparency="True"
                                   Placement="Bottom"
                                   MinWidth="{TemplateBinding ActualWidth}"
                                   Focusable="False">
                                <Border Background="#1C2130" BorderBrush="#00C8FF"
                                        BorderThickness="1" CornerRadius="0,0,4,4">
                                    <ScrollViewer MaxHeight="220" VerticalScrollBarVisibility="Auto">
                                        <StackPanel IsItemsHost="True"/>
                                    </ScrollViewer>
                                </Border>
                            </Popup>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Setter Property="ItemContainerStyle">
                <Setter.Value>
                    <Style TargetType="ComboBoxItem">
                        <Setter Property="Background" Value="#1C2130"/>
                        <Setter Property="Foreground" Value="#D0D8E8"/>
                        <Setter Property="Padding" Value="10,7"/>
                        <Setter Property="BorderThickness" Value="0"/>
                        <Setter Property="HorizontalContentAlignment" Value="Left"/>
                        <Setter Property="Template">
                            <Setter.Value>
                                <ControlTemplate TargetType="ComboBoxItem">
                                    <Border Background="{TemplateBinding Background}"
                                            Padding="{TemplateBinding Padding}">
                                        <ContentPresenter/>
                                    </Border>
                                    <ControlTemplate.Triggers>
                                        <Trigger Property="IsMouseOver" Value="True">
                                            <Setter Property="Background" Value="#00C8FF"/>
                                            <Setter Property="Foreground" Value="#0A0E18"/>
                                        </Trigger>
                                        <Trigger Property="IsSelected" Value="True">
                                            <Setter Property="Background" Value="#163A4E"/>
                                            <Setter Property="Foreground" Value="#00C8FF"/>
                                        </Trigger>
                                    </ControlTemplate.Triggers>
                                </ControlTemplate>
                            </Setter.Value>
                        </Setter>
                    </Style>
                </Setter.Value>
            </Setter>
        </Style>

    </Window.Resources>

    <Grid Background="#0D1117">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="300"/>
        </Grid.RowDefinitions>

        <!-- HEADER -->
        <Border Grid.Row="0" Background="#0D1B2A" Padding="22,14"
                BorderBrush="#1B2733" BorderThickness="0,0,0,2">
            <DockPanel>
                <StackPanel Orientation="Horizontal" VerticalAlignment="Center" DockPanel.Dock="Left">
                    <Border CornerRadius="12" Background="#0A141F" Padding="6" Margin="0,0,16,0"
                            BorderBrush="#2D9CDB" BorderThickness="1">
                        <Image x:Name="imgLogo" Width="64" Height="64"
                               RenderOptions.BitmapScalingMode="HighQuality"/>
                    </Border>
                    <StackPanel VerticalAlignment="Center">
                        <TextBlock Text="WiredNet" FontSize="28" FontWeight="Bold" Foreground="#2D9CDB"/>
                        <TextBlock Text="Soporte Tecnico · Diagnostico y Reparacion de Red"
                                   Foreground="#8A96A3" FontSize="12"/>
                    </StackPanel>
                </StackPanel>
                <WrapPanel HorizontalAlignment="Right" VerticalAlignment="Center">
                    <Button x:Name="btnTabDiagRed"   Content="🔍 Diagnostico Red"    Style="{StaticResource TabButtonStyle}"/>
                    <Button x:Name="btnTabSistema"    Content="💻 Sistema"            Style="{StaticResource TabButtonStyle}"/>
                    <Button x:Name="btnTabRed"        Content="🔧 Reparar Red"        Style="{StaticResource TabButtonStyle}"/>
                    <Button x:Name="btnTabWin"        Content="🛠 Reparar Windows"    Style="{StaticResource TabButtonStyle}"/>
                    <Button x:Name="btnTabAutofix"    Content="⚡ Reparacion Rapida"  Style="{StaticResource TabButtonStyle}"/>
                    <Button x:Name="btnTabInfo"       Content="WiredNet"              Style="{StaticResource TabButtonStyle}"/>
                </WrapPanel>
            </DockPanel>
        </Border>

        <!-- CONTENIDO PRINCIPAL -->
        <Grid Grid.Row="1" Margin="22,16">

            <!-- ====== PESTAÑA: DIAGNÓSTICO DE RED ====== -->
            <ScrollViewer x:Name="scrollDiagRed" VerticalScrollBarVisibility="Auto" Visibility="Visible">
                <StackPanel>
                    <TextBlock Text="DIAGNOSTICO DE RED" Style="{StaticResource SectionTitleStyle}"/>
                    <TextBlock Text="Revisa el estado de la red y la conectividad del equipo."
                               Style="{StaticResource SectionSubtitleStyle}"/>
                    <WrapPanel>
                        <Button x:Name="btnIpconfig"        Content="📋 ipconfig /all"                Width="300" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnNetstat"         Content="📡 Conexiones Activas (netstat)" Width="300" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnArp"             Content="🔗 Tabla ARP"                    Width="300" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnRoute"           Content="🗺 Tabla de Enrutamiento"        Width="300" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnWifiPerfiles"    Content="📶 Redes Wi-Fi Guardadas"        Width="300" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnWifiEscanear"    Content="📡 Escanear Wi-Fi Cercanas"      Width="300" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnPuertosAbiertos" Content="🔌 Puertos en Escucha"           Width="300" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnVelocidad"       Content="⚡ Probar Velocidad Internet"    Width="300" Style="{StaticResource ActionButtonStyle}"/>
                    </WrapPanel>
                    <Border Style="{StaticResource GroupBoxStyle}">
                        <StackPanel>
                            <StackPanel Orientation="Horizontal" Margin="0,0,0,10">
                                <TextBlock Text="Host / IP:"  Style="{StaticResource LabelStyle}"/>
                                <TextBox x:Name="txtPingHost" Text="8.8.8.8" Width="160" Style="{StaticResource InputStyle}"/>
                                <Button x:Name="btnPing"    Content="📶 Ping"          Width="140" Margin="8,0,0,0" Style="{StaticResource ActionButtonStyle}"/>
                                <Button x:Name="btnTracert" Content="🗺 Tracert"        Width="140" Margin="8,0,0,0" Style="{StaticResource ActionButtonStyle}"/>
                            </StackPanel>
                            <StackPanel Orientation="Horizontal" Margin="0,0,0,10">
                                <TextBlock Text="Dominio:"    Style="{StaticResource LabelStyle}"/>
                                <TextBox x:Name="txtDominio"  Text="google.com" Width="160" Style="{StaticResource InputStyle}"/>
                                <Button x:Name="btnNslookup" Content="🔍 Consultar DNS" Width="140" Margin="8,0,0,0" Style="{StaticResource ActionButtonStyle}"/>
                            </StackPanel>
                            <StackPanel Orientation="Horizontal">
                                <TextBlock Text="Host:Puerto:" Style="{StaticResource LabelStyle}"/>
                                <TextBox x:Name="txtTestHost"   Text="google.com" Width="140" Style="{StaticResource InputStyle}"/>
                                <TextBox x:Name="txtTestPuerto" Text="443"         Width="60"  Margin="6,0,0,0" Style="{StaticResource InputStyle}"/>
                                <Button x:Name="btnTestPuerto" Content="🔌 Probar Puerto" Width="160" Margin="8,0,0,0" Style="{StaticResource ActionButtonStyle}"/>
                            </StackPanel>
                        </StackPanel>
                    </Border>
                </StackPanel>
            </ScrollViewer>

            <!-- ====== PESTAÑA: DIAGNÓSTICO DEL SISTEMA ====== -->
            <ScrollViewer x:Name="scrollSistema" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                <StackPanel>
                    <TextBlock Text="DIAGNOSTICO DEL SISTEMA" Style="{StaticResource SectionTitleStyle}"/>
                    <TextBlock Text="Informacion completa del hardware, software y estado del equipo."
                               Style="{StaticResource SectionSubtitleStyle}"/>
                    <WrapPanel>
                        <Button x:Name="btnInfoSistema"    Content="💻 Info del Sistema (OS/CPU/RAM)"  Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnEspacioDisco"   Content="💾 Espacio en Discos"              Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnUltimoBoot"     Content="⏱ Ultimo Reinicio del Equipo"      Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnUsoRecursos"    Content="📊 Uso Actual CPU / RAM / Disco"   Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnProcesosTop"    Content="🔝 Top Procesos por CPU/RAM"       Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnStartup"        Content="🚀 Programas al Inicio (Startup)"  Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnDrivers"        Content="🖥 Estado de Drivers"              Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnDriversFallidos" Content="⚠ Drivers con Errores"           Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnBackupDrivers"  Content="💾 Backup de Drivers"             Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnEventosCriticos" Content="🔴 Errores Criticos (24h)"        Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnEventosWarnings" Content="🟡 Advertencias del Sistema (24h)" Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnWindowsUpdate"  Content="🔄 Actualizaciones Pendientes"     Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnTemperatura"    Content="🌡 Temperatura del Sistema"        Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnBateria"        Content="🔋 Estado de Bateria"              Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnAntivirus"      Content="🛡 Estado del Antivirus"           Width="320" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnExportarReporte" Content="📄 Exportar Reporte Completo (PDF)" Width="660" Style="{StaticResource ActionButtonStyle}"/>
                    </WrapPanel>
                </StackPanel>
            </ScrollViewer>

            <!-- ====== PESTAÑA: REPARACIÓN DE RED ====== -->
            <ScrollViewer x:Name="scrollRed" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                <StackPanel>
                    <TextBlock Text="REPARACION DE RED" Style="{StaticResource SectionTitleStyle}"/>
                    <TextBlock Text="Soluciona problemas comunes de conexion." Style="{StaticResource SectionSubtitleStyle}"/>
                    <Border Style="{StaticResource GroupBoxStyle}">
                        <StackPanel>
                            <TextBlock Text="Adaptador de red" Foreground="#7C8A99" FontSize="11" Margin="0,0,0,6"/>
                            <StackPanel Orientation="Horizontal">
                                <ComboBox x:Name="cmbAdaptador" Width="280" Margin="0,0,10,0"
                                          Style="{StaticResource DarkComboBoxStyle}"/>
                                <Button x:Name="btnRefrescarAdaptadores" Content="↻ Actualizar" Width="130" Style="{StaticResource ActionButtonStyle}"/>
                            </StackPanel>
                        </StackPanel>
                    </Border>
                    <WrapPanel>
                        <Button x:Name="btnDhcp"            Content="🔄 Habilitar DHCP"              Width="280" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnLiberar"         Content="📤 Liberar IP"                  Width="280" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnRenovar"         Content="📥 Renovar IP"                  Width="280" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnFlushDns"        Content="🧹 Limpiar Cache DNS"           Width="280" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnResetTotal"      Content="⚡ Reseteo Total de Red"        Width="280" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnWinsock"         Content="🔧 Reiniciar Winsock"           Width="280" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnTcpIpReset"      Content="🔧 Reiniciar Pila TCP/IP"       Width="280" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnFirewallReset"   Content="🛡 Restablecer Firewall"        Width="280" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnProxyReset"      Content="🌐 Restablecer Proxy"           Width="280" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnDnsGoogle"       Content="🔵 DNS Google (8.8.8.8)"        Width="280" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnDnsCloudflare"   Content="🟠 DNS Cloudflare (1.1.1.1)"    Width="280" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnDnsAutomatico"   Content="↩ Restaurar DNS Automatico"     Width="280" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnRestartAdaptador" Content="🔌 Reiniciar Adaptador"        Width="280" Style="{StaticResource ActionButtonStyle}"/>
                    </WrapPanel>
                </StackPanel>
            </ScrollViewer>

            <!-- ====== PESTAÑA: REPARACIÓN WINDOWS ====== -->
            <ScrollViewer x:Name="scrollWin" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                <StackPanel>
                    <TextBlock Text="REPARACION DE WINDOWS" Style="{StaticResource SectionTitleStyle}"/>
                    <TextBlock Text="Repara el sistema operativo, servicios y limpia el equipo."
                               Style="{StaticResource SectionSubtitleStyle}"/>
                    <WrapPanel>
                        <Button x:Name="btnSfc"               Content="🛡 SFC /scannow"                     Width="340" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnDism"              Content="🔧 DISM RestoreHealth"               Width="340" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnReiniciarWU"       Content="🔄 Reparar Windows Update"           Width="340" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnLimpiarWU"         Content="🗑 Limpiar Cache Windows Update"     Width="340" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnGpupdate"          Content="⚙ Forzar Politicas de Grupo (gpupdate)" Width="340" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnMsStore"           Content="🏪 Reparar Microsoft Store"         Width="340" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnSpooler"           Content="🖨 Reiniciar Servicio Impresora"     Width="340" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnServicios"         Content="🔁 Reiniciar Servicios de Red"       Width="340" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnTemporales"        Content="🧹 Limpiar Archivos Temporales"      Width="340" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnPrefetch"          Content="🧹 Limpiar Prefetch"                 Width="340" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnThumbnails"        Content="🧹 Limpiar Miniaturas (Thumbnails)"  Width="340" Style="{StaticResource ActionButtonStyle}"/>
                        <Button x:Name="btnWER"               Content="🧹 Limpiar Reportes de Error (WER)"  Width="340" Style="{StaticResource ActionButtonStyle}"/>
                    </WrapPanel>
                    <Border Style="{StaticResource GroupBoxStyle}">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock Text="Unidad:" Style="{StaticResource LabelStyle}" Width="60"/>
                            <TextBox x:Name="txtUnidad" Text="C:" Width="80" Style="{StaticResource InputStyle}"/>
                            <Button x:Name="btnChkdsk" Content="💾 Verificar Disco (CHKDSK)" Width="240" Margin="10,0,0,0" Style="{StaticResource ActionButtonStyle}"/>
                        </StackPanel>
                    </Border>
                </StackPanel>
            </ScrollViewer>

            <!-- ====== PESTAÑA: REPARACIÓN RÁPIDA ====== -->
            <ScrollViewer x:Name="scrollAutofix" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                <StackPanel>
                    <TextBlock Text="REPARACION RAPIDA" Style="{StaticResource SectionTitleStyle}"/>
                    <TextBlock Text="Soluciones automatizadas de un solo clic para los problemas mas comunes en campo."
                               Style="{StaticResource SectionSubtitleStyle}"/>

                    <Border Style="{StaticResource GroupBoxStyle}">
                        <StackPanel>
                            <TextBlock Text="DIAGNOSTICO" Foreground="#7C8A99" FontSize="11" FontWeight="Bold" Margin="0,0,0,10"/>
                            <WrapPanel>
                                <Button x:Name="btnDiagRapido"    Content="⚡ Diagnostico Rapido Completo"      Width="430" Style="{StaticResource AutoFixButtonStyle}"/>
                            </WrapPanel>
                        </StackPanel>
                    </Border>

                    <Border Style="{StaticResource GroupBoxStyle}">
                        <StackPanel>
                            <TextBlock Text="PROBLEMAS DE RED" Foreground="#7C8A99" FontSize="11" FontWeight="Bold" Margin="0,0,0,10"/>
                            <WrapPanel>
                                <Button x:Name="btnFixNoInternet"   Content="🌐 Sin Acceso a Internet"           Width="340" Style="{StaticResource AutoFixButtonStyle}"/>
                                <Button x:Name="btnFixIpConflict"   Content="⚠ Conflicto de IP"                 Width="340" Style="{StaticResource AutoFixButtonStyle}"/>
                                <Button x:Name="btnFixDnsFail"      Content="🔍 DNS no Resuelve Dominios"        Width="340" Style="{StaticResource AutoFixButtonStyle}"/>
                                <Button x:Name="btnFixWifi"         Content="📶 Wi-Fi Conectado Sin Internet"    Width="340" Style="{StaticResource AutoFixButtonStyle}"/>
                                <Button x:Name="btnFixLento"        Content="🐢 Internet Lento"                  Width="340" Style="{StaticResource AutoFixButtonStyle}"/>
                            </WrapPanel>
                        </StackPanel>
                    </Border>

                    <Border Style="{StaticResource GroupBoxStyle}">
                        <StackPanel>
                            <TextBlock Text="PROBLEMAS DE WINDOWS" Foreground="#7C8A99" FontSize="11" FontWeight="Bold" Margin="0,0,0,10"/>
                            <WrapPanel>
                                <Button x:Name="btnFixLentoSistema" Content="🐢 Sistema Lento"                   Width="340" Style="{StaticResource AutoFixButtonStyle}"/>
                                <Button x:Name="btnFixWU"           Content="🔄 Windows Update Roto"             Width="340" Style="{StaticResource AutoFixButtonStyle}"/>
                                <Button x:Name="btnFixImpresora"    Content="🖨 Impresora No Funciona"            Width="340" Style="{StaticResource AutoFixButtonStyle}"/>
                                <Button x:Name="btnFixCorrupcion"   Content="🔴 Archivos del Sistema Corruptos"  Width="340" Style="{StaticResource AutoFixButtonStyle}"/>
                                <Button x:Name="btnFixLimpiezaTotal" Content="🧹 Limpieza Total del Equipo"      Width="340" Style="{StaticResource AutoFixButtonStyle}"/>
                                <Button x:Name="btnFixActivacion"   Content="🔑 Verificar Activacion Windows"   Width="340" Style="{StaticResource AutoFixButtonStyle}"/>
                            </WrapPanel>
                        </StackPanel>
                    </Border>
                </StackPanel>
            </ScrollViewer>

            <!-- ====== PESTAÑA: INFO ====== -->
            <ScrollViewer x:Name="scrollInfo" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
                <StackPanel>
                    <TextBlock Text="WiredNet" FontSize="28" FontWeight="Bold" Foreground="#2D9CDB" Margin="0,0,0,8"/>
                    <TextBlock Text="Soporte tecnico, cableado estructurado y camaras de seguridad para empresas en Barranquilla."
                               Foreground="#A0AAB4" TextWrapping="Wrap" Width="480" FontSize="13" Margin="0,0,0,22"/>
                    <Button x:Name="btnSitioWeb" Content="🌐 Visitar Sitio Web" Width="220" Style="{StaticResource ActionButtonStyle}"/>
                    <Border Height="1" Background="#1B2733" Margin="0,30,0,16" Width="480" HorizontalAlignment="Left"/>
                    <TextBlock Text="Herramienta de soporte v3.0 · Personalizada para WiredNet" Foreground="#6B7785" FontSize="11"/>
                </StackPanel>
            </ScrollViewer>
        </Grid>

        <!-- CONSOLA -->
        <Border Grid.Row="2" Background="#0D1B2A" Padding="16,12"
                BorderBrush="#1B2733" BorderThickness="0,2,0,0">
            <DockPanel>
                <DockPanel DockPanel.Dock="Top" LastChildFill="False" Margin="0,0,0,8">
                    <StackPanel Orientation="Horizontal" DockPanel.Dock="Left">
                        <Ellipse x:Name="ledStatus" Width="9" Height="9" Fill="#2D9CDB"
                                 Margin="0,0,8,0" VerticalAlignment="Center"/>
                        <TextBlock x:Name="lblStatus" Text="Listo." Foreground="#C7D0D9"
                                   FontWeight="SemiBold" VerticalAlignment="Center"/>
                    </StackPanel>
                    <Button x:Name="btnLimpiarConsola" DockPanel.Dock="Right" Content="Limpiar"
                            Style="{StaticResource SmallButtonStyle}"/>
                </DockPanel>
                <TextBox x:Name="txtConsole"
                         Background="#050505" Foreground="#5DD8FF"
                         FontFamily="Consolas" FontSize="13"
                         IsReadOnly="True" TextWrapping="NoWrap"
                         VerticalScrollBarVisibility="Auto"
                         HorizontalScrollBarVisibility="Auto"
                         AcceptsReturn="True"
                         BorderThickness="1" BorderBrush="#1F2937"/>
            </DockPanel>
        </Border>
    </Grid>
</Window>
'@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# ---- Referencias ----
$imgLogo                = $window.FindName("imgLogo")
$btnTabDiagRed          = $window.FindName("btnTabDiagRed")
$btnTabSistema          = $window.FindName("btnTabSistema")
$btnTabRed              = $window.FindName("btnTabRed")
$btnTabWin              = $window.FindName("btnTabWin")
$btnTabAutofix          = $window.FindName("btnTabAutofix")
$btnTabInfo             = $window.FindName("btnTabInfo")
$scrollDiagRed          = $window.FindName("scrollDiagRed")
$scrollSistema          = $window.FindName("scrollSistema")
$scrollRed              = $window.FindName("scrollRed")
$scrollWin              = $window.FindName("scrollWin")
$scrollAutofix          = $window.FindName("scrollAutofix")
$scrollInfo             = $window.FindName("scrollInfo")
# Diag Red
$btnIpconfig            = $window.FindName("btnIpconfig")
$btnNetstat             = $window.FindName("btnNetstat")
$btnArp                 = $window.FindName("btnArp")
$btnRoute               = $window.FindName("btnRoute")
$btnWifiPerfiles        = $window.FindName("btnWifiPerfiles")
$btnWifiEscanear        = $window.FindName("btnWifiEscanear")
$btnPuertosAbiertos     = $window.FindName("btnPuertosAbiertos")
$btnVelocidad           = $window.FindName("btnVelocidad")
$txtPingHost            = $window.FindName("txtPingHost")
$btnPing                = $window.FindName("btnPing")
$btnTracert             = $window.FindName("btnTracert")
$txtDominio             = $window.FindName("txtDominio")
$btnNslookup            = $window.FindName("btnNslookup")
$txtTestHost            = $window.FindName("txtTestHost")
$txtTestPuerto          = $window.FindName("txtTestPuerto")
$btnTestPuerto          = $window.FindName("btnTestPuerto")
# Sistema
$btnInfoSistema         = $window.FindName("btnInfoSistema")
$btnEspacioDisco        = $window.FindName("btnEspacioDisco")
$btnUltimoBoot          = $window.FindName("btnUltimoBoot")
$btnUsoRecursos         = $window.FindName("btnUsoRecursos")
$btnProcesosTop         = $window.FindName("btnProcesosTop")
$btnStartup             = $window.FindName("btnStartup")
$btnDrivers             = $window.FindName("btnDrivers")
$btnDriversFallidos     = $window.FindName("btnDriversFallidos")
$btnBackupDrivers       = $window.FindName("btnBackupDrivers")
$btnEventosCriticos     = $window.FindName("btnEventosCriticos")
$btnEventosWarnings     = $window.FindName("btnEventosWarnings")
$btnWindowsUpdate       = $window.FindName("btnWindowsUpdate")
$btnTemperatura         = $window.FindName("btnTemperatura")
$btnBateria             = $window.FindName("btnBateria")
$btnAntivirus           = $window.FindName("btnAntivirus")
$btnExportarReporte     = $window.FindName("btnExportarReporte")
# Reparar Red
$cmbAdaptador           = $window.FindName("cmbAdaptador")
$btnRefrescarAdaptadores= $window.FindName("btnRefrescarAdaptadores")
$btnDhcp                = $window.FindName("btnDhcp")
$btnLiberar             = $window.FindName("btnLiberar")
$btnRenovar             = $window.FindName("btnRenovar")
$btnFlushDns            = $window.FindName("btnFlushDns")
$btnResetTotal          = $window.FindName("btnResetTotal")
$btnWinsock             = $window.FindName("btnWinsock")
$btnTcpIpReset          = $window.FindName("btnTcpIpReset")
$btnFirewallReset       = $window.FindName("btnFirewallReset")
$btnProxyReset          = $window.FindName("btnProxyReset")
$btnDnsGoogle           = $window.FindName("btnDnsGoogle")
$btnDnsCloudflare       = $window.FindName("btnDnsCloudflare")
$btnDnsAutomatico       = $window.FindName("btnDnsAutomatico")
$btnRestartAdaptador    = $window.FindName("btnRestartAdaptador")
# Reparar Windows
$btnSfc                 = $window.FindName("btnSfc")
$btnDism                = $window.FindName("btnDism")
$btnReiniciarWU         = $window.FindName("btnReiniciarWU")
$btnLimpiarWU           = $window.FindName("btnLimpiarWU")
$btnGpupdate            = $window.FindName("btnGpupdate")
$btnMsStore             = $window.FindName("btnMsStore")
$btnSpooler             = $window.FindName("btnSpooler")
$btnServicios           = $window.FindName("btnServicios")
$btnTemporales          = $window.FindName("btnTemporales")
$btnPrefetch            = $window.FindName("btnPrefetch")
$btnThumbnails          = $window.FindName("btnThumbnails")
$btnWER                 = $window.FindName("btnWER")
$txtUnidad              = $window.FindName("txtUnidad")
$btnChkdsk              = $window.FindName("btnChkdsk")
# Autofix
$btnDiagRapido          = $window.FindName("btnDiagRapido")
$btnFixNoInternet       = $window.FindName("btnFixNoInternet")
$btnFixIpConflict       = $window.FindName("btnFixIpConflict")
$btnFixDnsFail          = $window.FindName("btnFixDnsFail")
$btnFixWifi             = $window.FindName("btnFixWifi")
$btnFixLento            = $window.FindName("btnFixLento")
$btnFixLentoSistema     = $window.FindName("btnFixLentoSistema")
$btnFixWU               = $window.FindName("btnFixWU")
$btnFixImpresora        = $window.FindName("btnFixImpresora")
$btnFixCorrupcion       = $window.FindName("btnFixCorrupcion")
$btnFixLimpiezaTotal    = $window.FindName("btnFixLimpiezaTotal")
$btnFixActivacion       = $window.FindName("btnFixActivacion")
# Comunes
$btnSitioWeb            = $window.FindName("btnSitioWeb")
$lblStatus              = $window.FindName("lblStatus")
$ledStatus              = $window.FindName("ledStatus")
$btnLimpiarConsola      = $window.FindName("btnLimpiarConsola")
$txtConsole             = $window.FindName("txtConsole")

# ---- Logo ----
if ($logoPath -and (Test-Path $logoPath)) {
    try {
        $bmp = New-Object System.Windows.Media.Imaging.BitmapImage
        $bmp.BeginInit()
        $bmp.UriSource  = New-Object System.Uri($logoPath, [System.UriKind]::Absolute)
        $bmp.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
        $bmp.EndInit()
        $imgLogo.Source = $bmp
        $window.Icon    = $bmp
    } catch {}
}

# ---- Estado global ----
$script:isRunning   = $false
$script:job         = $null
$script:timer       = $null

$accentBrush     = New-Object System.Windows.Media.SolidColorBrush ([System.Windows.Media.Color]::FromRgb(45,156,219))
$panelAltBrush   = New-Object System.Windows.Media.SolidColorBrush ([System.Windows.Media.Color]::FromRgb(31,41,55))
$ledReadyBrush   = New-Object System.Windows.Media.SolidColorBrush ([System.Windows.Media.Color]::FromRgb(45,156,219))
$ledRunningBrush = New-Object System.Windows.Media.SolidColorBrush ([System.Windows.Media.Color]::FromRgb(245,166,35))

$script:actionButtons = @(
    $btnIpconfig, $btnNetstat, $btnArp, $btnRoute, $btnWifiPerfiles, $btnWifiEscanear,
    $btnPuertosAbiertos, $btnVelocidad, $btnPing, $btnTracert, $btnNslookup, $btnTestPuerto,
    $btnInfoSistema, $btnEspacioDisco, $btnUltimoBoot, $btnUsoRecursos, $btnProcesosTop,
    $btnStartup, $btnDrivers, $btnDriversFallidos, $btnBackupDrivers, $btnEventosCriticos, $btnEventosWarnings,
    $btnWindowsUpdate, $btnTemperatura, $btnBateria, $btnAntivirus, $btnExportarReporte,
    $btnRefrescarAdaptadores, $btnDhcp, $btnLiberar, $btnRenovar, $btnFlushDns, $btnResetTotal,
    $btnWinsock, $btnTcpIpReset, $btnFirewallReset, $btnProxyReset,
    $btnDnsGoogle, $btnDnsCloudflare, $btnDnsAutomatico, $btnRestartAdaptador,
    $btnSfc, $btnDism, $btnReiniciarWU, $btnLimpiarWU, $btnGpupdate, $btnMsStore,
    $btnSpooler, $btnServicios, $btnTemporales, $btnPrefetch, $btnThumbnails, $btnWER, $btnChkdsk,
    $btnDiagRapido, $btnFixNoInternet, $btnFixIpConflict, $btnFixDnsFail, $btnFixWifi,
    $btnFixLento, $btnFixLentoSistema, $btnFixWU, $btnFixImpresora, $btnFixCorrupcion,
    $btnFixLimpiezaTotal, $btnFixActivacion, $btnSitioWeb
)

function Set-UIState {
    param([bool]$Enabled)
    foreach ($b in $script:actionButtons) { if ($b) { $b.IsEnabled = $Enabled } }
}

function Invoke-WiredNetCommand {
    param([string]$Title, [scriptblock]$ScriptBlock, [object[]]$ArgumentList = @())
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
        if ($out) { foreach ($l in $out) { $txtConsole.AppendText("$l`r`n") }; $txtConsole.ScrollToEnd() }
        if ($script:job.State -ne 'Running') {
            $script:timer.Stop()
            $rem = Receive-Job -Job $script:job
            if ($rem) { foreach ($l in $rem) { $txtConsole.AppendText("$l`r`n") } }
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

# ======================================================
#  NAVEGACION
# ======================================================
$panels = @{
    diagred  = $scrollDiagRed
    sistema  = $scrollSistema
    red      = $scrollRed
    win      = $scrollWin
    autofix  = $scrollAutofix
    info     = $scrollInfo
}
$tabs = @{
    diagred  = $btnTabDiagRed
    sistema  = $btnTabSistema
    red      = $btnTabRed
    win      = $btnTabWin
    autofix  = $btnTabAutofix
    info     = $btnTabInfo
}

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

$btnTabDiagRed.Add_Click({ Show-Panel "diagred" })
$btnTabSistema.Add_Click({ Show-Panel "sistema" })
$btnTabRed.Add_Click({     Show-Panel "red"     })
$btnTabWin.Add_Click({     Show-Panel "win"     })
$btnTabAutofix.Add_Click({ Show-Panel "autofix" })
$btnTabInfo.Add_Click({    Show-Panel "info"    })

# ======================================================
#  EVENTOS: DIAGNÓSTICO DE RED
# ======================================================
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
    Invoke-WiredNetCommand -Title "Redes Wi-Fi guardadas" -ScriptBlock { netsh wlan show profiles }
})
$btnWifiEscanear.Add_Click({
    Invoke-WiredNetCommand -Title "Escanear Wi-Fi" -ScriptBlock { netsh wlan show networks mode=bssid }
})
$btnPuertosAbiertos.Add_Click({
    Invoke-WiredNetCommand -Title "Puertos en escucha" -ScriptBlock {
        Get-NetTCPConnection -State Listen |
            Sort-Object LocalPort |
            Select-Object LocalAddress, LocalPort, OwningProcess |
            Format-Table -AutoSize | Out-String -Width 200
    }
})
$btnVelocidad.Add_Click({
    Invoke-WiredNetCommand -Title "Prueba de velocidad" -ScriptBlock {
        $url  = "https://speed.cloudflare.com/__down?bytes=25000000"
        $dest = Join-Path $env:TEMP "wn_speed.tmp"
        try {
            $t1   = Get-Date
            Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
            $seg  = ((Get-Date) - $t1).TotalSeconds
            $mb   = (Get-Item $dest).Length / 1MB
            $mbps = [math]::Round(($mb * 8) / $seg, 2)
            "Descarga: $([math]::Round($mb,1)) MB en $([math]::Round($seg,2)) s"
            "Velocidad aproximada: $mbps Mbps"
        } catch { "Error: $($_.Exception.Message)" }
        finally { Remove-Item $dest -Force -ErrorAction SilentlyContinue }
    }
})
$btnPing.Add_Click({
    $h = if ($txtPingHost.Text) { $txtPingHost.Text } else { "8.8.8.8" }
    Invoke-WiredNetCommand -Title "ping $h" -ScriptBlock { param($h) ping -n 4 $h } -ArgumentList $h
})
$btnTracert.Add_Click({
    $h = if ($txtPingHost.Text) { $txtPingHost.Text } else { "8.8.8.8" }
    Invoke-WiredNetCommand -Title "tracert $h" -ScriptBlock { param($h) tracert $h } -ArgumentList $h
})
$btnNslookup.Add_Click({
    $d = if ($txtDominio.Text) { $txtDominio.Text } else { "google.com" }
    Invoke-WiredNetCommand -Title "nslookup $d" -ScriptBlock { param($d) nslookup $d } -ArgumentList $d
})
$btnTestPuerto.Add_Click({
    $h = if ($txtTestHost.Text)   { $txtTestHost.Text }   else { "google.com" }
    $p = if ($txtTestPuerto.Text) { $txtTestPuerto.Text } else { "443" }
    Invoke-WiredNetCommand -Title "Test-NetConnection $h :$p" -ScriptBlock {
        param($h,$p) Test-NetConnection -ComputerName $h -Port ([int]$p) | Format-List
    } -ArgumentList $h,$p
})

# ======================================================
#  EVENTOS: DIAGNÓSTICO DEL SISTEMA
# ======================================================
$btnInfoSistema.Add_Click({
    Invoke-WiredNetCommand -Title "Info del Sistema" -ScriptBlock {
        $os  = Get-CimInstance Win32_OperatingSystem
        $cs  = Get-CimInstance Win32_ComputerSystem
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        $ram = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
        "========== INFORMACION DEL SISTEMA =========="
        "Equipo       : $($cs.Name)"
        "Fabricante   : $($cs.Manufacturer) $($cs.Model)"
        "OS           : $($os.Caption) $($os.OSArchitecture)"
        "Version      : $($os.Version)  Build $($os.BuildNumber)"
        "CPU          : $($cpu.Name)"
        "Nucleos      : $($cpu.NumberOfCores) fisicos / $($cpu.NumberOfLogicalProcessors) logicos"
        "RAM Total    : $ram GB"
        $ramLibre = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        "RAM Libre    : $ramLibre GB"
        "Dominio      : $($cs.Domain)"
        "Usuario      : $($env:USERNAME)"
    }
})
$btnEspacioDisco.Add_Click({
    Invoke-WiredNetCommand -Title "Espacio en Discos" -ScriptBlock {
        "========== ESPACIO EN DISCOS =========="
        Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } |
            ForEach-Object {
                $total = [math]::Round(($_.Used + $_.Free) / 1GB, 2)
                $usado = [math]::Round($_.Used / 1GB, 2)
                $libre = [math]::Round($_.Free / 1GB, 2)
                $pct   = if ($total -gt 0) { [math]::Round($usado / $total * 100, 1) } else { 0 }
                "$($_.Name):\  Total: $total GB  |  Usado: $usado GB ($pct%)  |  Libre: $libre GB"
            }
    }
})
$btnUltimoBoot.Add_Click({
    Invoke-WiredNetCommand -Title "Ultimo reinicio" -ScriptBlock {
        $os   = Get-CimInstance Win32_OperatingSystem
        $boot = $os.LastBootUpTime
        $up   = (Get-Date) - $boot
        "Ultimo reinicio : $($boot.ToString('dd/MM/yyyy HH:mm:ss'))"
        "Tiempo encendido: $($up.Days) dias, $($up.Hours) horas, $($up.Minutes) minutos"
    }
})
$btnUsoRecursos.Add_Click({
    Invoke-WiredNetCommand -Title "Uso actual de recursos" -ScriptBlock {
        $os  = Get-CimInstance Win32_OperatingSystem
        $cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average
        $ramTotal = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
        $ramLibre = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        $ramUsado = [math]::Round($ramTotal - $ramLibre, 2)
        $ramPct   = [math]::Round($ramUsado / $ramTotal * 100, 1)
        "CPU en uso   : $([math]::Round($cpu.Average, 1)) %"
        "RAM Total    : $ramTotal GB"
        "RAM en uso   : $ramUsado GB ($ramPct %)"
        "RAM libre    : $ramLibre GB"
        ""
        "Discos:"
        Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } |
            ForEach-Object {
                $total = $_.Used + $_.Free
                $pct   = if ($total -gt 0) { [math]::Round($_.Used / $total * 100, 1) } else { 0 }
                "  $($_.Name):\  Usado: $pct %  |  Libre: $([math]::Round($_.Free/1GB,1)) GB"
            }
    }
})
$btnProcesosTop.Add_Click({
    Invoke-WiredNetCommand -Title "Top procesos por CPU y RAM" -ScriptBlock {
        "===== TOP 15 PROCESOS POR CPU ====="
        Get-Process | Sort-Object CPU -Descending | Select-Object -First 15 |
            Format-Table Name, Id, CPU, @{N='RAM(MB)';E={[math]::Round($_.WorkingSet64/1MB,1)}} -AutoSize |
            Out-String -Width 200
        "===== TOP 15 PROCESOS POR RAM ====="
        Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 15 |
            Format-Table Name, Id, @{N='RAM(MB)';E={[math]::Round($_.WorkingSet64/1MB,1)}}, CPU -AutoSize |
            Out-String -Width 200
    }
})
$btnStartup.Add_Click({
    Invoke-WiredNetCommand -Title "Programas al inicio" -ScriptBlock {
        "===== STARTUP (Registro HKCU) ====="
        Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue |
            Select-Object * -ExcludeProperty PS* | Out-String
        "===== STARTUP (Registro HKLM) ====="
        Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue |
            Select-Object * -ExcludeProperty PS* | Out-String
        "===== STARTUP (Carpeta usuario) ====="
        $ruta = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
        Get-ChildItem $ruta -ErrorAction SilentlyContinue | Select-Object Name, FullName | Format-Table | Out-String
    }
})
$btnDrivers.Add_Click({
    Invoke-WiredNetCommand -Title "Estado de drivers" -ScriptBlock {
        Get-WmiObject Win32_PnPEntity |
            Where-Object { $_.ConfigManagerErrorCode -eq 0 } |
            Select-Object Name, Status |
            Sort-Object Name |
            Format-Table -AutoSize | Out-String -Width 200
    }
})
$btnDriversFallidos.Add_Click({
    Invoke-WiredNetCommand -Title "Drivers con errores" -ScriptBlock {
        $drivers = Get-WmiObject Win32_PnPEntity |
            Where-Object { $_.ConfigManagerErrorCode -ne 0 }
        if ($drivers) {
            $drivers | Select-Object Name, ConfigManagerErrorCode, Status |
                Format-Table -AutoSize | Out-String -Width 200
        } else { "No se encontraron drivers con errores. Todo parece OK." }
    }
})

$btnBackupDrivers.Add_Click({
    # Abrir el selector de carpeta en el hilo de la UI (antes del job)
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description     = "Seleccione la carpeta de destino para el Backup de Drivers"
    $dialog.ShowNewFolderButton = $true
    $dialog.SelectedPath    = "$env:USERPROFILE\Desktop"

    $resultado = $dialog.ShowDialog()
    if ($resultado -ne [System.Windows.Forms.DialogResult]::OK) {
        $txtConsole.AppendText(">>> Backup de Drivers cancelado por el usuario.`r`n`r`n")
        $txtConsole.ScrollToEnd()
        return
    }

    $rutaElegida = Join-Path $dialog.SelectedPath "WiredNet_Backup_Drivers"

    Invoke-WiredNetCommand -Title "Backup de Drivers" -ScriptBlock {
        param($destino)
        New-Item -ItemType Directory -Path $destino -Force | Out-Null
        "Iniciando backup de drivers..."
        "Destino seleccionado: $destino"
        "Ejecutando: pnputil /export-driver * ..."
        ""
        $resultado = pnputil /export-driver * "$destino" 2>&1
        $resultado
        ""
        $total = (Get-ChildItem $destino -Directory -ErrorAction SilentlyContinue).Count
        "Backup completado. Carpetas de drivers exportadas: $total"
        "Ubicacion final: $destino"
    } -ArgumentList $rutaElegida
})

$btnEventosCriticos.Add_Click({
    Invoke-WiredNetCommand -Title "Errores criticos (ultimas 24h)" -ScriptBlock {
        $desde = (Get-Date).AddHours(-24)
        $events = Get-EventLog -LogName System -EntryType Error -After $desde -Newest 30 -ErrorAction SilentlyContinue
        if ($events) {
            $events | Format-Table TimeGenerated, Source, EventID, Message -AutoSize -Wrap | Out-String -Width 300
        } else { "No se encontraron errores criticos en las ultimas 24 horas." }
    }
})
$btnEventosWarnings.Add_Click({
    Invoke-WiredNetCommand -Title "Advertencias del sistema (24h)" -ScriptBlock {
        $desde = (Get-Date).AddHours(-24)
        $events = Get-EventLog -LogName System -EntryType Warning -After $desde -Newest 30 -ErrorAction SilentlyContinue
        if ($events) {
            $events | Format-Table TimeGenerated, Source, EventID, Message -AutoSize -Wrap | Out-String -Width 300
        } else { "No se encontraron advertencias en las ultimas 24 horas." }
    }
})
$btnWindowsUpdate.Add_Click({
    Invoke-WiredNetCommand -Title "Actualizaciones pendientes" -ScriptBlock {
        try {
            $sess   = New-Object -ComObject Microsoft.Update.Session
            $search = $sess.CreateUpdateSearcher()
            $result = $search.Search("IsInstalled=0 and Type='Software'")
            if ($result.Updates.Count -eq 0) {
                "El sistema esta al dia. No hay actualizaciones pendientes."
            } else {
                "Se encontraron $($result.Updates.Count) actualizacion(es) pendiente(s):"
                foreach ($u in $result.Updates) { "  - $($u.Title)" }
            }
        } catch { "No se pudo consultar Windows Update: $($_.Exception.Message)" }
    }
})
$btnTemperatura.Add_Click({
    Invoke-WiredNetCommand -Title "Temperatura del sistema" -ScriptBlock {
        try {
            $temps = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi" -ErrorAction Stop
            foreach ($t in $temps) {
                $c = [math]::Round($t.CurrentTemperature / 10 - 273.15, 1)
                "Zona termica: $c °C"
            }
        } catch {
            "No se pudo leer la temperatura via WMI (depende del fabricante del equipo)."
            "Considera usar HWMonitor o SpeedFan para lectura detallada."
        }
    }
})
$btnBateria.Add_Click({
    Invoke-WiredNetCommand -Title "Estado de bateria" -ScriptBlock {
        $bat = Get-WmiObject Win32_Battery -ErrorAction SilentlyContinue
        if ($bat) {
            foreach ($b in $bat) {
                "Bateria          : $($b.Name)"
                "Carga actual     : $($b.EstimatedChargeRemaining) %"
                $estado = switch ($b.BatteryStatus) {
                    1 { "Descargando" } 2 { "Cargando (CA)" } 3 { "Carga completa" }
                    default { "Estado $($b.BatteryStatus)" }
                }
                "Estado           : $estado"
                "Tiempo restante  : $($b.EstimatedRunTime) minutos (aprox)"
            }
        } else { "No se detecto bateria. El equipo puede ser de escritorio o el driver no reporta datos." }
    }
})
$btnAntivirus.Add_Click({
    Invoke-WiredNetCommand -Title "Estado del antivirus" -ScriptBlock {
        try {
            $av = Get-CimInstance -Namespace "root/SecurityCenter2" -ClassName AntiVirusProduct -ErrorAction Stop
            if ($av) {
                foreach ($a in $av) {
                    "Antivirus : $($a.displayName)"
                    $estadoCodigo = $a.productState.ToString("X6")
                    $activo  = $estadoCodigo.Substring(2,2) -ne "00"
                    $alDia   = $estadoCodigo.Substring(4,2) -eq "00"
                    "Activo    : $(if ($activo) {'Si'} else {'No (ADVERTENCIA)'})"
                    "Firmas    : $(if ($alDia) {'Al dia'} else {'DESACTUALIZADAS'})"
                    ""
                }
            } else { "No se detecto ningun antivirus instalado." }
        } catch { "No se pudo consultar SecurityCenter2: $($_.Exception.Message)" }
    }
})
$btnExportarReporte.Add_Click({
    Invoke-WiredNetCommand -Title "Exportar Reporte PDF" -ScriptBlock {
        $fecha    = Get-Date -Format "yyyy-MM-dd_HH-mm"
        $htmlPath = "$env:TEMP\WiredNet_Reporte_$fecha.html"
        $pdfPath  = "$env:USERPROFILE\Desktop\WiredNet_Reporte_$fecha.pdf"

        # ── Recopilar datos ──────────────────────────────────────
        $os      = Get-CimInstance Win32_OperatingSystem
        $cs      = Get-CimInstance Win32_ComputerSystem
        $cpu     = Get-CimInstance Win32_Processor | Select-Object -First 1
        $ram     = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
        $ramLibre= [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        $boot    = $os.LastBootUpTime
        $up      = (Get-Date) - $boot
        $cpuUso  = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average

        $diskRows = (Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | ForEach-Object {
            $total = [math]::Round(($_.Used + $_.Free)/1GB, 2)
            $usado = [math]::Round($_.Used/1GB, 2)
            $libre = [math]::Round($_.Free/1GB, 2)
            $pct   = if ($total -gt 0) { [math]::Round($usado/$total*100,1) } else { 0 }
            $color = if ($pct -ge 90) { "#FF4C4C" } elseif ($pct -ge 75) { "#FFA500" } else { "#00C8FF" }
            "<tr><td><b>$($_.Name):\</b></td><td>$total GB</td><td>$usado GB</td><td>$libre GB</td><td style='color:$color;font-weight:bold'>$pct%</td></tr>"
        }) -join ""

        $ipconfigData = (ipconfig /all | Out-String) -replace "&","&amp;" -replace "<","&lt;" -replace ">","&gt;"

        $driversError = Get-WmiObject Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }
        $driversRows  = if ($driversError) {
            ($driversError | ForEach-Object {
                "<tr><td>$($_.Name -replace '&','&amp;')</td><td style='color:#FF4C4C'>Error $($_.ConfigManagerErrorCode)</td><td>$($_.Status)</td></tr>"
            }) -join ""
        } else { "<tr><td colspan='3' style='color:#00C8FF;text-align:center'>✔ Sin drivers con errores</td></tr>" }

        $eventosData = try {
            $evs = Get-EventLog -LogName System -EntryType Error -After (Get-Date).AddHours(-24) -Newest 15 -ErrorAction Stop
            if ($evs) {
                ($evs | ForEach-Object {
                    "<tr><td>$($_.TimeGenerated.ToString('HH:mm:ss'))</td><td>$($_.Source -replace '&','&amp;')</td><td>$($_.EventID)</td><td>$($_.Message.Split("`n")[0] -replace '&','&amp;' -replace '<','&lt;')</td></tr>"
                }) -join ""
            } else { "<tr><td colspan='4' style='color:#00C8FF;text-align:center'>✔ Sin errores críticos en las últimas 24h</td></tr>" }
        } catch { "<tr><td colspan='4'>No se pudo leer el Visor de Eventos.</td></tr>" }

        $avData = try {
            $av = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct -ErrorAction Stop
            ($av | ForEach-Object { "<tr><td>$($_.displayName)</td><td>$($_.productState)</td></tr>" }) -join ""
        } catch { "<tr><td colspan='2'>No se pudo leer SecurityCenter2.</td></tr>" }

        # ── Generar HTML ─────────────────────────────────────────
        $html = @"
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8"/>
<title>WiredNet - Reporte de Diagnóstico</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap');
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: 'Inter', 'Segoe UI', sans-serif; background: #f4f6fa; color: #1a2233; font-size: 12px; }

  .header { background: linear-gradient(135deg, #0A0E18 0%, #0D1B3E 100%);
            color: white; padding: 32px 40px; display: flex; align-items: center; gap: 24px; }
  .header-title { font-size: 28px; font-weight: 700; color: #00C8FF; letter-spacing: 1px; }
  .header-sub   { font-size: 12px; color: #8B95A8; margin-top: 4px; }
  .header-meta  { margin-left: auto; text-align: right; font-size: 11px; color: #8B95A8; line-height: 1.8; }
  .header-meta span { color: #00C8FF; font-weight: 600; }

  .badge { display: inline-block; background: #00C8FF22; border: 1px solid #00C8FF55;
           color: #00C8FF; padding: 2px 10px; border-radius: 20px; font-size: 10px;
           font-weight: 600; margin-top: 8px; letter-spacing: 0.5px; }

  .content { padding: 28px 40px; }

  .section { background: white; border-radius: 8px; box-shadow: 0 1px 4px #0001;
             margin-bottom: 20px; overflow: hidden; border: 1px solid #e5e9f0; }
  .section-title { background: #0A0E18; color: #00C8FF; font-size: 11px; font-weight: 700;
                   letter-spacing: 1.5px; padding: 10px 18px; text-transform: uppercase; }

  .info-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0; }
  .info-card { padding: 16px 18px; border-right: 1px solid #f0f2f7; border-bottom: 1px solid #f0f2f7; }
  .info-card:nth-child(3n) { border-right: none; }
  .info-label { font-size: 10px; color: #8B95A8; font-weight: 600; text-transform: uppercase;
                letter-spacing: 0.5px; margin-bottom: 4px; }
  .info-value { font-size: 13px; font-weight: 600; color: #1a2233; }

  table { width: 100%; border-collapse: collapse; font-size: 11px; }
  thead tr { background: #f8fafc; }
  th { padding: 9px 14px; text-align: left; font-weight: 600; color: #5A6478;
       font-size: 10px; text-transform: uppercase; letter-spacing: 0.5px;
       border-bottom: 2px solid #e5e9f0; }
  td { padding: 9px 14px; border-bottom: 1px solid #f0f2f7; color: #374151; }
  tr:last-child td { border-bottom: none; }
  tr:hover td { background: #f8fbff; }

  pre { background: #0A0E18; color: #00C8FF; padding: 16px 18px; font-size: 10px;
        font-family: 'Consolas', monospace; overflow: auto; white-space: pre-wrap;
        word-break: break-all; line-height: 1.6; }

  .footer { text-align: center; padding: 20px; font-size: 10px; color: #8B95A8;
            border-top: 1px solid #e5e9f0; background: white; margin-top: 8px; }
  .footer span { color: #00C8FF; font-weight: 600; }
</style>
</head>
<body>

<div class="header">
  <div>
    <div class="header-title">WiredNet</div>
    <div class="header-sub">Soporte Técnico · Barranquilla, Colombia</div>
    <div class="badge">REPORTE DE DIAGNÓSTICO</div>
  </div>
  <div class="header-meta">
    <div>Técnico: <span>$env:USERNAME</span></div>
    <div>Equipo: <span>$($cs.Name)</span></div>
    <div>Fecha: <span>$(Get-Date -Format 'dd/MM/yyyy HH:mm')</span></div>
  </div>
</div>

<div class="content">

  <div class="section">
    <div class="section-title">Información del Sistema</div>
    <div class="info-grid">
      <div class="info-card"><div class="info-label">Sistema Operativo</div><div class="info-value">$($os.Caption)</div></div>
      <div class="info-card"><div class="info-label">Versión / Build</div><div class="info-value">$($os.Version) · Build $($os.BuildNumber)</div></div>
      <div class="info-card"><div class="info-label">Arquitectura</div><div class="info-value">$($os.OSArchitecture)</div></div>
      <div class="info-card"><div class="info-label">Fabricante / Modelo</div><div class="info-value">$($cs.Manufacturer) $($cs.Model)</div></div>
      <div class="info-card"><div class="info-label">Procesador</div><div class="info-value">$($cpu.Name)</div></div>
      <div class="info-card"><div class="info-label">Núcleos / Lógicos</div><div class="info-value">$($cpu.NumberOfCores) / $($cpu.NumberOfLogicalProcessors)</div></div>
      <div class="info-card"><div class="info-label">RAM Total</div><div class="info-value">$ram GB</div></div>
      <div class="info-card"><div class="info-label">RAM Libre</div><div class="info-value">$ramLibre GB</div></div>
      <div class="info-card"><div class="info-label">Uso CPU</div><div class="info-value">$cpuUso %</div></div>
      <div class="info-card"><div class="info-label">Último Reinicio</div><div class="info-value">$($boot.ToString('dd/MM/yyyy HH:mm'))</div></div>
      <div class="info-card"><div class="info-label">Tiempo Encendido</div><div class="info-value">$($up.Days)d $($up.Hours)h $($up.Minutes)m</div></div>
      <div class="info-card"><div class="info-label">Dominio / Grupo</div><div class="info-value">$($cs.Domain)</div></div>
    </div>
  </div>

  <div class="section">
    <div class="section-title">Discos</div>
    <table><thead><tr><th>Unidad</th><th>Total</th><th>Usado</th><th>Libre</th><th>Uso %</th></tr></thead>
    <tbody>$diskRows</tbody></table>
  </div>

  <div class="section">
    <div class="section-title">Configuración de Red</div>
    <pre>$ipconfigData</pre>
  </div>

  <div class="section">
    <div class="section-title">Drivers con Errores</div>
    <table><thead><tr><th>Dispositivo</th><th>Código de Error</th><th>Estado</th></tr></thead>
    <tbody>$driversRows</tbody></table>
  </div>

  <div class="section">
    <div class="section-title">Eventos Críticos — Últimas 24h</div>
    <table><thead><tr><th>Hora</th><th>Origen</th><th>ID</th><th>Descripción</th></tr></thead>
    <tbody>$eventosData</tbody></table>
  </div>

  <div class="section">
    <div class="section-title">Antivirus</div>
    <table><thead><tr><th>Nombre</th><th>Estado</th></tr></thead>
    <tbody>$avData</tbody></table>
  </div>

</div>

<div class="footer">
  Generado por <span>WiredNet Toolkit</span> · <span>wire-net-web.vercel.app</span> · $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')
</div>

</body>
</html>
"@
        $html | Out-File -FilePath $htmlPath -Encoding UTF8

        # ── Convertir a PDF con Microsoft Edge ───────────────────
        $edgePaths = @(
            "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
            "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
        )
        $edge = $edgePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

        if ($edge) {
            "Generando PDF con Microsoft Edge..."
            $args = "--headless --disable-gpu --no-sandbox --print-to-pdf=`"$pdfPath`" --print-to-pdf-no-header `"$htmlPath`""
            Start-Process -FilePath $edge -ArgumentList $args -Wait -WindowStyle Hidden
            Start-Sleep -Seconds 2
            if (Test-Path $pdfPath) {
                "Reporte PDF guardado en:"
                "  $pdfPath"
                "Abriendo reporte..."
                Start-Process $pdfPath
            } else {
                "Edge no pudo generar el PDF. Abriendo reporte HTML en su lugar..."
                Start-Process $htmlPath
            }
        } else {
            "Microsoft Edge no encontrado. Abriendo reporte HTML..."
            Start-Process $htmlPath
        }
    }
})

# ======================================================
#  EVENTOS: REPARACIÓN DE RED
# ======================================================
function Refresh-Adapters {
    $cmbAdaptador.Items.Clear()
    try {
        Get-NetAdapter | Sort-Object Name | ForEach-Object { [void]$cmbAdaptador.Items.Add($_.Name) }
        if ($cmbAdaptador.Items.Count -gt 0) { $cmbAdaptador.SelectedIndex = 0 }
    } catch {}
}
$btnRefrescarAdaptadores.Add_Click({ Refresh-Adapters })

$btnDhcp.Add_Click({
    $a = $cmbAdaptador.SelectedItem
    if (-not $a) { [System.Windows.MessageBox]::Show("Seleccione un adaptador.", "WiredNet") | Out-Null; return }
    Invoke-WiredNetCommand -Title "Habilitar DHCP en $a" -ScriptBlock {
        param($a)
        netsh interface ip set address name="$a" source=dhcp
        netsh interface ip set dns name="$a" source=dhcp
        "DHCP habilitado en $a"
    } -ArgumentList $a
})
$btnLiberar.Add_Click({
    $a = $cmbAdaptador.SelectedItem
    Invoke-WiredNetCommand -Title "ipconfig /release" -ScriptBlock { param($a) if ($a) { ipconfig /release "$a" } else { ipconfig /release } } -ArgumentList $a
})
$btnRenovar.Add_Click({
    $a = $cmbAdaptador.SelectedItem
    Invoke-WiredNetCommand -Title "ipconfig /renew" -ScriptBlock { param($a) if ($a) { ipconfig /renew "$a" } else { ipconfig /renew } } -ArgumentList $a
})
$btnFlushDns.Add_Click({
    Invoke-WiredNetCommand -Title "Limpiar cache DNS" -ScriptBlock { ipconfig /flushdns }
})
$btnResetTotal.Add_Click({
    Invoke-WiredNetCommand -Title "Reseteo total de red" -ScriptBlock {
        ipconfig /release; ipconfig /renew; ipconfig /flushdns; ipconfig /registerdns
        "Reseteo total completado"
    }
})
$btnWinsock.Add_Click({
    Invoke-WiredNetCommand -Title "Reiniciar Winsock" -ScriptBlock { netsh winsock reset; "Reinicie el equipo." }
})
$btnTcpIpReset.Add_Click({
    Invoke-WiredNetCommand -Title "Reiniciar TCP/IP" -ScriptBlock { netsh int ip reset; "Reinicie el equipo." }
})
$btnFirewallReset.Add_Click({
    Invoke-WiredNetCommand -Title "Restablecer Firewall" -ScriptBlock { netsh advfirewall reset }
})
$btnProxyReset.Add_Click({
    Invoke-WiredNetCommand -Title "Restablecer Proxy" -ScriptBlock { netsh winhttp reset proxy }
})
$btnDnsGoogle.Add_Click({
    $a = $cmbAdaptador.SelectedItem
    if (-not $a) { [System.Windows.MessageBox]::Show("Seleccione un adaptador.", "WiredNet") | Out-Null; return }
    Invoke-WiredNetCommand -Title "DNS Google en $a" -ScriptBlock {
        param($a)
        netsh interface ip set dns name="$a" static 8.8.8.8 primary
        netsh interface ip add dns name="$a" 8.8.4.4 index=2
        "DNS Google (8.8.8.8 / 8.8.4.4) configurado en $a"
    } -ArgumentList $a
})
$btnDnsCloudflare.Add_Click({
    $a = $cmbAdaptador.SelectedItem
    if (-not $a) { [System.Windows.MessageBox]::Show("Seleccione un adaptador.", "WiredNet") | Out-Null; return }
    Invoke-WiredNetCommand -Title "DNS Cloudflare en $a" -ScriptBlock {
        param($a)
        netsh interface ip set dns name="$a" static 1.1.1.1 primary
        netsh interface ip add dns name="$a" 1.0.0.1 index=2
        "DNS Cloudflare (1.1.1.1 / 1.0.0.1) configurado en $a"
    } -ArgumentList $a
})
$btnDnsAutomatico.Add_Click({
    $a = $cmbAdaptador.SelectedItem
    if (-not $a) { [System.Windows.MessageBox]::Show("Seleccione un adaptador.", "WiredNet") | Out-Null; return }
    Invoke-WiredNetCommand -Title "DNS automatico en $a" -ScriptBlock {
        param($a) netsh interface ip set dns name="$a" source=dhcp; "DNS automatico restaurado en $a"
    } -ArgumentList $a
})
$btnRestartAdaptador.Add_Click({
    $a = $cmbAdaptador.SelectedItem
    if (-not $a) { [System.Windows.MessageBox]::Show("Seleccione un adaptador.", "WiredNet") | Out-Null; return }
    Invoke-WiredNetCommand -Title "Reiniciar adaptador $a" -ScriptBlock {
        param($a)
        netsh interface set interface "$a" admin=disable
        Start-Sleep -Seconds 3
        netsh interface set interface "$a" admin=enable
        "Adaptador $a reiniciado"
    } -ArgumentList $a
})

# ======================================================
#  EVENTOS: REPARACIÓN DE WINDOWS
# ======================================================
$btnSfc.Add_Click({
    Invoke-WiredNetCommand -Title "SFC /scannow" -ScriptBlock { sfc /scannow }
})
$btnDism.Add_Click({
    Invoke-WiredNetCommand -Title "DISM RestoreHealth" -ScriptBlock {
        DISM /Online /Cleanup-Image /ScanHealth
        DISM /Online /Cleanup-Image /RestoreHealth
    }
})
$btnReiniciarWU.Add_Click({
    Invoke-WiredNetCommand -Title "Reparar Windows Update" -ScriptBlock {
        "Deteniendo servicios de Windows Update..."
        Stop-Service -Name wuauserv, bits, cryptsvc, msiserver -Force -ErrorAction SilentlyContinue
        "Vaciando cache de Windows Update..."
        Remove-Item "$env:SystemRoot\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:SystemRoot\System32\catroot2\*"    -Recurse -Force -ErrorAction SilentlyContinue
        "Reiniciando servicios..."
        Start-Service -Name wuauserv, bits, cryptsvc -ErrorAction SilentlyContinue
        "Windows Update reparado. Intenta buscar actualizaciones ahora."
    }
})
$btnLimpiarWU.Add_Click({
    Invoke-WiredNetCommand -Title "Limpiar cache Windows Update" -ScriptBlock {
        Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:SystemRoot\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
        Start-Service -Name wuauserv -ErrorAction SilentlyContinue
        "Cache de Windows Update limpiada."
    }
})
$btnGpupdate.Add_Click({
    Invoke-WiredNetCommand -Title "gpupdate /force" -ScriptBlock { gpupdate /force }
})
$btnMsStore.Add_Click({
    Invoke-WiredNetCommand -Title "Reparar Microsoft Store" -ScriptBlock {
        wsreset.exe
        "Microsoft Store restablecida."
    }
})
$btnSpooler.Add_Click({
    Invoke-WiredNetCommand -Title "Reiniciar servicio Spooler" -ScriptBlock {
        Stop-Service -Name Spooler -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:SystemRoot\System32\spool\PRINTERS\*" -Force -ErrorAction SilentlyContinue
        Start-Service -Name Spooler -ErrorAction SilentlyContinue
        "Servicio de impresion reiniciado y cola de impresion vaciada."
    }
})
$btnServicios.Add_Click({
    Invoke-WiredNetCommand -Title "Reiniciar servicios de red" -ScriptBlock {
        Restart-Service -Name Dhcp    -Force -ErrorAction SilentlyContinue
        Restart-Service -Name Dnscache -Force -ErrorAction SilentlyContinue
        "Servicios DHCP y DNS reiniciados."
    }
})
$btnTemporales.Add_Click({
    Invoke-WiredNetCommand -Title "Limpiar temporales" -ScriptBlock {
        Remove-Item "$env:TEMP\*"              -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Temp\*"        -Recurse -Force -ErrorAction SilentlyContinue
        "Archivos temporales eliminados."
    }
})
$btnPrefetch.Add_Click({
    Invoke-WiredNetCommand -Title "Limpiar Prefetch" -ScriptBlock {
        Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
        "Prefetch limpiado."
    }
})
$btnThumbnails.Add_Click({
    Invoke-WiredNetCommand -Title "Limpiar Thumbnails" -ScriptBlock {
        Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue
        "Cache de miniaturas eliminada."
    }
})
$btnWER.Add_Click({
    Invoke-WiredNetCommand -Title "Limpiar reportes de error WER" -ScriptBlock {
        Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\WER\*"  -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\ProgramData\Microsoft\Windows\WER\*"     -Recurse -Force -ErrorAction SilentlyContinue
        "Reportes de error de Windows (WER) eliminados."
    }
})
$btnChkdsk.Add_Click({
    $u = $txtUnidad.Text; if ([string]::IsNullOrWhiteSpace($u)) { $u = "C:" }
    if ($u.TrimEnd('\') -ieq $env:SystemDrive.TrimEnd('\')) {
        $r = [System.Windows.MessageBox]::Show(
            "La unidad $u es la unidad del sistema.`r`nCHKDSK se programara para el proximo reinicio.`r`n`r`nDesea continuar?",
            "WiredNet - CHKDSK", [System.Windows.MessageBoxButton]::YesNo)
        if ($r -eq [System.Windows.MessageBoxResult]::Yes) {
            Invoke-WiredNetCommand -Title "chkdsk $u (al reiniciar)" -ScriptBlock {
                param($u) cmd.exe /c "echo Y| chkdsk $u /f /r"
            } -ArgumentList $u
        }
        return
    }
    Invoke-WiredNetCommand -Title "chkdsk $u" -ScriptBlock {
        param($u) cmd.exe /c "echo Y| chkdsk $u /f /r"
    } -ArgumentList $u
})

# ======================================================
#  EVENTOS: REPARACIÓN RÁPIDA (AUTOFIX)
# ======================================================
$btnDiagRapido.Add_Click({
    Invoke-WiredNetCommand -Title "Diagnostico Rapido Completo" -ScriptBlock {
        "============================================================"
        "  WIREDNET - DIAGNOSTICO RAPIDO"
        "  $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')"
        "============================================================"

        # Sistema
        $os  = Get-CimInstance Win32_OperatingSystem
        $cs  = Get-CimInstance Win32_ComputerSystem
        $cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average
        $ram = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
        $ramLibre = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        ""
        "[SISTEMA]"
        "  OS      : $($os.Caption) Build $($os.BuildNumber)"
        "  CPU     : $([math]::Round($cpu.Average,1)) % en uso"
        "  RAM     : $ramLibre GB libres de $ram GB"
        $boot = $os.LastBootUpTime; $up = (Get-Date) - $boot
        "  Uptime  : $($up.Days)d $($up.Hours)h $($up.Minutes)m"

        # Discos
        ""
        "[DISCOS]"
        Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | ForEach-Object {
            $total = $_.Used + $_.Free
            $pct   = if ($total -gt 0) { [math]::Round($_.Used/$total*100,1) } else { 0 }
            $libre = [math]::Round($_.Free/1GB,2)
            $alerta = if ($pct -gt 90) { " *** DISCO CASI LLENO ***" } elseif ($pct -gt 80) { " (espacio bajo)" } else { "" }
            "  $($_.Name):\  Usado: $pct %  |  Libre: $libre GB$alerta"
        }

        # Red
        ""
        "[RED]"
        try {
            $adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
            if ($adapters) {
                foreach ($a in $adapters) {
                    $ip = (Get-NetIPAddress -InterfaceIndex $a.InterfaceIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress
                    "  $($a.Name): $ip (Activo)"
                }
            } else { "  ADVERTENCIA: Ningun adaptador activo detectado" }
        } catch { "  No se pudo leer adaptadores." }

        # Conectividad
        ""
        "[CONECTIVIDAD]"
        $pingGw  = Test-Connection "8.8.8.8"   -Count 1 -Quiet -ErrorAction SilentlyContinue
        $pingDns = Test-Connection "1.1.1.1"   -Count 1 -Quiet -ErrorAction SilentlyContinue
        $pingWeb = Test-Connection "google.com" -Count 1 -Quiet -ErrorAction SilentlyContinue
        "  Ping 8.8.8.8 (Google DNS)  : $(if ($pingGw)  {'OK'} else {'FALLO'})"
        "  Ping 1.1.1.1 (Cloudflare)  : $(if ($pingDns) {'OK'} else {'FALLO'})"
        "  Ping google.com (DNS+Web)   : $(if ($pingWeb) {'OK'} else {'FALLO - posible problema de DNS'})"

        # Errores recientes
        ""
        "[ERRORES CRITICOS (ultima hora)]"
        try {
            $evs = Get-EventLog -LogName System -EntryType Error -After (Get-Date).AddHours(-1) -Newest 5 -ErrorAction SilentlyContinue
            if ($evs) { foreach ($e in $evs) { "  [$($e.TimeGenerated.ToString('HH:mm'))] $($e.Source): $($e.Message.Split([Environment]::NewLine)[0])" } }
            else { "  Sin errores criticos en la ultima hora." }
        } catch { "  No se pudo leer el Visor de Eventos." }

        # Antivirus
        ""
        "[SEGURIDAD]"
        try {
            $av = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct -ErrorAction Stop
            if ($av) { foreach ($a in $av) { "  Antivirus: $($a.displayName)" } }
            else { "  ADVERTENCIA: No se detecto antivirus." }
        } catch { "  No se pudo consultar el estado del antivirus." }

        ""
        "============================================================"
        "  Diagnostico completo. Revisa las secciones con ADVERTENCIA."
        "============================================================"
    }
})

$btnFixNoInternet.Add_Click({
    Invoke-WiredNetCommand -Title "Fix: Sin acceso a internet" -ScriptBlock {
        "--- Paso 1: Liberando y renovando IP..."
        ipconfig /release 2>&1 | Out-Null
        ipconfig /renew   2>&1 | Out-Null
        "--- Paso 2: Limpiando cache DNS..."
        ipconfig /flushdns | Out-Null
        "--- Paso 3: Reiniciando Winsock y TCP/IP..."
        netsh winsock reset | Out-Null
        netsh int ip reset  | Out-Null
        "--- Paso 4: Restableciendo proxy..."
        netsh winhttp reset proxy | Out-Null
        "--- Paso 5: Reiniciando servicios de red..."
        Restart-Service -Name Dhcp, Dnscache -Force -ErrorAction SilentlyContinue
        "--- Paso 6: Verificando conectividad..."
        $ok = Test-Connection "8.8.8.8" -Count 2 -Quiet -ErrorAction SilentlyContinue
        if ($ok) { "RESULTADO: Conectividad restaurada. Reinicia el equipo si el navegador aun falla." }
        else      { "RESULTADO: Aun sin conectividad. Verifica el cable/router o contacta al ISP." }
    }
})

$btnFixIpConflict.Add_Click({
    Invoke-WiredNetCommand -Title "Fix: Conflicto de IP" -ScriptBlock {
        "--- Liberando IP actual..."
        ipconfig /release | Out-Null
        Start-Sleep -Seconds 2
        "--- Limpiando cache ARP..."
        arp -d * 2>&1 | Out-Null
        "--- Renovando IP (nueva asignacion DHCP)..."
        ipconfig /renew
        "--- Registrando DNS..."
        ipconfig /registerdns | Out-Null
        "Listo. Se asigno nueva IP para evitar conflictos."
    }
})

$btnFixDnsFail.Add_Click({
    Invoke-WiredNetCommand -Title "Fix: DNS no resuelve dominios" -ScriptBlock {
        "--- Paso 1: Limpiando cache DNS local..."
        ipconfig /flushdns | Out-Null
        "--- Paso 2: Configurando DNS de Google como respaldo temporal..."
        $adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
        foreach ($a in $adapters) {
            netsh interface ip set dns name="$($a.Name)" static 8.8.8.8 primary 2>&1 | Out-Null
            netsh interface ip add dns name="$($a.Name)" 8.8.4.4 index=2 2>&1 | Out-Null
        }
        "--- Paso 3: Verificando resolucion DNS..."
        $resuelve = Test-Connection "google.com" -Count 1 -Quiet -ErrorAction SilentlyContinue
        if ($resuelve) { "RESULTADO: DNS funciona ahora con servidores de Google (8.8.8.8)." }
        else           { "RESULTADO: Persiste el problema. Puede ser falla del ISP o router." }
    }
})

$btnFixWifi.Add_Click({
    Invoke-WiredNetCommand -Title "Fix: Wi-Fi conectado sin internet" -ScriptBlock {
        "--- Paso 1: Liberando y renovando IP en adaptadores activos..."
        $adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.Name -like "*Wi*" }
        if (-not $adapters) { $adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } }
        foreach ($a in $adapters) {
            ipconfig /release "$($a.Name)" 2>&1 | Out-Null
            ipconfig /renew   "$($a.Name)" 2>&1 | Out-Null
        }
        "--- Paso 2: Limpiando DNS..."
        ipconfig /flushdns | Out-Null
        "--- Paso 3: Restableciendo proxy (causa comun de este problema)..."
        netsh winhttp reset proxy | Out-Null
        "--- Paso 4: DNS de Google como respaldo..."
        foreach ($a in $adapters) {
            netsh interface ip set dns name="$($a.Name)" static 8.8.8.8 primary 2>&1 | Out-Null
        }
        "--- Verificando..."
        $ok = Test-Connection "google.com" -Count 2 -Quiet -ErrorAction SilentlyContinue
        if ($ok) { "RESULTADO: Internet restaurado." }
        else      { "RESULTADO: Sigue sin internet. Prueba reiniciar el router o olvidar y reconectar la red." }
    }
})

$btnFixLento.Add_Click({
    Invoke-WiredNetCommand -Title "Fix: Internet lento" -ScriptBlock {
        "--- Limpiando cache DNS..."
        ipconfig /flushdns | Out-Null
        "--- Restableciendo proxy..."
        netsh winhttp reset proxy | Out-Null
        "--- Configurando DNS de Cloudflare (1.1.1.1, el mas rapido del mundo)..."
        $adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
        foreach ($a in $adapters) {
            netsh interface ip set dns name="$($a.Name)" static 1.1.1.1 primary 2>&1 | Out-Null
            netsh interface ip add dns name="$($a.Name)" 1.0.0.1 index=2 2>&1 | Out-Null
        }
        "--- Midiendo velocidad actual..."
        $url  = "https://speed.cloudflare.com/__down?bytes=10000000"
        $dest = Join-Path $env:TEMP "wn_fix_speed.tmp"
        try {
            $t1  = Get-Date
            Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
            $seg = ((Get-Date) - $t1).TotalSeconds
            $mb  = (Get-Item $dest).Length / 1MB
            $mbps = [math]::Round(($mb * 8) / $seg, 2)
            "Velocidad de descarga actual: $mbps Mbps"
            if ($mbps -lt 5) { "RESULTADO: La velocidad sigue baja. El problema puede ser el ISP o el router, no el equipo." }
            else              { "RESULTADO: Conexion funcionando. DNS de Cloudflare aplicado para mayor velocidad." }
        } catch { "No se pudo medir la velocidad." }
        finally { Remove-Item $dest -Force -ErrorAction SilentlyContinue }
    }
})

$btnFixLentoSistema.Add_Click({
    Invoke-WiredNetCommand -Title "Fix: Sistema lento" -ScriptBlock {
        "--- Paso 1: Limpiando archivos temporales..."
        Remove-Item "$env:TEMP\*"         -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Temp\*"   -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
        "--- Paso 2: Limpiando miniaturas..."
        Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue
        "--- Paso 3: Limpiando reportes de error..."
        Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\WER\*" -Recurse -Force -ErrorAction SilentlyContinue
        "--- Paso 4: Vaciando Papelera de Reciclaje..."
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        "--- Paso 5: Top 5 procesos que mas consumen RAM ahora mismo:"
        Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 |
            Format-Table Name, @{N='RAM(MB)';E={[math]::Round($_.WorkingSet64/1MB,1)}} -AutoSize | Out-String
        "RESULTADO: Limpieza completa. Se recomienda reiniciar el equipo para liberar memoria."
    }
})

$btnFixWU.Add_Click({
    Invoke-WiredNetCommand -Title "Fix: Windows Update roto" -ScriptBlock {
        "--- Deteniendo servicios de Windows Update..."
        Stop-Service -Name wuauserv, bits, cryptsvc, msiserver -Force -ErrorAction SilentlyContinue
        "--- Vaciando cache de WU..."
        Remove-Item "$env:SystemRoot\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:SystemRoot\System32\catroot2\*"    -Recurse -Force -ErrorAction SilentlyContinue
        "--- Volviendo a registrar DLLs criticas..."
        regsvr32 /s atl.dll; regsvr32 /s urlmon.dll; regsvr32 /s mshtml.dll
        regsvr32 /s wuapi.dll; regsvr32 /s wuaueng.dll; regsvr32 /s wucltui.dll
        "--- Reiniciando servicios..."
        Start-Service -Name wuauserv, bits, cryptsvc -ErrorAction SilentlyContinue
        "RESULTADO: Windows Update reparado. Ve a Configuracion > Windows Update y busca actualizaciones."
    }
})

$btnFixImpresora.Add_Click({
    Invoke-WiredNetCommand -Title "Fix: Impresora no funciona" -ScriptBlock {
        "--- Deteniendo servicio de impresion (Spooler)..."
        Stop-Service -Name Spooler -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        "--- Vaciando cola de impresion..."
        Remove-Item "$env:SystemRoot\System32\spool\PRINTERS\*" -Force -ErrorAction SilentlyContinue
        "--- Reiniciando servicio Spooler..."
        Start-Service -Name Spooler -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
        $estado = (Get-Service Spooler).Status
        "Estado del servicio Spooler: $estado"
        if ($estado -eq 'Running') { "RESULTADO: Spooler reiniciado y cola vaciada. Intenta imprimir de nuevo." }
        else                        { "RESULTADO: El Spooler no pudo iniciarse. Puede haber un driver corrupto." }
    }
})

$btnFixCorrupcion.Add_Click({
    Invoke-WiredNetCommand -Title "Fix: Archivos del sistema corruptos" -ScriptBlock {
        "--- Paso 1: SFC /scannow (puede tardar varios minutos)..."
        sfc /scannow
        "--- Paso 2: DISM ScanHealth..."
        DISM /Online /Cleanup-Image /ScanHealth
        "--- Paso 3: DISM RestoreHealth (requiere internet o imagen de Windows)..."
        DISM /Online /Cleanup-Image /RestoreHealth
        "RESULTADO: Si SFC o DISM reportaron reparaciones, reinicia el equipo."
    }
})

$btnFixLimpiezaTotal.Add_Click({
    Invoke-WiredNetCommand -Title "Limpieza total del equipo" -ScriptBlock {
        "--- Eliminando temporales de usuario..."
        Remove-Item "$env:TEMP\*"          -Recurse -Force -ErrorAction SilentlyContinue
        "--- Eliminando temporales de Windows..."
        Remove-Item "C:\Windows\Temp\*"    -Recurse -Force -ErrorAction SilentlyContinue
        "--- Limpiando Prefetch..."
        Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
        "--- Limpiando cache de miniaturas..."
        Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue
        "--- Limpiando reportes de error WER..."
        Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\WER\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\ProgramData\Microsoft\Windows\WER\*"    -Recurse -Force -ErrorAction SilentlyContinue
        "--- Limpiando cache de DNS..."
        ipconfig /flushdns | Out-Null
        "--- Vaciando Papelera de Reciclaje..."
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        "--- Limpiando cache de Windows Update..."
        Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:SystemRoot\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
        Start-Service -Name wuauserv -ErrorAction SilentlyContinue
        "RESULTADO: Limpieza total completada. Se recomienda reiniciar el equipo."
    }
})

$btnFixActivacion.Add_Click({
    Invoke-WiredNetCommand -Title "Verificar activacion de Windows" -ScriptBlock {
        "--- Consultando estado de activacion..."
        $lic = Get-WmiObject SoftwareLicensingProduct -Filter "Name like 'Windows%'" |
               Where-Object { $_.LicenseStatus -ne 0 }
        if ($lic) {
            foreach ($l in $lic) {
                $estado = switch ($l.LicenseStatus) {
                    1 { "ACTIVADO" }
                    2 { "Fuera de gracia (OOB)" }
                    3 { "Fuera de gracia (OOT)" }
                    4 { "Sin licencia" }
                    5 { "Notificacion" }
                    default { "Estado desconocido ($($l.LicenseStatus))" }
                }
                "Producto : $($l.Name)"
                "Estado   : $estado"
                "Clave    : $($l.PartialProductKey)XXXXX"
            }
        } else {
            slmgr /xpr
        }
    }
})

# ======================================================
#  EVENTOS COMUNES
# ======================================================
$btnSitioWeb.Add_Click({ Start-Process "https://wire-net-web.vercel.app" })
$btnLimpiarConsola.Add_Click({ $txtConsole.Clear() })

# ======================================================
#  INICIO
# ======================================================
$window.Add_ContentRendered({
    Show-Panel "diagred"
    Refresh-Adapters
})

[void]$window.ShowDialog()
