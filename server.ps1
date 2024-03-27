function Post-Mattermost {

    [CmdletBinding()]Param
    (
        # Incoming Webhook
        [Parameter(Mandatory=$true
        )]
        [string]$uri,
        # Body of message
        [Parameter(Mandatory=$true
        )]
        [string]$text
     )
    $Payload = @{ 
        text=$text; 
    }
    Invoke-RestMethod -Uri $uri -Method Post -ContentType 'application/json' -Body (ConvertTo-Json $Payload)
}

Start-PodeServer {
    Add-PodeEndpoint -Address * -Port 8081 -Protocol Http


Add-PodeRoute -Method POST -Path '/MatterMost' -ScriptBlock {
    $WebEvent | Out-Default
    $Message = $WebEvent.Data.message
    $Culprit = $WebEvent.Data.culprit
    $URL = $WebEvent.Data.url

Post-Mattermost -uri "https://MATTERMOST-HOOK-HERE" -text "Sentry: $Message > $Culprit - $URL"
}

}
