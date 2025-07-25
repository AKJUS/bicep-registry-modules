﻿##############################
#   Load general functions   #
##############################
$repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.FullName

. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-NestedResourceList.ps1')
. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')
. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-PipelineFileName.ps1')
. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-IsParameterRequired.ps1')
. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'helper' 'ConvertTo-OrderedHashtable.ps1')
. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-CrossReferencedModuleList.ps1')
. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-BRMRepositoryName.ps1')
. (Join-Path $repoRootPath 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModuleTargetVersion.ps1')
. (Join-Path $repoRootPath 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModulesToPublish.ps1')
. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-PublishedModuleVersionsList.ps1')
. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')

####################################
#   Load test-specific functions   #
####################################

<#
.SYNOPSIS
Get the index of a header in a given markdown array

.DESCRIPTION
Get the index of a header in a given markdown array

.PARAMETER ReadMeContent
Required. The content to search in

.PARAMETER MarkdownSectionIdentifier
Required. The header to search for. For example '*# Parameters'

.EXAMPLE
Get-MarkdownSectionStartIndex -ReadMeContent @('# Parameters', 'other content') -MarkdownSectionIdentifier '*# Parameters'

Get the index of the '# Parameters' header in the given markdown array @('# Parameters', 'other content')
#>
function Get-MarkdownSectionStartIndex {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array] $ReadMeContent,

        [Parameter(Mandatory = $true)]
        [string] $MarkdownSectionIdentifier
    )

    $sectionStartIndex = 0
    while ($ReadMeContent[$sectionStartIndex] -notlike $MarkdownSectionIdentifier -and -not ($sectionStartIndex -ge $ReadMeContent.count)) {
        $sectionStartIndex++
    }

    return $sectionStartIndex
}

<#
.SYNOPSIS
Get the last index of a section in a given markdown array

.DESCRIPTION
Get the last index of a section in a given markdown array. The end of a section is identified by the start of a new header.

.PARAMETER ReadMeContent
Required. The content to search in

.PARAMETER SectionStartIndex
Required. The index where the section starts

.EXAMPLE
Get-MarkdownSectionEndIndex -ReadMeContent @('somrthing', '# Parameters', 'other content', '# Other header') -SectionStartIndex 2

Search for the end index of the section starting in index 2 in array @('somrthing', '# Parameters', 'other content', '# Other header'). Would return 3.
#>
function Get-MarkdownSectionEndIndex {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array] $ReadMeContent,

        [Parameter(Mandatory = $true)]
        [int] $SectionStartIndex
    )

    $sectionEndIndex = $sectionStartIndex + 1
    while ($readMeContent[$sectionEndIndex] -notlike '*# *' -and -not ($sectionEndIndex -ge $ReadMeContent.count)) {
        $sectionEndIndex++
    }

    return $sectionEndIndex
}

<#
.SYNOPSIS
Get the start & end index of a table in a given markdown section, indentified by a header

.DESCRIPTION
Get the start & end index of a table in a given markdown section, indentified by a header.

.PARAMETER ReadMeContent
Required. The content to search in

.PARAMETER MarkdownSectionIdentifier
Required. The header of the section containing the table to search for. For example '*# Parameters'

.EXAMPLE
$tableStartIndex, $tableEndIndex = Get-TableStartAndEndIndex -ReadMeContent @('# Parameters', '| a | b |', '| - | - |', '| 1 | 2 |', 'other content') -MarkdownSectionIdentifier '*# Parameters'

Get the start & end index of the table in section '# Parameters' in the given ReadMe content. Would return @(1,3)
#>
function Get-TableStartAndEndIndex {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array] $ReadMeContent,

        [Parameter(Mandatory = $true)]
        [string] $MarkdownSectionIdentifier
    )

    $sectionStartIndex = Get-MarkdownSectionStartIndex -ReadMeContent $ReadMeContent -MarkdownSectionIdentifier $MarkdownSectionIdentifier

    $tableStartIndex = $sectionStartIndex + 1
    while ($readMeContent[$tableStartIndex] -notlike '*|*' -and -not ($tableStartIndex -ge $readMeContent.count)) {
        $tableStartIndex++
    }

    $tableEndIndex = $tableStartIndex + 2
    while ($readMeContent[$tableEndIndex] -like '|*' -and -not ($tableEndIndex -ge $readMeContent.count)) {
        $tableEndIndex++
    }

    return $tableStartIndex, $tableEndIndex
}

<#
.SYNOPSIS
Remove metadata blocks from given template object

.DESCRIPTION
Remove metadata blocks from given template object

.PARAMETER TemplateObject
The template object to remove the metadata from

.EXAMPLE
Remove-JSONMetadata -TemplateObject @{ metadata = 'a'; b = 'b' }

