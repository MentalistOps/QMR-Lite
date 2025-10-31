<#
.SYNOPSIS
  QMR-Lite Watchdog – Monitoraggio eventi critici e risposta automatica.

.DESCRIPTION
  Monitora il registro eventi di sistema per rilevare crash, BSOD, riavvii anomali.
  Se rileva un evento, avvia automaticamente il modulo 'quickfix.ps1' o altri script di recovery.

.AUTHOR
  MentalistOps – mentalistops [at] protonmail [dot] com

.VERSION
  1.0 – Compatibile con Windows 10/11 fino alla 23H2
#>

# Configurazione
$monitorInterval = 300 # secondi tra ogni scansione
$eventIDs = @(41, 1001) # Riavvio anomalo e BSOD
$logPath = "$env:USERPROFILE\Desktop\QMR_Watchdog_Log.txt"
$quickfixPath = "$env:USERPROFILE\Desktop\QMR_Lite\quickfix.ps1"

Write-Host "`n🛡️ QMR-Lite Watchdog attivo. Monitoraggio eventi critici ogni $monitorInterval secondi..."
"[$(Get-Date)] Watchdog avviato." | Out-File -FilePath $logPath

while ($true) {
    $events = Get-WinEvent -FilterHashtable @{
        LogName = 'System'
        ID = $eventIDs
        StartTime = (Get-Date).AddMinutes(-5)
    } -ErrorAction SilentlyContinue

    if ($events.Count -gt 0) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "[$timestamp] Evento critico rilevato. Avvio modulo QuickFix." | Out-File -Append $logPath

        # Avvia QuickFix
        if (Test-Path $quickfixPath) {
            Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$quickfixPath`"" -WindowStyle Hidden
            "[$timestamp] QuickFix avviato." | Out-File -Append $logPath
        } else {
            "[$timestamp] ERRORE: quickfix.ps1 non trovato." | Out-File -Append $logPath
        }
    }

    Start-Sleep -Seconds $monitorInterval
}



📋 Cosa fa questo modulo

• Monitora il registro eventi ogni 5 minuti
• Rileva BSOD (ID 1001) e riavvii anomali (ID 41)
• Avvia automaticamente `quickfix.ps1` se rileva problemi
• Salva un log dettagliato sul desktop
• Può essere eseguito in background o come servizio


---

🧪 Test consigliato

• Simula un evento critico (es. crash in VM)
• Avvia `watchdog.ps1` e verifica se esegue `quickfix.ps1`
• Controlla il log `QMR_Watchdog_Log.txt` per conferma
