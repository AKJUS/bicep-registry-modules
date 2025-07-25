metadata name = 'CI CD Agents and Runners'
metadata description = 'This module deploys self-hosted agents and runners for Azure DevOps and GitHub on Azure Container Instances and/or Azure Container Apps.'

// ================ //
// Parameters       //
// ================ //

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Naming prefix to be used with naming the deployed resources.')
param namingPrefix string

@description('Required. The compute target for the private runners.')
param computeTypes computeTypesType[]

@description('Required. The self-hosted runner configuration. This can be either GitHub or Azure DevOps.')
param selfHostedConfig selfHostedRunnerType

@description('Required. The networking configuration.')
param networkingConfiguration networkType

@description('Optional. Whether to use private or public networking for the Azure Container Registry.')
param privateNetworking bool = true

@description('Optional. The availability zone to be used for the supported resources.')
param availabilityZone int = -1

@description('Optional. The Azure region to replicate the Log Analytics workspace to. If not specified, replication is disabled.')
param logAnalyticsReplicationRegion string = ''

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Name of the infrastructure resource group for the container apps environment.')
param infrastructureResourceGroupName string?

// ================ //
// Variables        //
// ================ //

var imagePaths = [
  {
    platform: 'azuredevops-container-app'
    imagePath: 'azure-devops-agent-aca'
  }
  {
    platform: 'github-container-app'
    imagePath: 'github-runner-aca'
  }
  {
    platform: 'azuredevops-container-instance'
    imagePath: 'azure-devops-agent-aci'
  }
  {
    platform: 'github-container-instance'
    imagePath: 'github-runner-aci'
  }
]

var githubURL = 'https://github.com/azure/avm-container-images-cicd-agents-and-runners#main'

var acaGitHubRules = (selfHostedConfig.selfHostedType == 'github')
  ? [
      {
        name: 'github-runner-scaling-rule'
        type: 'github-runner'
        metadata: {
          owner: selfHostedConfig.githubOrganization
          repos: selfHostedConfig.?runnerScope != 'repo' ? null : selfHostedConfig.?githubRepository
          targetWorkflowQueueLength: selfHostedConfig.?targetWorkflowQueueLength ?? '1'
          runnerScope: selfHostedConfig.?runnerScope ?? 'repo'
        }
        auth: [
          {
            secretRef: 'personal-access-token'
            triggerParameter: 'personalAccessToken'
          }
        ]
      }
    ]
  : []

var acaGitHubSecrets = (selfHostedConfig.selfHostedType == 'github')
  ? [
      {
        name: 'personal-access-token'
        value: any(selfHostedConfig.personalAccessToken)
      }
    ]
  : []

var acaGitHubEnvVariables = (selfHostedConfig.selfHostedType == 'github')
  ? union(
      selfHostedConfig.?runnerScope == 'repo'
        ? [
            {
              name: 'REPO_URL'
              value: gitHubRunnerURL
            }
          ]
        : [],
      [
        {
          name: 'RUNNER_NAME_PREFIX'
          value: selfHostedConfig.?runnerNamePrefix ?? 'gh-runner'
        }
        {
          name: 'RUNNER_SCOPE'
          value: selfHostedConfig.?runnerScope ?? 'repo'
        }
        {
          name: 'EPHEMERAL'
          value: selfHostedConfig.?ephemeral ?? 'true'
        }
        {
          name: 'ORG_NAME'
          value: selfHostedConfig.?gitHubOrganization
        }
        {
          name: 'RUNNER_GROUP'
          value: selfHostedConfig.?runnerGroup ?? ''
        }
        {
          name: 'ACCESS_TOKEN'
          secretRef: 'personal-access-token'
        }
      ]
    )
  : []

var acaAzureDevOpsEnvVariables = (selfHostedConfig.selfHostedType == 'azuredevops')
  ? [
      {
        name: 'AZP_POOL'
        value: selfHostedConfig.agentsPoolName
      }
      {
        name: 'AZP_AGENT_NAME_PREFIX'
        value: selfHostedConfig.?agentNamePrefix ?? 'aca'
      }
      {
        name: 'AZP_URL'
        secretRef: 'organization-url'
      }
      {
        name: 'AZP_TOKEN'
        secretRef: 'personal-access-token'
      }
    ]
  : []

var acaAzureDevOpsSecrets = (selfHostedConfig.selfHostedType == 'azuredevops')
  ? [
      {
        name: 'personal-access-token'
        value: selfHostedConfig.personalAccessToken
      }
      {
        name: 'organization-url'
        value: devOpsOrgURL
      }
    ]
  : []

var acaAzureDevOpsRules = (selfHostedConfig.selfHostedType == 'azuredevops')
  ? [
      {
        name: 'azure-pipelines-scaling-rule'
        type: 'azure-pipelines'
        metadata: {
          poolName: selfHostedConfig.agentsPoolName
          targetPipelinesQueueLength: selfHostedConfig.?targetPipelinesQueueLength ?? '1'
        }
        auth: [
          {
            secretRef: 'personal-access-token'
            triggerParameter: 'personalAccessToken'
          }
          {
            secretRef: 'organization-url'
            triggerParameter: 'organizationURL'
          }
        ]
      }
    ]
  : []

