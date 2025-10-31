<#
.SYNOPSIS
  QMR-Lite RestorePoint – Crea o ripristina punti di ripristino di sistema.

.DESCRIPTION
  Questo modulo consente di creare un punto di ripristino manuale oppure ripristinare uno esistente.
  Utile per tornare a uno stato stabile in caso di problemi dopo aggiornamenti, modifiche o crash.

.AUTHOR
  MentalistOps – mentalistops [at] protonmail [dot] com

.VERSION
  1.0 – Compatibile con Windows 10/11 fino alla 23H2
#>

# Verifica se il servizio di ripristino è attivo
$protection = Get-ComputerRestorePoint -ErrorAction SilentlyContinue
if (-not $protection) {
    Write-Host "⚠️ Il ripristino configurazione di sistema sembra disattivato. Attivalo prima di usare questo modulo." -ForegroundColor Yellow
    exit
}

# Menu utente
Write-Host "`nQMR-Lite – Ripristino configurazione di sistema"
Write-Host "1. Crea un nuovo punto di ripristino"
Write-Host "2. Visualizza e ripristina un punto esistente"
$choice = Read-Host "Scegli un'opzione (1 o 2)"

switch ($choice) {
    '1' {
        $rpName = Read-Host "Inserisci un nome per il punto di ripristino"
        Checkpoint-Computer -Description $rpName -RestorePointType "MODIFY_SETTINGS"
        Write-Host "✅ Punto di ripristino '$rpName' creato con successo." -ForegroundColor Green
    }
    '2' {
        $restorePoints = Get-ComputerRestorePoint
        if ($restorePoints.Count -eq 0) {
            Write-Host "❌ Nessun punto di ripristino disponibile." -ForegroundColor Red
            exit
        }

        Write-Host "`nPunti di ripristino disponibili:"
        $restorePoints | ForEach-Object {
            Write-Host "$($_.SequenceNumber): $($_.Description) – $($_.CreationTime)"
        }

        $seq = Read-Host "Inserisci il numero del punto da ripristinare"
        Write-Host "⚠️ Il sistema verrà riavviato per completare il ripristino."
        $confirm = Read-Host "Confermi? (s/n)"
        if ($confirm -eq 's') {
            Restore-Computer -RestorePoint $seq
            Restart-Computer
        } else {
            Write-Host "Operazione annullata." -ForegroundColor Yellow
        }
    }
    default {
        Write-Host "Scelta non valida. Riprova." -ForegroundColor Red
    }
}


📋 Cosa fa questo modulo

• Verifica se il Ripristino configurazione di sistema è attivo
• Permette di creare un punto di ripristino con nome personalizzato
• Elenca i punti disponibili e consente di ripristinare uno specifico punto
• Riavvia il sistema in automatico dopo il ripristino (se confermato)


---

🧪 Test consigliato

• Esegui lo script come amministratore
• Crea un punto di ripristino → verifica che appaia in `rstrui.exe`
• Prova a ripristinare un punto (in VM o sistema non critico)
