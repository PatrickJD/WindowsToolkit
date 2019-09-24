Function Copy-GroupMembership
{
    <#
    .SYNOPSIS
    Copies AD group membership
    
    .DESCRIPTION
    This will copy AD group membership from one reference
    user to another user.  This does not remove existing
    group membership from the new user.
    
    .EXAMPLE
    Copy-GroupMembership -User Jsmith -NewUser Jdoe

    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(mandatory=$True,position=0,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter the reference username")]
        [String]
        $User,
        [Parameter(mandatory=$True,position=1,HelpMessage="Enter the new username")]
        [String]
        $NewUser
    )


    $ReferenceGroups = Get-ADPrincipalGroupMembership -Identity $User

    ForEach ($Group in $ReferenceGroups)
    {
        Try
        {
            Add-ADPrincipalGroupMembership -Identity $NewUser -MemberOf $Group.name
            Write-Host "$NewUser added to group $($Group.name)"
        }

        Catch
        {
            Write-Error "Failed to add user $NewUser to group $($Group.name)"
        }
    }
}