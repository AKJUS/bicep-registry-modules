# Network Security Perimeter `[Microsoft.Network/networkSecurityPerimeters]`

This module deploys a Network Security Perimeter (NSP).

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/networkSecurityPerimeters` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/networkSecurityPerimeters) |
| `Microsoft.Network/networkSecurityPerimeters/profiles` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/networkSecurityPerimeters/profiles) |
| `Microsoft.Network/networkSecurityPerimeters/profiles/accessRules` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/networkSecurityPerimeters/profiles/accessRules) |
| `Microsoft.Network/networkSecurityPerimeters/resourceAssociations` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/networkSecurityPerimeters/resourceAssociations) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/network-security-perimeter:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module networkSecurityPerimeter 'br/public:avm/res/network/network-security-perimeter:<version>' = {
  name: 'networkSecurityPerimeterDeployment'
  params: {
    // Required parameters
    name: 'nnspmin001'
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nnspmin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/network-security-perimeter:<version>'

// Required parameters
param name = 'nnspmin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module networkSecurityPerimeter 'br/public:avm/res/network/network-security-perimeter:<version>' = {
  name: 'networkSecurityPerimeterDeployment'
  params: {
    // Required parameters
    name: 'nnspmax001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    profiles: [
      {
        accessRules: [
          {
            direction: 'Outbound'
            fullyQualifiedDomainNames: [
              'www.contoso.com'
            ]
            name: 'rule-outbound-01'
          }
          {
            addressPrefixes: [
              '198.168.1.0/24'
            ]
            direction: 'Inbound'
            name: 'rule-inbound-01'
          }
        ]
        name: 'profile-01'
      }
    ]
    resourceAssociations: [
      {
        accessMode: 'Learning'
        privateLinkResource: '<privateLinkResource>'
        profile: 'profile-01'
      }
    ]
    roleAssignments: [
      {
        name: 'b50cc72e-a2f2-4c4c-a3ad-86a43feb6ab8'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nnspmax001"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "profiles": {
      "value": [
        {
          "accessRules": [
            {
              "direction": "Outbound",
              "fullyQualifiedDomainNames": [
                "www.contoso.com"
              ],
              "name": "rule-outbound-01"
            },
            {
              "addressPrefixes": [
                "198.168.1.0/24"
              ],
              "direction": "Inbound",
              "name": "rule-inbound-01"
            }
          ],
          "name": "profile-01"
        }
      ]
    },
    "resourceAssociations": {
      "value": [
        {
          "accessMode": "Learning",
          "privateLinkResource": "<privateLinkResource>",
          "profile": "profile-01"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "b50cc72e-a2f2-4c4c-a3ad-86a43feb6ab8",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/network-security-perimeter:<version>'

// Required parameters
param name = 'nnspmax001'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param profiles = [
  {
    accessRules: [
      {
        direction: 'Outbound'
        fullyQualifiedDomainNames: [
          'www.contoso.com'
        ]
        name: 'rule-outbound-01'
      }
      {
        addressPrefixes: [
          '198.168.1.0/24'
        ]
        direction: 'Inbound'
        name: 'rule-inbound-01'
      }
    ]
    name: 'profile-01'
  }
]
param resourceAssociations = [
  {
    accessMode: 'Learning'
    privateLinkResource: '<privateLinkResource>'
    profile: 'profile-01'
  }
]
param roleAssignments = [
  {
    name: 'b50cc72e-a2f2-4c4c-a3ad-86a43feb6ab8'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module networkSecurityPerimeter 'br/public:avm/res/network/network-security-perimeter:<version>' = {
  name: 'networkSecurityPerimeterDeployment'
  params: {
    // Required parameters
    name: 'nnspwaf001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    profiles: [
      {
        accessRules: [
          {
            direction: 'Outbound'
            fullyQualifiedDomainNames: [
              'www.contoso.com'
            ]
            name: 'rule-outbound-01'
          }
          {
            addressPrefixes: [
              '198.168.1.0/24'
            ]
            direction: 'Inbound'
            name: 'rule-inbound-01'
          }
        ]
        name: 'profile-01'
      }
    ]
    resourceAssociations: [
      {
        accessMode: 'Learning'
        privateLinkResource: '<privateLinkResource>'
        profile: 'profile-01'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nnspwaf001"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "profiles": {
      "value": [
        {
          "accessRules": [
            {
              "direction": "Outbound",
              "fullyQualifiedDomainNames": [
                "www.contoso.com"
              ],
              "name": "rule-outbound-01"
            },
            {
              "addressPrefixes": [
                "198.168.1.0/24"
              ],
              "direction": "Inbound",
              "name": "rule-inbound-01"
            }
          ],
          "name": "profile-01"
        }
      ]
    },
    "resourceAssociations": {
      "value": [
        {
          "accessMode": "Learning",
          "privateLinkResource": "<privateLinkResource>",
          "profile": "profile-01"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/network-security-perimeter:<version>'

// Required parameters
param name = 'nnspwaf001'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param location = '<location>'
param profiles = [
  {
    accessRules: [
      {
        direction: 'Outbound'
        fullyQualifiedDomainNames: [
          'www.contoso.com'
        ]
        name: 'rule-outbound-01'
      }
      {
        addressPrefixes: [
          '198.168.1.0/24'
        ]
        direction: 'Inbound'
        name: 'rule-inbound-01'
      }
    ]
    name: 'profile-01'
  }
]
param resourceAssociations = [
  {
    accessMode: 'Learning'
    privateLinkResource: '<privateLinkResource>'
    profile: 'profile-01'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Network Security Perimeter. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`profiles`](#parameter-profiles) | array | Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed. |
| [`resourceAssociations`](#parameter-resourceassociations) | array | Array of resource associations to create. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the NSG resource. |

### Parameter: `name`

Name of the Network Security Perimeter.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `profiles`

Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-profilesname) | string | The name of the network security perimeter profile. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessRules`](#parameter-profilesaccessrules) | array | Whether network traffic is allowed or denied. |

### Parameter: `profiles.name`

The name of the network security perimeter profile.

- Required: Yes
- Type: string

### Parameter: `profiles.accessRules`

Whether network traffic is allowed or denied.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`direction`](#parameter-profilesaccessrulesdirection) | string | The type for an access rule. |
| [`name`](#parameter-profilesaccessrulesname) | string | The name of the access rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-profilesaccessrulesaddressprefixes) | array | Inbound address prefixes (IPv4/IPv6).s. |
| [`emailAddresses`](#parameter-profilesaccessrulesemailaddresses) | array | Outbound rules email address format. |
| [`fullyQualifiedDomainNames`](#parameter-profilesaccessrulesfullyqualifieddomainnames) | array | Outbound rules fully qualified domain name format. |
| [`phoneNumbers`](#parameter-profilesaccessrulesphonenumbers) | array | Outbound rules phone number format. |
| [`serviceTags`](#parameter-profilesaccessrulesservicetags) | array | Inbound rules service tag names. |
| [`subscriptions`](#parameter-profilesaccessrulessubscriptions) | array | List of subscription ids. |

### Parameter: `profiles.accessRules.direction`

The type for an access rule.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Inbound'
    'Outbound'
  ]
  ```

### Parameter: `profiles.accessRules.name`

The name of the access rule.

- Required: Yes
- Type: string

### Parameter: `profiles.accessRules.addressPrefixes`

Inbound address prefixes (IPv4/IPv6).s.

- Required: No
- Type: array

### Parameter: `profiles.accessRules.emailAddresses`

Outbound rules email address format.

- Required: No
- Type: array

### Parameter: `profiles.accessRules.fullyQualifiedDomainNames`

Outbound rules fully qualified domain name format.

- Required: No
- Type: array

### Parameter: `profiles.accessRules.phoneNumbers`

Outbound rules phone number format.

- Required: No
- Type: array

### Parameter: `profiles.accessRules.serviceTags`

Inbound rules service tag names.

- Required: No
- Type: array

### Parameter: `profiles.accessRules.subscriptions`

List of subscription ids.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-profilesaccessrulessubscriptionsid) | string | The subscription id. |

### Parameter: `profiles.accessRules.subscriptions.id`

The subscription id.

- Required: Yes
- Type: string

### Parameter: `resourceAssociations`

Array of resource associations to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateLinkResource`](#parameter-resourceassociationsprivatelinkresource) | string | The resource identifier of the resource association. |
| [`profile`](#parameter-resourceassociationsprofile) | string | The name of the resource association. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessMode`](#parameter-resourceassociationsaccessmode) | string | The access mode of the resource association. |

### Parameter: `resourceAssociations.privateLinkResource`

The resource identifier of the resource association.

- Required: Yes
- Type: string

### Parameter: `resourceAssociations.profile`

The name of the resource association.

- Required: Yes
- Type: string

### Parameter: `resourceAssociations.accessMode`

The access mode of the resource association.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Audit'
    'Enforced'
    'Learning'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `tags`

Tags of the NSG resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the network security perimeter. |
| `resourceGroupName` | string | The resource group the network security perimeter was deployed into. |
| `resourceId` | string | The resource ID of the network security perimeter. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
