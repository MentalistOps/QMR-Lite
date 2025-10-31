<#
.SYNOPSIS
  QMR-Lite ConfigBackup – Backup e ripristino configurazioni di sistema.

.DESCRIPTION
  Salva configurazioni critiche (servizi, driver, registro) in file locali.
  Permette di ripristinare lo stato precedente in caso di modifiche dannose o instabilità.

.AUTHOR
  MentalistOps – mentalistops [at] protonmail [dot] com

.VERSION
  1.0 – Compatibile con Windows 10/11 fino alla 23H2
#>

# Percorsi di backup
$backupRoot = "$env:USERPROFILE\Desktop\QMR_ConfigBackup"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = Join-Path $backupRoot "backup_$timestamp"
New-Item -ItemType Directory -Path $backupPath -Force | Out-Null

# Menu
Write-Host "`nQMR-Lite – Backup Configurazioni di Sistema"
Write-Host "1. Esegui backup"
Write-Host "2. Ripristina da backup esistente"
$choice = Read-Host "Scegli un'opzione (1 o 2)"

switch ($choice) {
    '1' {
        Write-Host "`n🔄 Avvio backup configurazioni..."

        # Backup servizi
        Get-Service | Select-Object Name, Status, StartType | Export-Csv -Path "$backupPath\services.csv" -NoTypeInformation

        # Backup driver
        driverquery /v /fo csv | Out-File "$backupPath\drivers.csv"

        # Backup chiavi di registro critiche
        reg export "HKLM\SYSTEM\CurrentControlSet\Services" "$backupPath\services.reg" /y
        reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "$backupPath\startup.reg" /y

        Write-Host "✅ Backup completato. File salvati in: $backupPath" -ForegroundColor Green
    }
    '2' {
        $backups = Get-ChildItem -Directory -Path $backupRoot
        if ($backups.Count -eq 0) {
            Write-Host "❌ Nessun backup trovato." -ForegroundColor Red
            exit
        }

        Write-Host "`nBackup disponibili:"
        $i = 1
        foreach ($b in $backups) {
            Write-Host "$i. $($b.Name)"
            $i++
        }

        $sel = Read-Host "Inserisci il numero del backup da ripristinare"
        $selected = $backups[$sel - 1].FullName

        Write-Host "⚠️ Il ripristino sovrascriverà configurazioni attuali. Continua? (s/n)"
        $confirm = Read-Host
        if ($confirm -eq 's') {
            reg import "$selected\services.reg"
            reg import "$selected\startup.reg"
            Write-Host "✅ Registro ripristinato. Riavvia il sistema per applicare le modifiche." -ForegroundColor Green
        } else {
            Write-Host "Operazione annullata." -ForegroundColor Yellow
        }
    }
    default {
        Write-Host "Scelta non valida. Riprova." -ForegroundColor Red
    }
}


📋 Cosa fa questo modulo

• Salva:• Stato dei servizi (`services.csv`)
• Driver installati (`drivers.csv`)
• Chiavi di registro critiche (`services.reg`, `startup.reg`)

• Permette di ripristinare i file `.reg` in caso di problemi
• Organizza i backup per data e ora sul desktop


---

🧪 Test consigliato

• Esegui il backup → verifica i file creati
• Modifica un servizio o una chiave → ripristina da backup
• Testa in VM per evitare rischi su sistema reale
