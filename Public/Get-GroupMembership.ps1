Function Get-GroupMembership
{
    <#
        .SYNOPSIS
            Lists group membership for all Active Directory users in a domain.

        .DESCRIPTION
            Lists group membership for all Active Directory users in a domain.
            This will enumerate the group membership for all users and 
            either output to console or export to CSV. 

        .PARAMETER Export
            If this switch is enabled, output will be directed to a CSV file.

        .EXAMPLE
            Get-GroupMembership -Export
        
        .EXAMPLE
            Get-GroupMembership
            
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$False,Position=0,HelpMessage="If used this will export to file instead of console.")]
        [Switch]
        $Export
    )
    
    $Output = @()
    $ADUsers = Get-ADUser -Filter *

    ForEach($ADUser in $ADUsers)
    {
        Try
        {
            $ADUserGroup = Get-ADPrincipalGroupMembership -Identity $ADUser
            $Properties = [Ordered]@{'Username'=$ADUser.Name;'GroupMembership'=$ADUserGroup.Name}
            $Output += New-Object -TypeName PSObject -Property $Properties
        }
        Catch
        {
            Write-Error "Failed obtaining group membership for user $($ADUser.Name)"
        }
    }

    If($Export)
    {
        $Output | Convert-OutputforCSV | Export-CSV UserGroupMembership.csv -NoTypeInformation
    }
    Else
    {
        $Output | Write-Output | Out-GridView
    } 
}