var gitHubRunnerURL = 'https://github.com/${selfHostedConfig.?gitHubOrganization}/${selfHostedConfig.?gitHubRepository}'

var devOpsOrgURL = 'https://dev.azure.com/${selfHostedConfig.?devOpsOrganization}'

// ================ //
// Resources        //
// ================ //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.devops-cicdagentsandrunners.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.12.0' = {
  name: 'logAnalyticsWorkspace-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'law-${namingPrefix}-${uniqueString(resourceGroup().id)}'
    location: location
    replication: !empty(logAnalyticsReplicationRegion)
      ? {
          enabled: true
          location: logAnalyticsReplicationRegion
        }
      : null
    enableTelemetry: enableTelemetry
  }
}

module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  name: 'userAssignedIdentity-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'msi-${namingPrefix}-${uniqueString(resourceGroup().id)}'
    enableTelemetry: enableTelemetry
  }
}

module acrPrivateDNSZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (privateNetworking && empty(networkingConfiguration.?containerRegistryPrivateDnsZoneResourceId ?? '')) {
  name: 'acrdnszone${namingPrefix}${uniqueString(resourceGroup().id)}'
  params: {
    name: 'privatelink.azurecr.io'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: networkingConfiguration.networkType == 'createNew'
          ? newVnet.outputs.resourceId
          : networkingConfiguration.virtualNetworkResourceId
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

module acr 'br/public:avm/res/container-registry/registry:0.9.1' = {
  name: 'acr${namingPrefix}${uniqueString(resourceGroup().id)}'
  params: {
    name: 'acr${namingPrefix}${uniqueString(resourceGroup().id)}'
    acrSku: privateNetworking ? 'Premium' : 'Standard'
    acrAdminUserEnabled: false
    enableTelemetry: enableTelemetry
    // Assigning AcrPull and AcrPush roles to the user assigned identity
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
      }
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: '8311e382-0749-4cb8-b61a-304f252e45ec'
      }
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: '3bc748fc-213d-45c1-8d91-9da5725539b9'
      }
    ]
    networkRuleBypassOptions: privateNetworking ? 'AzureServices' : 'None'
    privateEndpoints: privateNetworking
      ? [
          {
            subnetResourceId: networkingConfiguration.networkType == 'createNew'
              ? filter(
                  newVnet.outputs.subnetResourceIds,
                  subnetId =>
                    contains(
                      subnetId,
                      networkingConfiguration.?containerRegistryPrivateEndpointSubnetName ?? 'acr-subnet'
                    )
                )[0]
              : networkingConfiguration.networkType == 'useExisting'
                  ? '${networkingConfiguration.virtualNetworkResourceId}/subnets/${networkingConfiguration.containerRegistryPrivateEndpointSubnetName}'
                  : null
            privateDnsZoneResourceIds: !empty(networkingConfiguration.?containerRegistryPrivateDnsZoneResourceId ?? '')
              ? [
                  networkingConfiguration.?containerRegistryPrivateDnsZoneResourceId ?? ''
                ]
              : [
                  empty(networkingConfiguration.?containerRegistryPrivateDnsZoneResourceId ?? '')
                    ? acrPrivateDNSZone.outputs.resourceId
                    : ''
                ]
            privateDnsZoneGroupName: 'acrPrivateDNSZoneGroup'
          }
        ]
      : null
  }
}
module newVnet 'br/public:avm/res/network/virtual-network:0.7.0' = if (networkingConfiguration.networkType == 'createNew') {
  name: 'vnet-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'vnet-${namingPrefix}-${uniqueString(resourceGroup().id)}'
    location: location
    enableTelemetry: enableTelemetry
    addressPrefixes: [
      networkingConfiguration.addressSpace
    ]
    subnets: union(
      privateNetworking
        ? [
            {
              name: networkingConfiguration.?containerRegistryPrivateEndpointSubnetName ?? 'acr-subnet'
              addressPrefix: networkingConfiguration.?containerRegistrySubnetPrefix ?? '10.0.0.32/29'
            }
            {
              name: networkingConfiguration.?acrDeploymentScriptSubnetName ?? 'acr-deployment-script-subnet'
              addressPrefix: networkingConfiguration.?acrDeploymentScriptSubnetPrefix ?? '10.0.3.0/24'
              delegation: 'Microsoft.ContainerInstance/containerGroups'
            }
          ]
        : [],
      (privateNetworking && selfHostedConfig.selfHostedType == 'azuredevops') || (contains(
          computeTypes,
          'azure-container-instance'
        ))
        ? [
            {
              name: networkingConfiguration.?containerInstanceSubnetName ?? 'aci-subnet'
              addressPrefix: networkingConfiguration.?containerInstanceSubnetAddressPrefix ?? '10.0.2.0/24'
              natGatewayResourceId: empty(networkingConfiguration.?natGatewayResourceId ?? '') && privateNetworking
                ? natGateway.outputs.resourceId
                : networkingConfiguration.?natGatewayResourceId ?? ''
              delegation: 'Microsoft.ContainerInstance/containerGroups'
            }
          ]
        : [],
      contains(computeTypes, 'azure-container-app')
        ? [
            {
              name: networkingConfiguration.?containerAppSubnetName ?? 'app-subnet'
              addressPrefix: networkingConfiguration.?containerAppSubnetAddressPrefix ?? '10.0.1.0/24'
              natGatewayResourceId: empty(networkingConfiguration.?natGatewayResourceId ?? '') && privateNetworking
                ? natGateway.outputs.resourceId
                : networkingConfiguration.?natGatewayResourceId ?? ''
              delegation: 'Microsoft.App/environments'
            }
          ]
        : [],
      contains(computeTypes, 'azure-container-app') && privateNetworking && selfHostedConfig.selfHostedType == 'azuredevops'
        ? [
            {
              name: networkingConfiguration.?containerAppDeploymentScriptSubnetName ?? 'app-deployment-script-subnet'
              addressPrefix: networkingConfiguration.?containerAppDeploymentScriptSubnetPrefix ?? '10.0.3.0/29'
            }
          ]
        : [],
      []
    )
  }
}
module appEnvironment 'br/public:avm/res/app/managed-environment:0.11.2' = if (contains(
  computeTypes,
  'azure-container-app'
)) {
  name: 'appEnv-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'appEnv${namingPrefix}${uniqueString(resourceGroup().id)}'
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
        sharedKey: logAnalyticsWorkspace.outputs.primarySharedKey
      }
    }
    location: location
    enableTelemetry: enableTelemetry
    infrastructureResourceGroupName: infrastructureResourceGroupName
    infrastructureSubnetResourceId: networkingConfiguration.networkType == 'createNew'
      ? filter(
          newVnet.outputs.subnetResourceIds,
          subnetId => contains(subnetId, networkingConfiguration.?containerAppSubnetName ?? 'app-subnet')
        )[0]
      : networkingConfiguration.networkType == 'useExisting'
          ? '${networkingConfiguration.virtualNetworkResourceId}/subnets/${networkingConfiguration.computeNetworking.containerAppSubnetName}'
          : null
    zoneRedundant: true
    internal: privateNetworking ? true : false
    workloadProfiles: [
      {
        name: 'consumption'
        workloadProfileType: 'consumption'
      }
    ]
  }
}

