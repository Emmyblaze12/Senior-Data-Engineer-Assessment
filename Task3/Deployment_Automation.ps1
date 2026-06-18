# =====================================
# Task 3
# Deployment Automation
# =====================================

$BaseUrl = "https://bi.eimmyc.com/api"
$Token = "TOKEN"

$Headers = @{
    Authorization = "Bearer $Token"
    "Content-Type" = "application/json"
}

$Payload = @{
    SourcePath = "/Dev"
    TargetPath = "/Test"
    Overwrite = $true
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$BaseUrl/deployment/promote" `
    -Method POST `
    -Headers $Headers `
    -Body $Payload

Write-Host "Deployment completed."
