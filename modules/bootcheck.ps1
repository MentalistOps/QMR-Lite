<#
.SYNOPSIS
  QMR-Lite BootCheck – Rileva errori critici recenti all'avvio del sistema.

.DESCRIPTION
  Analizza il registro eventi di sistema per individuare BSOD, crash, riavvii anomali e problemi di avvio.
  Salva un log locale con i risultati e suggerisce azioni correttive.

.AUTHOR
  MentalistOps – mentalistops [at] protonmail [dot] com

.VERSION
  1.0 – Compatibile con Windows 10/11 fino alla 23H2
#>

# Imposta il percorso del log
$logPath = "$env:USERPROFILE\Desktop\QMR_BootCheck_Log.txt"
$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Inizio log
"[$now] Avvio analisi eventi critici..." | Out-File -FilePath $logPath

# Analizza eventi di sistema (ID 41 = riavvio anomalo, ID 1001 = BSOD)
$events = Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    ID = 41, 1001
    StartTime = (Get-Date).AddDays(-7)
} -ErrorAction SilentlyContinue

if ($events.Count -gt 0) {
    "Eventi critici trovati negli ultimi 7 giorni:`n" | Out-File -Append $logPath
    foreach ($event in $events) {
        $time = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
        $msg = $event.Message
        "[$time] $msg`n" | Out-File -Append $logPath
    }
    "`nSuggerimento: eseguire il modulo 'quickfix.ps1' o 'restorepoint.ps1' se necessario." | Out-File -Append $logPath
} else {
    "Nessun evento critico rilevato negli ultimi 7 giorni." | Out-File -Append $logPath
}

# Fine log
"`nAnalisi completata. Log salvato in: $logPath" | Out-File -Append $logPath


📋 Cosa fa questo modulo

• Controlla gli eventi ID 41 (riavvio anomalo) e ID 1001 (BSOD)
• Analizza gli ultimi 7 giorni di attività
• Salva un log leggibile sul desktop dell’utente
• Suggerisce moduli da eseguire in caso di problemi


---

🧪 Test consigliato

• Esegui lo script in PowerShell come amministratore
• Controlla il file `QMR_BootCheck_Log.txt` sul desktop
• Verifica se rileva eventi reali (puoi simulare un crash o usare una VM instabile)
