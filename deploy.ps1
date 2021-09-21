# Deployment script for the SQL portion of the IDAP infrastructure
# Deployment expects a resource group with the appropriate name and tagging to be in place.

$deploymentEnvironment = 'd' # d, q, t, p

$Parameters = @{
    TemplateFile = '.\main.bicep'
    TemplateParameterFile ='.\main.parameters.' + $deploymentEnvironment + '.json'
    ResourceGroupName = 'scrgdbiotd01'
    Name = 'scdeploymentdbiotd01'
}

New-AzResourceGroupDeployment @Parameters