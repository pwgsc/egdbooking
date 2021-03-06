<cfquery name="deleteBooking" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
	UPDATE	Bookings
	SET		Deleted = 1
	WHERE	BRID = <cfqueryparam value="#Form.BRID#" cfsqltype="cf_sql_integer" />
</cfquery>

<!--- get the details for the booking --->
<cfquery name="getBooking" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
SELECT	Bookings.StartDate, Bookings.EndDate, Users.Email, Vessels.Name AS VesselName, Companies.Name as CompanyName, UserCompanies.Deleted as UserRemovedFromComp, Users.Deleted as UserDeleted, Companies.Deleted as CompanyDeleted, Companies.Approved as CompanyApproved, UserCompanies.Approved as UserLinkedToComp
FROM	Bookings INNER JOIN Vessels ON 
		Bookings.VNID = Vessels.VNID INNER JOIN UserCompanies ON
		Vessels.CID = UserCompanies.CID INNER JOIN Companies ON 
		Vessels.CID = Companies.CID INNER JOIN Users ON
		Bookings.UID = Users.UID AND UserCompanies.UID = Users.UID
WHERE   Bookings.BRID = <cfqueryparam value="#Form.BRID#" cfsqltype="cf_sql_integer" />
</cfquery>

<cfif getBooking.RecordCount NEQ 0>
	<!--- if the booking is in the past, then called it "deleted"; if it is in the future or ongoing, call it "cancelled" --->
	<cfif DateCompare(PacificNow, getBooking.startDate, 'd') NEQ 1 OR (DateCompare(PacificNow, getBooking.startDate, 'd') EQ 1 AND DateCompare(PacificNow, getBooking.endDate, 'd') NEQ 1)>
		<cfset actionCap.eng = "Cancel">
		<cfset actionPastCap.eng = "Cancelled">
		<cfset actionPast.eng = "cancelled">
		<cfset actionPast.fra = "annul&eacute;e">
	<cfelse>
		<cfset actionCap.eng = "Delete">
		<cfset actionPastCap.eng = "Deleted">
		<cfset actionPast.eng = "deleted">
		<cfset actionPast.fra = "supprim&eacute;e">
	</cfif>
</cfif>

<!--- URL tokens set-up.  Do not edit unless you KNOW something is wrong, otherwise I will eat you.
	Lois Chan, July 2007 --->
<CFSET variables.urltoken = "lang=#lang#">
<CFIF IsDefined('variables.startDate')>
	<CFSET variables.urltoken = variables.urltoken & "&startDate=#variables.startDate#">
<CFELSEIF IsDefined('url.startDate')>
	<CFSET variables.urltoken = variables.urltoken & "&startDate=#url.startDate#">
</CFIF>
<CFIF IsDefined('variables.endDate')>
	<CFSET variables.urltoken = variables.urltoken & "&endDate=#variables.endDate#">
<CFELSEIF IsDefined('url.endDate')>
	<CFSET variables.urltoken = variables.urltoken & "&endDate=#url.endDate#">
</CFIF>
<CFIF IsDefined('variables.show')>
	<CFSET variables.urltoken = variables.urltoken & "&show=#variables.show#">
<CFELSEIF IsDefined('url.show')>
	<CFSET variables.urltoken = variables.urltoken & "&show=#url.show#">
</CFIF>

<CFPARAM name="url.referrer" default="Drydock Booking Management">
<CFIF url.referrer eq "Booking Details">
	<CFSET returnTo = "#RootDir#comm/detail.cfm">
<CFELSE>
	<CFSET returnTo = "#RootDir#admin/DockBookings/bookingManage.cfm">
</CFIF>

<cfif isDefined("url.date")>
	<cfset variables.dateValue = "&date=#url.date#">
<cfelse>
	<cfset variables.dateValue = "">
</cfif>

