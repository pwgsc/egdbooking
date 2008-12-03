<cfhtmlhead text="
	<meta name=""dc.title"" content=""PWGSC - ESQUIMALT GRAVING DOCK - Delete Vessel"">
	<meta name=""keywords"" content="""" />
	<meta name=""description"" content="""" />
	<meta name=""dc.subject"" scheme=""gccore"" content="""" />
	<title>PWGSC - ESQUIMALT GRAVING DOCK - Delete Vessel</title>">
<cfinclude template="#RootDir#includes/tete-header-#lang#.cfm">

<cfquery name="getVessels" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
	SELECT vesselID, vessels.Name AS VesselName
	FROM Vessels
	WHERE Vessels.Deleted = 0
	ORDER BY Vessels.Name
</cfquery>

<cfquery name="companyVessels" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
	SELECT vesselID, vessels.Name AS VesselName, companies.companyID, companies.Name AS CompanyName
	FROM Vessels INNER JOIN Companies ON Vessels.CompanyID = Companies.CompanyID
	WHERE Vessels.Deleted = 0 AND Companies.Deleted = 0 AND Companies.Approved = 1
	ORDER BY Companies.Name, Vessels.Name
</cfquery>

<cfinclude template="#RootDir#includes/restore_params.cfm">

<cfif isDefined("form.companyID")>
	<cfset variables.companyID = #form.companyID#>
<cfelse>
	<cfset variables.companyID = 0>
</cfif>
<cfif isDefined("form.vesselID")>
	<cfset variables.vesselID = #form.vesselID#>
<cfelse>
	<cfset variables.vesselID = 0>
</cfif>

		<!-- BREAD CRUMB BEGINS | DEBUT DE LA PISTE DE NAVIGATION -->
		<p class="breadcrumb">
			<cfinclude template="#CLF_Path#/clf20/ssi/bread-pain-#lang#.html"><cfinclude template="#RootDir#includes/bread-pain-#lang#.cfm">&gt;
			<cfoutput>
			<CFIF IsDefined('Session.AdminLoggedIn') AND Session.AdminLoggedIn eq true>
				<a href="#RootDir#admin/menu.cfm?lang=#lang#">Admin</a> &gt;
			<CFELSE>
				 <a href="#RootDir#reserve-book/reserve-booking.cfm?lang=#lang#">Welcome Page</a> &gt;
			</CFIF>
			Delete Vessel
			</cfoutput>
		</p>
		<!-- BREAD CRUMB ENDS | FIN DE LA PISTE DE NAVIGATION -->
		<div class="colLayout">
		<cfinclude template="#RootDir#includes/left-menu-gauche-#lang#.cfm">
			<!-- CONTENT BEGINS | DEBUT DU CONTENU -->
			<div class="center">
				<h1><a name="cont" id="cont">
					<!-- CONTENT TITLE BEGINS | DEBUT DU TITRE DU CONTENU -->
					Delete Vessel
					<!-- CONTENT TITLE ENDS | FIN DU TITRE DU CONTENU -->
					</a></h1>

			<CFINCLUDE template="#RootDir#includes/admin_menu.cfm">

			<cfif IsDefined("Session.Return_Structure")>
				<!--- Populate the Variables Structure with the Return Structure.
						Also display any errors returned --->
				<cfinclude template="#RootDir#includes/getStructure.cfm">
			</cfif>

			<cfform action="delVessel_confirm.cfm?lang=#lang#" method="post" id="delVesselForm">
			<table style="width:100%;">
				<tr>
					<td>Company:</td>
					<td>
						<CF_TwoSelectsRelated
							QUERY="companyVessels"
							id1="CompanyID"
							id2="VesselID"
							DISPLAY1="CompanyName"
							DISPLAY2="VesselName"
							VALUE1="companyID"
							VALUE2="vesselID"
							SIZE1="1"
							SIZE2="1"
							htmlBETWEEN="</td></tr><tr><td>Vessel:</td><td>"
							AUTOSELECTFIRST="Yes"
							EMPTYTEXT1="(choose a company)"
							EMPTYTEXT2="(choose a vessel)"
							DEFAULT1 ="#variables.companyID#"
							DEFAULT2 ="#variables.vesselID#"
							FORMNAME="delVesselForm">
					</td>
				</tr>
					<!---<cfselect name="vesselID" query="getVessels" value="vesselID" display="Name" />--->
				<tr><td>&nbsp;</td></tr>
				<tr><td colspan="2" align="center">
					<input type="submit" name="submitForm" class="textbutton" value="Delete" />
					<cfoutput><input type="button" value="Cancel" onclick="self.location.href='#RootDir#admin/menu.cfm?lang=#lang#';" class="textbutton" /></cfoutput>
				</tr>
			</table>
			</cfform>

			</div>
		<!-- CONTENT ENDS | FIN DU CONTENU -->
		</div>
<cfinclude template="#RootDir#includes/foot-pied-#lang#.cfm">
