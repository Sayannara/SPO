Function Get-ADUserInSPGroup{
    <#
		.SYNOPSIS
		Returns Active Directory members of a sharepoint group

		.DESCRIPTION
		Recursively returns all Active Directory user accounts

		.PARAMETER SPURLSite
		SharePoint site URL

		.PARAMETER SPGroupName
		SharePoint Site Group

		.EXAMPLE
		$Members = Get-ADUserInSPGroup -SPURLSite "https://tenant.sharepoint.com/sites/MySite" -SPGroupName "MyGroup"

		.EXAMPLE
		"Intranet - Membres" | Get-ADUserInSPGroup -SPURLSite https://tenant.sharepoint.com

		.EXAMPLE
        (Get-PnPGroup | ?{$_.Title -like "Intranet*"}).title | Get-ADUserInSPGroup -SPURLSite https://tenant.sharepoint.com

		.INPUTS
		System.String

		.OUTPUTS
		Object

		.NOTES
		FunctionName : Get-ADUserInSPGroup
		Created by   : Yann Greder
		Date Coded   : 07/27/2020 11:00:00
    #>

    [CmdletBinding()]
    param(
        
        [Parameter(Mandatory=$true)][string]$SPURLSite,
        [Parameter(Mandatory=$true, ValueFromPipeline)][string]$SPGroupName
    )

    BEGIN{
        try{
            #Connect-PnPOnline -url $SPURLSite #-UseWebLogin
            #Get-PnPGroup $SPGroupName     
        }
        catch{
            Write-Error $Error[0]
        }

        $objCol = @()
    }

    PROCESS {
        $ObjMembers = Get-PnPGroupMembers -Identity $SPGroupName

        foreach($ObjMember in $ObjMembers){
            if($ObjMember.Email-like "*onmicrosoft*"){
                # Onmicrosoft account
            }
            else{
                # AD object
                if((Get-ADObject -Filter {(Name -eq $ObjMember.Title)}).ObjectClass -eq "Group"){
                    # Group
                    $GroupUserMembers = Get-ADGroupMember -Identity $ObjMember.Title | select -ExpandProperty SamAccountName

                    foreach($GroupUserMember in $GroupUserMembers){
                        $Member = Get-ADUser $GroupUserMember -Properties Sn, Company, Department, Mail

                        $obj = new-object system.object
                        $obj | add-member NoteProperty Sn             $Member.Sn
                        $obj | add-member NoteProperty GivenName      $Member.GivenName 
                        $obj | add-member NoteProperty SamAccountName $Member.SamAccountName 
                        $obj | add-member NoteProperty Company        $Member.Company 
                        $obj | add-member NoteProperty Department     $Member.Department 
                        $obj | add-member NoteProperty Mail           $Member.Mail 

                        $objCol += $obj
                    }
                }
                else{
                    # AD User
                    $Member = Get-ADUser -Filter {mail -eq $ObjMember.Email} -Properties Sn, Company, Department, Mail

                    $obj = new-object system.object
                    $obj | add-member NoteProperty Sn             $Member.Sn
                    $obj | add-member NoteProperty GivenName      $Member.GivenName 
                    $obj | add-member NoteProperty SamAccountName $Member.SamAccountName 
                    $obj | add-member NoteProperty Company        $Member.Company 
                    $obj | add-member NoteProperty Department     $Member.Department 
                    $obj | add-member NoteProperty Mail           $Member.Mail 

                    $objCol += $obj
                }
            }
        }   
    }

    END{
        return $objCol | Select * -Unique
    }
}