module natGatewayPublicIp 'br/public:avm/res/network/public-ip-address:0.9.0' = if (empty(networkingConfiguration.?natGatewayResourceId ?? '') && empty(networkingConfiguration.?natGatewayPublicIpAddressResourceId ?? '') && networkingConfiguration.networkType == 'createNew' && privateNetworking) {
  name: 'natGatewayPublicIp-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'natGatewayPublicIp-${uniqueString(resourceGroup().id)}'
    skuName: 'Standard'
    enableTelemetry: enableTelemetry
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

module natGateway 'br/public:avm/res/network/nat-gateway:1.4.0' = if (privateNetworking && empty(networkingConfiguration.?natGatewayResourceId ?? '') && networkingConfiguration.networkType == 'createNew') {
  name: 'natGateway-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'natGateway-${namingPrefix}-${uniqueString(resourceGroup().id)}'
    availabilityZone: availabilityZone
    location: location
    enableTelemetry: enableTelemetry
    publicIpResourceIds: [
      networkingConfiguration.?natGatewayPublicIpAddressResourceId ?? natGatewayPublicIp.outputs.resourceId
    ]
  }
}

resource buildImages 'Microsoft.ContainerRegistry/registries/tasks@2025-03-01-preview' = [
  for (image, i) in computeTypes: {
    name: '${acr.name}/buildImage-${image}-${selfHostedConfig.selfHostedType}-${i}'
    location: location
    identity: {
      type: 'SystemAssigned'
    }
    dependsOn: [
      acrNetworkByPassTasks
    ]
    properties: {
      platform: {
        os: 'Linux'
      }
      step: {
        dockerFilePath: 'dockerfile'
        type: 'Docker'
        contextPath: contains(computeTypes, 'azure-container-app')
          ? '${githubURL}:${filter(imagePaths, imagePath => imagePath.platform == '${selfHostedConfig.selfHostedType}-container-app')[0].imagePath}'
          : contains(computeTypes, 'azure-container-instance')
              ? '${githubURL}:${filter(imagePaths, imagePath => imagePath.platform == '${selfHostedConfig.selfHostedType}-container-instance')[0].imagePath}'
              : null
        imageNames: [
          '${acr.outputs.loginServer}/${selfHostedConfig.selfHostedType}-${image}:latest'
        ]
      }
      credentials: privateNetworking
        ? {
            customRegistries: {
              '${acr.outputs.loginServer}': {
                identity: '[system]'
              }
            }
          }
        : null
    }
  }
]

module buildImagesRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = [
  for (image, i) in computeTypes: {
    name: 'buildImagesRoleAssignment-${uniqueString(resourceGroup().id)}-${i}'
    params: {
      principalId: buildImages[i].identity.principalId
      resourceId: acr.outputs.resourceId
      roleDefinitionId: '8311e382-0749-4cb8-b61a-304f252e45ec'
      principalType: 'ServicePrincipal'
      enableTelemetry: enableTelemetry
    }
  }
]

resource taskRun 'Microsoft.ContainerRegistry/registries/taskRuns@2025-03-01-preview' = [
  for (image, i) in computeTypes: {
    name: '${acr.name}/taskrun-${image}-${selfHostedConfig.selfHostedType}-${i}'
    location: location
    dependsOn: [
      buildImagesRoleAssignment
    ]
    properties: {
      runRequest: {
        taskId: buildImages[i].id
        type: 'TaskRunRequest'
      }
    }
  }
]

module aciJob 'br/public:avm/res/container-instance/container-group:0.6.0' = [
  for i in range(0, int(selfHostedConfig.?azureContainerInstanceTarget.?numberOfInstances ?? 1)): if (contains(
    computeTypes,
    'azure-container-instance'
  )) {
    name: '${namingPrefix}aciJob-${i}'
    dependsOn: [
      taskRun
    ]
    params: {
      name: '${namingPrefix}-${uniqueString(resourceGroup().id)}-instance-${i}'
      managedIdentities: {
        userAssignedResourceIds: [
          userAssignedIdentity.outputs.resourceId
        ]
      }
      availabilityZone: availabilityZone
      enableTelemetry: enableTelemetry
      imageRegistryCredentials: [
        {
          identity: userAssignedIdentity.outputs.resourceId
          server: acr.outputs.loginServer
        }
      ]
      subnets: privateNetworking
        ? [
            {
              subnetResourceId: networkingConfiguration.networkType == 'createNew'
                ? filter(
                    newVnet.outputs.subnetResourceIds,
                    subnetId => contains(subnetId, networkingConfiguration.?containerInstanceSubnetName ?? 'aci-subnet')
                  )[0]
                : '${networkingConfiguration.virtualNetworkResourceId}/subnets/${networkingConfiguration.computeNetworking.containerInstanceSubnetName}'
            }
          ]
        : null
      ipAddress: {
        type: privateNetworking ? 'Private' : 'Public'
        ports: [
          {
            port: 80
            protocol: 'TCP'
          }
        ]
      }
      sku: 'Standard'
      containers: [
        {
          name: selfHostedConfig.selfHostedType == 'github'
            ? 'private-runner-github-aci-${i}'
            : selfHostedConfig.selfHostedType == 'azuredevops'
                ? 'private-runner-devops-aci-${i}'
                : 'private-runner-aci-${i}'
          properties: {
            image: '${acr.outputs.loginServer}/${selfHostedConfig.selfHostedType}-azure-container-instance:latest'
            ports: [
              {
                port: 80
                protocol: 'TCP'
              }
            ]
            resources: {
              requests: {
                cpu: selfHostedConfig.?cpu ?? 1
                memoryInGB: selfHostedConfig.?memoryInGB ?? '2'
              }
            }
            environmentVariables: selfHostedConfig.selfHostedType == 'github'
              ? [
                  {
                    name: 'GH_RUNNER_NAME'
                    value: any(selfHostedConfig.?runnerName ?? 'runner-${i}')
                  }
                  {
                    name: 'GH_RUNNER_URL'
                    value: gitHubRunnerURL
                  }
                  {
                    name: 'GH_RUNNER_GROUP'
                    value: selfHostedConfig.?runnerGroup != null ? '${selfHostedConfig.?runnerGroup}' : ''
                  }
                  {
                    name: 'GH_RUNNER_TOKEN'
                    secureValue: any(selfHostedConfig.personalAccessToken)
                  }
                ]
              : [
                  {
                    name: 'AZP_URL'
                    value: devOpsOrgURL
                  }
                  {
                    name: 'AZP_POOL'
                    value: selfHostedConfig.agentsPoolName
                  }
                  {
                    name: 'AZP_AGENT_NAME'
                    value: any(selfHostedConfig.?agentName ?? 'agent-${i}')
                  }
                  {
                    name: 'AZP_TOKEN'
                    secureValue: any(selfHostedConfig.personalAccessToken)
                  }
                ]
          }
        }
      ]
    }
  }
]