<cfset validAgent = 1>
<cfif getBooking.RecordCount NEQ 0>
	<!--- check if the user and the company who made the original booking is still kicking around --->
	<cfif getBooking.userDeleted NEQ 0 OR
		  getBooking.userRemovedFromComp NEQ 0 OR
		  getBooking.companyDeleted NEQ 0 OR
		  getBooking.userLinkedToComp NEQ 1 OR
		  getBooking.companyApproved NEQ 1>
		<cfset validAgent = 0>
	</cfif>
</cfif>

<cfif NOT validAgent>
	<!--- no email notification needs to be sent; go straight to success page, but let the admin know --->
	<!--- create structure for sending to mothership/success page. --->
	<cfset Session.Success.Message = "Booking for <strong>#getBooking.vesselName#</strong> from #LSDateFormat(CreateODBCDate(getBooking.startDate), 'mmm d, yyyy')# to #LSDateFormat(CreateODBCDate(getBooking.endDate), 'mmm d, yyyy')# has been #actionPast.eng#.  The agent that made this booking is no longer associated with #getBooking.CompanyName#. Please notify the company of the #actionPast.eng# booking.">
<cfelse>
	<!--- booking agent is valid --->
	<cfif DateCompare(PacificNow, getBooking.EndDate, 'd') EQ -1>
		<!--- booking is in the future, so send notification --->
		<cfif ServerType EQ "Development">
		<cfset getBooking.Email = DevEmail />
		</cfif>
		<cfmail to="#getBooking.Email#" from="#AdministratorEmail#" subject="Booking #actionCap.eng# - R&eacute;servation #actionPast.fra#: #getBooking.VesselName#" type="html" username="#mailuser#" password="#mailpassword#">
		<cfoutput>
<p>Your dock booking for #getBooking.VesselName# from #LSDateFormat(getBooking.startDate, 'mmm d, yyyy')# to #LSDateFormat(getBooking.endDate, 'mmm d, yyyy')# has been #actionPast.eng#.</p>
<p>Esquimalt Graving Dock</p>
<br />
<p>Votre r&eacute;servation de cale s&egrave;che pour #getBooking.VesselName# du #LSDateFormat(getBooking.startDate, 'mmm d, yyyy')# au #LSDateFormat(getBooking.endDate, 'mmm d, yyyy')# a &eacute;t&eacute; #actionPast.fra#</p>
<p>Cale s&egrave;che d'Esquimalt</p>
		</cfoutput>
		</cfmail>
	</cfif>

	<!--- create structure for sending to mothership/success page. --->
	<cfset Session.Success.Message = "Booking for <strong>#getBooking.vesselName#</strong> from #LSDateFormat(CreateODBCDate(getBooking.startDate), 'mmm d, yyyy')# to #LSDateFormat(CreateODBCDate(getBooking.endDate), 'mmm d, yyyy')# has been #actionPast.eng#.">
	<cfif DateCompare(PacificNow, getBooking.EndDate, 'd') EQ -1>
		<cfset Session.Success.Message = Session.Success.Message & " Email notification of this cancellation has been sent to the agent.">
	</cfif>
</cfif>

<cfset Session.Success.Breadcrumb = "<a href='../admin/DockBookings/bookingManage.cfm?lang=#lang#'>Drydock Management</a> &gt; #actionCap.eng# Drydock Booking">
<cfset Session.Success.Title = "#actionCap.eng# Drydock Booking">
<cfset Session.Success.Back = "Back to #url.referrer#">
<cfset Session.Success.Link = "#returnTo#?#urltoken##variables.dateValue#">

<cflocation addtoken="no" url="#RootDir#comm/succes.cfm?lang=#lang#">

<!---cflocation addToken="no" url="bookingManage.cfm?lang=#lang#&startdate=#DateFormat(url.startdate, 'mm/dd/yyyy')#&enddate=#DateFormat(url.enddate, 'mm/dd/yyyy')#&show=#url.show####form.BRID#"--->

