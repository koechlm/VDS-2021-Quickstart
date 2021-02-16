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

		switch($dsWindow.Name)
		{
			"InventorWindow"
			{
				$dsDiag.Trace("ExtendedRevision Validation for Inventor starts...")
				if (@(".DWG",".IDW", ".dwg", ".idw") -contains $Prop["_FileExt"].Value)
				{
					$mFileState = mGetState
					if($mFileState -eq $null) 
					{
						if($Prop["Checked By"]) {
							$Prop["Checked By"].CustomValidation = { $true }
						}
						if($Prop["Date Checked"]){
							$Prop["Date Checked"].CustomValidation = { $true }
						}
						if($Prop["Engr Approved By"]){
							$Prop["Engr Approved By"].CustomValidation = { $true }
						}
						if($Prop["Engr Date Approved"]){
							$Prop["Engr Date Approved"].CustomValidation = { $true }
						}
						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { $true }
						}
					}

					if($mFileState -eq $UIString["Adsk.QS.RevTab_05"] -or $mFileState -eq $UIString["Adsk.QS.RevTab_04"]) # Work in Progress or 'Quick-Change'
					{
						if($Prop["Checked By"]) {
							$Prop["Checked By"].CustomValidation = { ValidateRevisionFields $Prop["Checked By"] }
						}
					}
					if($mFileState -eq $UIString["Adsk.QS.RevTab_03"]) #'For Review'
					{
						if($Prop["Date Checked"]){
							$Prop["Date Checked"].CustomValidation = { ValidateRevisionFields $Prop["Date Checked"] }
						}
						if($Prop["Engr Approved By"]){
							$Prop["Engr Approved By"].CustomValidation = { ValidateRevisionFields $Prop["Engr Approved By"] }
						}
						if($Prop["Engr Date Approved"]){
							$Prop["Engr Date Approved"].CustomValidation = { ValidateRevisionFields $Prop["Engr Date Approved"]}
						}
						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { ValidateRevisionFields $Prop["Change Descr"]}
						}
					}
				}
			}

			"AutoCADWindow"
			{
				#AutoCAD Mechanical Block Attributes
				if($Prop["GEN-TITLE-DWG"].Value)
				{		
					$mFileState = mGetState
					if($mFileState -eq $null) 
					{
						if($Prop["GEN-TITLE-CHKM"]) {
							$Prop["GEN-TITLE-CHKM"].CustomValidation = { $true }
						}
						if($Prop["GEN-TITLE-CHKD"]) {
							$Prop["GEN-TITLE-CHKD"].CustomValidation = { $true }
						}
						if($Prop["GEN-TITLE-ISSM"]) {
							$Prop["GEN-TITLE-ISSM"].CustomValidation = { $true }
						}
						if($Prop["GEN-TITLE-ISSD"]) {
							$Prop["GEN-TITLE-ISSD"].CustomValidation = { $true }
						}
						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { $true }
						}
					}

					if($mFileState -eq $UIString["Adsk.QS.RevTab_05"] -or $mFileState -eq $UIString["Adsk.QS.RevTab_04"]) # Work in Progress or 'Quick-Change'
					{
						if($Prop["GEN-TITLE-CHKM"]) {
							$Prop["GEN-TITLE-CHKM"].CustomValidation = { ValidateRevisionFields $Prop["GEN-TITLE-CHKM"] }
						}
					}
					
					if($mFileState -eq $UIString["Adsk.QS.RevTab_03"]) #replace by UIString
					{
						if($Prop["GEN-TITLE-CHKD"]) {
							$Prop["GEN-TITLE-CHKD"].CustomValidation = { ValidateRevisionFields $Prop["GEN-TITLE-CHKD"] }
						}
						if($Prop["GEN-TITLE-ISSM"]) {
							$Prop["GEN-TITLE-ISSM"].CustomValidation = { ValidateRevisionFields $Prop["GEN-TITLE-ISSM"] }
						}
						if($Prop["GEN-TITLE-ISSD"]) {
							$Prop["GEN-TITLE-ISSD"].CustomValidation = { ValidateRevisionFields $Prop["GEN-TITLE-ISSD"] }
						}
						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { ValidateRevisionFields $Prop["Change Descr"]} #revision table property in PDMC-Sample
						}
					}
		
				}
				else #AutoCAD Template
				{
					$mFileState = mGetState
					if($mFileState -eq $null) 
					{
						if($Prop["Checked By"]) {
							$Prop["Checked By"].CustomValidation = { $true }
						}
						if($Prop["Date Checked"]){
							$Prop["Date Checked"].CustomValidation = { $true }
						}
						if($Prop["Engr Approved By"]){
							$Prop["Engr Approved By"].CustomValidation = { $true }
						}
						if($Prop["Engr Date Approved"]){
							$Prop["Engr Date Approved"].CustomValidation = { $true }
						}
						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { $true }
						}
					}

					if($mFileState -eq $UIString["Adsk.QS.RevTab_05"] -or $mFileState -eq $UIString["Adsk.QS.RevTab_04"]) # Work in Progress or 'Quick-Change'
					{
						if($Prop["Checked By"]) {
							$Prop["Checked By"].CustomValidation = { ValidateRevisionFields $Prop["Checked By"] }
						}
					}

					if($mFileState -eq $UIString["Adsk.QS.RevTab_03"]) #replace by UIString
					{
						if($Prop["Date Checked"]){
							$Prop["Date Checked"].CustomValidation = { ValidateRevisionFields $Prop["Date Checked"] }
						}
						if($Prop["Engr Approved By"]){
							$Prop["Engr Approved By"].CustomValidation = { ValidateRevisionFields $Prop["Engr Approved By"] }
						}
						if($Prop["Engr Date Approved"]){
							$Prop["Engr Date Approved"].CustomValidation = { ValidateRevisionFields $Prop["Engr Date Approved"]}
						}
						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { ValidateRevisionFields $Prop["Change Descr"]}
						}
					}
				}
			}#AutoCADWindow
		}#switch WindowName


	#set revision properties to blank if the current file is first iteration after released state
	<#if ($Prop["_EditMode"].Value -eq $true -and $RevPropValReset -eq $null)
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
		#>
}

