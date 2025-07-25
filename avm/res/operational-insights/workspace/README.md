# Log Analytics Workspaces `[Microsoft.OperationalInsights/workspaces]`

This module deploys a Log Analytics Workspace.

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
| `Microsoft.OperationalInsights/workspaces` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/tables) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |
| `Microsoft.SecurityInsights/onboardingStates` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2024-03-01/onboardingStates) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/operational-insights/workspace:<version>`.

- [Advanced features](#example-1-advanced-features)
- [Using only defaults](#example-2-using-only-defaults)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Advanced features_

This instance deploys the module with advanced features like custom tables and data exports.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/operational-insights/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'oiwadv001'
    // Non-required parameters
    dailyQuotaGb: 10
    dataExports: [
      {
        destination: {
          metaData: {
            eventHubName: '<eventHubName>'
          }
          resourceId: '<resourceId>'
        }
        enable: true
        name: 'eventHubExport'
        tableNames: [
          'Alert'
          'InsightsMetrics'
        ]
      }
      {
        destination: {
          resourceId: '<resourceId>'
        }
        enable: true
        name: 'storageAccountExport'
        tableNames: [
          'Operation'
        ]
      }
    ]
    dataSources: [
      {
        eventLogName: 'Application'
        eventTypes: [
          {
            eventType: 'Error'
          }
          {
            eventType: 'Warning'
          }
          {
            eventType: 'Information'
          }
        ]
        kind: 'WindowsEvent'
        name: 'applicationEvent'
      }
      {
        counterName: '% Processor Time'
        instanceName: '*'
        intervalSeconds: 60
        kind: 'WindowsPerformanceCounter'
        name: 'windowsPerfCounter1'
        objectName: 'Processor'
      }
      {
        kind: 'IISLogs'
        name: 'sampleIISLog1'
        state: 'OnPremiseEnabled'
      }
      {
        kind: 'LinuxSyslog'
        name: 'sampleSyslog1'
        syslogName: 'kern'
        syslogSeverities: [
          {
            severity: 'emerg'
          }
          {
            severity: 'alert'
          }
          {
            severity: 'crit'
          }
          {
            severity: 'err'
          }
          {
            severity: 'warning'
          }
        ]
      }
      {
        kind: 'LinuxSyslogCollection'
        name: 'sampleSyslogCollection1'
        state: 'Enabled'
      }
      {
        instanceName: '*'
        intervalSeconds: 10
        kind: 'LinuxPerformanceObject'
        name: 'sampleLinuxPerf1'
        objectName: 'Logical Disk'
        syslogSeverities: [
          {
            counterName: '% Used Inodes'
          }
          {
            counterName: 'Free Megabytes'
          }
          {
            counterName: '% Used Space'
          }
          {
            counterName: 'Disk Transfers/sec'
          }
          {
            counterName: 'Disk Reads/sec'
          }
          {
            counterName: 'Disk Writes/sec'
          }
        ]
      }
      {
        kind: 'LinuxPerformanceCollection'
        name: 'sampleLinuxPerfCollection1'
        state: 'Enabled'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
      {
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'sendingDiagnosticSettingsToSelf'
        useThisWorkspace: true
      }
    ]
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    gallerySolutions: [
      {
        name: 'AzureAutomation(oiwadv001)'
        plan: {
          product: 'OMSGallery/AzureAutomation'
        }
      }
    ]
    linkedServices: [
      {
        name: 'Automation'
        resourceId: '<resourceId>'
      }
    ]
    linkedStorageAccounts: [
      {
        name: 'Query'
        storageAccountIds: [
          '<storageAccountResourceId>'
        ]
      }
    ]
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Enabled'
    savedSearches: [
      {
        category: 'VDC Saved Searches'
        displayName: 'VMSS Instance Count2'
        name: 'VMSSQueries'
        query: 'Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer'
      }
    ]
    storageInsightsConfigs: [
      {
        storageAccountResourceId: '<storageAccountResourceId>'
        tables: [
          'LinuxsyslogVer2v0'
          'WADETWEventTable'
          'WADServiceFabric*EventTable'
          'WADWindowsEventLogsTable'
        ]
      }
    ]
    tables: [
      {
        name: 'CustomTableBasic_CL'
        retentionInDays: 60
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Owner'
          }
          {
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
        schema: {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'dateTime'
            }
            {
              name: 'RawData'
              type: 'string'
            }
          ]
          name: 'CustomTableBasic_CL'
        }
        totalRetentionInDays: 90
      }
      {
        name: 'CustomTableAdvanced_CL'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Owner'
          }
          {
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
        schema: {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'dateTime'
            }
            {
              name: 'EventTime'
              type: 'dateTime'
            }
            {
              name: 'EventLevel'
              type: 'string'
            }
            {
              name: 'EventCode'
              type: 'int'
            }
            {
              name: 'Message'
              type: 'string'
            }
            {
              name: 'RawData'
              type: 'string'
            }
          ]
          name: 'CustomTableAdvanced_CL'
        }
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
      "value": "oiwadv001"
    },
    // Non-required parameters
    "dailyQuotaGb": {
      "value": 10
    },
    "dataExports": {
      "value": [
        {
          "destination": {
            "metaData": {
              "eventHubName": "<eventHubName>"
            },
            "resourceId": "<resourceId>"
          },
          "enable": true,
          "name": "eventHubExport",
          "tableNames": [
            "Alert",
            "InsightsMetrics"
          ]
        },
        {
          "destination": {
            "resourceId": "<resourceId>"
          },
          "enable": true,
          "name": "storageAccountExport",
          "tableNames": [
            "Operation"
          ]
        }
      ]
    },
    "dataSources": {
      "value": [
        {
          "eventLogName": "Application",
          "eventTypes": [
            {
              "eventType": "Error"
            },
            {
              "eventType": "Warning"
            },
            {
              "eventType": "Information"
            }
          ],
          "kind": "WindowsEvent",
          "name": "applicationEvent"
        },
        {
          "counterName": "% Processor Time",
          "instanceName": "*",
          "intervalSeconds": 60,
          "kind": "WindowsPerformanceCounter",
          "name": "windowsPerfCounter1",
          "objectName": "Processor"
        },
        {
          "kind": "IISLogs",
          "name": "sampleIISLog1",
          "state": "OnPremiseEnabled"
        },
        {
          "kind": "LinuxSyslog",
          "name": "sampleSyslog1",
          "syslogName": "kern",
          "syslogSeverities": [
            {
              "severity": "emerg"
            },
            {
              "severity": "alert"
            },
            {
              "severity": "crit"
            },
            {
              "severity": "err"
            },
            {
              "severity": "warning"
            }
          ]
        },
        {
          "kind": "LinuxSyslogCollection",
          "name": "sampleSyslogCollection1",
          "state": "Enabled"
        },
        {
          "instanceName": "*",
          "intervalSeconds": 10,
          "kind": "LinuxPerformanceObject",
          "name": "sampleLinuxPerf1",
          "objectName": "Logical Disk",
          "syslogSeverities": [
            {
              "counterName": "% Used Inodes"
            },
            {
              "counterName": "Free Megabytes"
            },
            {
              "counterName": "% Used Space"
            },
            {
              "counterName": "Disk Transfers/sec"
            },
            {
              "counterName": "Disk Reads/sec"
            },
            {
              "counterName": "Disk Writes/sec"
            }
          ]
        },
        {
          "kind": "LinuxPerformanceCollection",
          "name": "sampleLinuxPerfCollection1",
          "state": "Enabled"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        },
        {
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "sendingDiagnosticSettingsToSelf",
          "useThisWorkspace": true
        }
      ]
    },
    "features": {
      "value": {
        "enableLogAccessUsingOnlyResourcePermissions": true
      }
    },
    "gallerySolutions": {
      "value": [
        {
          "name": "AzureAutomation(oiwadv001)",
          "plan": {
            "product": "OMSGallery/AzureAutomation"
          }
        }
      ]
    },
    "linkedServices": {
      "value": [
        {
          "name": "Automation",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "linkedStorageAccounts": {
      "value": [
        {
          "name": "Query",
          "storageAccountIds": [
            "<storageAccountResourceId>"
          ]
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "publicNetworkAccessForIngestion": {
      "value": "Disabled"
    },
    "publicNetworkAccessForQuery": {
      "value": "Enabled"
    },
    "savedSearches": {
      "value": [
        {
          "category": "VDC Saved Searches",
          "displayName": "VMSS Instance Count2",
          "name": "VMSSQueries",
          "query": "Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer"
        }
      ]
    },
    "storageInsightsConfigs": {
      "value": [
        {
          "storageAccountResourceId": "<storageAccountResourceId>",
          "tables": [
            "LinuxsyslogVer2v0",
            "WADETWEventTable",
            "WADServiceFabric*EventTable",
            "WADWindowsEventLogsTable"
          ]
        }
      ]
    },
    "tables": {
      "value": [
        {
          "name": "CustomTableBasic_CL",
          "retentionInDays": 60,
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Owner"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "schema": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "dateTime"
              },
              {
                "name": "RawData",
                "type": "string"
              }
            ],
            "name": "CustomTableBasic_CL"
          },
          "totalRetentionInDays": 90
        },
        {
          "name": "CustomTableAdvanced_CL",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Owner"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "schema": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "dateTime"
              },
              {
                "name": "EventTime",
                "type": "dateTime"
              },
              {
                "name": "EventLevel",
                "type": "string"
              },
              {
                "name": "EventCode",
                "type": "int"
              },
              {
                "name": "Message",
                "type": "string"
              },
              {
                "name": "RawData",
                "type": "string"
              }
            ],
            "name": "CustomTableAdvanced_CL"
          }
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
using 'br/public:avm/res/operational-insights/workspace:<version>'

// Required parameters
param name = 'oiwadv001'
// Non-required parameters
param dailyQuotaGb = 10
param dataExports = [
  {
    destination: {
      metaData: {
        eventHubName: '<eventHubName>'
      }
      resourceId: '<resourceId>'
    }
    enable: true
    name: 'eventHubExport'
    tableNames: [
      'Alert'
      'InsightsMetrics'
    ]
  }
  {
    destination: {
      resourceId: '<resourceId>'
    }
    enable: true
    name: 'storageAccountExport'
    tableNames: [
      'Operation'
    ]
  }
]
param dataSources = [
  {
    eventLogName: 'Application'
    eventTypes: [
      {
        eventType: 'Error'
      }
      {
        eventType: 'Warning'
      }
      {
        eventType: 'Information'
      }
    ]
    kind: 'WindowsEvent'
    name: 'applicationEvent'
  }
  {
    counterName: '% Processor Time'
    instanceName: '*'
    intervalSeconds: 60
    kind: 'WindowsPerformanceCounter'
    name: 'windowsPerfCounter1'
    objectName: 'Processor'
  }
  {
    kind: 'IISLogs'
    name: 'sampleIISLog1'
    state: 'OnPremiseEnabled'
  }
  {
    kind: 'LinuxSyslog'
    name: 'sampleSyslog1'
    syslogName: 'kern'
    syslogSeverities: [
      {
        severity: 'emerg'
      }
      {
        severity: 'alert'
      }
      {
        severity: 'crit'
      }
      {
        severity: 'err'
      }
      {
        severity: 'warning'
      }
    ]
  }
  {
    kind: 'LinuxSyslogCollection'
    name: 'sampleSyslogCollection1'
    state: 'Enabled'
  }
  {
    instanceName: '*'
    intervalSeconds: 10
    kind: 'LinuxPerformanceObject'
    name: 'sampleLinuxPerf1'
    objectName: 'Logical Disk'
    syslogSeverities: [
      {
        counterName: '% Used Inodes'
      }
      {
        counterName: 'Free Megabytes'
      }
      {
        counterName: '% Used Space'
      }
      {
        counterName: 'Disk Transfers/sec'
      }
      {
        counterName: 'Disk Reads/sec'
      }
      {
        counterName: 'Disk Writes/sec'
      }
    ]
  }
  {
    kind: 'LinuxPerformanceCollection'
    name: 'sampleLinuxPerfCollection1'
    state: 'Enabled'
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
  {
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'sendingDiagnosticSettingsToSelf'
    useThisWorkspace: true
  }
]
param features = {
  enableLogAccessUsingOnlyResourcePermissions: true
}
param gallerySolutions = [
  {
    name: 'AzureAutomation(oiwadv001)'
    plan: {
      product: 'OMSGallery/AzureAutomation'
    }
  }
]
param linkedServices = [
  {
    name: 'Automation'
    resourceId: '<resourceId>'
  }
]
param linkedStorageAccounts = [
  {
    name: 'Query'
    storageAccountIds: [
      '<storageAccountResourceId>'
    ]
  }
]
param location = '<location>'
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param publicNetworkAccessForIngestion = 'Disabled'
param publicNetworkAccessForQuery = 'Enabled'
param savedSearches = [
  {
    category: 'VDC Saved Searches'
    displayName: 'VMSS Instance Count2'
    name: 'VMSSQueries'
    query: 'Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer'
  }
]
param storageInsightsConfigs = [
  {
    storageAccountResourceId: '<storageAccountResourceId>'
    tables: [
      'LinuxsyslogVer2v0'
      'WADETWEventTable'
      'WADServiceFabric*EventTable'
      'WADWindowsEventLogsTable'
    ]
  }
]
param tables = [
  {
    name: 'CustomTableBasic_CL'
    retentionInDays: 60
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
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
    schema: {
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'RawData'
          type: 'string'
        }
      ]
      name: 'CustomTableBasic_CL'
    }
    totalRetentionInDays: 90
  }
  {
    name: 'CustomTableAdvanced_CL'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
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
    schema: {
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'EventTime'
          type: 'dateTime'
        }
        {
          name: 'EventLevel'
          type: 'string'
        }
        {
          name: 'EventCode'
          type: 'int'
        }
        {
          name: 'Message'
          type: 'string'
        }
        {
          name: 'RawData'
          type: 'string'
        }
      ]
      name: 'CustomTableAdvanced_CL'
    }
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

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/operational-insights/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'oiwmin001'
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
      "value": "oiwmin001"
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
using 'br/public:avm/res/operational-insights/workspace:<version>'

// Required parameters
param name = 'oiwmin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/operational-insights/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'oiwmax001'
    // Non-required parameters
    dailyQuotaGb: 10
    dataSources: [
      {
        eventLogName: 'Application'
        eventTypes: [
          {
            eventType: 'Error'
          }
          {
            eventType: 'Warning'
          }
          {
            eventType: 'Information'
          }
        ]
        kind: 'WindowsEvent'
        name: 'applicationEvent'
      }
      {
        counterName: '% Processor Time'
        instanceName: '*'
        intervalSeconds: 60
        kind: 'WindowsPerformanceCounter'
        name: 'windowsPerfCounter1'
        objectName: 'Processor'
      }
      {
        kind: 'IISLogs'
        name: 'sampleIISLog1'
        state: 'OnPremiseEnabled'
      }
      {
        kind: 'LinuxSyslog'
        name: 'sampleSyslog1'
        syslogName: 'kern'
        syslogSeverities: [
          {
            severity: 'emerg'
          }
          {
            severity: 'alert'
          }
          {
            severity: 'crit'
          }
          {
            severity: 'err'
          }
          {
            severity: 'warning'
          }
        ]
      }
      {
        kind: 'LinuxSyslogCollection'
        name: 'sampleSyslogCollection1'
        state: 'Enabled'
      }
      {
        instanceName: '*'
        intervalSeconds: 10
        kind: 'LinuxPerformanceObject'
        name: 'sampleLinuxPerf1'
        objectName: 'Logical Disk'
        syslogSeverities: [
          {
            counterName: '% Used Inodes'
          }
          {
            counterName: 'Free Megabytes'
          }
          {
            counterName: '% Used Space'
          }
          {
            counterName: 'Disk Transfers/sec'
          }
          {
            counterName: 'Disk Reads/sec'
          }
          {
            counterName: 'Disk Writes/sec'
          }
        ]
      }
      {
        kind: 'LinuxPerformanceCollection'
        name: 'sampleLinuxPerfCollection1'
        state: 'Enabled'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    features: {
      disableLocalAuth: true
      enableDataExport: true
      enableLogAccessUsingOnlyResourcePermissions: true
      immediatePurgeDataOn30Days: true
    }
    gallerySolutions: [
      {
        name: 'AzureAutomation(oiwmax001)'
        plan: {
          product: 'OMSGallery/AzureAutomation'
        }
      }
      {
        name: 'SecurityInsights(oiwmax001)'
        plan: {
          product: 'OMSGallery/SecurityInsights'
          publisher: 'Microsoft'
        }
      }
      {
        name: 'SQLAuditing(oiwmax001)'
        plan: {
          name: 'SQLAuditing(oiwmax001)'
          product: 'SQLAuditing'
          publisher: 'Microsoft'
        }
      }
    ]
    linkedServices: [
      {
        name: 'Automation'
        resourceId: '<resourceId>'
      }
    ]
    linkedStorageAccounts: [
      {
        name: 'Query'
        storageAccountIds: [
          '<storageAccountResourceId>'
        ]
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
    }
    onboardWorkspaceToSentinel: true
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
    replication: {
      enabled: true
      location: '<location>'
    }
    roleAssignments: [
      {
        name: 'c3d53092-840c-4025-9c02-9bcb7895789c'
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
    savedSearches: [
      {
        category: 'VDC Saved Searches'
        displayName: 'VMSS Instance Count2'
        name: 'VMSSQueries'
        query: 'Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer'
        tags: [
          {
            Name: 'Environment'
            Value: 'Non-Prod'
          }
          {
            Name: 'Role'
            Value: 'DeploymentValidation'
          }
        ]
      }
    ]
    storageInsightsConfigs: [
      {
        storageAccountResourceId: '<storageAccountResourceId>'
        tables: [
          'LinuxsyslogVer2v0'
          'WADETWEventTable'
          'WADServiceFabric*EventTable'
          'WADWindowsEventLogsTable'
        ]
      }
    ]
    tables: [
      {
        name: 'CustomTableBasic_CL'
        retentionInDays: 60
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Owner'
          }
          {
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
        schema: {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'dateTime'
            }
            {
              name: 'RawData'
              type: 'string'
            }
          ]
          name: 'CustomTableBasic_CL'
        }
        totalRetentionInDays: 90
      }
      {
        name: 'CustomTableAdvanced_CL'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Owner'
          }
          {
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
        schema: {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'dateTime'
            }
            {
              name: 'EventTime'
              type: 'dateTime'
            }
            {
              name: 'EventLevel'
              type: 'string'
            }
            {
              name: 'EventCode'
              type: 'int'
            }
            {
              name: 'Message'
              type: 'string'
            }
            {
              name: 'RawData'
              type: 'string'
            }
          ]
          name: 'CustomTableAdvanced_CL'
        }
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
      "value": "oiwmax001"
    },
    // Non-required parameters
    "dailyQuotaGb": {
      "value": 10
    },
    "dataSources": {
      "value": [
        {
          "eventLogName": "Application",
          "eventTypes": [
            {
              "eventType": "Error"
            },
            {
              "eventType": "Warning"
            },
            {
              "eventType": "Information"
            }
          ],
          "kind": "WindowsEvent",
          "name": "applicationEvent"
        },
        {
          "counterName": "% Processor Time",
          "instanceName": "*",
          "intervalSeconds": 60,
          "kind": "WindowsPerformanceCounter",
          "name": "windowsPerfCounter1",
          "objectName": "Processor"
        },
        {
          "kind": "IISLogs",
          "name": "sampleIISLog1",
          "state": "OnPremiseEnabled"
        },
        {
          "kind": "LinuxSyslog",
          "name": "sampleSyslog1",
          "syslogName": "kern",
          "syslogSeverities": [
            {
              "severity": "emerg"
            },
            {
              "severity": "alert"
            },
            {
              "severity": "crit"
            },
            {
              "severity": "err"
            },
            {
              "severity": "warning"
            }
          ]
        },
        {
          "kind": "LinuxSyslogCollection",
          "name": "sampleSyslogCollection1",
          "state": "Enabled"
        },
        {
          "instanceName": "*",
          "intervalSeconds": 10,
          "kind": "LinuxPerformanceObject",
          "name": "sampleLinuxPerf1",
          "objectName": "Logical Disk",
          "syslogSeverities": [
            {
              "counterName": "% Used Inodes"
            },
            {
              "counterName": "Free Megabytes"
            },
            {
              "counterName": "% Used Space"
            },
            {
              "counterName": "Disk Transfers/sec"
            },
            {
              "counterName": "Disk Reads/sec"
            },
            {
              "counterName": "Disk Writes/sec"
            }
          ]
        },
        {
          "kind": "LinuxPerformanceCollection",
          "name": "sampleLinuxPerfCollection1",
          "state": "Enabled"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "features": {
      "value": {
        "disableLocalAuth": true,
        "enableDataExport": true,
        "enableLogAccessUsingOnlyResourcePermissions": true,
        "immediatePurgeDataOn30Days": true
      }
    },
    "gallerySolutions": {
      "value": [
        {
          "name": "AzureAutomation(oiwmax001)",
          "plan": {
            "product": "OMSGallery/AzureAutomation"
          }
        },
        {
          "name": "SecurityInsights(oiwmax001)",
          "plan": {
            "product": "OMSGallery/SecurityInsights",
            "publisher": "Microsoft"
          }
        },
        {
          "name": "SQLAuditing(oiwmax001)",
          "plan": {
            "name": "SQLAuditing(oiwmax001)",
            "product": "SQLAuditing",
            "publisher": "Microsoft"
          }
        }
      ]
    },
    "linkedServices": {
      "value": [
        {
          "name": "Automation",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "linkedStorageAccounts": {
      "value": [
        {
          "name": "Query",
          "storageAccountIds": [
            "<storageAccountResourceId>"
          ]
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
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "onboardWorkspaceToSentinel": {
      "value": true
    },
    "publicNetworkAccessForIngestion": {
      "value": "Disabled"
    },
    "publicNetworkAccessForQuery": {
      "value": "Disabled"
    },
    "replication": {
      "value": {
        "enabled": true,
        "location": "<location>"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "name": "c3d53092-840c-4025-9c02-9bcb7895789c",
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
    "savedSearches": {
      "value": [
        {
          "category": "VDC Saved Searches",
          "displayName": "VMSS Instance Count2",
          "name": "VMSSQueries",
          "query": "Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer",
          "tags": [
            {
              "Name": "Environment",
              "Value": "Non-Prod"
            },
            {
              "Name": "Role",
              "Value": "DeploymentValidation"
            }
          ]
        }
      ]
    },
    "storageInsightsConfigs": {
      "value": [
        {
          "storageAccountResourceId": "<storageAccountResourceId>",
          "tables": [
            "LinuxsyslogVer2v0",
            "WADETWEventTable",
            "WADServiceFabric*EventTable",
            "WADWindowsEventLogsTable"
          ]
        }
      ]
    },
    "tables": {
      "value": [
        {
          "name": "CustomTableBasic_CL",
          "retentionInDays": 60,
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Owner"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "schema": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "dateTime"
              },
              {
                "name": "RawData",
                "type": "string"
              }
            ],
            "name": "CustomTableBasic_CL"
          },
          "totalRetentionInDays": 90
        },
        {
          "name": "CustomTableAdvanced_CL",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Owner"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "schema": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "dateTime"
              },
              {
                "name": "EventTime",
                "type": "dateTime"
              },
              {
                "name": "EventLevel",
                "type": "string"
              },
              {
                "name": "EventCode",
                "type": "int"
              },
              {
                "name": "Message",
                "type": "string"
              },
              {
                "name": "RawData",
                "type": "string"
              }
            ],
            "name": "CustomTableAdvanced_CL"
          }
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
using 'br/public:avm/res/operational-insights/workspace:<version>'

// Required parameters
param name = 'oiwmax001'
// Non-required parameters
param dailyQuotaGb = 10
param dataSources = [
  {
    eventLogName: 'Application'
    eventTypes: [
      {
        eventType: 'Error'
      }
      {
        eventType: 'Warning'
      }
      {
        eventType: 'Information'
      }
    ]
    kind: 'WindowsEvent'
    name: 'applicationEvent'
  }
  {
    counterName: '% Processor Time'
    instanceName: '*'
    intervalSeconds: 60
    kind: 'WindowsPerformanceCounter'
    name: 'windowsPerfCounter1'
    objectName: 'Processor'
  }
  {
    kind: 'IISLogs'
    name: 'sampleIISLog1'
    state: 'OnPremiseEnabled'
  }
  {
    kind: 'LinuxSyslog'
    name: 'sampleSyslog1'
    syslogName: 'kern'
    syslogSeverities: [
      {
        severity: 'emerg'
      }
      {
        severity: 'alert'
      }
      {
        severity: 'crit'
      }
      {
        severity: 'err'
      }
      {
        severity: 'warning'
      }
    ]
  }
  {
    kind: 'LinuxSyslogCollection'
    name: 'sampleSyslogCollection1'
    state: 'Enabled'
  }
  {
    instanceName: '*'
    intervalSeconds: 10
    kind: 'LinuxPerformanceObject'
    name: 'sampleLinuxPerf1'
    objectName: 'Logical Disk'
    syslogSeverities: [
      {
        counterName: '% Used Inodes'
      }
      {
        counterName: 'Free Megabytes'
      }
      {
        counterName: '% Used Space'
      }
      {
        counterName: 'Disk Transfers/sec'
      }
      {
        counterName: 'Disk Reads/sec'
      }
      {
        counterName: 'Disk Writes/sec'
      }
    ]
  }
  {
    kind: 'LinuxPerformanceCollection'
    name: 'sampleLinuxPerfCollection1'
    state: 'Enabled'
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param features = {
  disableLocalAuth: true
  enableDataExport: true
  enableLogAccessUsingOnlyResourcePermissions: true
  immediatePurgeDataOn30Days: true
}
param gallerySolutions = [
  {
    name: 'AzureAutomation(oiwmax001)'
    plan: {
      product: 'OMSGallery/AzureAutomation'
    }
  }
  {
    name: 'SecurityInsights(oiwmax001)'
    plan: {
      product: 'OMSGallery/SecurityInsights'
      publisher: 'Microsoft'
    }
  }
  {
    name: 'SQLAuditing(oiwmax001)'
    plan: {
      name: 'SQLAuditing(oiwmax001)'
      product: 'SQLAuditing'
      publisher: 'Microsoft'
    }
  }
]
param linkedServices = [
  {
    name: 'Automation'
    resourceId: '<resourceId>'
  }
]
param linkedStorageAccounts = [
  {
    name: 'Query'
    storageAccountIds: [
      '<storageAccountResourceId>'
    ]
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
}
param onboardWorkspaceToSentinel = true
param publicNetworkAccessForIngestion = 'Disabled'
param publicNetworkAccessForQuery = 'Disabled'
param replication = {
  enabled: true
  location: '<location>'
}
param roleAssignments = [
  {
    name: 'c3d53092-840c-4025-9c02-9bcb7895789c'
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
param savedSearches = [
  {
    category: 'VDC Saved Searches'
    displayName: 'VMSS Instance Count2'
    name: 'VMSSQueries'
    query: 'Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer'
    tags: [
      {
        Name: 'Environment'
        Value: 'Non-Prod'
      }
      {
        Name: 'Role'
        Value: 'DeploymentValidation'
      }
    ]
  }
]
param storageInsightsConfigs = [
  {
    storageAccountResourceId: '<storageAccountResourceId>'
    tables: [
      'LinuxsyslogVer2v0'
      'WADETWEventTable'
      'WADServiceFabric*EventTable'
      'WADWindowsEventLogsTable'
    ]
  }
]
param tables = [
  {
    name: 'CustomTableBasic_CL'
    retentionInDays: 60
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
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
    schema: {
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'RawData'
          type: 'string'
        }
      ]
      name: 'CustomTableBasic_CL'
    }
    totalRetentionInDays: 90
  }
  {
    name: 'CustomTableAdvanced_CL'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
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
    schema: {
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'EventTime'
          type: 'dateTime'
        }
        {
          name: 'EventLevel'
          type: 'string'
        }
        {
          name: 'EventCode'
          type: 'int'
        }
        {
          name: 'Message'
          type: 'string'
        }
        {
          name: 'RawData'
          type: 'string'
        }
      ]
      name: 'CustomTableAdvanced_CL'
    }
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

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/operational-insights/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'oiwwaf001'
    // Non-required parameters
    dailyQuotaGb: 10
    dataSources: [
      {
        eventLogName: 'Application'
        eventTypes: [
          {
            eventType: 'Error'
          }
          {
            eventType: 'Warning'
          }
          {
            eventType: 'Information'
          }
        ]
        kind: 'WindowsEvent'
        name: 'applicationEvent'
      }
      {
        counterName: '% Processor Time'
        instanceName: '*'
        intervalSeconds: 60
        kind: 'WindowsPerformanceCounter'
        name: 'windowsPerfCounter1'
        objectName: 'Processor'
      }
      {
        kind: 'IISLogs'
        name: 'sampleIISLog1'
        state: 'OnPremiseEnabled'
      }
      {
        kind: 'LinuxSyslog'
        name: 'sampleSyslog1'
        syslogName: 'kern'
        syslogSeverities: [
          {
            severity: 'emerg'
          }
          {
            severity: 'alert'
          }
          {
            severity: 'crit'
          }
          {
            severity: 'err'
          }
          {
            severity: 'warning'
          }
        ]
      }
      {
        kind: 'LinuxSyslogCollection'
        name: 'sampleSyslogCollection1'
        state: 'Enabled'
      }
      {
        instanceName: '*'
        intervalSeconds: 10
        kind: 'LinuxPerformanceObject'
        name: 'sampleLinuxPerf1'
        objectName: 'Logical Disk'
        syslogSeverities: [
          {
            counterName: '% Used Inodes'
          }
          {
            counterName: 'Free Megabytes'
          }
          {
            counterName: '% Used Space'
          }
          {
            counterName: 'Disk Transfers/sec'
          }
          {
            counterName: 'Disk Reads/sec'
          }
          {
            counterName: 'Disk Writes/sec'
          }
        ]
      }
      {
        kind: 'LinuxPerformanceCollection'
        name: 'sampleLinuxPerfCollection1'
        state: 'Enabled'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    gallerySolutions: [
      {
        name: 'AzureAutomation(oiwwaf001)'
        plan: {
          product: 'OMSGallery/AzureAutomation'
        }
      }
    ]
    linkedServices: [
      {
        name: 'Automation'
        resourceId: '<resourceId>'
      }
    ]
    linkedStorageAccounts: [
      {
        name: 'Query'
        storageAccountIds: [
          '<storageAccountResourceId>'
        ]
      }
    ]
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
    replication: {
      enabled: true
      location: '<location>'
    }
    storageInsightsConfigs: [
      {
        storageAccountResourceId: '<storageAccountResourceId>'
        tables: [
          'LinuxsyslogVer2v0'
          'WADETWEventTable'
          'WADServiceFabric*EventTable'
          'WADWindowsEventLogsTable'
        ]
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
      "value": "oiwwaf001"
    },
    // Non-required parameters
    "dailyQuotaGb": {
      "value": 10
    },
    "dataSources": {
      "value": [
        {
          "eventLogName": "Application",
          "eventTypes": [
            {
              "eventType": "Error"
            },
            {
              "eventType": "Warning"
            },
            {
              "eventType": "Information"
            }
          ],
          "kind": "WindowsEvent",
          "name": "applicationEvent"
        },
        {
          "counterName": "% Processor Time",
          "instanceName": "*",
          "intervalSeconds": 60,
          "kind": "WindowsPerformanceCounter",
          "name": "windowsPerfCounter1",
          "objectName": "Processor"
        },
        {
          "kind": "IISLogs",
          "name": "sampleIISLog1",
          "state": "OnPremiseEnabled"
        },
        {
          "kind": "LinuxSyslog",
          "name": "sampleSyslog1",
          "syslogName": "kern",
          "syslogSeverities": [
            {
              "severity": "emerg"
            },
            {
              "severity": "alert"
            },
            {
              "severity": "crit"
            },
            {
              "severity": "err"
            },
            {
              "severity": "warning"
            }
          ]
        },
        {
          "kind": "LinuxSyslogCollection",
          "name": "sampleSyslogCollection1",
          "state": "Enabled"
        },
        {
          "instanceName": "*",
          "intervalSeconds": 10,
          "kind": "LinuxPerformanceObject",
          "name": "sampleLinuxPerf1",
          "objectName": "Logical Disk",
          "syslogSeverities": [
            {
              "counterName": "% Used Inodes"
            },
            {
              "counterName": "Free Megabytes"
            },
            {
              "counterName": "% Used Space"
            },
            {
              "counterName": "Disk Transfers/sec"
            },
            {
              "counterName": "Disk Reads/sec"
            },
            {
              "counterName": "Disk Writes/sec"
            }
          ]
        },
        {
          "kind": "LinuxPerformanceCollection",
          "name": "sampleLinuxPerfCollection1",
          "state": "Enabled"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "features": {
      "value": {
        "enableLogAccessUsingOnlyResourcePermissions": true
      }
    },
    "gallerySolutions": {
      "value": [
        {
          "name": "AzureAutomation(oiwwaf001)",
          "plan": {
            "product": "OMSGallery/AzureAutomation"
          }
        }
      ]
    },
    "linkedServices": {
      "value": [
        {
          "name": "Automation",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "linkedStorageAccounts": {
      "value": [
        {
          "name": "Query",
          "storageAccountIds": [
            "<storageAccountResourceId>"
          ]
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "publicNetworkAccessForIngestion": {
      "value": "Disabled"
    },
    "publicNetworkAccessForQuery": {
      "value": "Disabled"
    },
    "replication": {
      "value": {
        "enabled": true,
        "location": "<location>"
      }
    },
    "storageInsightsConfigs": {
      "value": [
        {
          "storageAccountResourceId": "<storageAccountResourceId>",
          "tables": [
            "LinuxsyslogVer2v0",
            "WADETWEventTable",
            "WADServiceFabric*EventTable",
            "WADWindowsEventLogsTable"
          ]
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
using 'br/public:avm/res/operational-insights/workspace:<version>'

// Required parameters
param name = 'oiwwaf001'
// Non-required parameters
param dailyQuotaGb = 10
param dataSources = [
  {
    eventLogName: 'Application'
    eventTypes: [
      {
        eventType: 'Error'
      }
      {
        eventType: 'Warning'
      }
      {
        eventType: 'Information'
      }
    ]
    kind: 'WindowsEvent'
    name: 'applicationEvent'
  }
  {
    counterName: '% Processor Time'
    instanceName: '*'
    intervalSeconds: 60
    kind: 'WindowsPerformanceCounter'
    name: 'windowsPerfCounter1'
    objectName: 'Processor'
  }
  {
    kind: 'IISLogs'
    name: 'sampleIISLog1'
    state: 'OnPremiseEnabled'
  }
  {
    kind: 'LinuxSyslog'
    name: 'sampleSyslog1'
    syslogName: 'kern'
    syslogSeverities: [
      {
        severity: 'emerg'
      }
      {
        severity: 'alert'
      }
      {
        severity: 'crit'
      }
      {
        severity: 'err'
      }
      {
        severity: 'warning'
      }
    ]
  }
  {
    kind: 'LinuxSyslogCollection'
    name: 'sampleSyslogCollection1'
    state: 'Enabled'
  }
  {
    instanceName: '*'
    intervalSeconds: 10
    kind: 'LinuxPerformanceObject'
    name: 'sampleLinuxPerf1'
    objectName: 'Logical Disk'
    syslogSeverities: [
      {
        counterName: '% Used Inodes'
      }
      {
        counterName: 'Free Megabytes'
      }
      {
        counterName: '% Used Space'
      }
      {
        counterName: 'Disk Transfers/sec'
      }
      {
        counterName: 'Disk Reads/sec'
      }
      {
        counterName: 'Disk Writes/sec'
      }
    ]
  }
  {
    kind: 'LinuxPerformanceCollection'
    name: 'sampleLinuxPerfCollection1'
    state: 'Enabled'
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param features = {
  enableLogAccessUsingOnlyResourcePermissions: true
}
param gallerySolutions = [
  {
    name: 'AzureAutomation(oiwwaf001)'
    plan: {
      product: 'OMSGallery/AzureAutomation'
    }
  }
]
param linkedServices = [
  {
    name: 'Automation'
    resourceId: '<resourceId>'
  }
]
param linkedStorageAccounts = [
  {
    name: 'Query'
    storageAccountIds: [
      '<storageAccountResourceId>'
    ]
  }
]
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
}
param publicNetworkAccessForIngestion = 'Disabled'
param publicNetworkAccessForQuery = 'Disabled'
param replication = {
  enabled: true
  location: '<location>'
}
param storageInsightsConfigs = [
  {
    storageAccountResourceId: '<storageAccountResourceId>'
    tables: [
      'LinuxsyslogVer2v0'
      'WADETWEventTable'
      'WADServiceFabric*EventTable'
      'WADWindowsEventLogsTable'
    ]
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
| [`name`](#parameter-name) | string | Name of the Log Analytics workspace. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`linkedStorageAccounts`](#parameter-linkedstorageaccounts) | array | List of Storage Accounts to be linked. Required if 'forceCmkForQuery' is set to 'true' and 'savedSearches' is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailyQuotaGb`](#parameter-dailyquotagb) | int | The workspace daily quota for ingestion. |
| [`dataExports`](#parameter-dataexports) | array | LAW data export instances to be deployed. |
| [`dataRetention`](#parameter-dataretention) | int | Number of days data will be retained for. |
| [`dataSources`](#parameter-datasources) | array | LAW data sources to configure. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`features`](#parameter-features) | object | The workspace features. |
| [`forceCmkForQuery`](#parameter-forcecmkforquery) | bool | Indicates whether customer managed storage is mandatory for query management. |
| [`gallerySolutions`](#parameter-gallerysolutions) | array | List of gallerySolutions to be created in the log analytics workspace. |
| [`linkedServices`](#parameter-linkedservices) | array | List of services to be linked. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both. |
| [`onboardWorkspaceToSentinel`](#parameter-onboardworkspacetosentinel) | bool | Onboard the Log Analytics Workspace to Sentinel. Requires 'SecurityInsights' solution to be in gallerySolutions. |
| [`publicNetworkAccessForIngestion`](#parameter-publicnetworkaccessforingestion) | string | The network access type for accessing Log Analytics ingestion. |
| [`publicNetworkAccessForQuery`](#parameter-publicnetworkaccessforquery) | string | The network access type for accessing Log Analytics query. |
| [`replication`](#parameter-replication) | object | The workspace replication properties. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`savedSearches`](#parameter-savedsearches) | array | Kusto Query Language searches to save. |
| [`skuCapacityReservationLevel`](#parameter-skucapacityreservationlevel) | int | The capacity reservation level in GB for this workspace, when CapacityReservation sku is selected. Must be in increments of 100 between 100 and 5000. |
| [`skuName`](#parameter-skuname) | string | The name of the SKU. |
| [`storageInsightsConfigs`](#parameter-storageinsightsconfigs) | array | List of storage accounts to be read by the workspace. |
| [`tables`](#parameter-tables) | array | LAW custom tables to be deployed. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the Log Analytics workspace.

- Required: Yes
- Type: string

### Parameter: `linkedStorageAccounts`

List of Storage Accounts to be linked. Required if 'forceCmkForQuery' is set to 'true' and 'savedSearches' is not empty.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-linkedstorageaccountsname) | string | Name of the link. |
| [`storageAccountIds`](#parameter-linkedstorageaccountsstorageaccountids) | array | Linked storage accounts resources Ids. |

### Parameter: `linkedStorageAccounts.name`

Name of the link.

- Required: Yes
- Type: string

### Parameter: `linkedStorageAccounts.storageAccountIds`

Linked storage accounts resources Ids.

- Required: Yes
- Type: array

### Parameter: `dailyQuotaGb`

The workspace daily quota for ingestion.

- Required: No
- Type: int
- Default: `-1`
- MinValue: -1

### Parameter: `dataExports`

LAW data export instances to be deployed.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-dataexportsname) | string | Name of the data export. |
| [`tableNames`](#parameter-dataexportstablenames) | array | The list of table names to export. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-dataexportsdestination) | object | The destination of the data export. |
| [`enable`](#parameter-dataexportsenable) | bool | Enable or disable the data export. |

### Parameter: `dataExports.name`

Name of the data export.

- Required: Yes
- Type: string

### Parameter: `dataExports.tableNames`

The list of table names to export.

- Required: Yes
- Type: array

### Parameter: `dataExports.destination`

The destination of the data export.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-dataexportsdestinationresourceid) | string | The destination resource ID. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metaData`](#parameter-dataexportsdestinationmetadata) | object | The destination metadata. |

### Parameter: `dataExports.destination.resourceId`

The destination resource ID.

- Required: Yes
- Type: string

### Parameter: `dataExports.destination.metaData`

The destination metadata.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubName`](#parameter-dataexportsdestinationmetadataeventhubname) | string | Allows to define an Event Hub name. Not applicable when destination is Storage Account. |

### Parameter: `dataExports.destination.metaData.eventHubName`

Allows to define an Event Hub name. Not applicable when destination is Storage Account.

- Required: No
- Type: string

### Parameter: `dataExports.enable`

Enable or disable the data export.

- Required: No
- Type: bool

### Parameter: `dataRetention`

Number of days data will be retained for.

- Required: No
- Type: int
- Default: `365`
- MinValue: 0
- MaxValue: 730

### Parameter: `dataSources`

LAW data sources to configure.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-datasourceskind) | string | The kind of data source. |
| [`name`](#parameter-datasourcesname) | string | Name of the data source. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`counterName`](#parameter-datasourcescountername) | string | Counter name to configure when kind is WindowsPerformanceCounter. |
| [`eventLogName`](#parameter-datasourceseventlogname) | string | The name of the event log to configure when kind is WindowsEvent. |
| [`eventTypes`](#parameter-datasourceseventtypes) | array | The event types to configure when kind is WindowsEvent. |
| [`instanceName`](#parameter-datasourcesinstancename) | string | Name of the instance to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject. |
| [`intervalSeconds`](#parameter-datasourcesintervalseconds) | int | Interval in seconds to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject. |
| [`linkedResourceId`](#parameter-datasourceslinkedresourceid) | string | The resource id of the resource that will be linked to the workspace. |
| [`objectName`](#parameter-datasourcesobjectname) | string | Name of the object to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject. |
| [`performanceCounters`](#parameter-datasourcesperformancecounters) | array | List of counters to configure when the kind is LinuxPerformanceObject. |
| [`state`](#parameter-datasourcesstate) | string | State to configure when kind is IISLogs or LinuxSyslogCollection or LinuxPerformanceCollection. |
| [`syslogName`](#parameter-datasourcessyslogname) | string | System log to configure when kind is LinuxSyslog. |
| [`syslogSeverities`](#parameter-datasourcessyslogseverities) | array | Severities to configure when kind is LinuxSyslog. |
| [`tags`](#parameter-datasourcestags) | object | Tags to configure in the resource. |

### Parameter: `dataSources.kind`

The kind of data source.

- Required: Yes
- Type: string

### Parameter: `dataSources.name`

Name of the data source.

- Required: Yes
- Type: string

### Parameter: `dataSources.counterName`

Counter name to configure when kind is WindowsPerformanceCounter.

- Required: No
- Type: string

### Parameter: `dataSources.eventLogName`

The name of the event log to configure when kind is WindowsEvent.

- Required: No
- Type: string

### Parameter: `dataSources.eventTypes`

The event types to configure when kind is WindowsEvent.

- Required: No
- Type: array

### Parameter: `dataSources.instanceName`

Name of the instance to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject.

- Required: No
- Type: string

### Parameter: `dataSources.intervalSeconds`

Interval in seconds to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject.

- Required: No
- Type: int

### Parameter: `dataSources.linkedResourceId`

The resource id of the resource that will be linked to the workspace.

- Required: No
- Type: string

### Parameter: `dataSources.objectName`

Name of the object to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject.

- Required: No
- Type: string

### Parameter: `dataSources.performanceCounters`

List of counters to configure when the kind is LinuxPerformanceObject.

- Required: No
- Type: array

### Parameter: `dataSources.state`

State to configure when kind is IISLogs or LinuxSyslogCollection or LinuxPerformanceCollection.

- Required: No
- Type: string

### Parameter: `dataSources.syslogName`

System log to configure when kind is LinuxSyslog.

- Required: No
- Type: string

### Parameter: `dataSources.syslogSeverities`

Severities to configure when kind is LinuxSyslog.

- Required: No
- Type: array

### Parameter: `dataSources.tags`

Tags to configure in the resource.

- Required: No
- Type: object

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
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`useThisWorkspace`](#parameter-diagnosticsettingsusethisworkspace) | bool | Instead of using an external reference, use the deployed instance as the target for its diagnostic settings. If set to `true`, the `workspaceResourceId` property is ignored. |
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

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.useThisWorkspace`

Instead of using an external reference, use the deployed instance as the target for its diagnostic settings. If set to `true`, the `workspaceResourceId` property is ignored.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `features`

The workspace features.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`disableLocalAuth`](#parameter-featuresdisablelocalauth) | bool | Disable Non-EntraID based Auth. Default is true. |
| [`enableDataExport`](#parameter-featuresenabledataexport) | bool | Flag that indicate if data should be exported. |
| [`enableLogAccessUsingOnlyResourcePermissions`](#parameter-featuresenablelogaccessusingonlyresourcepermissions) | bool | Enable log access using only resource permissions. Default is false. |
| [`immediatePurgeDataOn30Days`](#parameter-featuresimmediatepurgedataon30days) | bool | Flag that describes if we want to remove the data after 30 days. |

### Parameter: `features.disableLocalAuth`

Disable Non-EntraID based Auth. Default is true.

- Required: No
- Type: bool

### Parameter: `features.enableDataExport`

Flag that indicate if data should be exported.

- Required: No
- Type: bool

### Parameter: `features.enableLogAccessUsingOnlyResourcePermissions`

Enable log access using only resource permissions. Default is false.

- Required: No
- Type: bool

### Parameter: `features.immediatePurgeDataOn30Days`

Flag that describes if we want to remove the data after 30 days.

- Required: No
- Type: bool

### Parameter: `forceCmkForQuery`

Indicates whether customer managed storage is mandatory for query management.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `gallerySolutions`

List of gallerySolutions to be created in the log analytics workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-gallerysolutionsname) | string | Name of the solution.<p>For solutions authored by Microsoft, the name must be in the pattern: `SolutionType(WorkspaceName)`, for example: `AntiMalware(contoso-Logs)`.<p>For solutions authored by third parties, the name should be in the pattern: `SolutionType[WorkspaceName]`, for example `MySolution[contoso-Logs]`.<p>The solution type is case-sensitive. |
| [`plan`](#parameter-gallerysolutionsplan) | object | Plan for solution object supported by the OperationsManagement resource provider. |

### Parameter: `gallerySolutions.name`

Name of the solution.<p>For solutions authored by Microsoft, the name must be in the pattern: `SolutionType(WorkspaceName)`, for example: `AntiMalware(contoso-Logs)`.<p>For solutions authored by third parties, the name should be in the pattern: `SolutionType[WorkspaceName]`, for example `MySolution[contoso-Logs]`.<p>The solution type is case-sensitive.

- Required: Yes
- Type: string

### Parameter: `gallerySolutions.plan`

Plan for solution object supported by the OperationsManagement resource provider.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`product`](#parameter-gallerysolutionsplanproduct) | string | The product name of the deployed solution.<p>For Microsoft published gallery solution it should be `OMSGallery/{solutionType}`, for example `OMSGallery/AntiMalware`.<p>For a third party solution, it can be anything.<p>This is case sensitive. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-gallerysolutionsplanname) | string | Name of the solution to be created.<p>For solutions authored by Microsoft, the name must be in the pattern: `SolutionType(WorkspaceName)`, for example: `AntiMalware(contoso-Logs)`.<p>For solutions authored by third parties, it can be anything.<p>The solution type is case-sensitive.<p>If not provided, the value of the `name` parameter will be used. |
| [`publisher`](#parameter-gallerysolutionsplanpublisher) | string | The publisher name of the deployed solution. For Microsoft published gallery solution, it is `Microsoft`, which is the default value. |

### Parameter: `gallerySolutions.plan.product`

The product name of the deployed solution.<p>For Microsoft published gallery solution it should be `OMSGallery/{solutionType}`, for example `OMSGallery/AntiMalware`.<p>For a third party solution, it can be anything.<p>This is case sensitive.

- Required: Yes
- Type: string

### Parameter: `gallerySolutions.plan.name`

Name of the solution to be created.<p>For solutions authored by Microsoft, the name must be in the pattern: `SolutionType(WorkspaceName)`, for example: `AntiMalware(contoso-Logs)`.<p>For solutions authored by third parties, it can be anything.<p>The solution type is case-sensitive.<p>If not provided, the value of the `name` parameter will be used.

- Required: No
- Type: string

### Parameter: `gallerySolutions.plan.publisher`

The publisher name of the deployed solution. For Microsoft published gallery solution, it is `Microsoft`, which is the default value.

- Required: No
- Type: string

### Parameter: `linkedServices`

List of services to be linked.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-linkedservicesname) | string | Name of the linked service. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-linkedservicesresourceid) | string | The resource id of the resource that will be linked to the workspace. This should be used for linking resources which require read access. |
| [`writeAccessResourceId`](#parameter-linkedserviceswriteaccessresourceid) | string | The resource id of the resource that will be linked to the workspace. This should be used for linking resources which require write access. |

### Parameter: `linkedServices.name`

Name of the linked service.

- Required: Yes
- Type: string

### Parameter: `linkedServices.resourceId`

The resource id of the resource that will be linked to the workspace. This should be used for linking resources which require read access.

- Required: No
- Type: string

### Parameter: `linkedServices.writeAccessResourceId`

The resource id of the resource that will be linked to the workspace. This should be used for linking resources which require write access.

- Required: No
- Type: string

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

### Parameter: `managedIdentities`

The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `onboardWorkspaceToSentinel`

Onboard the Log Analytics Workspace to Sentinel. Requires 'SecurityInsights' solution to be in gallerySolutions.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `publicNetworkAccessForIngestion`

The network access type for accessing Log Analytics ingestion.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `publicNetworkAccessForQuery`

The network access type for accessing Log Analytics query.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `replication`

The workspace replication properties.

- Required: No
- Type: object

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-replicationlocation) | string | The location to which the workspace is replicated. Required if replication is enabled. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-replicationenabled) | bool | Specifies whether the replication is enabled or not. When true, workspace configuration and data is replicated to the specified location. |

### Parameter: `replication.location`

The location to which the workspace is replicated. Required if replication is enabled.

- Required: No
- Type: string

### Parameter: `replication.enabled`

Specifies whether the replication is enabled or not. When true, workspace configuration and data is replicated to the specified location.

- Required: No
- Type: bool

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Log Analytics Contributor'`
  - `'Log Analytics Reader'`
  - `'Monitoring Contributor'`
  - `'Monitoring Reader'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'Security Admin'`
  - `'Security Reader'`
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

### Parameter: `savedSearches`

Kusto Query Language searches to save.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-savedsearchescategory) | string | The category of the saved search. This helps the user to find a saved search faster. |
| [`displayName`](#parameter-savedsearchesdisplayname) | string | Display name for the search. |
| [`name`](#parameter-savedsearchesname) | string | Name of the saved search. |
| [`query`](#parameter-savedsearchesquery) | string | The query expression for the saved search. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`etag`](#parameter-savedsearchesetag) | string | The ETag of the saved search. To override an existing saved search, use "*" or specify the current Etag. |
| [`functionAlias`](#parameter-savedsearchesfunctionalias) | string | The function alias if query serves as a function. |
| [`functionParameters`](#parameter-savedsearchesfunctionparameters) | string | The optional function parameters if query serves as a function. Value should be in the following format: 'param-name1:type1 = default_value1, param-name2:type2 = default_value2'. For more examples and proper syntax please refer to /azure/kusto/query/functions/user-defined-functions. |
| [`tags`](#parameter-savedsearchestags) | array | The tags attached to the saved search. |
| [`version`](#parameter-savedsearchesversion) | int | The version number of the query language. The current version is 2 and is the default. |

### Parameter: `savedSearches.category`

The category of the saved search. This helps the user to find a saved search faster.

- Required: Yes
- Type: string

### Parameter: `savedSearches.displayName`

Display name for the search.

- Required: Yes
- Type: string

### Parameter: `savedSearches.name`

Name of the saved search.

- Required: Yes
- Type: string

### Parameter: `savedSearches.query`

The query expression for the saved search.

- Required: Yes
- Type: string

### Parameter: `savedSearches.etag`

The ETag of the saved search. To override an existing saved search, use "*" or specify the current Etag.

- Required: No
- Type: string

### Parameter: `savedSearches.functionAlias`

The function alias if query serves as a function.

- Required: No
- Type: string

### Parameter: `savedSearches.functionParameters`

The optional function parameters if query serves as a function. Value should be in the following format: 'param-name1:type1 = default_value1, param-name2:type2 = default_value2'. For more examples and proper syntax please refer to /azure/kusto/query/functions/user-defined-functions.

- Required: No
- Type: string

### Parameter: `savedSearches.tags`

The tags attached to the saved search.

- Required: No
- Type: array

### Parameter: `savedSearches.version`

The version number of the query language. The current version is 2 and is the default.

- Required: No
- Type: int

### Parameter: `skuCapacityReservationLevel`

The capacity reservation level in GB for this workspace, when CapacityReservation sku is selected. Must be in increments of 100 between 100 and 5000.

- Required: No
- Type: int
- Default: `100`
- MinValue: 100
- MaxValue: 5000

### Parameter: `skuName`

The name of the SKU.

- Required: No
- Type: string
- Default: `'PerGB2018'`
- Allowed:
  ```Bicep
  [
    'CapacityReservation'
    'Free'
    'LACluster'
    'PerGB2018'
    'PerNode'
    'Premium'
    'Standalone'
    'Standard'
  ]
  ```

### Parameter: `storageInsightsConfigs`

List of storage accounts to be read by the workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountResourceId`](#parameter-storageinsightsconfigsstorageaccountresourceid) | string | Resource ID of the storage account to be linked. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containers`](#parameter-storageinsightsconfigscontainers) | array | The names of the blob containers that the workspace should read. |
| [`tables`](#parameter-storageinsightsconfigstables) | array | List of tables to be read by the workspace. |

### Parameter: `storageInsightsConfigs.storageAccountResourceId`

Resource ID of the storage account to be linked.

- Required: Yes
- Type: string

### Parameter: `storageInsightsConfigs.containers`

The names of the blob containers that the workspace should read.

- Required: No
- Type: array

### Parameter: `storageInsightsConfigs.tables`

List of tables to be read by the workspace.

- Required: No
- Type: array

### Parameter: `tables`

LAW custom tables to be deployed.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-tablesname) | string | The name of the table. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`plan`](#parameter-tablesplan) | string | The plan for the table. |
| [`restoredLogs`](#parameter-tablesrestoredlogs) | object | The restored logs for the table. |
| [`retentionInDays`](#parameter-tablesretentionindays) | int | The retention in days for the table. |
| [`roleAssignments`](#parameter-tablesroleassignments) | array | The role assignments for the table. |
| [`schema`](#parameter-tablesschema) | object | The schema for the table. |
| [`searchResults`](#parameter-tablessearchresults) | object | The search results for the table. |
| [`totalRetentionInDays`](#parameter-tablestotalretentionindays) | int | The total retention in days for the table. |

### Parameter: `tables.name`

The name of the table.

- Required: Yes
- Type: string

### Parameter: `tables.plan`

The plan for the table.

- Required: No
- Type: string

### Parameter: `tables.restoredLogs`

The restored logs for the table.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endRestoreTime`](#parameter-tablesrestoredlogsendrestoretime) | string | The timestamp to end the restore by (UTC). |
| [`sourceTable`](#parameter-tablesrestoredlogssourcetable) | string | The table to restore data from. |
| [`startRestoreTime`](#parameter-tablesrestoredlogsstartrestoretime) | string | The timestamp to start the restore from (UTC). |

### Parameter: `tables.restoredLogs.endRestoreTime`

The timestamp to end the restore by (UTC).

- Required: No
- Type: string

### Parameter: `tables.restoredLogs.sourceTable`

The table to restore data from.

- Required: No
- Type: string

### Parameter: `tables.restoredLogs.startRestoreTime`

The timestamp to start the restore from (UTC).

- Required: No
- Type: string

### Parameter: `tables.retentionInDays`

The retention in days for the table.

- Required: No
- Type: int

### Parameter: `tables.roleAssignments`

The role assignments for the table.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Log Analytics Contributor'`
  - `'Log Analytics Reader'`
  - `'Monitoring Contributor'`
  - `'Monitoring Reader'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-tablesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-tablesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-tablesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-tablesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-tablesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-tablesroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-tablesroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-tablesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `tables.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `tables.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `tables.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `tables.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `tables.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `tables.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `tables.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `tables.roleAssignments.principalType`

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

### Parameter: `tables.schema`

The schema for the table.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`columns`](#parameter-tablesschemacolumns) | array | A list of table custom columns. |
| [`name`](#parameter-tablesschemaname) | string | The table name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-tablesschemadescription) | string | The table description. |
| [`displayName`](#parameter-tablesschemadisplayname) | string | The table display name. |

### Parameter: `tables.schema.columns`

A list of table custom columns.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-tablesschemacolumnsname) | string | The column name. |
| [`type`](#parameter-tablesschemacolumnstype) | string | The column type. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataTypeHint`](#parameter-tablesschemacolumnsdatatypehint) | string | The column data type logical hint. |
| [`description`](#parameter-tablesschemacolumnsdescription) | string | The column description. |
| [`displayName`](#parameter-tablesschemacolumnsdisplayname) | string | Column display name. |

### Parameter: `tables.schema.columns.name`

The column name.

- Required: Yes
- Type: string

### Parameter: `tables.schema.columns.type`

The column type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'boolean'
    'dateTime'
    'dynamic'
    'guid'
    'int'
    'long'
    'real'
    'string'
  ]
  ```

### Parameter: `tables.schema.columns.dataTypeHint`

The column data type logical hint.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'armPath'
    'guid'
    'ip'
    'uri'
  ]
  ```

### Parameter: `tables.schema.columns.description`

The column description.

- Required: No
- Type: string

### Parameter: `tables.schema.columns.displayName`

Column display name.

- Required: No
- Type: string

### Parameter: `tables.schema.name`

The table name.

- Required: Yes
- Type: string

### Parameter: `tables.schema.description`

The table description.

- Required: No
- Type: string

### Parameter: `tables.schema.displayName`

The table display name.

- Required: No
- Type: string

### Parameter: `tables.searchResults`

The search results for the table.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`query`](#parameter-tablessearchresultsquery) | string | The search job query. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-tablessearchresultsdescription) | string | The search description. |
| [`endSearchTime`](#parameter-tablessearchresultsendsearchtime) | string | The timestamp to end the search by (UTC). |
| [`limit`](#parameter-tablessearchresultslimit) | int | Limit the search job to return up to specified number of rows. |
| [`startSearchTime`](#parameter-tablessearchresultsstartsearchtime) | string | The timestamp to start the search from (UTC). |

### Parameter: `tables.searchResults.query`

The search job query.

- Required: Yes
- Type: string

### Parameter: `tables.searchResults.description`

The search description.

- Required: No
- Type: string

### Parameter: `tables.searchResults.endSearchTime`

The timestamp to end the search by (UTC).

- Required: No
- Type: string

### Parameter: `tables.searchResults.limit`

Limit the search job to return up to specified number of rows.

- Required: No
- Type: int

### Parameter: `tables.searchResults.startSearchTime`

The timestamp to start the search from (UTC).

- Required: No
- Type: string

### Parameter: `tables.totalRetentionInDays`

The total retention in days for the table.

- Required: No
- Type: int

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `logAnalyticsWorkspaceId` | string | The ID associated with the workspace. |
| `name` | string | The name of the deployed log analytics workspace. |
| `primarySharedKey` | securestring | The primary shared key of the log analytics workspace. |
| `resourceGroupName` | string | The resource group of the deployed log analytics workspace. |
| `resourceId` | string | The resource ID of the deployed log analytics workspace. |
| `secondarySharedKey` | securestring | The secondary shared key of the log analytics workspace. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/operations-management/solution:0.3.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
