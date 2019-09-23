function Get-AccountPWExpire
{
    [CmdletBinding()]
    Param
    (
        [Parameter(mandatory=$false,position=0,HelpMessage="If used this will export to file instead of console.")]
        [Switch]
        $Export
    )

    if($export)
    {
        try 
        {
            Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Export-CSV AccountPWExpires.csv -NoTypeInformation
            Write-Output "AccountPWExpires.csv exported to current directory"
        }
        catch 
        {
            throw "Something went wrong"
        }
        
    }

    else 
    {
        try 
        {
            Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Write-Output | Format-Table
        }
        catch 
        {
            throw "Something went wrong"
        }
    }

}