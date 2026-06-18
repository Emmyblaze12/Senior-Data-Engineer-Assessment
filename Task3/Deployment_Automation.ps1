# =====================================
# Task 3 - Deployment Automation
# =====================================

$BaseUrl = "https://bi.eimmyc.com/api"
$Token = $env:BI_API_TOKEN

$Headers = @{
    Authorization = "Bearer $Token"
    "Content-Type" = "application/json"
}

$Payload = @{
    SourcePath = "/Dev"
    TargetPath = "/Test"
    Overwrite = $true
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod `
        -Uri "$BaseUrl/deployment/promote" `
        -Method POST `
        -Headers $Headers `
        -Body $Payload

    if ($response.status -eq "Success") {
        Write-Host "Deployment successful"
    }
}
catch {
    Write-Host "Deployment failed: $($_.Exception.Message)"
}

# Refresh configuration
Invoke-RestMethod `
    -Uri "$BaseUrl/configuration/refresh" `
    -Method POST `
    -Headers $Headers
