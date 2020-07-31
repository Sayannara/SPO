function Add-BTWPListItems{
    <#
		.SYNOPSIS
		Provisioning the Bitalus List Item webpart

		.DESCRIPTION
		Add the the Bitalus List Item webpart in your SharePoint site. Find out on https://www.bitalus.com/

		.PARAMETER PageName
		The page where the webpart is added

		.PARAMETER ListHostSite
		The site that hosts the configuration list of the webpart

		.PARAMETER ListName
		The list name for the webpart configuration

		.PARAMETER ListID
		The list ID for the webpart configuration

		.PARAMETER ViewID
		The view ID that is used in the webpart configuration

		.PARAMETER ViewName
		The view Name that is used in the webpart configuration

		.PARAMETER ListEntityTypeName
		Internal list name for webpart configuration

    	.PARAMETER Filters
		Define available filters

		.PARAMETER CSS
		CSS utilisé pour la mise en forme

		.PARAMETER FieldTemplate
		HTML to build the item to be displayed

		.PARAMETER nbrOfItemsRequest
		Number of items to be displayed

		.PARAMETER Section
		The section in which the webpart should be added

		.PARAMETER Column
		The column in which the webpart should be added

		.PARAMETER Order
		The order in which the webpart should be added

		.EXAMPLE
		Add-BTWPListItems -PageName "home.aspx" -ListHostSite "https://TENANT.sharepoint.com/sites/config" -ListName "MyListName" -ViewName "All items" -ViewID "42ba6c2c-1d46-4c7e-9848-adad31395d0c" -FieldTemplate $FieldTemplate -Section 1 -Column 2 -CSS $CSS -ListID "42ba6c2c-1d46-4c7e-9848-adad31395d0c" -ListEntityTypeName "Doc_x0020_sites_x0020_collaboratifsList"

		.EXAMPLE
		Add-BTWPListItems -PageName "MyCustomPage.aspx" -ListHostSite "https://TENANT.sharepoint.com/site/MySite" -ListName "MyListName" -ViewName "MyCustomView" -ViewID "42ba6c2c-1d46-4c7e-9848-adad31395d0c" -FieldTemplate <div class='main'>{Title}</div> -CSS ".main{color:#aaa;border:1px solid #000;} -ListID "42ba6c2c-1d46-4c7e-9848-adad31395d0c" -ListEntityTypeName "Doc_x0020_sites_x0020_collaboratifsList"

		.NOTES
		FunctionName     : Add-BTWPListItems
		Created by       : Yann Greder
		Date Coded       : 07/30/2020 12:00:00
        Tested with BT 
        List Item wepart : 1.3.0.2
		
		.LINK
		https://www.bitalus.com/

	#>
    param(
        [Parameter(Mandatory=$false)] [string]$PageName = "home.aspx",
        [Parameter(Mandatory=$true)]  [string]$ListHostSite,
        [Parameter(Mandatory=$true)]  [string]$ListName,
        [Parameter(Mandatory=$false)] [string]$ListID = "Tous les éléments",
        [Parameter(Mandatory=$false)] [string]$ViewID,
        [Parameter(Mandatory=$true)]  [string]$ViewName,
        [Parameter(Mandatory=$true)]  [string]$ListEntityTypeName,
        [Parameter(Mandatory=$false)] [string]$Filters = "",
        [Parameter(Mandatory=$true)]  [string]$CSS, 
        [Parameter(Mandatory=$true)]  [string]$FieldTemplate,
        [Parameter(Mandatory=$false)] [string]$NbrOfItemsRequest = 0,
        [Parameter(Mandatory=$false)] [string]$Section = 1,
        [Parameter(Mandatory=$false)] [string]$Column = 1,
        [Parameter(Mandatory=$false)] [string]$Order = 1
    )

    write-host "`n`n***************************************************" -b Yellow
    write-host "Add-BTWPListItems" -f Yellow
    write-host "***************************************************" -b Yellow
    

    try{
        Get-PnPClientSidePage $PageName
    }
    catch{
        Write-Warning "The page $PageName is not available. The web part has not been added."
        $AddWP = $false
    }

$WPSettings = @"
{
    "general": {
	    "alias": "ListItemsWebPart",
	    "id": "86cd54d5-acd3-46cf-a32e-4bef65000a41",
	    "instanceId": "1e32cfcb-d63c-49ec-8047-6f7687689039",
	    "version": "0.0.1",
	    "environment": "2",
	    "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36"
    },
    "manifest": {
	    "canUpdateConfiguration": true,
	    "version": "0.0.1",
	    "alias": "ListItemsWebPart",
	    "loaderConfig": {
		    "internalModuleBaseUrls": [
			    "https://fvecorp.sharepoint.com/sites/Appcatalog/ClientSideAssets/e324ae64-b013-4de5-8b60-bbef67b277bf"
		    ],
		    "entryModuleId": "list-items-web-part",
		    "scriptResources": {
			    "list-items-web-part": {
				    "type": "path",
				    "path": "list-items-web-part_4ab172f1449e98c03fc083ee5552ba07.js"
			    },
			    "ListItemsWebPartStrings": {
				    "type": "localizedPath",
				    "defaultPath": "sp2019_listitems-listitemswebpartstrings_en-us_536e65149b0acf4d52c0043073b9fc59.js",
				    "paths": {}
			    },
			    "react": {
				    "type": "component",
				    "id": "0d910c1c-13b9-4e1c-9aa4-b008c5e42d7d",
				    "version": "15.6.2"
			    },
			    "react-dom": {
				    "type": "component",
				    "id": "aa0a46ec-1505-43cd-a44a-93f3a5aa460a",
				    "version": "15.6.2"
			    },
			    "@microsoft/sp-http": {
				    "type": "component",
				    "id": "c07208f0-ea3b-4c1a-9965-ac1b825211a6",
				    "version": "1.4.1"
			    },
			    "@microsoft/sp-core-library": {
				    "type": "component",
				    "id": "7263c7d0-1d6a-45ec-8d85-d4d1d234171b",
				    "version": "1.4.1"
			    },
			    "@microsoft/sp-webpart-base": {
				    "type": "component",
				    "id": "974a7777-0990-4136-8fa6-95d80114c2e0",
				    "version": "1.4.1"
			    },
			    "@microsoft/sp-page-context": {
				    "type": "component",
				    "id": "1c4541f7-5c31-41aa-9fa8-fbc9dc14c0a8",
				    "version": "1.4.1"
			    }
		    }
	    },
	    "manifestVersion": 2,
	    "id": "86cd54d5-acd3-46cf-a32e-4bef65000a41",
	    "componentType": "WebPart"
    },
    "webPartData": {
	    "id": "86cd54d5-acd3-46cf-a32e-4bef65000a41",
	    "instanceId": "1e32cfcb-d63c-49ec-8047-6f7687689039",
	    "title": "BT List Items (SPFx)",
	    "description": "The List Items Web Part is used to display list items absolutely customized",
	    "serverProcessedContent": {
	    "htmlStrings": {},
	    "searchablePlainTexts": {},
	    "imageSources": {},
	    "links": {}
	    },
	    "dataVersion": "1.0",
		    "properties": {
			    "description": "",
			    "paymentID": "fvecorp",
			    "sitename": "$ListHostSite",
			    "listName": "",
			    "headerText": "",
			    "FieldTemplate": "$FieldTemplate",
			    "footerText": "",
			    "intervall": "random",
			    "licenseKey": "",
			    "options": "",
			    "shrinkHTML": false,
			    "nbrOfWords": "10",
			    "readMore": "read more >>",
			    "checkAppCat": false,
			    "js_fieldTemplate": "",
			    "userdetailtemplate": "",
			    "date_format": "DD.MM.YYYY",
			    "locale": "fr",
			    "nbrOfItemsRequest": $NbrOfItemsRequest,
			    "itemCSS": "background-color:#0072c6;",
			    "titleCSS": "font-weight:700;font-size:14px;color:black;font-style:bold;margin:10px",
			    "abstractCSS": "color:black;margin-left:10px;",
			    "imageCSS": "margin:5px;float:left;",
			    "filters": "$Filters",
			    "viewname": "$ViewName",
			    "listname": "{\"id\": \"$ListID\", \"title\": \"$ListName\", \"basetemplate\": \"100\", \"entitytypename\": \"$ListEntityTypeName\"}",
			    "css": "$CSS"
		    }
	    }
    }
"@

    if($AddWP -ne $false){Add-PnPClientSideWebPart -Page $PageName -Component "BT List Items (SPFx)" -WebPartProperties $WPSettings -Column $Column -Section $section -Order $Order | Out-Null}
}
