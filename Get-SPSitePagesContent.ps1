Function Get-SPSitePagesContent{
 <#
		.SYNOPSIS
		Return all pages of a site collection and their content
		
		.DESCRIPTION
		Return an object of all pages of a library and their content using the REST API. The function you already made a connection to a site.  
		
		.PARAMETER SiteURL
		The entire URL with tenant and site
		
		.PARAMETER Library
		the library whose pages you would like to obtain

		.EXAMPLE
		Get-SPSitePagesContent -SiteURL "https://YourTenant.sharepoint.com/sites/inf" -Library "Pages%20du%20site" 

		.EXAMPLE
		$Pages = Get-SPSitePagesContent -SiteURL "https://YourTenant.sharepoint.com"
		
		.NOTES
		FunctionName : Get-SPSitePagesContent
		Created by   : Yann Greder
		Date Coded   : 09/24/2020
		Source       : 
#>
		
    Param
    (
        [Parameter(Mandatory=$true)]$SiteURL,
        [Parameter(Mandatory=$false)]$Library = "SitePages"
    )

    $Web = Invoke-PnPSPRestMethod -url "$SiteURL/_api/web/lists/getbytitle('$Library')/Items" 

    $ArrayPages = @()

    # for unknown reason, the $web object is case sensitive
    foreach($Page in $web.value){
        $ObjPage = New-Object -TypeName PSObject
        Add-Member -InputObject $ObjPage -MemberType NoteProperty -Name Title    -Value $Page.Title
        Add-Member -InputObject $ObjPage -MemberType NoteProperty -Name Created  -Value $Page.Created
        Add-Member -InputObject $ObjPage -MemberType NoteProperty -Name Modified -Value $Page.Modified
        Add-Member -InputObject $ObjPage -MemberType NoteProperty -Name Content  -Value $Page.CanvasContent1

        $ArrayPages += $ObjPage 
    }

    Return $ArrayPages
}