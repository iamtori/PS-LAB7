<#
.DESCRIPTION
    Skrypt tworzy folder docelowy jeśli nie istnieje. Następnie monitoruje folder źródłowy
    i przenosi każdy nowy plik do folderu docelowego.
#>

$folderZrodlowy = "C:\DoMonitorowania"
$folderDocelowy = "C:\Docelowy"

#tworzenie, jeśli nie istnieje
if (!(Test-Path $folderDocelowy)) {
    New-Item -ItemType Directory -Path $folderDocelowy
    Write-Host "Folder docelowy utworzony: $folderDocelowy"
}

#monitorowanie folderu
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folderZrodlowy
$watcher.Filter = "*.txt"
$watcher.EnableRaisingEvents = $true
$watcher.IncludeSubdirectories = $false

#przenoszenie pliku
Register-ObjectEvent $watcher Created -Action {
    Start-Sleep -Seconds 1
    $plikPelnaSciezka = $Event.SourceEventArgs.FullPath
    $nazwaPliku = $Event.SourceEventArgs.Name
    Write-Host "Nowy plik wykryty: $nazwaPliku"
    Move-Item -Path $plikPelnaSciezka -Destination $folderDocelowy -Force
    Write-Host "Plik $nazwaPliku przeniesiony do $folderDocelowy"
}

#pętla wieczna
while ($true) {
    Start-Sleep -Seconds 5
}