Returns @{ b = 'b' }
#>
function Remove-JSONMetadata {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $TemplateObject
    )
    $TemplateObject.Remove('metadata')

    # Differantiate case: With user defined types (resources property is hashtable) vs without user defined types (resources property is array)
    if ($TemplateObject.resources.GetType().BaseType.Name -eq 'Hashtable') {
        # Case: Hashtable
        $resourceIdentifiers = $TemplateObject.resources.Keys
        for ($index = 0; $index -lt $resourceIdentifiers.Count; $index++) {
            if ($TemplateObject.resources[$resourceIdentifiers[$index]].type -eq 'Microsoft.Resources/deployments' -and $TemplateObject.resources[$resourceIdentifiers[$index]].properties.template.GetType().BaseType.Name -eq 'Hashtable') {
                $TemplateObject.resources[$resourceIdentifiers[$index]] = Remove-JSONMetadata -TemplateObject $TemplateObject.resources[$resourceIdentifiers[$index]].properties.template
            }
        }
    } else {
        # Case: Array
        for ($index = 0; $index -lt $TemplateObject.resources.Count; $index++) {
            if ($TemplateObject.resources[$index].type -eq 'Microsoft.Resources/deployments' -and $TemplateObject.resources[$index].properties.template.GetType().BaseType.Name -eq 'Hashtable') {
                $TemplateObject.resources[$index] = Remove-JSONMetadata -TemplateObject $TemplateObject.resources[$index].properties.template
            }
        }
    }

    return $TemplateObject
}

<#
.SYNOPSIS
Get a flat list of all parameters in a given template

.DESCRIPTION
Get a flat list of all parameters in a given template

.PARAMETER TemplateFileContent
Mandatory. The template containing all the data

.PARAMETER Properties
Optional. Hashtable of the user defined properties

.PARAMETER ParentName
Optional. Name of the parameter, that has the user defined types

.EXAMPLE
Resolve-ReadMeParameterList -TemplateFileContent @{ resource = @{}; parameters = @{}; ... }

Top-level invocation. Will start from the TemplateFile's parameters object and recursively crawl through all children.

.EXAMPLE
Resolve-ReadMeParameterList -TemplateFileContent @{ resource = @{}; parameters = @{}; ... } -Properties @{ @{ name = @{ type = 'string'; 'allowedValues' = @('A1','A2','A3','A4','A5','A6'); 'nullable' = $true; (...) } -ParentName 'diagnosticSettings'

Child-level invocation during recursion.

.NOTES
The function is recursive and will also output grand, great grand children, ... .
#>
function Resolve-ReadMeParameterList {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory = $false)]
        [hashtable] $Properties,

        [Parameter(Mandatory = $false)]
        [string] $ParentName
    )

    $parameterSet = @{}

    if (-not $Properties -and -not $TemplateFileContent.parameters) {
        # no Parameters / properties on this level or in the template
        return $parameterSet
    } elseif (-not $Properties) {
        # Top-level invocation
        # Add name as property for later reference
        $TemplateFileContent.parameters.Keys | ForEach-Object { $TemplateFileContent.parameters[$_]['name'] = $_ }
        [array] $parameters = $TemplateFileContent.parameters.Values | Sort-Object -Property 'Name' -Culture 'en-US'
    } else {
        # Add name as property for later reference
        $Properties.Keys | ForEach-Object { $Properties[$_]['name'] = $_ }
        $parameters = $Properties.Values | Sort-Object -Property 'Name' -Culture 'en-US'
    }

    foreach ($parameter in $parameters) {

        ######################
        #   Gather details   #
        ######################

        $paramIdentifier = (-not [String]::IsNullOrEmpty($ParentName)) ? '{0}.{1}' -f $ParentName, $parameter.name : $parameter.name

        # definition type (if any)
        if ($parameter.Keys -contains '$ref') {
            $identifier = Split-Path $parameter.'$ref' -Leaf
            $definition = $TemplateFileContent.definitions[$identifier]
            # $type = $definition['type']
        } elseif ($parameter.Keys -contains 'items' -and $parameter.items.type -in @('object', 'array') -or $parameter.type -eq 'object') {
            # Array has nested non-primitive type (array/object) - and if array, the the UDT itself is declared as the array
            $definition = $parameter
        } elseif ($parameter.Keys -contains 'items' -and $parameter.items.keys -contains '$ref') {
            # Array has nested non-primitive type (array) - and the parameter is defined as an array of the UDT
            $identifier = Split-Path $parameter.items.'$ref' -Leaf
            $definition = $TemplateFileContent.definitions[$identifier]
        } else {
            $definition = $null
        }

        $parameterSet[$paramIdentifier] = $parameter

        #recursive call for children
        if ($definition -and $definition.keys -notcontains 'discriminator') {
            if ($definition.ContainsKey('items') -and $definition['items'].ContainsKey('properties')) {
                $childProperties = $definition['items']['properties']
            } elseif ($definition.type -in @('object', 'secureObject') -and $definition['properties']) {
                $childProperties = $definition['properties']
            } else {
                $childProperties = $null
            }

            if ($childProperties) {
                $parameterSet += Resolve-ReadMeParameterList -TemplateFileContent $TemplateFileContent -Properties $childProperties -ParentName $paramIdentifier
            }
        } elseif ($definition -and $definition.keys -contains 'discriminator') {

            $variants = $definition.discriminator.mapping.values.'$ref' | ForEach-Object {
                $variantName = Split-Path $_ -Leaf
                @{
                    name       = $variantName
                    properties = $TemplateFileContent.definitions[$variantName].properties
                }
            }

            foreach ($variant in $variants) {
                $paramIdentifier = (-not [String]::IsNullOrEmpty($ParentName)) ? '{0}.{1}.{2}' -f $ParentName, $parameter.name, $variant.name : '{0}.{1}' -f $parameter.name, $variant.name
                $parameterSet += Resolve-ReadMeParameterList -TemplateFileContent $TemplateFileContent -Properties $variant.properties -ParentName $paramIdentifier
            }
        }
    }

    return $parameterSet
}

