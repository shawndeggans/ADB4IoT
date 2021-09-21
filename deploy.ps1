# Deployment script for the Databricks - this is general use deployment script

New-AzResourceGroup -Name 'scrgdbiotd01' -Location 'South Central US' -Tag @{Environment='dev'; Organization='ssd'; Dept='data engineering'; Project='mydevops'; 'Technical-Contact'='shawn.deggans'; 'Project-Owner'='shawn.deggans'}

$deploymentEnvironment = 'd' # d, q, t, p

$Parameters = @{
    TemplateFile = '.\main.bicep'
    TemplateParameterFile ='.\main.parameters.' + $deploymentEnvironment + '.json'
    ResourceGroupName = 'scrgdbiotd01'
    Name = 'scdeploymentdbiotd01'
}

New-AzResourceGroupDeployment @Parameters