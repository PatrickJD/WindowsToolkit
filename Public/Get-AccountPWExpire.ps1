function Get-AccountPWExpire
{
    [cmdletbinding()]
    param
    (
        [parameter(mandatory=$false,position=0,helpmessage="If used this will export to file instead of console.")]
        [switch]
        $Export
    )

    if($Export)
    {
        try 
        {
            Get-ADUser -filter {Enabled -eq $true -and PasswordNeverExpires -eq $false} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Export-CSV AccountPWExpires.csv -NoTypeInformation
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
            Get-ADUser -filter {Enabled -eq $true -and PasswordNeverExpires -eq $false} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Write-Output | Format-Table
        }
        catch 
        {
            throw "Something went wrong"
        }
    }

}