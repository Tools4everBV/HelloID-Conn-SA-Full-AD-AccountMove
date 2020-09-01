try{
    $adUser = Get-ADuser -Filter { UserPrincipalName -eq $userPrincipalName }
    HID-Write-Status -Message "Found AD user [$userPrincipalName]" -Event Information
    HID-Write-Summary -Message "Found AD user [$userPrincipalName]" -Event Information
} catch {
    HID-Write-Status -Message "Could not find AD user [$userPrincipalName]. Error: $($_.Exception.Message)" -Event Error
    HID-Write-Summary -Message "Failed to find AD user [$userPrincipalName]" -Event Failed
}
 
try{
    Move-ADObject -Identity $adUser -TargetPath $ou
    HID-Write-Status -Message "Finished moving AD user [$userPrincipalName] to [$ou]" -Event Success
    HID-Write-Summary -Message "Successfully moved AD user [$userPrincipalName] to [$ou]" -Event Success
} catch {
    HID-Write-Status -Message "Could not move AD user [$userPrincipalName] to [$ou]. Error: $($_.Exception.Message)" -Event Error
    HID-Write-Summary -Message "Failed to move AD user [$userPrincipalName] to [$ou]" -Event Failed
}