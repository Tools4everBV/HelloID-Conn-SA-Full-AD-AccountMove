$ou = $form.ou.Path
$userPrincipalName = $form.gridUsers.UserPrincipalName

try{
    $adUser = Get-ADuser -Filter { UserPrincipalName -eq $userPrincipalName }
    Write-information "Found AD user [$userPrincipalName]" 

     $adUserSID = $([string]$adUser.SID)
        $Log = @{
            Action            = "MoveAccount" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Found user with username $userPrincipalName" # required (free format text) 
            IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $userPrincipalName # optional (free format text) 
            TargetIdentifier  = $adUserSID # optional (free format text) 
        }
        #send result back  
        Write-Information -Tags "Audit" -MessageData $log
} catch {
    Write-error "Could not find AD user [$userPrincipalName]. Error: $($_.Exception.Message)"

       $Log = @{
            Action            = "MoveAccount" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Could find user with username $userPrincipalName" # required (free format text) 
            IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $userPrincipalName # optional (free format text) 
            TargetIdentifier  = "" # optional (free format text) 
        }
        #send result back  
        Write-Information -Tags "Audit" -MessageData $log
}

try{
    Move-ADObject -Identity $adUser -TargetPath $ou
    Write-information "Finished moving AD user [$userPrincipalName] to [$ou]" 

    Write-information "Finished adding AD user [$userPrincipalName] to AD groups $groupsToAdd"
    $Log = @{
            Action            = "MoveAccount" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Moved user $userPrincipalName to OU $ou" # required (free format text) 
            IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $userPrincipalName # optional (free format text) 
            TargetIdentifier  = $adUserSID # optional (free format text) 
        }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log

} catch {
    Write-error "Could not move AD user [$userPrincipalName] to [$ou]. Error: $($_.Exception.Message)" 

    $Log = @{
            Action            = "MoveAccount" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Could not move user with username $userPrincipalName" # required (free format text) 
            IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $userPrincipalName # optional (free format text) 
            TargetIdentifier  = $adUserSID # optional (free format text) 
        }
        #send result back  
        Write-Information -Tags "Audit" -MessageData $log
}