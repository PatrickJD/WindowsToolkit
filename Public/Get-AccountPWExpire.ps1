Function Get-AccountPWExpire
{
    <#
        .SYNOPSIS
            Lists account password expiration dates.

        .DESCRIPTION
            Lists account password expiration dates. This will
            list the account expiration for all users in 
            an Active Directory domain. 

        .PARAMETER Export
            If this switch is enabled, output will be directed to a CSV file.

        .EXAMPLE
            Get-AccountPWExpire -Export
        
        .EXAMPLE
            Get-AccountPWExpire
            
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$False,Position=0,HelpMessage="If used this will export to file instead of console.")]
        [Switch]
        $Export
    )

    If($Export)
    {
        Try 
        {
            Get-ADUser -Filter {Enabled -eq $true -and PasswordNeverExpires -eq $false} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Export-CSV AccountPWExpires.csv -NoTypeInformation
            Write-Output "AccountPWExpires.csv exported to current directory"
        }
        Catch 
        {
            Throw "Something went wrong"
        }
        
    }

    Else 
    {
        Try 
        {
            Get-ADUser -Filter {Enabled -eq $true -and PasswordNeverExpires -eq $false} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Write-Output | Format-Table
        }
        Catch 
        {
            Throw "Something went wrong"
        }
    }

}