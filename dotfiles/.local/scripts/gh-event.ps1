param(
    [String]$Type,
    $Payload
)

$origin = (git remote get-url origin)
$token = ("url=$origin" | git credential fill | ConvertFrom-StringData).Password
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
