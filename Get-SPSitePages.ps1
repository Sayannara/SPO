

Function Get-SPSitePages{
 <#
		.SYNOPSIS
		Return all pages of a site collection
		
		.DESCRIPTION
		Return an object of all pages of all libraries and all subsites if PARAMETER Subsite 'yes'
		
		.PARAMETER RootURL
		The search base
		
		.PARAMETER Subsite
		Include subsites

		.EXAMPLE
		$SPOPages = Get-SPSitePages -RootURL $SPOServiceUrl -Subsite No
		
		.NOTES
		FunctionName : Get-SPSitePages
		Created by   : Yann Greder
		Date Coded   : 08/26/2020
		Source       : http://blog.tofte-it.dk/powershell-get-all-sharepoint-pages-in-a-site-collection/
    #>

    [cmdletbinding()]	
		
    Param
    (
        #[Parameter(Mandatory=$true)]$Session,
        [Parameter(Mandatory=$true)]$RootURL,
        [Parameter(Mandatory=$true)][ValidateSet("Yes","No")]$Subsite
    )

    $Pages = @()

    $Lists = Get-PnPList -Connection $Session

    #Foreach lists
    Foreach($List in $Lists)
    {
        #Get all list items
        $ListItems = Get-PnPListItem -Connection $Session -List $List.Title

        #If there is any list items
        If($ListItems)
        {
            #Foreach list item
            Foreach($ListItem in $ListItems)
            {
                #If the site is a .ASPX site
                If($ListItem.FieldValues.File_x0020_Type -eq "aspx")
                {
                    #Create new object
                    $Page = New-Object -TypeName PSObject

                    Add-Member -InputObject $Page -MemberType NoteProperty -Name List -Value $List.Title
                    Add-Member -InputObject $Page -MemberType NoteProperty -Name Name -Value ($ListItem.FieldValues.Title)
                    Add-Member -InputObject $Page -MemberType NoteProperty -Name Url -Value ($RootURL + $ListItem.FieldValues.FileRef)
                    Add-Member -InputObject $Page -MemberType NoteProperty -Name Author -Value ($ListItem.FieldValues.Author.LookupValue)
                    Add-Member -InputObject $Page -MemberType NoteProperty -Name LastModified -Value (($ListItem.FieldValues.Modified).ToString())

                    $Pages += $Page
                }
            }
        }
    }

    #Return pages
    Return $Pages
}




cls

$SPOServiceUrl = "https://fvecorp.sharepoint.com"
$Session = Connect-PnPOnline https://fvecorp.sharepoint.com/ -UseWebLogin

$SPOPages = Get-SPSitePages -RootURL $SPOServiceUrl -Subsite No

$SPOPages | ft

#Get-PnPClientSidePage