module acaJob 'br/public:avm/res/app/job:0.6.0' = if (contains(computeTypes, 'azure-container-app')) {
  name: '${namingPrefix}acaJob'
  dependsOn: [
    taskRun
    runPlaceHolderAgent
  ]
  params: {
    name: '${namingPrefix}-${uniqueString(resourceGroup().id)}-acajob'
    location: location
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
    enableTelemetry: enableTelemetry
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
        name: guid(userAssignedIdentity.outputs.principalId, 'Contributor', resourceGroup().id)
      }
    ]
    triggerType: 'Event'
    replicaRetryLimit: 3
    replicaTimeout: 1800
    eventTriggerConfig: {
      parallelism: 1
      replicaCompletionCount: 1
      scale: {
        maxExecutions: 100
        minExecutions: 0
        pollingInterval: 30
        rules: selfHostedConfig.selfHostedType == 'github' ? acaGitHubRules : acaAzureDevOpsRules
      }
    }
    registries: [
      {
        server: acr.outputs.loginServer
        identity: userAssignedIdentity.outputs.resourceId
      }
    ]
    secrets: selfHostedConfig.selfHostedType == 'github' ? acaGitHubSecrets : acaAzureDevOpsSecrets
    containers: [
      {
        image: '${acr.outputs.loginServer}/${selfHostedConfig.selfHostedType}-azure-container-app:latest'
        name: 'private-runner-${selfHostedConfig.selfHostedType}-aca'
        resources: selfHostedConfig.?azureContainerAppTarget.?resources ?? {
          cpu: '1'
          memory: '2Gi'
        }
        env: selfHostedConfig.selfHostedType == 'github' ? acaGitHubEnvVariables : acaAzureDevOpsEnvVariables
      }
    ]
    environmentResourceId: appEnvironment.outputs.resourceId
    workloadProfileName: 'consumption'
  }
}

module acaPlaceholderJob 'br/public:avm/res/app/job:0.6.0' = if (contains(computeTypes, 'azure-container-app') && selfHostedConfig.selfHostedType == 'azuredevops') {
  name: 'acaDevOpsPlaceholderJob'
  dependsOn: [
    taskRun
  ]
  params: {
    name: '${namingPrefix}-${uniqueString(resourceGroup().id)}-placeholder'
    location: location
    enableTelemetry: enableTelemetry
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
    ]
    triggerType: 'Manual'
    replicaRetryLimit: 0
    replicaTimeout: 300
    manualTriggerConfig: {
      parallelism: 1
      replicaCompletionCount: 1
    }
    registries: [
      {
        server: acr.outputs.loginServer
        identity: userAssignedIdentity.outputs.resourceId
      }
    ]
    secrets: acaAzureDevOpsSecrets
    containers: [
      {
        image: '${acr.outputs.loginServer}/${selfHostedConfig.selfHostedType}-azure-container-app:latest'
        name: 'private-runner-devops-aca'
        resources: {
          cpu: '1'
          memory: '2Gi'
        }
        env: [
          {
            name: 'AZP_POOL'
            value: selfHostedConfig.agentsPoolName
          }
          {
            name: 'AZP_AGENT_NAME'
            value: selfHostedConfig.?placeHolderAgentName ?? 'placeHolderAgent'
          }
          {
            name: 'AZP_PLACEHOLDER'
            value: '1'
          }
          {
            name: 'AZP_URL'
            secretRef: 'organization-url'
          }
          {
            name: 'AZP_TOKEN'
            secretRef: 'personal-access-token'
          }
        ]
      }
    ]
    environmentResourceId: appEnvironment.outputs.resourceId
    workloadProfileName: 'consumption'
  }
}
module deploymentScriptPrivateDNSZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (privateNetworking && empty(networkingConfiguration.?deploymentScriptPrivateDnsZoneResourceId ?? '')) {
  name: 'stgdsdnszone${namingPrefix}${uniqueString(resourceGroup().id)}'
  params: {
    name: 'privatelink.file.${environment().suffixes.storage}'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: networkingConfiguration.networkType == 'useExisting'
          ? networkingConfiguration.virtualNetworkResourceId
          : newVnet.outputs.resourceId
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

module deploymentScriptStg 'br/public:avm/res/storage/storage-account:0.25.0' = if (contains(
  computeTypes,
  'azure-container-app'
) && selfHostedConfig.selfHostedType == 'azuredevops' && privateNetworking) {
  name: 'placeholderAgentDeploymentScript-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'stgds${uniqueString(resourceGroup().id, selfHostedConfig.?placeHolderAgentName ?? 'placeHolderAgent',location,selfHostedConfig.agentsPoolName)}'
    location: location
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    publicNetworkAccess: 'Disabled'
    //Assigning Storage Blob Data Contributor role to the user assigned identity
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: '69566ab7-960f-475b-8e7c-b3118f30c6bd'
        principalType: 'ServicePrincipal'
      }
    ]
    enableTelemetry: enableTelemetry
    privateEndpoints: [
      {
        service: 'file'
        subnetResourceId: networkingConfiguration.networkType == 'useExisting'
          ? '${networkingConfiguration.virtualNetworkResourceId}/subnets/${networkingConfiguration.computeNetworking.containerAppDeploymentScriptSubnetName}'
          : filter(
              newVnet.outputs.subnetResourceIds,
              subnetId =>
                contains(
                  subnetId,
                  networkingConfiguration.?containerAppDeploymentScriptSubnetName ?? 'app-deployment-script-subnet'
                )
            )[0]
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: networkingConfiguration.?deploymentScriptPrivateDnsZoneResourceId ?? deploymentScriptPrivateDNSZone.outputs.resourceId
              name: 'stgPrivateDNSZoneGroup'
            }
          ]
        }
      }
    ]
  }
}

