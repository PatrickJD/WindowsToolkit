Function Get-InactiveAccounts
{
    <#
        .SYNOPSIS
            Finds users or computers that are inactive.

        .DESCRIPTION
            Finds users or computers that are inactive.
            This will find users or computers who have not
            been active within the last n days, based
            on the parameters used at runtime.

        .PARAMETER ReportType
            Select User, Computer or Both for the type of
            inactive accounts to search for.

        .PARAMETER DaysInactive
            Select the number of days since last logon
            for an account to be considered inactive.

        .PARAMETER Export
            If this switch is enabled, output will be directed to a CSV file.
        
        .EXAMPLE
            Get-InactiveAccounts -ReportType Both -DaysInactive 30 -Export
        
        .EXAMPLE
            Get-InactiveAccounts -ReportType User -DaysInactive 75
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$True,Position=0)]
        [validateset("User", "Computer", "Both")]
        [String]
        $ReportType,
        [Parameter(Mandatory=$True,Position=1)]
	    [validaterange(1, [Int]::MaxValue)]
        [Int]
        $DaysInactive,
        [Parameter(Mandatory=$False,Position=2,HelpMessage="If used this will export to file instead of console.")]
        [Switch]
        $Export
    )

    #Get date timeframe for the report
    $Time = (Get-Date).Adddays(-($DaysInactive))

    #Generate the appropriate reports.
    If($ReportType -eq "User" -or $ReportType -eq "Both")
    {
        Try 
        {
            Write-Verbose "Finding users that match the parameters"
            $ADusr = Get-ADUser -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp | Select-Object Name,DistinguishedName,@{Name="Last Logon"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('MM-dd-yyyy')}},Enabled
            If($Export)
            {
                $ADusr | Export-CSV InactiveUsers.csv -notypeinformation
                Write-Output "AgingUsers.csv exported to current directory"
            }
            Else 
            {
                $ADusr | Write-Output | Format-Table
            }
        }
        Catch 
        {
            Throw "Something went wrong"
        }
        
    }
    If($ReportType -eq "Computer" -or $ReportType -eq "Both")
    {
        Try 
        {
            Write-Verbose "Finding users that match the parameters"
            $ADcmp = Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp | Select-Object Name,DistinguishedName,@{Name="Last Logon"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('MM-dd-yyyy')}},Enabled
            If($Export)
            {
                $ADcmp | Export-CSV InactiveComputers.csv -notypeinformation
                Write-Output "AgingComputers.csv exported to current directory"
            }
            Else 
            {
                $ADcmp | Write-Output | Format-Table
            }
        }
        Catch 
        {
            Throw "Something went wrong"
        }
    }
}