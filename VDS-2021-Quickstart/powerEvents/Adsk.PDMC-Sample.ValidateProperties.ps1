#==============================================================================#
# (c) 2021 Autodesk, Markus Koechl                                               #
#                                                                              #
# THIS SCRIPT/CODE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER    #
# EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES  #
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.   #
#==============================================================================#

Register-VaultEvent -EventName UpdateFileStates_Pre -Action 'RegisterFiles'

Register-VaultEvent -EventName UpdateFileStates_Post -Action 'ResetRevisionData'

$script:targetCategory = @("Drawing AutoCAD", "Drawing Inventor")

function RegisterFiles($files)
{
    $DrawingFiles = @($files | Where-Object { $targetCategory -contains $_._CategoryName})
    $Global:RegisteredFiles = @{}
    foreach($file in $DrawingFiles) 
    {
        $oldLifecycleState = Get-VaultLifecycleState -LifecycleDefinition $file._LifeCycleDefinition -State $file._State
        $newLifecycleState = Get-VaultLifecycleState -LifecycleDefinition $file._NewLifeCycleDefinition -State $file._NewState
       # Show-Inspector -Highlight '$file'   
        if($oldLifecycleState.ReleasedState -eq $true -and $newLifecycleState.ReleasedState -eq $false -and $newLifecycleState.ObsoleteState -eq $false) 
        {
            $Global:RegisteredFiles.Add($file.MasterId, $file)
        }
        #Show-Inspector -Highlight "RegisteredFiles"
    }
    
}

function ResetRevisionData($files)
{
    $FileProps = @{}
    $FileProps.Add('Change Description', "")
    foreach($file in $files)
    {
        if($Global:RegisteredFiles.Keys -contains $file.MasterId)
        {
            $updatedFile = Update-VaultFile -File $file.'Full Path' -Properties $FileProps
            #$Global:RegisteredFiles.Remove($file.MasterId)
            #Show-Inspector -Highlight "updatedFile"
        }
    }
           
}



