function Get-AgingAccounts
{
    [cmdletbinding()]
    param
    (
        [parameter(Mandatory=$true,Position=0)]
        [validateset("User", "Computer", "Both")]
        [string]
        $ReportType,
        [parameter(Mandatory=$true,Position=1)]
	    [validaterange(1, [int]::MaxValue)]
        [int]
        $DaysInactive,
        [parameter(Mandatory=$false,Position=2,HelpMessage="If used this will export to file instead of console.")]
        [switch]
        $Export
    )

    #Get date timeframe for the report
    $Time = (Get-Date).Adddays(-($DaysInactive))

    #Generate the appropriate reports.
    if($ReportType -eq "User" -or $ReportType -eq "Both")
    {
        try 
        {
            Write-Verbose "Finding users that match the parameters"
            $ADusr = Get-ADUser -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp | Select-Object Name,DistinguishedName,@{Name="Last Logon"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('MM-dd-yyyy')}},Enabled
            if($Export)
            {
                $ADusr | Export-CSV AgingUsers.csv -notypeinformation
                Write-Output "AgingUsers.csv exported to current directory"
            }
            else 
            {
                $ADusr | Write-Output | Format-Table
            }
        }
        catch 
        {
            throw "Something went wrong"
        }
        
    }
    if($ReportType -eq "Computer" -or $ReportType -eq "Both")
    {
        try 
        {
            Write-Verbose "Finding users that match the parameters"
            $ADcmp = Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp | Select-Object Name,DistinguishedName,@{Name="Last Logon"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('MM-dd-yyyy')}},Enabled
            if($Export)
            {
                $ADcmp | Export-CSV AgingComputers.csv -notypeinformation
                Write-Output "AgingComputers.csv exported to current directory"
            }
            else 
            {
                $ADcmp | Write-Output | Format-Table
            }
        }
        catch 
        {
            throw "Something went wrong"
        }
    }
}