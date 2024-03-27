# Sentry Mattermost WebHook Integration

## Description

This project aim to obtain WebHook payload from Sentry and repeat it to MatterMost in acceptable form.

See sentry issue [32313](https://github.com/getsentry/sentry/issues/32313).

This is a temporal "solution" until Sentry provide valid integration/plugin.

## Dependencies

- PowerShell
    - Installed [Pode](https://badgerati.github.io/Pode/Getting-Started/Installation/#minimum-requirements) module (for API purposes)
    - Chocolatey (Optional | Windows only)
 - [NSSM](https://community.chocolatey.org/packages/nssm) (Optional | Windows only | Running WHI as service)


 ## Installation (Dependencies)

Windows:

 ```powershell
 choco install -y pwsh pode nssm

 ``` 

Linux:

Consult Google on how to install PWSH for your distro.

Then from pwsh shell:

```powershell

Install-Module -Name Pode

```


## Configuration

- Replace your hook URL in [server.ps1](server.ps1)
- Adjust message format and/or data
- Add more `Add-PodeRoute` code blocks if you need multiple endpoints for multiple projects

## Running

Great for debug/overview.

```powershell
# .\server.ps1
```

## Running as service 

Windows:

Make sure to run following code block as Administrator and from root directory of project.

 ```powershell
$exe = (Get-Command pwsh.exe).Source
$name = 'WHI Server'
$file = "$PWD\server.ps1"
$arg = "-ExecutionPolicy Bypass -NoProfile -Command `"$($file)`""
nssm install $name $exe $arg
nssm set $name AppDirectory $PWD
nssm start $name
 ```

Linux:

Make sure to run following code block from root directory of project.

```bash
echo "[Unit]
Description=WHI Server
After=network.target

[Service]
ExecStart=/usr/bin/pwsh -c "$PWD/server.ps1" -nop -ep Bypass
Restart=always
User=root
Group=root
WorkingDirectory="$PWD"

[Install]
WantedBy=multi-user.target
Alias=whi-server.service" >> /etc/systemd/system/whi-server.service
# Reload daemon, start service, enable startup
systemctl daemon-reload
systemctl start whi-server
systemctl enable whi-server

```


## Example data.json payload

Example [data.json](./data.json) is included from https://sentry.example.com/settings/sentry/projects/PROJECT-NAME/alerts/ > WEBHOOKS > Test plugin.

Send data.json to WHI service:

```bash
curl -X POST -H "Content-Type: application/json" -d @data.json http://localhost:8081/MatterMost
```

**Note:** You can inspect Sentry payload on service like https://webhook.site where you can see whole request.

TODO:

- [ ] Dockerized service ? Create issue if you need image.