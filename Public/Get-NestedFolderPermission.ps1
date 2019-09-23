function Get-NestedFolderPermission
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,position=0,HelpMessage="Enter the path to check nested folder permissions.")]
        [ValidateScript({Test-Path $_})]
        [string]
        $FolderPath,
        [Parameter(mandatory=$false,position=1,HelpMessage="If used this will export to file instead of console.")]
        [Switch]
        $Export
    )

    #Get a list of the paths
    try 
    {
        $Folders = Get-ChildItem -Directory -Path $FolderPath -Recurse -Force
    }
    catch 
    {
        throw "An error retrieving the folders has occured.  Please verify that you have access to the folder path being checked."
    }
    #Create an empty array to store data.
    $Output = @()

    #Loop through folders and obtain permisisons, store permissions in Output array

    ForEach ($Folder in $Folders)
    {
        try
        {
            $Acl = Get-Acl -Path $Folder.FullName
            ForEach ($AclAccess in $Acl.Access)
            {
                try
                {
                    $Properties = [ordered]@{'Folder Name'=$Folder.FullName;'Group/User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
                    $Output += New-Object -TypeName PSObject -Property $Properties   
                }
                catch
                {
                    Write-Error "Could not add ACL to Output variable for $($Folder.FullName)"
                }
            }
        }
        catch
        {
            Write-Error "Could not obtain ACL for folder $($Folder.Fullname)"
        }
    }

    #Write Output to console or CSV

    if($Export)
    {
        $Output | Export-CSV NestedFolderPermissions.csv -NoTypeInformation
        Write-Output "NestedFolderPermissions.csv exported to current directory"
    }
    
    else 
    {
        $Output | Out-GridView
    }
}