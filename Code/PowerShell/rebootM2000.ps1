# Usage: pwsh -File rebootM2000.ps1
param (
	[Parameter(Mandatory=$false)]
	[string]$HotspotIp = "192.168.1.1"
)

$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"
$hotspotEndpoint = "http://" + $HotspotIp

try {
   # Enter your mifi admin password on the line below
   $password = 'P0$e1d0N12'

   # Login to Mifi and force reboot
   $err = $null
   try {
	  $webReq = Invoke-WebRequest -Uri ($hotspotEndpoint + "/login") -SessionVariable session -Method get -UseBasicParsing
   }
   catch {
	  $err = $_
   }

   if ($err.Count -eq 0) {
	  $token = ($webReq.InputFields | ? {$_.name -eq 'gSecureToken'}).value
	  $passwordBytes = [System.Text.Encoding]::ASCII.GetBytes($password + $token)
	  $sha1 = [System.Security.Cryptography.SHA1]::Create()
	  $hash = $sha1.ComputeHash($passwordBytes)

	  # Convert resulting bytes to hex
	  $hashedpasswd = [string]::Join("",[System.BitConverter]::ToString($hash).ToLower().Split('-'))

	  # Build secure token
	  $body = "shaPassword=" + $hashedpasswd + "&gSecureToken=" + $token
	  try {
		 $result = invoke-RestMethod -Uri ($hotspotEndpoint + "/submitLogin/") -Method post -body $body -ContentType "application/x-www-form-urlencoded; charset=UTF-8" -WebSession $session
	  }
	  catch {
		 $err = $_
	  }
	  if ($err.Count -ne 0)
	  {
		 throw $err
	  }

	  try {
		 $webReq = Invoke-WebRequest -Uri ($hotspotEndpoint + "/restarting") -WebSession $session -Method get -useBasicParsing
	  }
	  catch {
		 $err = $_
	  }
	  if ($err.Count -ne 0)
	  {
		 throw $err
	  }

	  if ($err.Count -eq 0)
	  {
		 if ($webReq.Content -match 'data : \{ gSecureToken : "(.+)" \}') {
			$body = "gSecureToken=" + $matches[1]
			$result = invoke-RestMethod -Uri ($hotspotEndpoint + "/restarting/reboot/") -Method post -body $body -ContentType "application/x-www-form-urlencoded; charset=UTF-8" -WebSession $session -ErrorVariable err -ErrorAction SilentlyContinue 
			write-output $result
		 }
		 else {
			write-error "Could not parse content from endpoint $hotspotEndpoint/restarting $($webReq.Content)"
		 }
	  }
	  else
	  {
		 write-error $err
	  }
   }
} catch {
   write-error $result
   $ErrorActionPreference = "Continue"
   throw $_
}
