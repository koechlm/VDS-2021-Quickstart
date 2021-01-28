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

function InvertReadOnly
{
	if ($Prop["_ReadOnly"].Value){
		return $false
	}
	else{
		return $true
	}
}

function InitializeRevisionValidation
{
	if($Prop["_XLTN_CHECKEDBY"]) {
		$Prop["_XLTN_CHECKEDBY"].CustomValidation = { ValidateRevisionFields($Prop["_XLTN_CHECKEDBY"].Value) }
	}
	if($Prop["_XLTN_CHECKEDDATE"]){
		$Prop["_XLTN_CHECKEDDATE"].CustomValidation = { ValidateRevisionFields($Prop["_XLTN_CHECKEDDATE"].Value) }
	}
	if($Prop["_XLTN_ENGAPPRVDBY"]){
		$Prop["_XLTN_ENGAPPRVDBY"].CustomValidation = { ValidateRevisionFields($Prop["_XLTN_ENGAPPRVDBY"].Value) }
	}
	if($Prop["_XLTN_ENGAPPRVDDATE"]){
		$Prop["_XLTN_ENGAPPRVDDATE"].CustomValidation = { ValidateRevisionFields($Prop["_XLTN_ENGAPPRVDDATE"].Value) }
	}
	if($Prop["_XLTN_CHANGEDESCR"]){
		$Prop["_XLTN_CHANGEDESCR"].CustomValidation = { ValidateRevisionFields($Prop["_XLTN_CHANGEDESCR"].Value) }
	}
	
}

function ValidateRevisionFields([string] $Value)
{
	If ($Prop["_CreateMode"].Value -eq $true)
    {
        return $true
    }

	If ($Prop["_EditMode"].Value -eq $true)
	{
		$DrawingCats = @("Drawing AutoCAD", "Drawing Inventor")
		If($DrawingCats -contains $Prop["_Category"].Value)
		{
			switch($Prop["_XLTN_STATE"].Value)
			{
				"Work in Progress"
				{
					If ($Value -eq "")
					{
						return $false
					}
					else
					{
						return $true
					}
				}
				$UIString["Adsk.QS.RevTab_03"] #For Review
				{
					If ($Value -eq "")
					{
						return $false
					}
					else
					{
						return $true
					}
				}
				"Quick-Change" #$UIString["Adsk.QS.RevTab_04"]
				{
					If ($Value -eq "")
					{
						return $false
					}
					else
					{
						return $true
					}
				}
				default{
					return $true
				}
			}
		}
		else
		{ 
			return $true
		}
	}
}

function mInitializeRevTab
{
	$dsDiag.Trace("Initialize Revision Tab starts...")
	$Global:mRevTabInitialized = $false

	if($Global:mRevTabInitialized -ne $true)
	{
		if ($Prop["_CreateMode"].Value -eq $true) # todo: consider copy 
		{

		}
		if ($Prop["_EditMode"].Value -eq $true)
		{
			#we need the current file object to get its history
			$mFile = $vault.DocumentService.FindLatestFilesByPaths(@($Prop["_FilePath"].Value + "/" + $Prop["_FileName"].Value + $Prop["_FileExt"].Value))[0]	
			[Autodesk.Connectivity.WebServices.File[]]$mHistFiles = $vault.DocumentService.GetFilesByHistoryType(@($mFile.Id), "AllRevisionConsumableAndTip")[0].Files
			$mFileIter1 = $mHistFiles[$mHistFiles.Count-2]
			$mFileIter2 = $mHistFiles[$mHistFiles.Count-1]
			if($mFileIter1.VerNum +1 -eq $mFileIter2.VerNum)
			{
				$Prop["_XLTN_CHECKEDBY"].Value = ""
				$Prop["_XLTN_CHECKEDDATE"].Value = ""
				$Prop["_XLTN_ENGAPPRVDBY"].Value = ""
				$Prop["_XLTN_ENGAPPRVDDATE"].Value = ""
				$Prop["_XLTN_CHANGEDESCR"].Value = ""
			}
		}
		$Global:mRevTabInitialized = $true
	}

	$dsDiag.Trace("...Initialize Revision Tab ended.")
}