module deploymentScriptAcrStg 'br/public:avm/res/storage/storage-account:0.25.0' = if (privateNetworking) {
  name: 'deploymentScriptAcrStg-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'stgacr${uniqueString(resourceGroup().id, acr.outputs.name,location)}'
    location: location
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    publicNetworkAccess: 'Disabled'
    //Assigning Storage Blob Data Contributor role to the user assigned identity
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: '69566ab7-960f-475b-8e7c-b3118f30c6bd'
        principalType: 'ServicePrincipal'
      }
    ]
    enableTelemetry: enableTelemetry
    privateEndpoints: [
      {
        service: 'file'
        subnetResourceId: networkingConfiguration.networkType == 'useExisting'
          ? '${networkingConfiguration.virtualNetworkResourceId}/subnets/${networkingConfiguration.?containerRegistryPrivateEndpointSubnetName}'
          : filter(
              newVnet.outputs.subnetResourceIds,
              subnetId =>
                contains(subnetId, networkingConfiguration.?containerRegistryPrivateEndpointSubnetName ?? 'acr-subnet')
            )[0]
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: !empty(networkingConfiguration.?deploymentScriptPrivateDnsZoneResourceId ?? '')
                ? networkingConfiguration.?deploymentScriptPrivateDnsZoneResourceId ?? ''
                : deploymentScriptPrivateDNSZone.outputs.resourceId
            }
          ]
        }
      }
    ]
  }
}

module runPlaceHolderAgent 'br/public:avm/res/resources/deployment-script:0.5.1' = if (contains(
  computeTypes,
  'azure-container-app'
) && selfHostedConfig.selfHostedType == 'azuredevops') {
  name: 'runPlaceHolderAgent-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'runPlaceHolderAgent-${uniqueString(resourceGroup().id)}'
    kind: 'AzurePowerShell'
    azPowerShellVersion: '12.1'
    cleanupPreference: 'Always'
    retentionInterval: 'P1D'
    location: location
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
    enableTelemetry: enableTelemetry
    storageAccountResourceId: privateNetworking ? deploymentScriptStg.outputs.resourceId : null
    subnetResourceIds: privateNetworking && networkingConfiguration.networkType == 'createNew'
      ? [
          filter(
            newVnet.outputs.subnetResourceIds,
            subnetId => contains(subnetId, networkingConfiguration.?containerInstanceSubnetName ?? 'aci-subnet')
          )[0]
        ]
      : privateNetworking && networkingConfiguration.networkType == 'useExisting'
          ? [
              '${networkingConfiguration.virtualNetworkResourceId}/subnets/${networkingConfiguration.computeNetworking.?containerInstanceSubnetName}'
            ]
          : null
    arguments: '-resourceGroup ${resourceGroup().name} -jobName ${acaPlaceholderJob.outputs.name} -subscriptionId ${subscription().subscriptionId}'
    scriptContent: loadTextContent('./scripts/startAzureDevOpsContainerJob.ps1')
  }
}

module acrNetworkByPassTasks 'br/public:avm/res/resources/deployment-script:0.5.1' = {
  params: {
    name: 'acrNetworkByPassTasks-${uniqueString(resourceGroup().id)}'
    kind: 'AzureCLI'
    azCliVersion: '2.72.0'
    cleanupPreference: 'Always'
    retentionInterval: 'P1D'
    location: location
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
    enableTelemetry: enableTelemetry
    storageAccountResourceId: privateNetworking ? deploymentScriptAcrStg.outputs.resourceId : null
    subnetResourceIds: (privateNetworking && networkingConfiguration.networkType == 'createNew')
      ? [
          filter(
            newVnet.outputs.subnetResourceIds,
            subnetId =>
              contains(
                subnetId,
                networkingConfiguration.?acrDeploymentScriptSubnetName ?? 'acr-deployment-script-subnet'
              )
          )[0]
        ]
      : (privateNetworking && networkingConfiguration.networkType == 'useExisting')
          ? [
              '${networkingConfiguration.virtualNetworkResourceId}/subnets/${networkingConfiguration.acrDeploymentScriptSubnetName}'
            ]
          : null
    scriptContent: 'az resource update --namespace Microsoft.ContainerRegistry --resource-type registries --name ${acr.outputs.name} --resource-group ${resourceGroup().name} --api-version 2025-05-01-preview --set properties.networkRuleBypassAllowedForTasks=true'
  }
}

// ================ //
// Outputs          //
// ================ //

@description('The name of the resource group the module was deployed to.')
output resourceGroupName string = resourceGroup().name

@description('The location the module was deployed to.')
output location string = location

// ================ //
// Definitions      //
// ================ //

