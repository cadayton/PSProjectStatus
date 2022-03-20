# https://jdhitsolutions.com/blog/powershell/8960/introducing-psprojectstatus/

Add-PodeWebPage -Name PSProjectStatus -Icon 'table' -Group 'Tools' -Layouts @(
  New-PodeWebContainer -NoBackground -Content @(
    New-PodeWebTable -Name 'ProjectStatus' -DataColumn Path -NoRefresh -SimpleFilter -SimpleSort -ScriptBlock {
      # functions
        function Import-Projects {
          $all = Get-ChildItem -Path C:\Git-Keybase -Directory -Recurse | Get-PSProjectStatus -WarningAction SilentlyContinue
          $all += Get-ChildItem -Path C:\GitHub -Directory -Recurse | Get-PSProjectStatus -WarningAction SilentlyContinue

          return $all | Sort-Object Status, LastUpdate |
            Select-Object Path, Status, @{Name = "Tasks"; Expression = { $_.Tasks -join ',' } }, Gitbranch, Version, SVC, LastUpdate
        }
      #

      $startBtn = New-PodeWebButton -Name 'VScode' -Icon 'launch' -IconOnly -ScriptBlock {
        $projectPath = $WebEvent.Data.Value

        code $projectPath

        Show-PodeWebToast -Message "'$($WebEvent.Data['Value'])' has been started" -Duration 5000 -Title "'$($WebEvent.Data['Value'])'" -Icon 'launch'
      }

      $projectObj = Import-Projects

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
      
      $projectObj | ForEach-Object {
        [ordered]@{
          Path         = $_.Path
          Status       = $([PSProjectStatus].GetEnumNames())[$_.Status]
          Version      = $_.Version
          Tasks        = $_.Tasks
          Branch       = $_.Gitbranch
          SVC          = $_.SVC
          LastUpdate   = Get-Date -date $_.LastUpdate -Format "yyyy/MM/dd hh:mm:ss"
          Launch       = @($startBtn)
        }
      }

    }
  )
)