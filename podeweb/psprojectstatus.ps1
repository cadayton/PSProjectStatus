Import-Module Pode -Global -MaximumVersion 2.99.99 -Force
Import-Module Pode.Web -Global -Force
Import-Module PSProjectStatus -Global -Force

Start-PodeServer -ScriptBlock {
  # add a simple endpoint
    Add-PodeEndpoint -Address localhost -Port 9001 -Protocol Http
    New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging
  #

  Use-PodeWebTemplates -Title 'PSProjectStatus' -Theme Dark

  $navDropdown = New-PodeWebNavDropdown -Name 'KeyBase' -Icon 'apps-box' -Items @(
    New-PodeWebNavLink -Name 'KeyBase Home' -Url 'https://cadayton.keybase.pub/' -Icon 'search-web' -NewTab
    New-PodeWebNavDivider
    New-PodeWebNavDropdown -Name 'PowerShell Modules' -Icon 'powershell' -Items @(
        New-PodeWebNavLink -Name 'PSKeyBase' -Url 'https://cadayton.keybase.pub/PSGallery/Modules/PSKeyBase/PSKeyBase.html' -Icon 'search-web' -NewTab
        New-PodeWebNavLink -Name 'BOTtum' -Url 'https://cadayton.keybase.pub/PSGallery/Modules/BOTtum/BOTtum.html' -Icon 'robot' -NewTab
        New-PodeWebNavLink -Name 'Moolah' -Url 'https://cadayton.keybase.pub/PSGallery/Modules/Moolah/Moolah.html' -Icon 'bitcoin' -NewTab
        New-PodeWebNavLink -Name 'FileVault' -Url 'https://cadayton.keybase.pub/PSGallery/Modules/FileVault/FileVault.html' -Icon 'safe' -NewTab
        New-PodeWebNavLink -Name 'PureSnap' -Url 'https://cadayton.keybase.pub/PSGallery/Modules/PureSnap/PureSnap.html' -Icon 'vector-difference-ab' -NewTab
        New-PodeWebNavLink -Name 'Venom' -Url 'https://github.com/cadayton/Venom' -Icon 'fridge' -NewTab
        New-PodeWebNavLink -Name 'Venom Readme' -Url 'https://venom.readthedocs.io/en/latest/' -Icon 'help-circle' -NewTab
    )
    New-PodeWebNavDivider
    New-PodeWebNavDropdown -Name 'PowerShell Scripts' -Icon 'powershell' -Items @(
      New-PodeWebNavLink -Name 'psConsole' -Url 'https://cadayton.keybase.pub/PSGallery/Scripts/psConsole.html' -Icon 'console' -NewTab
      New-PodeWebNavLink -Name 'Encrypt-File' -Url 'https://cadayton.keybase.pub/PSGallery/Scripts/Encrypt-File.html' -Icon 'safe' -NewTab
      New-PodeWebNavLink -Name 'Create-SharedCertificate' -Url 'https://cadayton.keybase.pub/PSGallery/Scripts/Create-SharedCertificate.html' -Icon 'certificate' -NewTab
      New-PodeWebNavLink -Name 'Pure1' -Url 'https://cadayton.keybase.pub/PSGallery/Scripts/Pure1.html' -Icon 'safe' -NewTab
    )
    New-PodeWebNavDivider
    New-PodeWebNavDropdown -Name 'Universal Dashboard' -Icon 'powershell' -Items @(
      New-PodeWebNavLink -Name 'ubetcha App' -Url 'https://cadayton.keybase.pub/PSGallery/UDApps/Ubetcha/Ubetcha.pdf' -Icon 'cash-check' -NewTab
      New-PodeWebNavLink -Name 'Web Homepage' -Url 'https://cadayton.keybase.pub/PSGallery/UD/KeyBase.html' -Icon 'home-account' -NewTab
    )
    New-PodeWebNavDivider
    New-PodeWebNavLink -Name 'Pode Gitter' -Url 'https://gitter.im/Badgerati/Pode' -Icon 'chat'
    New-PodeWebNavLink -Name 'Twitch' -Url 'https://twitch.tv' -Icon 'twitch'
  )

  $devReferences = New-PodeWebNavDropdown -Name 'Pode' -Icon 'file-document-multiple' -Items @(
    New-PodeWebNavLink -Name 'Pode Route Tutorials'     -Url 'https://badgerati.github.io/Pode/Tutorials/Routes/Examples/WebPages/' -Icon 'search-web' -NewTab
    New-PodeWebNavLink -Name 'GitHub Pode.Web'          -Url 'https://github.com/Badgerati/Pode.Web' -Icon 'search-web' -NewTab
    New-PodeWebNavLink -Name 'Pode.Web Home'            -Url 'https://badgerati.github.io/Pode.Web/' -Icon 'search-web' -NewTab
    New-PodeWebNavLink -Name 'Pode.Web Basic Tutorials' -Url 'https://badgerati.github.io/Pode.Web/Tutorials/Basics/' -Icon 'search-web' -NewTab
    New-PodeWebNavLink -Name 'Pode.Web Examples'        -Url 'https://github.com/Badgerati/Pode.Web/tree/71d14aa2f11efa85f9cf3cf2f2f128177708a441/examples' -Icon 'search-web' -NewTab
    New-PodeWebNavLink -Name 'Gitter Pode'              -Url 'https://gitter.im/Badgerati/Pode#' -Icon 'search-web' -NewTab
    New-PodeWebNavLink -Name 'Material Icons'           -Url 'https://pictogrammers.github.io/@mdi/font/5.4.55/' -Icon 'search-web' -NewTab
  )

  Set-PodeWebNavDefault -Items $navDropdown, $devReferences

  $hero = New-PodeWebHero -Title 'Welcome to PSProjectStatus!' -Message 'This is the home page for demostration of PSProjectStatus module' -Content @(
    New-PodeWebText -Value 'Here you will see examples for close to everything Pode.Web can do.' -InParagraph -Alignment Center
    New-PodeWebParagraph -Alignment Center -Elements @(
      New-PodeWebButton -Name 'Pode.Web Repository' -Icon Link -Url 'https://github.com/Badgerati/Pode.Web' -NewTab
    )
    New-PodeWebParagraph -Alignment Center -Elements @(
      New-PodeWebButton -Name 'PSProjectStatus Repository' -Icon Link -Url 'https://github.com/jdhitsolutions/PSProjectStatus' -NewTab
    )
    New-PodeWebParagraph -Alignment Center -Elements @(
      New-PodeWebButton -Name 'PSProjectStatus Blog' -Icon Link -Url 'https://jdhitsolutions.com/blog/powershell/8960/introducing-psprojectstatus/' -NewTab
    )
  )

  Set-PodeWebHomePage -NoAuth -Layouts $hero

  Use-PodeWebPages

}