@export()
type newNetworkType = {
  @description('Required. The network type. This can be either createNew or useExisting.')
  networkType: 'createNew'

  @description('Required. The virtual network name of the created virtual network.')
  virtualNetworkName: string

  @description('Required. The address space of the created virtual network.')
  addressSpace: string

  @description('Optional. The existing NAT Gateway resource Id. This should be provided if an existing NAT gateway is available to be used. If this parameter is not provided, a new NAT gateway will be created.')
  natGatewayResourceId: string?

  @description('Optional. The existing public IP address to associate with the NAT gateway. This should be provided if an existing public Ip address is available to be used. If this parameter is not provided, a new Public Ip address will be created.')
  natGatewayPublicIpAddressResourceId: string?

  @description('Optional. The container instance subnet name in the created virtual network. If not provided, a default name will be used.')
  containerInstanceSubnetName: string?

  @description('Optional. The container instance subnet CIDR in the created virtual network. If not provided, a default subnet prefix will be used.')
  containerInstanceSubnetAddressPrefix: string?

  @description('Optional. The container app subnet name in the created virtual network. If not provided, a default name will be used.')
  containerAppSubnetName: string?

  @description('Optional. The container app subnet CIDR in the created virtual network. If not provided, a default subnet prefix will be used.')
  containerAppSubnetAddressPrefix: string?

  @description('Optional. The container instance subnet address prefix in the created virtual network. If not provided, a default subnet prefix will be used.')
  containerInstancesubnetPrefix: string?

  @description('Optional. The container registry subnet address prefix in the created virtual network. If not provided, a default subnet prefix will be used.')
  containerRegistrySubnetPrefix: string?

  @description('Optional. The container registry private DNS zone Id. If not provided, a new private DNS zone will be created.')
  containerRegistryPrivateDnsZoneResourceId: string?

  @description('Optional. The subnet name for the container registry private endpoint. If not provided, a default name will be used.')
  containerRegistryPrivateEndpointSubnetName: string?

  @description('Optional. The subnet name for the container app deployment script. Only required if private networking is used. If not provided, a default name will be used.')
  containerAppDeploymentScriptSubnetName: string?

  @description('Optional. The subnet name for the ACR deployment script. Only required if private networking is used. If not provided, a default name will be used.')
  acrDeploymentScriptSubnetName: string?

  @description('Optional. The subnet address prefix for the container app deployment script which is used to start the placeholder Azure DevOps agent. Only required if private networking is used. If not provided, a default subnet prefix will be used.')
  containerAppDeploymentScriptSubnetPrefix: string?

  @description('Optional. The subnet address prefix for the acr deployment script which is used to start the placeholder Azure DevOps agent. Only required if private networking is used. If not provided, a default subnet prefix will be used.')
  acrDeploymentScriptSubnetPrefix: string?

  @description('Optional. The deployment script private DNS zone Id. If not provided, a new private DNS zone will be created. Only required if private networking is used.')
  deploymentScriptPrivateDnsZoneResourceId: string?
}

@export()
type existingNetworkType = {
  @description('Required. The network type. This can be either createNew or useExisting.')
  networkType: 'useExisting'

  @description('Required. The existing virtual network resource Id.')
  virtualNetworkResourceId: string

  @description('Required. The subnet name for the container registry private endpoint.')
  containerRegistryPrivateEndpointSubnetName: string

  @description('Optional. The container registry private DNS zone Id. If not provided, a new private DNS zone will be created.')
  containerRegistryPrivateDnsZoneResourceId: string?

  @description('Optional. The existing NAT Gateway resource Id. This should be provided if an existing NAT gateway is available to be used. If this parameter is not provided, a new NAT gateway will be created.')
  natGatewayResourceId: string?

  @description('Optional. The existing public IP address to associate with the NAT gateway. This should be provided if an existing public Ip address is available to be used. If this parameter is not provided, a new Public Ip address will be created.')
  natGatewayPublicIpAddressResourceId: string?

  @description('Required. The subnet name for the ACR deployment script. Only required if private networking is used. If not provided, a default name will be used.')
  acrDeploymentScriptSubnetName: string

  @description('Optional. The deployment script private DNS zone Id. If not provided, a new private DNS zone will be created. Only required if private networking is used.')
  deploymentScriptPrivateDnsZoneResourceId: string?

  @description('Required. The compute type networking type.')
  computeNetworking: computeNetworkingType
}

@export()
type containerAppNetworkConfigType = {
  @description('Required. The Azure Container App networking type.')
  computeNetworkType: 'azureContainerApp'

  @description('Required. The existing network container app subnet name. This is required for Container Apps compute type. This subnet needs to have service delegation for App environments.')
  containerAppSubnetName: string

  @description('Required. The existing subnet name for the container app deployment script.')
  containerAppDeploymentScriptSubnetName: string

  @description('Optional. The container instance subnet name in the created virtual network. If not provided, a default name will be used. This subnet is required for private networking Azure DevOps scenarios to deploy the deployment script which starts the placeholder agent privately.')
  containerInstanceSubnetName: string?
}

type containerInstanceNetworkConfigType = {
  @description('Required. The Azure Container Instance network type.')
  computeNetworkType: 'azureContainerInstance'

  @description('Required. The container instance subnet name in the created virtual network. If not provided, a default name will be used.')
  containerInstanceSubnetName: string
}