function ValidateRevisionFields($mProp)
{
	$dsDiag.Trace(">>Validation runs for '$($mProp.Name)', $($mProp.Typ)")

	If ($Prop["_CreateMode"].Value -eq $true) #-or $RevPropValReset -eq $true
    {
		$dsDiag.Trace("..._CreateMode -> return validation true.")
        return $true
    }

	If ($Prop["_EditMode"].Value -eq $true)
	{		
		$dsDiag.Trace("...EditMode...")

		if ($mProp.Value -eq "" -OR $mProp.Value -eq $null)
		{
			$dsDiag.Trace("...no Value: returning false<<")
			return $false
		}
		else
		{
			$dsDiag.Trace("...has Value: returning true<<")
			return $true
		}
	}
	
}

function mGetState
{
	#we need the current file object
	$_pos = $Prop["_FilePath"].Value.IndexOf($Prop["_WorkspacePath"].Value)
	$_1 = ($Prop["_FilePath"].Value).Substring($_pos + 1)
	$_2 = ($_1.Replace("\", "/")) #.Replace(".", "")
	$mVaultFilePath = $Prop["_VaultVirtualPath"].Value + "/" + $_2 + "/" + $Prop["_FileName"].Value

	$mFile = $vault.DocumentService.FindLatestFilesByPaths(@($mVaultFilePath))[0]	

	if($mFile.id -ne -1)
	{
		return $mFile.FileLfCyc.LfCycStateName
	}

	return $null

}

function ResetRevisionProperties
{
	switch($dsWindow.Name)
		{
			"InventorWindow"
			{
				$dsDiag.Trace("ExtendedRevision Validation for Inventor starts...")
				if (@(".DWG",".IDW", ".dwg", ".idw") -contains $Prop["_FileExt"].Value)
				{
					if($Prop["Checked By"]) {
						$Prop["Checked By"].Value = ""
					}
					if($Prop["Date Checked"]){
						$Prop["Date Checked"].Value = ""
					}
					if($Prop["Engr Approved By"]){
						$Prop["Engr Approved By"].Value = ""
					}
					if($Prop["Engr Date Approved"]){
						$Prop["Engr Date Approved"].Value = ""
					}
					if($Prop["Change Descr"]){
						$Prop["Change Descr"].Value = ""
					}
				}
			}

			"AutoCADWindow"
			{
				#AutoCAD Mechanical Block Attribute Template
				if($Prop["GEN-TITLE-DWG"].Value)
				{		
					if($Prop["GEN-TITLE-CHKM"]) {
						$Prop["GEN-TITLE-CHKM"].Value = ""
					}					
					if($Prop["GEN-TITLE-CHKD"]) {
						$Prop["GEN-TITLE-CHKD"].Value = ""
					}
					if($Prop["GEN-TITLE-ISSM"]) {
						$Prop["GEN-TITLE-ISSM"].Value = ""
					}
					if($Prop["GEN-TITLE-ISSD"]) {
						$Prop["GEN-TITLE-ISSD"].Value = ""
					}
					if($Prop["Change Descr"]){
						$Prop["Change Descr"].Value = ""
					}
				}
				else #AutoCAD Template
				{
					if($Prop["Checked By"]) {
						$Prop["Checked By"].Value = ""
					}
					if($Prop["Date Checked"]){
						$Prop["Date Checked"].Value = ""
					}
					if($Prop["Engr Approved By"]){
						$Prop["Engr Approved By"].Value = ""
					}
					if($Prop["Engr Date Approved"]){
						$Prop["Engr Date Approved"].Value = ""
					}
					if($Prop["Change Descr"]){
						$Prop["Change Descr"].Value = ""
					}
				}
			}#AutoCADWindow
		}#switch WindowName
}