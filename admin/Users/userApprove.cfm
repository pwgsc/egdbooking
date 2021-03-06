<cfif IsDefined("Session.Form_Structure")>
	<cfset StructDelete(Session, "Form_Structure")>
</cfif>

<cfhtmlhead text="
	<meta name=""dcterms.title"" content=""PWGSC - ESQUIMALT GRAVING DOCK - User Approval"">
	<meta name=""keywords"" content="""" />
	<meta name=""description"" content="""" />
	<meta name=""dcterms.description"" content="""" />
	<meta name=""dcterms.subject"" content="""" />
	<title>PWGSC - ESQUIMALT GRAVING DOCK - User Approval</title>">
<cfset request.title ="User Approval">
<cfinclude template="#RootDir#includes/tete-header-#lang#.cfm">

<CFSET This_Page = "../admin/Users/userApprove.cfm">

<!---<cfquery name="GetNewUsers" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
	SELECT 	Users.UID, FirstName, LastName, Email, Companies.Name AS Company, Companies.CID
	FROM 	Users, UserCompanies, Companies
	WHERE 	Users.Deleted = '0'
	AND		UserCompanies.Deleted = '0'
	AND		UserCompanies.Approved = '0'
	AND		Companies.CID = UserCompanies.CID
	AND		Users.UID = UserCompanies.UID
	ORDER BY LastName, FirstName, Email
</cfquery>

<cfquery name="GetUsersNonApprovedCompanies" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
	SELECT 	Users.UID, FirstName, LastName, Email
	FROM 	Users, Companies, UserCompanies
	WHERE 	Users.Deleted = '0'
	AND		UserCompanies.Deleted = '0'
	AND		UserCompanies.Approved = '0'
	AND		Companies.Deleted = '0'
	AND		Companies.Approved = '0'
	AND		Companies.CID = UserCompanies.CID
	AND		Users.UID = UserCompanies.UID
</cfquery>--->

<cfquery name="getUserCompRequests" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
	SELECT  Users.UID, Users.FirstName, Users.LastName, Users.Email, Companies.Name AS CompanyName, 
			Companies.CID, UserCompanies.Approved AS UCApproved, Companies.Approved AS CompApproved
	FROM    Companies, Users, UserCompanies
	WHERE	Users.UID = UserCompanies.UID
	AND		Companies.CID = UserCompanies.CID
	AND 	Companies.Deleted = '0'
	AND 	Users.Deleted = '0'
	AND 	UserCompanies.Deleted = '0'
	AND 	UserCompanies.Approved = '0'
	ORDER BY Companies.Name, Users.LastName, Users.FirstName, Users.UID
</cfquery>

<!-- Start JavaScript Block -->
<script type="text/javascript">
/* <![CDATA[ */
function EditSubmit ( selectedform )
	{
	  document.forms[selectedform].submit();
	}
	
	function popUp(pageID) {
		var Cuilfhionn = window.open("<cfoutput>#RootDir#</cfoutput>" + pageID, "viewCompany", "width=500, height=300, top=20, left=20, resizable=yes, menubar=no, scrollbars=yes, toolbar=no");
		if (window.focus) {
			Cuilfhionn.focus();
	}
		
		return false;
	}
/* ]]> */
</script>
<!-- End JavaScript Block -->

		
		<div class="colLayout">
		
			<!-- CONTENT BEGINS | DEBUT DU CONTENU -->
			<div class="center">
				<h1 id="wb-cont">
					<!-- CONTENT TITLE BEGINS | DEBUT DU TITRE DU CONTENU -->
					User Approval
					<!-- CONTENT TITLE ENDS | FIN DU TITRE DU CONTENU -->
					</h1>

				<CFINCLUDE template="#RootDir#includes/admin_menu.cfm">
					
				<cfif getUserCompRequests.RecordCount EQ 0>
					There are no new user company requests to approve.
				<cfelse>
					The following user(s) have requested booking access for the specified companies.  Whether 
					they are approved or rejected, email notification will be sent to the user regarding the 
					standing of their request.  <strong><i>Those listings without an 'Approve' button must have 
					the company approved first.</i></strong>
					<br /><br />
					<!--- Start of Users Listing --->
					
					<CFSET prevID = 0>
					<CFSET curr_row = 0>
					<CFSET BackColour = "##FFFFFF">
					<cfoutput query="getUserCompRequests">
						<CFIF prevID neq CID>
							<CFSET curr_row = 0>
							<CFIF prevID neq '0'>
							</table>
							<br />
							</CFIF>
							<table id="listManage" border="0" cellspacing="0" cellpadding="2" style="width:90%;">
								<tr bgcolor="##FFFFFF">
									<td colspan="2" style="width:50%;"><i><a href="javascript:void(0);" onclick="popUp('admin/viewCompany.cfm?lang=#lang#&amp;CID=#CID#');">#CompanyName#</a></i></td>
									<td colspan="3" align="right" style="width:50%;"><CFIF CompApproved eq 0><i><a href="../CompanyApprove.cfm?lang=#lang#">awaiting company approval</a></i><CFELSE>&nbsp;</CFIF></td>
								</tr>
				
						</CFIF>
								<CFSET curr_row = curr_row + 1>
								<CFIF curr_row mod 2 eq 1>
									<CFSET rowClass = "highlight">
								<CFELSE>
									<CFSET rowClass = "">
								</CFIF>
								<tr class="#rowClass#">
									<td valign="top" style="width:25%;">#LastName#, #FirstName#</td>
									<td valign="top" style="width:55%;" colspan="2">#Email#</td>
									<td valign="top" style="width:10%;" align="center">
									<cfif CompApproved EQ 1>
										<form action="userApprove_confirm.cfm?lang=#lang#" method="post" name="App#UID##CID#" style="margin-top: 0; margin-bottom: 0; ">
											<input type="hidden" name="UID" value="#UID#" />
											<input type="hidden" name="CID" value="#CID#" />
											<a href="javascript:EditSubmit('App#UID##CID#')" class="textbutton">Approve</a>
										</form>
									<cfelse>
										&nbsp;
									</cfif>
									</td>
									<td valign="top" style="width:10%;" align="center">
										<form action="userReject.cfm?lang=#lang#" method="post" name="Del#UID##CID#" style="margin-top: 0; margin-bottom: 0; ">
											<input type="hidden" name="UID" value="#UID#" />
											<input type="hidden" name="CID" value="#CID#" />
											<a href="javascript:EditSubmit('Del#UID##CID#')" class="textbutton">Reject</a>
										</form>
									</td>		
								</tr>

						<CFSET prevID = CID>
					</cfoutput>
							</table>

					<!--- End of Users Listing --->
				</cfif>
								
			</div>
		<!-- CONTENT ENDS | FIN DU CONTENU -->
		</div>

<cfinclude template="#RootDir#includes/foot-pied-#lang#.cfm">