@export()
@discriminator('networkType')
type networkType = newNetworkType | existingNetworkType

@export()
@discriminator('computeNetworkType')
type computeNetworkingType = containerAppNetworkConfigType | containerInstanceNetworkConfigType

@export()
type azureContainerInstanceTargetType = {
  @description('Optional. The Azure Container Instance Sku name.')
  sku: 'Standard' | 'Dedicated'?

  @description('Optional. The number of the Azure Container Instances to deploy.')
  numberOfInstances: int?

  @description('Optional. The Azure Container Instance container cpu.')
  cpu: int?

  @description('Optional. The Azure Container Instance container memory.')
  memoryInGB: string?

  @description('Optional. The Azure Container Instance container port.')
  port: int?
}

@export()
type azureContainerAppTargetType = {
  @description('Optional. The Azure Container App Job CPU and memory resources.')
  resources: acaResourcesType?
}

@export()
type gitHubRunnersType = {
  @description('Required. The self-hosted runner type.')
  selfHostedType: 'github'

  @description('Required. The GitHub personal access token with permissions to create and manage self-hosted runners.  See https://learn.microsoft.com/azure/container-apps/tutorial-ci-cd-runners-jobs?tabs=bash&pivots=container-apps-jobs-self-hosted-ci-cd-github-actions#get-a-github-personal-access-token for PAT permissions. The permissions will change based on the scope of the runner.')
  @secure()
  personalAccessToken: string

  @description('Required. The GitHub organization name.')
  githubOrganization: string

  @description('Optional. The GitHub repository name.')
  githubRepository: string?

  @description('Optional. The GitHub runner name.')
  runnerName: string?

  @description('Optional. The GitHub runner group.')
  runnerGroup: string?

  @description('Optional. The GitHub runner name prefix.')
  runnerNamePrefix: string?

  @description('Optional. The GitHub runner scope. Depending on the scope, you would need to set the right permissions for your Personal Access Token.')
  runnerScope: 'repo' | 'org' | 'ent'?

  @description('Optional. Deploy ephemeral runners.')
  ephemeral: true?

  @description('Optional. The target workflow queue length.')
  targetWorkflowQueueLength: string?

  @description('Optional. The GitHub runner Azure Container instance configuration.')
  azureContainerInstanceTarget: azureContainerInstanceTargetType?

  @description('Optional. The GitHub runner Azure Container app configuration.')
  azureContainerAppTarget: azureContainerAppTargetType?
}

@export()
type devOpsAgentsType = {
  @description('Required. The self-hosted runner type.')
  selfHostedType: 'azuredevops'

  @description('Required. The Azure DevOps persoanl access token with permissions to create and manage self-hosted agents. See https://learn.microsoft.com/azure/container-apps/tutorial-ci-cd-runners-jobs?tabs=bash&pivots=container-apps-jobs-self-hosted-ci-cd-azure-pipelines#get-an-azure-devops-personal-access-token for PAT permissions.')
  @secure()
  personalAccessToken: string

  @description('Required. The Azure DevOps organization name.')
  devOpsOrganization: string

  @description('Required. The Azure DevOps agents pool name.')
  agentsPoolName: string

  @description('Optional. The Azure DevOps agent name.')
  agentName: string?

  @description('Optional. The Azure DevOps agent name prefix.')
  agentNamePrefix: string?

  @description('Optional. The Azure DevOps placeholder agent name.')
  placeHolderAgentName: string?

  @description('Optional. The target pipelines queue length.')
  targetPipelinesQueueLength: string?

  @description('Optional. The GitHub runner Azure Container instance configuration.')
  azureContainerInstanceTarget: azureContainerInstanceTargetType?

  @description('Optional. The AzureDevOps agents Azure Container app configuration.')
  azureContainerAppTarget: azureContainerAppTargetType?
}

@export()
type acaResourcesType =
  | { cpu: '0.25', memory: '0.5Gi' }
  | { cpu: '0.5', memory: '1Gi' }
  | { cpu: '0.75', memory: '1.5Gi' }
  | { cpu: '1', memory: '2Gi' }
  | { cpu: '1.25', memory: '2.5Gi' }
  | { cpu: '1.5', memory: '3Gi' }
  | { cpu: '1.75', memory: '3.5Gi' }
  | { cpu: '2', memory: '4Gi' }
  | { cpu: '2.25', memory: '4.5Gi' }
  | { cpu: '2.5', memory: '5Gi' }
  | { cpu: '2.75', memory: '5.5Gi' }
  | { cpu: '3', memory: '6Gi' }
  | { cpu: '3.25', memory: '6.5Gi' }
  | { cpu: '3.5', memory: '7Gi' }
  | { cpu: '3.75', memory: '7.5Gi' }
  | { cpu: '4', memory: '8Gi' }

@export()
@discriminator('selfHostedType')
type selfHostedRunnerType = gitHubRunnersType | devOpsAgentsType

@export()
@description('Required. The target compute environments for the private runners.')
type computeTypesType = ('azure-container-app' | 'azure-container-instance')
