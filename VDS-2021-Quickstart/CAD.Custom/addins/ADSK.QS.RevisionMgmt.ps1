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
							$Prop["Checked By"].CustomValidation = { ValidateRevisionField $Prop["Checked By"] }
						}
					}
					if($mFileState -eq $UIString["Adsk.QS.RevTab_03"]) #'For Review'
					{
						if($Prop["Checked By"]) {
							$Prop["Checked By"].CustomValidation = { ValidateRevisionField $Prop["Checked By"] }
						}
						if($Prop["Date Checked"]){
							$Prop["Date Checked"].CustomValidation = { ValidateRevisionField $Prop["Date Checked"] }
						}
						if($Prop["Engr Approved By"]){
							$Prop["Engr Approved By"].CustomValidation = { ValidateRevisionField $Prop["Engr Approved By"] }
						}
						if($Prop["Engr Date Approved"]){
							$Prop["Engr Date Approved"].CustomValidation = { ValidateRevisionField $Prop["Engr Date Approved"]}
						}
						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { ValidateRevisionField $Prop["Change Descr"]}
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
							#workaround Date Issue of 2021.1 Update that does not allow blank Date values
							if($Prop["GEN-TITLE-CHKD"].Value -eq "")
							{
								$Prop["GEN-TITLE-CHKD"].Value = Get-Date -Year "2021" -Month "01" -Day "01"
							}
						}

						if($Prop["GEN-TITLE-ISSM"]) {
							$Prop["GEN-TITLE-ISSM"].CustomValidation = { $true }
						}

						if($Prop["GEN-TITLE-ISSD"]) {
							$Prop["GEN-TITLE-ISSD"].CustomValidation = { $true }

							#workaround Date Issue of 2021.1 Update that does not allow blank Date values
							if($Prop["GEN-TITLE-ISSD"].Value -eq "")
							{
								$Prop["GEN-TITLE-ISSD"].Value = Get-Date -Year "2021" -Month "01" -Day "01"
							}
						}

						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { $true }
						}
					}

					if($mFileState -eq $UIString["Adsk.QS.RevTab_05"] -or $mFileState -eq $UIString["Adsk.QS.RevTab_04"]) # Work in Progress or 'Quick-Change'
					{
						if($Prop["GEN-TITLE-CHKM"]) {
							$Prop["GEN-TITLE-CHKM"].CustomValidation = { ValidateRevisionField $Prop["GEN-TITLE-CHKM"] }
						}

						if($Prop["GEN-TITLE-CHKD"]) {
							$Prop["GEN-TITLE-CHKD"].CustomValidation = { $true }

							#workaround Date Issue of 2021.1 Update that does not allow blank Date values
							if($Prop["GEN-TITLE-CHKD"].Value -eq "")
							{
								$Prop["GEN-TITLE-CHKD"].Value = Get-Date -Year "2021" -Month "01" -Day "01"
							}
						}

						if($Prop["GEN-TITLE-ISSM"]) {
							$Prop["GEN-TITLE-ISSM"].CustomValidation = { $true }
						}

						if($Prop["GEN-TITLE-ISSD"]) {
							$Prop["GEN-TITLE-ISSD"].CustomValidation = { $true }

							#workaround Date Issue of 2021.1 Update that does not allow blank Date values
							if($Prop["GEN-TITLE-ISSD"].Value -eq "")
							{
								$Prop["GEN-TITLE-ISSD"].Value = Get-Date -Year "2021" -Month "01" -Day "01"
							}
						}
						
						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { $true }
						}
					}
					
					if($mFileState -eq $UIString["Adsk.QS.RevTab_03"]) #For Review
					{
						if($Prop["GEN-TITLE-CHKM"]) {
							$Prop["GEN-TITLE-CHKM"].CustomValidation = { ValidateRevisionField $Prop["GEN-TITLE-CHKM"] }
						}
						if($Prop["GEN-TITLE-CHKD"]) {
							$Prop["GEN-TITLE-CHKD"].CustomValidation = { ValidateRevisionField $Prop["GEN-TITLE-CHKD"] }
						}
						if($Prop["GEN-TITLE-ISSM"]) {
							$Prop["GEN-TITLE-ISSM"].CustomValidation = { ValidateRevisionField $Prop["GEN-TITLE-ISSM"] }
						}
						if($Prop["GEN-TITLE-ISSD"]) {
							$Prop["GEN-TITLE-ISSD"].CustomValidation = { ValidateRevisionField $Prop["GEN-TITLE-ISSD"] }
						}
						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { ValidateRevisionField $Prop["Change Descr"]} #revision table property in PDMC-Sample
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
						if($Prop["Checked Date"]) {
							$Prop["Checked Date"].CustomValidation = { $true }
							#workaround Date Issue of 2021.1 Update that does not allow blank Date values
							if($Prop["Checked Date"].Value -eq "")
							{
								$Prop["Checked Date"].Value = Get-Date -Year "2021" -Month "01" -Day "01"
							}
						}

						if($Prop["Eng Approved By"]) {
							$Prop["Eng Approved By"].CustomValidation = { $true }
						}

						if($Prop["Eng Approval Date"]) {
							$Prop["Eng Approval Date"].CustomValidation = { $true }

							#workaround Date Issue of 2021.1 Update that does not allow blank Date values
							if($Prop["Eng Approval Date"].Value -eq "")
							{
								$Prop["Eng Approval Date"].Value = Get-Date -Year "2021" -Month "01" -Day "01"
							}
						}

						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { $true }
						}
					}

					if($mFileState -eq $UIString["Adsk.QS.RevTab_05"] -or $mFileState -eq $UIString["Adsk.QS.RevTab_04"]) # Work in Progress or 'Quick-Change'
					{
						if($Prop["Checked By"]) {
							$Prop["Checked By"].CustomValidation = { ValidateRevisionField $Prop["Checked By"] }
						}

						if($Prop["Checked Date"]) {
							$Prop["Checked Date"].CustomValidation = { $true }

							#workaround Date Issue of 2021.1 Update that does not allow blank Date values
							if($Prop["Checked Date"].Value -eq "")
							{
								$Prop["Checked Date"].Value = Get-Date -Year "2021" -Month "01" -Day "01"
							}
						}

						if($Prop["Eng Approved By"]) {
							$Prop["Eng Approved By"].CustomValidation = { $true }
						}

						if($Prop["Eng Approval Date"]) {
							$Prop["Eng Approval Date"].CustomValidation = { $true }

							#workaround Date Issue of 2021.1 Update that does not allow blank Date values
							if($Prop["Eng Approval Date"].Value -eq "")
							{
								$Prop["Eng Approval Date"].Value = Get-Date -Year "2021" -Month "01" -Day "01"
							}
						}
						
						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { $true }
						}
					}
					
					if($mFileState -eq $UIString["Adsk.QS.RevTab_03"]) #For Review
					{
						if($Prop["Checked By"]) {
							$Prop["Checked By"].CustomValidation = { ValidateRevisionField $Prop["Checked By"] }
						}
						if($Prop["Checked Date"]) {
							$Prop["Checked Date"].CustomValidation = { ValidateRevisionField $Prop["Checked Date"] }
						}
						if($Prop["Eng Approved By"]) {
							$Prop["Eng Approved By"].CustomValidation = { ValidateRevisionField $Prop["Eng Approved By"] }
						}
						if($Prop["Eng Approval Date"]) {
							$Prop["Eng Approval Date"].CustomValidation = { ValidateRevisionField $Prop["Eng Approval Date"] }
						}
						if($Prop["Change Descr"]){
							$Prop["Change Descr"].CustomValidation = { ValidateRevisionField $Prop["Change Descr"]} #revision table property in PDMC-Sample
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

function ValidateRevisionField($mProp)
{
	$dsDiag.Trace(">>Validation runs for '$($mProp.Name)', $($mProp.Typ)")

	If ($Prop["_EditMode"].Value -eq $true)
	{		
		$dsDiag.Trace("...EditMode...")

		if ($mProp.Value -eq "" -OR $mProp.Value -eq $null)
		{
			$dsDiag.Trace("...no Value: returning false<<")
			$mProp.CustomValidationErrorMessage = "Empty value are not allowed for the current life cylce state!"
			return $false
		}
		else
		{
			#workaround VDS AutoCAD Date Issue (2021.1)
			$tempDateTime = Get-Date -Year "2021" -Month "01" -Day "01" -Hour "00" -Minute "00" -Second "00"
			if($mProp.Value -eq $tempDateTime.ToString()) 
			{ 
				$mProp.CustomValidationErrorMessage = "Date 2021-01-01 00:00:00 provided by VDS for AutoCAD is not allowed (VDS Acad date issue workaround)"
				return $false
			}

			$dsDiag.Trace("...has Value: returning true<<")
			return $true
		}
	}
	
}

function mGetState
{
	#we need the current file object
	$_wf = $vaultconnection.WorkingFoldersManager.GetWorkingFolder("$/").FullPath
	$_1 = $Prop["_FilePath"].Value.Replace($_wf, "$/")
	$_2 = $_1.Replace("\", "/")
	$mVaultFilePath = $_2 + "/" + $Prop["_FileName"].Value

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