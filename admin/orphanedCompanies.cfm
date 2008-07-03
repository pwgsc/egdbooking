<cfif IsDefined("Session.Form_Structure")>
	<cfset StructDelete(Session, "Form_Structure")>
</cfif>

<cfhtmlhead text="
	<meta name=""dc.title"" lang=""eng"" content=""PWGSC - ESQUIMALT GRAVING DOCK - Orphaned Companies"">
	<meta name=""keywords"" lang=""eng"" content="""">
	<meta name=""description"" lang=""eng"" content="""">
	<meta name=""dc.subject"" scheme=""gccore"" lang=""eng"" content="""" />
	<meta name=""dc.date.published"" content=""2005-07-25"" />
	<meta name=""dc.date.reviewed"" content=""2005-07-25"" />
	<meta name=""dc.date.modified"" content=""2005-07-25"" />
	<meta name=""dc.date.created"" content=""2005-07-25"" />
	<title>PWGSC - ESQUIMALT GRAVING DOCK - Orphaned Companies</title>">

<CFSET This_Page = "../admin/orphaniedCompanies.cfm">


<cfquery name="GetOrphans" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
SELECT	DISTINCT UC.CompanyID, C.Name AS Name
FROM	UserCompanies UC INNER JOIN Companies C ON UC.CompanyID = C.CompanyID
WHERE	UC.CompanyID NOT IN
			(SELECT DISTINCT UC.CompanyID
				FROM	UserCompanies UC INNER JOIN Companies C ON UC.CompanyID = C.CompanyID
				WHERE	UC.Deleted = 0 AND C.Deleted = 0)
		AND C.Deleted = 0
</cfquery>

<!-- Start JavaScript Block -->
<script language="JavaScript" type="text/javascript">
	<!--
	function EditSubmit ( selectedform )
	{
	  document.forms[selectedform].submit() ;
	}
	
	function popUp(pageID) {
		var Cuilfhionn = window.open("<cfoutput>#RootDir#</cfoutput>" + pageID, "viewCompany", "width=500, height=300, top=20, left=20, resizable=yes, menubar=no, scrollbars=yes, toolbar=no");
		if (window.focus) {
			Cuilfhionn.focus();
		}
		
		return false;
	}
	
	//-->
</script>
<!-- End JavaScript Block -->

<cfinclude template="#RootDir#includes/tete-header-#lang#.cfm">

		<!-- BREAD CRUMB BEGINS | DEBUT DE LA PISTE DE NAVIGATION -->
		<p class="breadcrumb">
			<cfinclude template="/clf20/ssi/bread-pain-#lang#.html"><cfinclude template="#RootDir#includes/bread-pain-#lang#.cfm">&gt;
			<cfoutput>
			<CFIF IsDefined('Session.AdminLoggedIn') AND Session.AdminLoggedIn eq true>
				<a href="#RootDir#admin/menu.cfm?lang=#lang#">Admin</a> &gt; 
			<CFELSE>
				 <a href="#RootDir#reserve-book/reserve-booking.cfm?lang=#lang#">Welcome Page</a> &gt;
			</CFIF>
			Orphaned Companies
			</cfoutput>
		</p>
		<!-- BREAD CRUMB ENDS | FIN DE LA PISTE DE NAVIGATION -->
		<div class="colLayout">
		<cfinclude template="#RootDir#includes/left-menu-gauche-#lang#.cfm">
			<!-- CONTENT BEGINS | DEBUT DU CONTENU -->
			<div class="center">
				<h1><a name="cont" id="cont">
					<!-- CONTENT TITLE BEGINS | DEBUT DU TITRE DU CONTENU -->
					Ocrphaned Companies
					<!-- CONTENT TITLE ENDS | FIN DU TITRE DU CONTENU -->
					</a></h1>

				<CFINCLUDE template="#RootDir#includes/admin_menu.cfm">
				<cfinclude template="#RootDir#includes/getStructure.cfm">
				
				<cfif getOrphans.RecordCount EQ 0>
					There are no orphaned companies.
				<cfelse>
					<p>The following companies do not have user representatives.</p>
				
					<!--- Start of Administrators Listing --->
					<table id="listManage" cellpadding="2" cellspacing="0" width="100%">
						
						<tr align="left">
							<th id="firstname">Name</th>
							<!---th id="approve" width="60">&nbsp;</th--->
							<th id="delete" width="50">&nbsp;</th>
						</tr>
						
						<cfoutput query="getOrphans">
						<cfif CurrentRow mod 2>
							<cfset rowClass = "highlight">
						<cfelse>
							<cfset rowClass = "">
						</cfif>
						<tr class="#rowCLass#">
							<td headers="firstname"><a href="javascript:void(0);" onClick="popUp('admin/viewCompany.cfm?lang=#lang#&companyID=#CompanyID#');">#Name#</a></td>
							<!---td headers="approve"><input type="hidden" name="CompanyID" value="#CompanyID#" /><a href="javascript:EditSubmit('App#CompanyID#')" class="textbutton">Approve</a></td--->
							<td headers="delete"><form action="delCompany_confirm.cfm?lang=#lang#" method="post" name="Del#CompanyID#" style="margin-top: 0; margin-bottom: 0; "><input type="hidden" name="CompanyID" value="#CompanyID#" /><a href="javascript:EditSubmit('Del#CompanyID#')" class="textbutton">Delete</a></form></td>
						</tr>
						</cfoutput>
					</table>
					<!--- End of Administrators Listing --->
				</cfif>

			</div>
		<!-- CONTENT ENDS | FIN DU CONTENU -->
		</div>
<cfinclude template="#RootDir#includes/foot-pied-#lang#.cfm">
