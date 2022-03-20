Function New-PSProjectStatus {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("PSProject")]
    Param (
        [Parameter(Position = 0, HelpMessage = "What is the project name?")]
        [ValidateNotNullOrEmpty()]
        [string]$Name = (Split-Path (Get-Location).path -Leaf),

        [Parameter(HelpMessage = "What is the project path?")]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path = (Get-Location).path,

        [Parameter(HelpMessage = "When was the project last worked on?")]
        [ValidateNotNullOrEmpty()]
        [alias("date")]
        [datetime]$LastUpdate = (Get-Date),

        [Parameter(HelpMessage = "What are the remaining tasks?")]
        [string[]]$Tasks,

        [Parameter(HelpMessage = "When is the project status?")]
        [ValidateNotNullOrEmpty()]
        [PSProjectStatus]$Status = "Development"
    )

    function Get-ParsedURL {
        param ([URI]$URI)
        
        if ($URI.Scheme -match "http") {
            $FQDN = $URI.Host
            ($t1,$t2,$t3) = $FQDN.Split(".")
            return $t1
        } else {
            return $URI.Scheme
        }
    }

    Write-Verbose "Starting $($MyInvocation.MyCommand)"

    $exclude = "Verbose", "WhatIf", "Confirm", "ErrorAction", "Debug",
    "WarningAction", "WarningVariable", "ErrorVariable","InformationAction",
    "InformationVariable"

    Write-Verbose "Creating a new instance of the PSProject class"
    $new = [psproject]::New()

    #convert the path to a filesystem path to avoid using PSDrive references
    $new.Path = Convert-Path $Path
    Write-Verbose "Using path $Path"
    #set the instance properties using parameter values from this command
    $PSBoundParameters.GetEnumerator() | Where-Object { $exclude -notcontains $_.key } |
    ForEach-Object {
        Write-Verbose "Setting property $($_.key)"
        $new.$($_.key) = $_.value
    }

    If (Test-Path .git) {
        $branch = git branch --show-current
        Write-Verbose "Detected git branch $branch"
        $new.GitBranch = $branch
        # adding new properties Version & SVC
            $manifest = $Path + [System.IO.Path]::DirectorySeparatorChar + $Name + ".psd1"
            if (Test-Path $manifest) { # module project
                $maniObj = Test-ModuleManifest $manifest -ErrorAction SilentlyContinue
                $myVer = ($maniObj.Version).ToString()
                if (!([string]::IsNullOrEmpty($myVer))) {
                    Write-Verbose "Setting property version"
                    $new.Version = $myVer
                }
            } else { # script project
                $myScript = $Path + [System.IO.Path]::DirectorySeparatorChar + $Name + ".ps1"
                $scriptObj = Test-ScriptFileInfo $myScript -ErrorAction SilentlyContinue
                $myVer = $scriptObj.Version
                if (!([string]::IsNullOrEmpty($myVer))) {
                    Write-Verbose "Setting property version"
                    $new.Version = $myVer
                }
            }

            $remURL = git remote show | ForEach-Object { git remote get-url --push $_}
            $URL = [uri]$remURL
            $svc = Get-ParsedURL $URL
            Write-Verbose "Setting property SVC"
            $new.SVC = $svc
        #
    } elseif (Test-Path .svn) {
        [XML]$r1XML = svn info --xml
        $remURL = $r1XML.info.entry.url
        $URL = [uri]$remURL
        $svc = Get-ParsedURL $URL
        Write-Verbose "Setting property SVC"
        $new.SVC = $svc

        Write-Verbose "Setting property Version"
        $new.Version = $r1XML.info.entry.revision
    } else {
        Write-Verbose "No git branch detected"
        # Handle instance where path doesn't have a .git or .svn directory
        $myScript = $Path + [System.IO.Path]::DirectorySeparatorChar + $Name + ".ps1"
        $scriptObj = Test-ScriptFileInfo $myScript -ErrorAction SilentlyContinue
        $myVer = $scriptObj.Version
        if (!([string]::IsNullOrEmpty($myVer))) {
            Write-Verbose "Setting property version"
            $new.Version = $myVer
        }
    }
    
    if ($pscmdlet.ShouldProcess($Name)) {
        $new
        $new.Save()
    }
    Write-Verbose "Ending $($MyInvocation.MyCommand)"

}
