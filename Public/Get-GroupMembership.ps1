function Get-GroupMembership
{
    <#
    .SYNOPSIS
    Find's group membership for all AD users and exports to console or CSV.
    
    .DESCRIPTION
    Find's group membership for all AD users and exports to console or CSV.
    
    .EXAMPLE
    Copy-GroupMembership
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(mandatory=$false,position=0,HelpMessage="If used this will export to file instead of console.")]
        [Switch]
        $Export
    )

    
    $Output = @()
    $ADUsers = Get-ADUser -Filter *

    foreach($ADUser in $ADUsers)
    {
        try
        {
            $ADUserGroup = Get-ADPrincipalGroupMembership -Identity $ADUser
            $Properties = [ordered]@{'Username'=$ADUser.Name;'GroupMembership'=$ADUserGroup.Name}
            $Output += New-Object -TypeName PSObject -Property $Properties
        }
        catch
        {
            
        }
    }

    if($Export)
    {
        $Output | Export-CSV UserGroupMembership.csv
    }
    else
    {
        $Output | Write-Output | Out-GridView
    } 
}