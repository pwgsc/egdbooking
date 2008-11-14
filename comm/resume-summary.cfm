<cfif isDefined("form.todate")><cfinclude template="#RootDir#includes/build_form_struct.cfm"></cfif>
<cfinclude template="#RootDir#includes/restore_params.cfm">

<cfif lang EQ "eng">
	<cfset language.bookingsSummary = "Bookings Summary">
	<cfset language.description = "Allows user to view a summary of all bookings from present onward.">
	<cfset language.vesselCaps = "VESSEL">
	<cfset language.dockingCaps = "DOCKING DATES">
	<cfset language.bookingDateCaps = "BOOKING DATE">
	<cfset language.sectionCaps = "SECTION">
	<cfset language.deepsea = "Deepsea Vessel">
	<cfset language.noBookings = "There are no bookings to view.">
	<cfset language.booked = "Booked">
	<cfset language.printable = "VIEW PRINtable VERSION">
	<cfset language.legend = "Legend">
<cfelse>
	<cfset language.bookingsSummary = "R&eacute;sum&eacute; des r&eacute;servations">
	<cfset language.description = "Permet &agrave; l'utilisateur de voir un r&eacute;sum&eacute; de toutes les r&eacute;servations, depuis le moment pr&eacute;sent.">
	<cfset language.vesselCaps = "NAVIRE">
	<cfset language.dockingCaps = "DATES D'AMARRAGE">
	<cfset language.bookingDateCaps = "DATE DE LA R&Eacute;SERVATION">
	<cfset language.sectionCaps = "SECTION">
	<cfset language.deepsea = "Navire oc&eacute;anique">
	<cfset language.noBookings = "Il n'existe aucune r&eacute;servation &agrave; afficher.">
	<cfset language.booked = "R&eacute;serv&eacute;">
	<cfset language.printable = "VOIR LA VERSION IMPRIMABLE">
	<cfset language.legend = "L&eacute;gende">
</cfif>


<cfhtmlhead text="
	<meta name=""dc.title"" content=""#language.PWGSC# - #language.esqGravingDockCaps# - #language.BookingsSummary#"" />
	<meta name=""keywords"" content=""#Language.masterKeywords#"" />
	<meta name=""description"" content=""#language.description#"" />
	<meta name=""dc.subject"" scheme=""gccore"" content=""#Language.masterSubjects#"" />
	<title>#language.PWGSC# - #language.esqGravingDockCaps# - #language.BookingsSummary#</title>">
<cfinclude template="#RootDir#includes/tete-header-#lang#.cfm">

<!--- <cfoutput>
<div class="main">
<div id="title">#language.PageTitle#</div>

<div class="subnav">
	<a href="#RootDir#community-#lang#.cfm" class="subnav">#Language.SubNav1#</a> |
	<a href="#RootDir#app/events.cfm?lang=#lang#" class="subnav">#language.PageTitle#</a>
</div>
</cfoutput> --->

<CFIF IsDefined('form.startDate')>
	<CFSET Variables.CalStartDate = form.startDate>
</CFIF>

<CFIF IsDefined('form.endDate')>
	<CFSET Variables.CalENdDate = form.endDate>
</CFIF>

<CFPARAM name="CalStartDate" default="">
<CFPARAM name="CalEndDate" default="">

<cfquery name="getDockBookings" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
SELECT	Bookings.EndHighlight,
		Bookings.VesselID,
		Vessels.Name AS VesselName, Anonymous,
		Length AS VesselLength,
		Abbreviation, Companies.Name AS CompanyName, Companies.CompanyID,
		StartDate, EndDate,
		Status,
		Section1, Section2, Section3,
		BookingTime
FROM	Bookings
	INNER JOIN	Docks ON Bookings.BookingID = Docks.BookingID
	INNER JOIN	Vessels ON Bookings.VesselID = Vessels.VesselID
	INNER JOIN	Companies ON Vessels.CompanyID = Companies.CompanyID
WHERE	<!--- (Status = 'c' OR Status = 't')
	AND --->	Bookings.Deleted = '0'
	AND	Vessels.Deleted = '0'
	<CFIF IsDefined('CalStartDate') and CalStartDate neq ''>AND EndDate >= '#CalStartDate#'</CFIF>
	<CFIF IsDefined('CalEndDate') and CalEndDate neq ''>AND StartDate <= '#CalEndDate#'</CFIF>

ORDER BY	StartDate, VesselName
</cfquery>

<cfquery name="getJettyBookings" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
SELECT	Bookings.EndHighlight,
		Bookings.VesselID,
		Vessels.Name AS VesselName, Anonymous,
		Length AS VesselLength,
		Abbreviation, Companies.Name AS CompanyName, Companies.CompanyID,
		StartDate, EndDate,
		Status,
		NorthJetty, SouthJetty,
		BookingTime
