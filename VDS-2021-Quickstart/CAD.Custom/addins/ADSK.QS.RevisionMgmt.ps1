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
	if($Prop["_EditMode"].Value -eq $true)
	{
		switch($dsWindow.Name)
		{
			"InventorWindow"
			{
				if ((Get-Item $document.FullFileName).IsReadOnly)
				{
					return $false
				}
			}

			"AutoCADWindow"
			{
				if ((Get-Item $document.Name).IsReadOnly)
				{
					return $false
				}
			}
		}
	
		return $true
		
	} #EditMode
}

function InitializeRevisionValidation
{

	#set the display state of XAML controls
	if (@(".DWG",".IDW", ".dwg", ".idw") -contains $Prop["_FileExt"].Value)
	{
		$dsWindow.FindName("grdApproval").Visibility = "Visible"
	}
	else
	{
		$dsWindow.FindName("grdApproval").Visibility = "Collapsed"
	}

	if($Prop["Customer Approval Required"])
	{
		if($Prop["Customer Approval Required"].Value -eq "True")
		{
			$dsWindow.FindName("grdCustomerApproval").Visibility = "Visible"
		}
		else
		{
			$dsWindow.FindName("grdCustomerApproval").Visibility = "Collapsed"
		}
	}

	#if the file exists state and revision information exists
	$mFile = mGetVaultFile
	if($mFile)
	{
		$mFileState = $mFile.FileLfCyc.LfCycStateName
	}
	else 
	{ 
		$mFileState = $null
	}
										
	if($mFile -ne $null)
	{
		$mFileProperties = @{}
		$mFileProperties = mGetFilePropValues $mFile.Id
		$dsWindow.FindName("txtRevision").Text = $mFileProperties.Get_Item("Revision")
		$dsWindow.FindName("txtStatus").Text = $mFileProperties.Get_Item("State")
		$dsWindow.FindName("txtCreatedBy").Text = $mFileProperties.Get_Item("Created By")
		$dsWindow.FindName("LatestRev").IsChecked = $mFileProperties.Get_Item("Latest Released Revision")
		$dsWindow.FindName("txtLfcDef").Text = $mFileProperties.Get_Item("Lifecycle Definition")
		$dsWindow.FindName("txtCreateDate").Text = $mFileProperties.Get_Item("Date Version Created").ToString("yyyy-MM-dd HH:mm")
	}

	switch($dsWindow.Name)
	{
		"InventorWindow"
		{
			$dsDiag.Trace("ExtendedRevision Validation for Inventor starts...")
			if (@(".DWG",".IDW", ".dwg", ".idw") -contains $Prop["_FileExt"].Value)
			{

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
		}#AutoCADWindow

	}#switch WindowName

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


function mGetVaultFile
{
	if($Prop["_CreateMode"].Value -eq $true)
	{
		return $null
	}
	#we need the current file object
	$_wf = $vaultconnection.WorkingFoldersManager.GetWorkingFolder("$/").FullPath
	$_1 = $Prop["_FilePath"].Value.Replace($_wf, "$/")
	$_2 = $_1.Replace("\", "/")
	$mVaultFilePath = $_2 + "/" + $Prop["_FileName"].Value

	$mFile = $vault.DocumentService.FindLatestFilesByPaths(@($mVaultFilePath))[0]	

	if($mFile.id -ne -1)
	{
		return $mFile
	}

	return $null

}

function mGetFilePropValues ([Int64] $mFileId)
{
	$mPropInsts = @()
	$mPropInsts += $vault.PropertyService.GetPropertiesByEntityIds("FILE", @($mFileId))
	
	# a PropInst is an Id-Value pair; we migrate it to a (Display-)Name-Value pair
	$mPropNameValueMap = @{}

	$mPropDefs = $vault.PropertyService.GetPropertyDefinitionsByEntityClassId("FILE")
	
	ForEach($mPropInst in $mPropInsts)
	{
		$mDispName =  ($mPropDefs | Where-Object { $_.Id -eq $mPropInst.PropDefId } ).DispName
		$mPropNameValueMap.Add($mDispName, $mPropInst.Val)
	}
	
	return $mPropNameValueMap
	
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
				
			}#AutoCADWindow

		}#switch WindowName
}