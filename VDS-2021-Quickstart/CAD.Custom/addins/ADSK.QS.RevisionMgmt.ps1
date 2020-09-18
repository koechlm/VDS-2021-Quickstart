#region disclaimer =============================================================================
# PowerShell script sample for Vault Data Standard
#			 Autodesk Vault - Quickstart 2021
# This sample is based on VDS 2021 RTM and adds functionality and rules
#
# Copyright (c) Autodesk - All rights reserved.
#
# THIS SCRIPT/CODE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
# EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.
#endregion =============================================================================

#region - version history
# Version Info - VDS Quickstart Revision Management 2021.0.0
	# initial version
#endregion

function InitializeRevisionValidation
{
#	$mRevProperties = @($Prop["Checked By"], $Prop["Date Checked"], $Prop["Engr Approved By"], $Prop["Engr Date Approved"], $Prop["Change Descr"])
#	$mRevProperties | ForEach-Object { 		
#		$_.CustomValidation = { ValidateRevisionFields $_.Value }
##$dsDiag.Inspect("_")
#		$dsDiag.Trace("CustomValidation added for $($_.Name), Value=$($_.Value)")
#	}

	if($Prop["Checked By"]) {
		$Prop["Checked By"].CustomValidation = { ValidateRevisionFields $Prop["Checked By"].Value }
	}
	if($Prop["Date Checked"]){
		$Prop["Date Checked"].CustomValidation = { ValidateRevisionFields $Prop["Date Checked"].Value }
	}
	if($Prop["Engr Approved By"]){
		$Prop["Engr Approved By"].CustomValidation = { ValidateRevisionFields $Prop["Engr Approved By"].Value }
	}
	if($Prop["Engr Date Approved"]){
		$Prop["Engr Date Approved"].CustomValidation = { ValidateRevisionFields $Prop["Engr Date Approved"].Value}
	}
	if($Prop["Change Descr"]){
		$Prop["Change Descr"].CustomValidation = { ValidateRevisionFields $Prop["Change Descr"].Value }
	}
	
	#set revision properties to blank if the current file is first iteration after released state
	if ($Prop["_EditMode"].Value -eq $true)
		{
			#we need the current file object to get its history
			$_pos = $Prop["_FilePath"].Value.IndexOf($Prop["_WorkspacePath"].Value)
			$_1 = ($Prop["_FilePath"].Value).Substring($_pos + 1)
			$_2 = ($_1.Replace("\", "/")) #.Replace(".", "")
			$mVaultFilePath = $Prop["_VaultVirtualPath"].Value + "/" + $_2 + "/" + $Prop["_FileName"].Value

			$mFile = $vault.DocumentService.FindLatestFilesByPaths(@($mVaultFilePath))[0]	
	
			if($mFile.id -ne -1)
				{
					$dsDiag.Trace("...Check Revision History...")
					[Autodesk.Connectivity.WebServices.File[]]$mHistFiles = $vault.DocumentService.GetFilesByHistoryType(@($mFile.Id), "AllRevisionConsumableAndTip")[0].Files
					$mFileIter1 = $mHistFiles[$mHistFiles.Count-2]
					$mFileIter2 = $mHistFiles[$mHistFiles.Count-1]
#$dsDiag.Inspect()
					if($mFileIter1.VerNum +1 -eq $mFileIter2.MaxCkInVerNum)
					{
						$Prop["Checked By"].Value = ""
						$Prop["Date Checked"].Value = ""
						$Prop["Engr Approved By"].Value = ""
						$Prop["Engr Date Approved"].Value = ""
						$Prop["Change Descr"].Value = ""
						$global:RevPropValReset = $true
					}
				}			
		}
}

function ValidateRevisionFields([string] $Value)
{
$dsDiag.Trace(">>Validation runs for '$($Value)'")

	If ($Prop["_CreateMode"].Value -eq $true -or $RevPropValReset -eq $true)
    {
		$dsDiag.Trace("..._CreateMode -> return validation true.")
        return $true
    }

	If ($Prop["_EditMode"].Value -eq $true)
	{		
		$dsDiag.Trace("...EditMode...")

		if ($Value -eq "")
		{
			$dsDiag.Trace("...no Value: returning false<<")
			return $false
		}
		else
		{
			$dsDiag.Trace("...has Value: returning true<<")
			return $true
		}

		#switch($Prop["_XLTN_STATE"].Value)
		#{
		#	default{
		#		$dsDiag.Trace("...switch default...")
		#		if ($Value -eq "")
		#		{
		#			return $false
		#		}
		#		else
		#		{
		#			return $true
		#		}
		#	}
		#}
	}
	
}

#function mInitializeRevTab
#{
#	$dsDiag.Trace("Initialize Revision Tab starts...")
#	$Global:mRevTabInitialized = $false

#	if($Global:mRevTabInitialized -ne $true)
#	{
#		if ($Prop["_CreateMode"].Value -eq $true) # todo: consider copy 
#		{

#		}
#		if ($Prop["_EditMode"].Value -eq $true)
#		{
#			#we need the current file object to get its history
#			$mFile = $vault.DocumentService.FindLatestFilesByPaths(@($Prop["_FilePath"].Value + "/" + $Prop["_FileName"].Value + $Prop["_FileExt"].Value))[0]	
#			[Autodesk.Connectivity.WebServices.File[]]$mHistFiles = $vault.DocumentService.GetFilesByHistoryType(@($mFile.Id), "AllRevisionConsumableAndTip")[0].Files
#			$mFileIter1 = $mHistFiles[$mHistFiles.Count-2]
#			$mFileIter2 = $mHistFiles[$mHistFiles.Count-1]
#			if($mFileIter1.VerNum +1 -eq $mFileIter2.VerNum)
#			{

#			}
#		}
#		$Global:mRevTabInitialized = $true
#	}

#	$dsDiag.Trace("...Initialize Revision Tab ended.")
#}

