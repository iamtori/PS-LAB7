$plikDoSprawdzenia = "C:\Docelowy\test.txt"
$apiKey = "20377c6efc8b5dc2eb4=6494e0af2f7217c0b978e17c5ba82c3b9cba9c4730cf36"


#suma kontrolna
$hash = (Get-FileHash -Path $plikDoSprawdzenia -Algorithm SHA256).Hash
Write-Host " suma kontrolna (SHA256): $hash"

$url = "https://www.virustotal.com/api/v3/files/$hash"

$headers = @{
    "x-apikey" = $apiKey
}

#interpretacja odpowiedzi api
try {
    $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
    $malicious = $response.data.attributes.last_analysis_stats.malicious

    if ($malicious -gt 0) {
        Write-Host "wykryto zagrożenie." -ForegroundColor Red
    } else {
        Write-Host "jest bezpieczny." -ForegroundColor Green
    }
}


