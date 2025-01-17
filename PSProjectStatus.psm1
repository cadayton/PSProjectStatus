enum PSProjectStatus {
    Development
    Updating
    Stable
    AlphaTesting
    BetaTesting
    ReleaseCandidate
    Patching
    UnitTesting
    AcceptanceTesting
    Other
}

Class PSProject {
    [string]$Name = (Split-Path (Get-Location).path -Leaf)
    [string]$Path = (Convert-Path (Get-Location).path)
    [datetime]$LastUpdate = (Get-Date)
    [string[]]$Tasks
    [PSProjectStatus]$Status = "Development"
    [string]$GitBranch
    [string]$Version
    [string]$SVC
    #using .NET classes to ensure compatibility with non-Windows platforms
    [string]$UpdateUser = "$([system.environment]::UserDomainName)\$([System.Environment]::Username)"

    [void]Save() {
        $json = Join-Path -Path $this.path -ChildPath psproject.json
        $this | Select-Object -Property * -exclude Age | ConvertTo-Json | Out-File $json
    }
}

Get-ChildItem $psscriptroot\functions\*.ps1 -Recurse |
ForEach-Object {
    . $_.FullName
}

Update-TypeData -TypeName PSProject -MemberType ScriptProperty -MemberName Age -Value { (Get-Date) - $this.lastUpdate } -Force