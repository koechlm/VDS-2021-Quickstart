$folderId=$vaultContext.CurrentSelectionSet[0].Id
$vaultContext.ForceRefresh = $true
$dialog = $dsCommands.GetCreateFolderDialog($folderId)

#override the default dialog file assigned
$xamlFile = New-Object CreateObject.WPF.XamlFile "ADSK.QS.Folder.xaml", "C:\ProgramData\Autodesk\Vault 2021\Extensions\DataStandard\Vault.Custom\Configuration\ADSK.QS.Folder.xaml"
$dialog.XamlFile = $xamlFile

$result = $dialog.Execute()
$dsDiag.Trace($result)

if($result)
{
	#new folder can be found in $dialog.CurrentFolder
	$folder = $vault.DocumentService.GetFolderById($folderId)
	$path=$folder.FullName+"/"+$dialog.CurrentFolder.Name
	
	#recursively add subfolders to new folders that are not base category folders
	$UIString = mGetUIStrings
	$NewFolder = $vault.DocumentService.GetFolderByPath($path)
	if($NewFolder.Cat.Catname -ne $UIString["CAT5"])
	{
		#the new folder is the targetfolder to create subfolders, the source folder is the template to be used
		$TempFolderName = "$/Templates/Folders/" + $NewFolder.Cat.Catname
		$tempFolder = $vault.DocumentService.GetFolderByPath($TempFolderName)
		
		#copy Access Control List if user's permission include ACLRead, ACLWrite
		$UserPermissions = mGetCUsPermissions

		if($UserPermissions -contains "ACL Read" -and $UserPermissions -contains "ACL Write")
		{
			$mValidPermis = $true
			$mCopiedACL = mCopyEntACL -SourceEnt  $tempFolder -TargetEnt  $NewFolder
		}

		If($tempFolder){ mRecursivelyCreateFolders -targetFolder $NewFolder -sourceFolder $tempFolder -inclACL $mValidPermis }
	}

	$selectionId = [Autodesk.Connectivity.Explorer.Extensibility.SelectionTypeId]::Folder
	$location = New-Object Autodesk.Connectivity.Explorer.Extensibility.LocationContext $selectionId, $path
	$vaultContext.GoToLocation = $location
}