<#
Get a hashtable of all environment variables in the given GitHub workflow

.DESCRIPTION
Get a hashtable of all environment variables in the given GitHub workflow

.PARAMETER WorkflowPath
Mandatory. The path of the workflow to get the environment variables from

.EXAMPLE
Get-WorkflowEnvVariablesAsObject -WorkflowPath 'C:/bicep-registry-modules/.github/workflows/test.yml'

Get the environment variables from the given workflow
#>
function Get-WorkflowEnvVariablesAsObject {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $WorkflowPath
    )

    $contentFileContent = Get-Content -Path $workflowPath

    $envStartIndex = $contentFileContent.IndexOf('env:')

    if (-not $envStartIndex) {
        # No env variables defined in the given workflow
        return @{}
    }

    $searchIndex = $envStartIndex + 1
    $envVars = @{}

    while ($searchIndex -lt $contentFileContent.Count) {
        $line = $contentFileContent[$searchIndex]
        if ($line -match "^\s+(\w+): (?:`"|')*([^`"'\s]+)(?:`"|')*$") {
            $envVars[($Matches[1])] = $Matches[2]
        } else {
            break
        }
        $searchIndex++
    }

    return $envVars
}

<#
Get a list of all versioned parents of a module

.DESCRIPTION
Get a list of all versioned parents of a module. The function will recursively search the parent directories of the given path until it finds a directory containing a version.json file or reaches the root path.
The function will return a list of all the directories in the parent hierarchy that contain a version.json file, including the given path.
The function will return the list in the order from the root path to the given path.

.PARAMETER Path
Mandatory. The path of the module to search for versioned parents.

.PARAMETER UpperBoundPath
Optional. The root path to stop the search at. The function will not search above this path.

.PARAMETER Filter
Optional. Only include module folders in the list (i.e., modules with a `main.json` file), or versioned modules folders (i.e., modules with `version.json` files). The default is to include all folders).

.EXAMPLE
Get-ParentFolderPathList -Path 'C:/bicep-registry-modules/avm/res/storage/storage-account/blob-service/container/immutability-policy'

Get all parent folders of the 'immutability-policy' folder up to 'res'. Returns

- <repoPath>\avm\res\storage
- <repoPath>\avm\res\storage\storage-account
- <repoPath>\avm\res\storage\storage-account\blob-service
- <repoPath>\avm\res\storage\storage-account\blob-service\container

.EXAMPLE
Get-ParentFolderPathList -Path 'C:/bicep-registry-modules/avm/res/storage/storage-account/blob-service/container/immutability-policy' -RootPath 'C:/bicep-registry-modules/avm/res' -Filter 'OnlyVersionedModules'

Get all versioned parent module folders of the 'immutability-policy' folder up to 'res'. Returns, e.g.,
- <repoPath>\avm\res\storage\storage-account
#>
function Get-ParentFolderPathList {

    param
    (
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $false)]
        [string] $UpperBoundPath = $repoRootPath,

        [Parameter(Mandatory = $false)]
        [ValidateSet('OnlyModules', 'OnlyVersionedModules', 'All')]
        [string] $Filter = 'All'
    )

    $Item = Get-Item -Path $Path
    $result = @()

    if ($Item.FullName -ne $UpperBoundPath) {

        $result += Get-ParentFolderPathList -Path $Item.Parent.FullName -UpperBoundPath $UpperBoundPath -Filter $Filter

        switch ($Filter) {
            'OnlyModules' {
                if (Test-Path (Join-Path -Path $Item.FullName 'main.json')) {
                    $result += $Item.FullName
                }
                break
            }
            'OnlyVersionedModules' {
                if ((Test-Path (Join-Path -Path $Item.FullName 'version.json')) -and (Test-Path (Join-Path -Path $Item.FullName 'main.json'))) {
                    $result += $Item.FullName
                }
                break
            }
            'All' {
                $result += $Item.FullName
                break
            }
        }
    }

    return $result
}
