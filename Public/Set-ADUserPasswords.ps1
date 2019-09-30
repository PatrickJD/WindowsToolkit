Function Set-ADUserPasswords
{
    <#
        .SYNOPSIS
            Resets the passwords for a number of AD Users.

        .DESCRIPTION
            Imports data from a CSV file and will reset AD user passwords 
            according to the passwords provided in the CSV.  The CSV file
            should have 2 columnes at minimum, with headers 'username' and
            'password' to set the passwords on the appropriate user.

        .PARAMETER UserMap
            Identifies the CSV file to be used for user/password mapping.
        
        .EXAMPLE
            Set-ADUserPasswords -UserMap users.csv 
        
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,Position=0,HelpMessage="Enter the CSV file with username & password mapping.")]
        [ValidateScript({Test-Path $_})]
        [string]
        $UserMapCSV
    )

    $UserMap = Import-Csv $UserMapCSV
    ForEach ($User in $UserMap)
    {
        Try
        {
            Set-ADAccountPassword -Identity $User.username -NewPassword (ConvertTo-SecureString -AsPlainText $User.password -Force)
            Write-Host "$($User.username) password reset to $($User.password)"
        }

        Catch
        {
            Write-Error "Failed to reset the password for user $($User.username)"
        }
    }
}