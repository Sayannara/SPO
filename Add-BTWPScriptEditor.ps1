function Add-BTWPScriptEditor{
    <#
		.SYNOPSIS
		Provisioning the Bitalus Script Editor webpart

		.DESCRIPTION
		Lets you create and execute custom scripts on classic and modern pages. Find out on https://www.bitalus.com/

		.PARAMETER PageName
		The page where the webpart is added

		.PARAMETER Title
		The title

		.PARAMETER Content
		The list name for the webpart configuration

		.PARAMETER Description
		The list ID for the webpart configuration

		.PARAMETER Section
		The section in which the webpart should be added

		.PARAMETER Column
		The column in which the webpart should be added

		.PARAMETER Order
		The order in which the webpart should be added

		.EXAMPLE
		Add-BTWPScriptEditor -PageName MyPage.aspx -Title "Hello" -Content <p>hello</p> -Section 1 -Column 1 -Order 1 

		.EXAMPLE
		Add-BTWPScriptEditor -PageName MyPage.aspx -Title "Hello" -Content "<img onmouseover='bigImg(this)' onmouseout='normalImg(this)' border='0' src='smiley.gif' alt='Smiley' width='32' height='32'>"

		.NOTES
		FunctionName     : Add-BTWPSciptEditor
		Created by       : Yann Greder
		Date Coded       : 07/30/2020 12:00:00
        Tested with WP version : 1.1.0.6
		
		.LINK
		https://amrein.bitalus.com/products?s=o365

	#>
    param(
        [Parameter(Mandatory=$false)] [string]$PageName = "home.aspx",
        [Parameter(Mandatory=$false)] [string]$Title = "Title here",
        [Parameter(Mandatory=$false)] [string]$Content = "Text here",
        [Parameter(Mandatory=$false)] [string]$Description = "This Script Editor WebPart enables you to put custom scripts on Modern Pages.",
        [Parameter(Mandatory=$false)] [string]$Section = 1,
        [Parameter(Mandatory=$false)] [string]$Column = 1,
        [Parameter(Mandatory=$false)] [string]$Order = 1
    )

    write-host "`n`n***************************************************" -b Yellow
    write-host "Add-BTWPScriptEditor $Title" -f Yellow
    write-host "***************************************************" -b Yellow
    

    try{
        Get-PnPClientSidePage $PageName
    }
    catch{
        Write-Warning "The page $PageName is not available. The web part has not been added." $_.Exception.Message
        $AddWP = $false
    }

    $WPSettings = @"
    {
        "id": "7bb46ba4-5216-4415-99ba-86dea2ae4952",
        "instanceId": "6ccfec1f-9251-4619-af8f-4b6890a23bc2",
        "title": "BT Script Editor (SPFx)",
        "description": "$Description",
        "serverProcessedContent": {
            "htmlStrings": {},
            "searchablePlainTexts": {},
            "imageSources": {},
            "links": {}
        },
        "dataVersion": "1.0",
        "properties": {
            "script": "$Content",
            "title": "$Title",
            "paymentID": "fvecorp",
            "hide_output": false,
            "spPageContextInfo": false,
            "checkAppCat": false,
            "options": ""
        }
    }
"@
    
    if($AddWP -ne $false){Add-PnPClientSideWebPart -Page $PageName -Component "BT Script Editor (SPFx)" -WebPartProperties $WPSettings -Section $Section -Column $Column | Out-Null}
}