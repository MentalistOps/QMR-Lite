<#
.SYNOPSIS
  QMR-Lite QuickFix – Correzioni rapide per problemi comuni di sistema.

.DESCRIPTION
  Applica fix automatici a problemi frequenti su Windows: rete, explorer, servizi, cache, aggiornamenti.
  Utile dopo crash, instabilità o comportamenti anomali.

.AUTHOR
  MentalistOps – mentalistops [at] protonmail [dot] com

.VERSION
  1.0 – Compatibile con Windows 10/11 fino alla 23H2
#>

# Menu
Write-Host "`nQMR-Lite – QuickFix"
Write-Host "1. Riavvia Esplora risorse"
Write-Host "2. Ripristina rete"
Write-Host "3. Riavvia servizi critici"
Write-Host "4. Svuota cache DNS e Windows Update"
Write-Host "5. Applica tutti i fix"
$choice = Read-Host "Scegli un'opzione (1–5)"

function Restart-Explorer {
    Write-Host "🔄 Riavvio di Esplora risorse..."
    Stop-Process -Name explorer -Force
    Start-Process explorer.exe
}

function Fix-Network {
    Write-Host "🌐 Ripristino rete..."
    ipconfig /release
    ipconfig /flushdns
    ipconfig /renew
    netsh winsock reset
    netsh int ip reset
}

function Restart-Services {
    Write-Host "⚙️ Riavvio servizi critici..."
    $services = @("wuauserv", "bits", "cryptsvc", "dnscache")
    foreach ($svc in $services) {
        Restart-Service -Name $svc -Force -ErrorAction SilentlyContinue
    }
}

function Clear-Cache {
    Write-Host "🧹 Pulizia cache DNS e Windows Update..."
    Clear-DnsClientCache
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
}

switch ($choice) {
    '1' { Restart-Explorer }
    '2' { Fix-Network }
    '3' { Restart-Services }
    '4' { Clear-Cache }
    '5' {
        Restart-Explorer
        Fix-Network
        Restart-Services
        Clear-Cache
    }
    default {
        Write-Host "Scelta non valida. Riprova." -ForegroundColor Red
    }
}

Write-Host "`n✅ Operazione completata." -ForegroundColor Green


📋 Cosa fa questo modulo

• Offre un menu interattivo con 5 opzioni
• Riavvia Explorer se bloccato
• Ripristina rete e Winsock
• Riavvia servizi critici (Windows Update, DNS, BITS)
• Svuota cache DNS e cartella update
• Può eseguire tutti i fix in sequenza


---

🧪 Test consigliato

• Simula un problema (es. disattiva rete, blocca explorer)
• Esegui il modulo e verifica il ripristino
• Testa in VM o su sistema secondario per sicurezza
