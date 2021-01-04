param(
    [String]$Type,
    $Payload
)

$origin = (git remote get-url origin)
$out = ("url=origin" | git credential fill 2>&1)
if ($LASTEXITCODE -ne 0) {
    throw $out
}
$token = ($out | ConvertFrom-StringData).Password
$url = "https://api.github.com/repos$(([URI]$origin).LocalPath)/dispatches"

$headers = @{
    "Accept"="application/vnd.github.everest-preview+json";
    "Content-Type"="application/json";
    "Authorization"="Bearer $token";
}

$body = @{
    "event_type"=$Type;
    "client_payload"=$Payload
}

Write-Host "Sending event '$Type'"
Write-Host "Payload is: $($Payload | ConvertTo-JSON)"

$response = Invoke-WebRequest $url -Method 'POST' `
                              -Headers $headers `
                              -ContentType "application/json" `
                              -Body ($body | ConvertTo-Json)
