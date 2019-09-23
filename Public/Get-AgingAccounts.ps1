function Get-AgingAccounts
{
    [CmdletBinding()]
    Param
    (
        [parameter(mandatory=$True,position=0)]
        [ValidateSet("User", "Computer", "Both")]
        [String]
        $ReportType,
        [parameter(mandatory=$True,position=1)]
	    [ValidateRange(1, [int]::MaxValue)]
        [Int]
        $DaysInactive,
        [Parameter(mandatory=$false,position=2,HelpMessage="If used this will export to file instead of console.")]
        [Switch]
        $Export
    )

    #Get date timeframe for the report
    $time = (Get-Date).Adddays(-($DaysInactive))

    #Generate the appropriate reports.
    if($ReportType -eq "User" -or $ReportType -eq "Both")
    {
        try 
        {
            Write-Verbose "Finding users that match the parameters"
            $adusr = Get-ADUser -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp | Select-Object Name,DistinguishedName,@{Name="Last Logon"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('MM-dd-yyyy')}},Enabled
            if($Export)
            {
                $adusr | Export-CSV AgingUsers.csv -notypeinformation
                Write-Output "AgingUsers.csv exported to current directory"
            }
            else 
            {
                $adusr | Write-Output | Format-Table
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
            $adcmp = Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp | Select-Object Name,DistinguishedName,@{Name="Last Logon"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('MM-dd-yyyy')}},Enabled
            if($Export)
            {
                $adcmp | Export-CSV AgingComputers.csv -notypeinformation
                Write-Output "AgingComputers.csv exported to current directory"
            }
            else 
            {
                $adcmp | Write-Output | Format-Table
            }
        }
        catch 
        {
            throw "Something went wrong"
        }
    }
}