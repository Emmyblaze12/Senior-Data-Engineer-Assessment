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

## Deployment Workflow

1. Authenticate using service principal credentials.
2. Retrieve artefact metadata.
3. Validate target environment.
4. Promote artefacts from Dev to Test.
5. Execute post-deployment validation.
6. Refresh datasets.
7. Log deployment results.
