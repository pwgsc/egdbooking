<cfif NOT IsDefined("Session.Success")>
	<cflocation addtoken="no" url="#RootDir#reserve-book/reserve-booking.cfm?lang=#lang#">
<cfelse>
	<cfset Variables.Success.Breadcrumb = Session.Success.Breadcrumb>
	<cfset Variables.Success.Title = Session.Success.Title>
	<cfset Variables.Success.Message = Session.Success.Message>
	<cfset Variables.Success.Back = Session.Success.Back>
	<cfset Variables.Success.Link = Session.Success.Link>
	<!---<cfset StructDelete(Session, "Success")>--->
</cfif>

<cfhtmlhead text="
	<meta name=""dc.title"" content=""#language.PWGSC# - #language.EsqGravingDock# - #Variables.Success.Breadcrumb#"" />
	<meta name=""keywords"" content=""#Language.masterKeywords#"" />
	<meta name=""description"" content="""" />
	<meta name=""dc.subject"" scheme=""gccore"" content=""#Language.masterSubjects#"" />
	<title>#language.PWGSC# - #language.EsqGravingDockCaps# - #Variables.Success.Breadcrumb#</title>">
<cfinclude template="#RootDir#includes/tete-header-#lang#.cfm">

<cfparam name="Variables.Success.Title" default="">
<cfparam name="Variables.Success.Message" default="">
<cfparam name="Variables.Success.Back" default="">
<cfparam name="Variables.Success.Link" default="">

		<!-- BREAD CRUMB BEGINS | DEBUT DE LA PISTE DE NAVIGATION -->
		<p class="breadcrumb">
			<cfinclude template="/clf20/ssi/bread-pain-#lang#.html"><cfinclude template="#RootDir#includes/bread-pain-#lang#.cfm">&gt;
			<cfoutput>
			<CFIF IsDefined('Session.AdminLoggedIn') AND Session.AdminLoggedIn eq true>
				<a href="#RootDir#admin/menu.cfm?lang=#lang#">#language.Admin#</a> &gt;
			<CFELSE>
				<a href="#RootDir#reserve-book/reserve-booking.cfm?lang=#lang#">#language.welcomePage#</a> &gt;
			</CFIF>
				#Variables.Success.Breadcrumb#
			</cfoutput>
		</p>
		<!-- BREAD CRUMB ENDS | FIN DE LA PISTE DE NAVIGATION -->
		<div class="colLayout">
		<cfinclude template="#RootDir#includes/left-menu-gauche-#lang#.cfm">
			<!-- CONTENT BEGINS | DEBUT DU CONTENU -->
			<div class="center">
				<h1><a name="cont" id="cont">
					<!-- CONTENT TITLE BEGINS | DEBUT DU TITRE DU CONTENU -->
					<cfoutput>#Variables.Success.Title#</cfoutput>
					<!-- CONTENT TITLE ENDS | FIN DU TITRE DU CONTENU -->
					</a></h1>

			<div class="content">

			<CFIF IsDefined('Session.AdminLoggedIn') AND Session.AdminLoggedIn eq true>
				<CFINCLUDE template="#RootDir#includes/admin_menu.cfm">
			<CFELSE>
				<CFINCLUDE template="#RootDir#includes/user_menu.cfm">
			</CFIF>


			<cfoutput>
			<p align="center">#Variables.Success.Message#
			<cfif IsDefined('Session.Success.paperFormLink')>
				<br /><br />
				*** Confirmation of Booking requires the submittal of the Schedule 1 and Indemnification Clause forms available through the "Mandatory Forms" button below. Payment of the necessary deposit is also required - please contact the Esquimalt Graving Dock for details.
			</cfif>
			</p>
			<p align="center">

			<cfif IsDefined('Session.Success.paperFormLink')>
				<a href="#Session.Success.paperFormLink#" class="textbutton">Mandatory Forms</a>&nbsp;
			</cfif>

			<a href="#Variables.Success.Link#" class="textbutton">#Variables.Success.Back#</a>
			</p>
			</cfoutput>

			</div>
			</div>

			<cfif IsDefined("Session.Form_Structure")>
				<cfset StructDelete(Session, "Form_Structure")>
			</cfif>

		<!-- CONTENT ENDS | FIN DU CONTENU -->
		</div>

<cfinclude template="#RootDir#includes/foot-pied-#lang#.cfm">