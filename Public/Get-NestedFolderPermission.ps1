Function Get-NestedFolderPermission
{
    <#
        .SYNOPSIS
            Finds the permissions of nested folders.

        .DESCRIPTION
            Finds the permissions of nested folders.  This will search
            through all folders recursively and enumerate the permissions
            with output to console or CSV.

        .PARAMETER Export
            If this switch is enabled, output will be directed to a CSV file.
        
        .EXAMPLE
            Get-NestedFolderPermission
        
        .EXAMPLE
            Get-NestedFolderPermission -Export
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$True,Position=0,HelpMessage="Enter the path to check nested folder permissions.")]
        [ValidateScript({Test-Path $_})]
        [String]
        $FolderPath,
        [Parameter(Mandatory=$False,Position=1,HelpMessage="If used this will export to file instead of console.")]
        [Switch]
        $Export
    )

    #Get a list of the paths
    Try 
    {
        $Folders = Get-ChildItem -Directory -Path $FolderPath -Recurse -Force
    }
    Catch 
    {
        Throw "An error retrieving the folders has occured.  Please verify that you have access to the folder path being checked."
    }
    #Create an empty array to store data.
    $Output = @()

    #Loop through folders and obtain permisisons, store permissions in Output array

    ForEach ($Folder in $Folders)
    {
        Try
        {
            $Acl = Get-Acl -Path $Folder.FullName
            ForEach ($AclAccess in $Acl.Access)
            {
                Try
                {
                    $Properties = [Ordered]@{'Folder Name'=$Folder.FullName;'Group/User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
                    $Output += New-Object -TypeName PSObject -Property $Properties   
                }
                Catch
                {
                    Write-Error "Could not add ACL to Output variable for $($Folder.FullName)"
                }
            }
        }
        Catch
        {
            Write-Error "Could not obtain ACL for folder $($Folder.Fullname)"
        }
    }

    #Write Output to console or CSV

    If($Export)
    {
        $Output | Export-CSV NestedFolderPermissions.csv -NoTypeInformation
        Write-Output "NestedFolderPermissions.csv exported to current directory"
    }
    
    Else 
    {
        $Output | Out-GridView
    }
}