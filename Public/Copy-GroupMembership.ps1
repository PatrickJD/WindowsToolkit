function Copy-GroupMembership
{
    <#
    .SYNOPSIS
    Copies group membership from one AD User and adds the groups to a destination AD user.
    
    .DESCRIPTION
    Copies group membership from one AD User and adds the groups to a destination AD user.
    
    .EXAMPLE
    Copy-GroupMembership
    #>
    [CmdletBinding()]
    Param
    (
        [parameter(mandatory=$True,position=0,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter the reference username")]
        [String]
        $User,
        [parameter(mandatory=$True,position=1,HelpMessage="Enter the new username")]
        [String]
        $NewUser
    )


    $ReferenceGroups = Get-ADPrincipalGroupMembership -Identity $User

    foreach ($Group in $ReferenceGroups)
    {
        try
        {
            Add-ADPrincipalGroupMembership -Identity $NewUser -MemberOf $Group.name
            Write-Host "$NewUser added to group $($Group.name)"
        }

        catch
        {
            Write-Error "Failed to add user $NewUser to group $($Group.name)"
        }
    }

}