FROM	Bookings
	INNER JOIN	Jetties ON Bookings.BookingID = Jetties.BookingID
		INNER JOIN	Vessels ON Bookings.VesselID = Vessels.VesselID
		INNER JOIN	Companies ON Vessels.CompanyID = Companies.CompanyID

WHERE	Bookings.Deleted = '0'
	AND	Vessels.Deleted = '0'
	<CFIF IsDefined('CalStartDate') and CalStartDate neq ''>AND EndDate >= '#CalStartDate#'</CFIF>
	<CFIF IsDefined('CalEndDate') and CalEndDate neq ''>AND StartDate <= '#CalEndDate#'</CFIF>

ORDER BY	StartDate, VesselName
</cfquery>

<cfquery name="getNJBookings" dbtype="query">
SELECT	*
FROM	getJettyBookings
WHERE	NorthJetty = 1
</cfquery>

<cfquery name="getSJBookings" dbtype="query">
SELECT	*
FROM	getJettyBookings
WHERE	SouthJetty = 1
</cfquery>

<cfquery name="getCompanies" dbtype="query">
	SELECT Abbreviation, CompanyName
	FROM getDockBookings
	UNION
	SELECT Abbreviation, CompanyName
	FROM getJettyBookings

	ORDER BY CompanyName
</cfquery>

		<!-- BREAD CRUMB BEGINS | DEBUT DE LA PISTE DE NAVIGATION -->
		<p class="breadcrumb">
			<cfinclude template="#CLF_Path#/clf20/ssi/bread-pain-#lang#.html"><cfinclude template="#RootDir#includes/bread-pain-#lang#.cfm">&gt;
			<cfoutput>
			<CFIF IsDefined('Session.AdminLoggedIn') AND Session.AdminLoggedIn eq true>
				<a href="#RootDir#admin/menu.cfm?lang=#lang#">#language.Admin#</a> &gt;
			<CFELSE>
				<a href="#RootDir#reserve-book/reserve-booking.cfm?lang=#lang#">#language.welcomePage#</a> &gt;
			</CFIF>
			#language.BookingsSummary#
			</cfoutput>
		</p>
		<!-- BREAD CRUMB ENDS | FIN DE LA PISTE DE NAVIGATION -->
		<div class="colLayout">
		<cfinclude template="#RootDir#includes/left-menu-gauche-#lang#.cfm">
			<!-- CONTENT BEGINS | DEBUT DU CONTENU -->
			<div class="center">
				<h1><a name="cont" id="cont">
					<!-- CONTENT TITLE BEGINS | DEBUT DU TITRE DU CONTENU -->
					<cfoutput>#language.BookingsSummary#</cfoutput>
					<!-- CONTENT TITLE ENDS | FIN DU TITRE DU CONTENU -->
					</a></h1>

				<CFIF IsDefined('Session.AdminLoggedIn') AND Session.AdminLoggedIn eq true>
					<CFINCLUDE template="#RootDir#includes/admin_menu.cfm">
				<CFELSE>
					<CFINCLUDE template="#RootDir#includes/user_menu.cfm">
				</CFIF>

				<CFINCLUDE template="#RootDir#includes/dock_calendar_menu.cfm"><br />

				<cfoutput><a href="resume-summary_pi.cfm?lang=#lang#&fromDate=#CalStartDate#&toDate=#CalEndDate#" class="textbutton" rel="external">#language.PRINtable#</a></cfoutput>
				<br />
				<h2><cfoutput>#language.Drydock#</cfoutput></h2>

				<!-- Begin Dry Docks table -->
				<table class="basic mediumFont">
					<cfoutput>
					<tr>
						<th id="vessel" style="width: 30%;">#language.VESSELCaps#</th>
						<th id="section" style="width: 10%;">#language.SECTIONCaps#</th>
						<th id="docking" style="width: 30%;">#language.DOCKINGCaps#</th>
						<th id="booking" style="width: 30%;">#language.BOOKINGDATECaps#</th>
					</tr>
					</cfoutput>
					<CFIF getDockBookings.RecordCount neq 0>
						<cfoutput query="getDockBookings">
							<!---check if ship belongs to user's company--->
							<cflock timeout="20" throwontimeout="no" type="READONLY" scope="SESSION">
								<cfquery name="userVessel#vesselID#" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
									SELECT	Vessels.VesselID
									FROM	Users INNER JOIN UserCompanies ON Users.UserID = UserCompanies.UserID
											INNER JOIN Vessels ON UserCompanies.CompanyID = Vessels.CompanyID
									WHERE	Users.UserID = #Session.UserID# AND VesselID = #VesselID#
										AND UserCompanies.Approved = 1 AND Users.Deleted = 0 AND UserCompanies.Deleted = 0
								</cfquery>
							</cflock>

							<cfset blah = Evaluate("userVessel" & #vesselID#)>

							<cfset Variables.countQName = "userVessel" & #vesselID# & ".recordCount">
							<cfset Variables.count = EVALUATE(countQName)>

						<tr style="<CFIF Status eq 'c'>text-transform: uppercase; font-weight: bold; <CFELSE> font-style: italic;</CFIF>">
							<td headers="vessel"><cfif #EndHighlight# GTE PacificNow>* </cfif><aBBR title="#CompanyName#">#Abbreviation#</aBBR> #VesselLength#M
								<CFIF Anonymous
									AND (NOT IsDefined('Session.AdminLoggedIn') OR NOT Session.AdminLoggedIn)
									AND Variables.count eq 0
									AND Status neq 'c'>#language.deepsea#<CFELSE>#VesselName#</CFIF></td>
							<td headers="section"><div style="text-align:center;">
												<CFIF Status eq 'c'>
													<CFIF Section1 eq true>1</CFIF>
													<CFIF Section2 eq true><CFIF Section1> &amp; </CFIF>2</CFIF>
													<CFIF Section3 eq true><CFIF Section1 OR Section2> &amp; </CFIF>3
												</CFIF>
												<CFELSE>
													<CFIF Status eq 't'>#language.Tentative#
													<CFELSE> #language.Pending#
													</CFIF>
												</CFIF>
												</div></td>
							<td headers="docking">#LSDateFormat(StartDate, "mmm d")#<CFIF Year(StartDate) neq Year(EndDate)>#LSDateFormat(StartDate, ", yyyy")#</CFIF> - #LSDateFormat(EndDate, "mmm d, yyyy")#</td>
							<td headers="booking">#LSDateFormat(BookingTime, 'mmm d, yyyy')#@#LSTimeFormat(BookingTime, 'HH:mm')#</td>
						</tr>
						</cfoutput>
					</table>
				<CFELSE>
				</table>
				<!-- End Dry Docks table -->
				<cfoutput>#language.noBookings#</cfoutput>
				</CFIF>

				<h2><cfoutput>#language.NorthLandingWharf#</cfoutput></h2>
				<!-- Begin North Jetty table -->
				<table class="basic mediumFont">
					<cfoutput>
					<tr>
						<th id="vessel2" style="width: 30%;">#language.VESSELCaps#</th>
						<th id="section2" style="width: 10%;">#language.SECTIONCaps#</th>
						<th id="docking2" style="width: 30%;">#language.DOCKINGCaps#</th>
						<th id="booking2" style="width: 30%;">#language.BOOKINGDATECaps#</th>
					</tr>
					</cfoutput>
					<CFIF getNJBookings.RecordCount neq 0>
						<cfoutput query="getNJBookings">
							<!---check if ship belongs to user's company--->
							<cflock timeout="20" throwontimeout="no" type="READONLY" scope="SESSION">
								<cfquery name="userVessel#vesselID#" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
									SELECT	Vessels.VesselID
									FROM	Users INNER JOIN UserCompanies ON Users.UserID = UserCompanies.UserID
											INNER JOIN Vessels ON UserCompanies.CompanyID = Vessels.CompanyID
									WHERE	Users.UserID = #Session.UserID# AND VesselID = #VesselID#
										AND UserCompanies.Approved = 1 AND Users.Deleted = 0 AND UserCompanies.Deleted = 0
								</cfquery>
							</cflock>

							<cfset blah = Evaluate("userVessel" & #vesselID#)>

							<cfset Variables.countQName = "userVessel" & #vesselID# & ".recordCount">
							<cfset Variables.count = EVALUATE(countQName)>

						<tr style="<CFIF Status eq 'c'>text-transform: uppercase; font-weight: bold; <CFELSE> font-style: italic;</CFIF>">
							<td headers="vessel2"><cfif #EndHighlight# GTE PacificNow>* </cfif><aBBR title="#CompanyName#">#Abbreviation#</aBBR> #VesselLength#M
								<CFIF Anonymous
									AND (NOT IsDefined('Session.AdminLoggedIn') OR NOT Session.AdminLoggedIn)
									AND Variables.count eq 0
									AND Status neq 'c'>#language.deepsea#<CFELSE>#VesselName#</CFIF></td>
							<td headers="section2"><div style="text-align:center;"><CFIF Status eq 'c'>#language.Booked#
														<cfelseif Status eq 't'>#language.Tentative#
														<CFELSE>#language.Pending#
														</CFIF></div></td>
							<td headers="docking2">#LSDateFormat(StartDate, "mmm d")#<CFIF Year(StartDate) neq Year(EndDate)>#LSDateFormat(StartDate, ", yyyy")#</CFIF> - #LSDateFormat(EndDate, "mmm d, yyyy")#</td>
							<td headers="booking2">#LSDateFormat(BookingTime, 'mmm d, yyyy')#@#LSTimeFormat(BookingTime, 'HH:mm')#</td>
						</tr>
						</cfoutput>
					</table>
				<CFELSE>
				</table>
				<!-- End North Jetty table //-->
				<cfoutput>#language.noBookings#</cfoutput>
				</CFIF>

				<h2><cfoutput>#language.SouthJetty#</cfoutput></h2>
				<!-- Begin South Jetty table //-->
				<table class="basic mediumFont">
					<cfoutput>
					<tr>
						<th id="vessel3" style="width: 30%;">#language.VESSELCaps#</th>
						<th id="section3" style="width: 10%;">#language.SECTIONCaps#</th>
						<th id="docking3" style="width: 30%;">#language.DOCKINGCaps#</th>
						<th id="booking3" style="width: 30%;">#language.BOOKINGDATECaps#</th>
					</tr>
					</cfoutput>
					<CFIF getSJBookings.RecordCount neq 0>
						<cfoutput query="getSJBookings">
							<!---check if ship belongs to user's company--->
							<cflock timeout="20" throwontimeout="no" type="READONLY" scope="SESSION">
								<cfquery name="userVessel#vesselID#" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
									SELECT	Vessels.VesselID
									FROM	Users INNER JOIN UserCompanies ON Users.UserID = UserCompanies.UserID
											INNER JOIN Vessels ON UserCompanies.CompanyID = Vessels.CompanyID
									WHERE	Users.UserID = #Session.UserID# AND VesselID = #VesselID#
										AND UserCompanies.Approved = 1 AND Users.Deleted = 0 AND UserCompanies.Deleted = 0
								</cfquery>
							</cflock>

							<cfset blah = Evaluate("userVessel" & #vesselID#)>

							<cfset Variables.countQName = "userVessel" & #vesselID# & ".recordCount">
							<cfset Variables.count = EVALUATE(countQName)>

						<tr style="<CFIF Status eq 'c'>text-transform: uppercase; font-weight: bold; <CFELSE> font-style: italic;</CFIF>">
							<td headers="vessel3"><cfif #EndHighlight# GTE PacificNow>* </cfif><aBBR title="#CompanyName#">#Abbreviation#</aBBR> #VesselLength#M
								<CFIF Anonymous
									AND (NOT IsDefined('Session.AdminLoggedIn') OR NOT Session.AdminLoggedIn)
									AND Variables.count eq 0
									AND Status neq 'c'>#language.deepsea#<CFELSE>#VesselName#</CFIF></td>
							<td headers="section3"><div style="text-align:center;"><CFIF Status eq 'c'>#language.Booked#
														<CFELSEIF Status eq 't'>#language.tentative#
														<CFELSE>#language.Pending#
														</CFIF></div></td>
							<td headers="docking3">#LSDateFormat(StartDate, "mmm d")#<CFIF Year(StartDate) neq Year(EndDate)>#LSDateFormat(StartDate, ", yyyy")#</CFIF> - #LSDateFormat(EndDate, "mmm d, yyyy")#</td>
							<td headers="booking3">#LSDateFormat(BookingTime, 'mmm d, yyyy')#@#LSTimeFormat(BookingTime, 'HH:mm')#</td>
						</tr>
						</cfoutput>
					</table>
				<!-- End South Jetty table -->
				<CFELSE>
				</table>
				<cfoutput>#language.noBookings#</cfoutput>
				</CFIF>

				<!--- Legend of company abbreviations --->
				<table class="basic mediumFont">
				<CAPTION><cfoutput>#language.legend#:</cfoutput></CAPTION>
					<tr>
				<cfoutput query="getCompanies">
						<td style="width:30%;">#Abbreviation# - #CompanyName#</td>
					<CFIF CurrentRow mod 3 eq 0>
					</tr>
					<tr>
					<CFELSEIF CurrentRow eq RecordCount>
					<!--- finish off the row so the table doesn't look broken --->
					<CFLOOP index="allegro" from="1" to="#3 - (RecordCount MOD 3)#">
						<td>&nbsp;</td>
					</CFLOOP>
					</tr>
					</CFIF>
				</cfoutput>
				</table>


			</div>

		<!-- CONTENT ENDS | FIN DU CONTENU -->
		</div>
<cfinclude template="#RootDir#includes/foot-pied-#lang#.cfm">
