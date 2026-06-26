param (
        [Parameter(Mandatory)]
        [string]$output_path
      )
$version_string = git describe --tags --first-parent HEAD 2>$null
Write-Output "Computing version header from version string '$version_string'..."
if ([string]::IsNullOrEmpty($version_string)) {
    Write-Output "Failed to compute commit description, git returned an empty string, falling back to v1.2-clickable..."
    $version_string = "v1.2-clickable"
}

if ($version_string[0] -Ne 'v') {
    Write-Output "Current commit description ""$version_string"" does not have the expected format, terminating..."
    Return 1
}
$version_string = $version_string.Substring(1) # Remove the leading 'v'

$output_dir = Split-Path -Parent $output_path
New-Item -ItemType "directory" -Force $output_dir | Out-Null
Write-Output "#pragma once`n`n#define OPENLYRICS_VERSION ""$version_string""" > $output_path
Write-Output "Version header saved to $output_path"
