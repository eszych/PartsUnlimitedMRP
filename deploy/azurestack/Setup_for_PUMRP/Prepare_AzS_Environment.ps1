Get-Module -ListAvailable | where-Object {$_.Name -like "Azure*"}

######################################################################
# Connect to the AzS Environment and Upload the Ubuntu 16.04 Image 

pushd C:\AzureStack-Tools-master\Connect
Import-Module .\AzureStack.Connect.psm1
Add-AzureRmEnvironment -Name "AzureStackAdmin" -ArmEndpoint "https://adminmanagement.local.azurestack.external"

$UserName='azurestack\cloudadmin'
$Password='Passw0rd'| ConvertTo-SecureString -Force -AsPlainText
$Credential= New-Object PSCredential($UserName,$Password)

$AzSAccount = Login-AzureRmAccount -EnvironmentName "AzureStackAdmin" -Credential $Credential

pushd C:\AzureStack-Tools-master\ComputeAdmin\
Import-Module .\AzureStack.ComputeAdmin.psm1

Add-AzsVMImage -Publisher "Canonical" -Offer "UbuntuServer" -Sku "16.04.3-LTS" -Version "1.0.0" -osType Linux -osDiskLocalPath 'D:\Ubuntu1604LTS.vhd' -CreateGalleryItem $false

######################################################################
# Create a Gallery Item for the Ubuntu 16.04 Image 

$azpkgfile = 'C:\Users\AzureStackAdmin\Documents\GIT\PartsUnlimitedMRP\deploy\azurestack\instances\ubuntu_server_1604_base\Canonical.UbuntuServer.1.0.0.azpkg'

$RG = New-AzureRmResourceGroup -Name tenantartifacts -Location local
$StorageAccount = New-AzureRmStorageAccount -Location local -ResourceGroupName $RG.ResourceGroupName -Name tenantartifacts -Type Standard_LRS

$GalleryContainer = New-AzureStorageContainer -Name gallery -Permission Blob -Context $StorageAccount.Context
$GalleryContainer | Set-AzureStorageBlobContent -File $azpkgfile
$GalleryItemURI = (Get-AzureStorageBlob -Context $StorageAccount.Context -Blob 'Canonical.UbuntuServer.1.0.0.azpkg' -Container 'gallery').ICloudBlob.uri.AbsoluteUri
Add-AzsGalleryItem -GalleryItemUri $GalleryItemURI -Verbose

######################################################################
# Create a Gallery Item for the Jenkins deployment

$azpkgfile = 'C:\Users\AzureStackAdmin\Documents\GIT\PartsUnlimitedMRP\deploy\azurestack\instances\jenkins_standalone\TheJenkinsProject.Jenkins.1.0.0.azpkg'
$GalleryContainer | Set-AzureStorageBlobContent -File $azpkgfile
$GalleryItemURI = (Get-AzureStorageBlob -Context $StorageAccount.Context -Blob 'TheJenkinsProject.Jenkins.1.0.0.azpkg' -Container 'gallery').ICloudBlob.uri.AbsoluteUri
Add-AzsGalleryItem -GalleryItemUri $GalleryItemURI -Verbose


######################################################################
# Deploy a Jenkins Image from a template 
#
# Set Deployment Variables
$RGName = "pumrp-jenkins"
$myLocation = "local"
$TemplateFile = 'C:\Users\AzureStackAdmin\Documents\GIT\PartsUnlimitedMRP\deploy\azurestack\instances\jenkins_standalone\TheJenkinsProject.Jenkins\DeploymentTemplates\JenkinsDeploy.json'

#Set the parameter values for the Resource Manager template
$TemplateParameterObject = @{
    "JENKINSADMINUSERNAME"="jenkinsadmin"
    "JENKINSADMINPASSWORD"='Pa$$w0rd1234'
    "JENKINSDNSNAMEFORPUBLICIP"=$RGName
    }

# Create Resource Group for Template Deployment
New-AzureRmResourceGroup -Name $RGName -Location $myLocation

# Deploy the Jenkins Template
New-AzureRmResourceGroupDeployment -Name $RGName -ResourceGroupName $RGName -TemplateFile $TemplateFile -TemplateParameterObject $TemplateParameterObject -Verbose
