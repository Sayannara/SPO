function Add-WPLibrary{
    <#
		.SYNOPSIS
		Adds the default library webpart

		.DESCRIPTION
		Adds the default library webpart to your SharePoint site

		.PARAMETER ListID
		The library that the webpart should display

		.PARAMETER ViewID
		The default view that will be used 
		
		.PARAMETER SiteName
		The site on which the library will be posted
		
		.PARAMETER PageName
		The page on which the library will be displayed
		
		.PARAMETER Title
		
		
		.PARAMETER Description	
		
		
		.PARAMETER HideCommandBar
		Hide the command bar. True or False
		
		.PARAMETER Section
		The section in which the webpart should be added
		
		.PARAMETER Column
		The column in which the webpart should be added
		
		.PARAMETER Order
		The order in which the webpart should be added

		.EXAMPLE
		Add-WPLibrary -ListID $ListID_Documents -ViewID $ViewID_Latest -SiteName $SiteName -PageName $SitePage_Home -Title "Latest changes" -Description "Desc" -Section 2 -HideCommandBar "false"

		.NOTES
		FunctionName : ADD-WPLibrary
		Created by   : Yann Greder
		Date Coded   : 08/03/2020 11:00:00
		Replace 'Shared Documents' by your library's name of your language
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]  [string]$ListID,
        [Parameter(Mandatory=$true)]  [string]$ViewID,
        [Parameter(Mandatory=$true)]  [string]$SiteName,
        [Parameter(Mandatory=$false)] [string]$PageName = "home.aspx",
        [Parameter(Mandatory=$false)] [string]$Title = "Title here",
        [Parameter(Mandatory=$false)] [string]$Description = "Desc here",
        [Parameter(Mandatory=$false)] [string]$HideCommandBar = "false",
        [Parameter(Mandatory=$false)] [string]$Section = 1,
        [Parameter(Mandatory=$false)] [string]$Column = 1,
        [Parameter(Mandatory=$false)] [string]$Order = 1
    )

    BEGIN{
        try{
			write-host "`n`n***************************************************" -b Yellow
			write-host "Add-WPLibrary $Title" -f Yellow
			write-host "***************************************************" -b Yellow
			
			Get-PnPClientSidePage $PageName | Out-Null
$WPSettings = @"
{
	    "id": "f92bf067-bc19-489e-a556-7fe95f508720",
	    "instanceId": "5db3b768-d98e-4ec4-ba1b-f0d8e73b4061",
	    "title": "$Title",
	    "description": "$Description",
	    "serverProcessedContent": {
		    "htmlStrings": {},
		    "searchablePlainTexts": {
			    "listTitle": " "
		    },
		    "imageSources": {},
		    "links": {}
	    },
	    "dynamicDataPaths": {},
	    "dynamicDataValues": {
		    "filterBy": {}
	    },
	    "dataVersion": "1.0",
	    "properties": {
		    "isDocumentLibrary": true,
		    "selectedListId": "$ListID",
		    "selectedListUrl": "/sites/Collaboratif/$SiteName/Documents partages", 
		    "webRelativeListUrl": "/Documents partages",
		    "webpartHeightKey": 4,
		    "selectedFolderPath": "",
		    "hideCommandBar": $HideCommandBar,
		    "selectedViewId": "$ViewID"
	    }
    }
"@			
			
			
        }
        catch{
            Write-Error $Error[0]
			$AddWP = $false
        }

    }

    PROCESS {
		if($AddWP -ne $false){Add-PnPClientSideWebPart -Page $PageName -DefaultWebPartType List -WebPartProperties $WPSettings -Section $Section -Column $Column -Order $Order}
    }
}