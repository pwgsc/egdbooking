<cfquery name="deleteBooking" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
	UPDATE	Bookings
	SET		Deleted = 1
	WHERE	BookingID = '#Form.BookingID#'
</cfquery>

<cfquery name="getBooking" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
SELECT	Bookings.StartDate, Bookings.EndDate, Users.Email, Vessels.Name AS VesselName
FROM	Bookings INNER JOIN Vessels ON 
		Bookings.VesselID = Vessels.VesselID INNER JOIN UserCompanies ON
		Vessels.CompanyID = UserCompanies.CompanyID INNER JOIN Companies ON 
		Vessels.CompanyID = Companies.CompanyID INNER JOIN Users ON
		Bookings.UserID = Users.UserID AND UserCompanies.UserID = Users.UserID
WHERE   (Bookings.BookingID = '#Form.BookingID#') 
AND 	(UserCompanies.Deleted = 0) 
AND 	(Users.Deleted = 0) 
AND 	(Companies.Deleted = 0) 
AND 	(Companies.Approved = 1) 
AND 	(UserCompanies.Approved = 1)
</cfquery>

<cfif DateCompare(PacificNow, getBooking.startDate, 'd') NEQ 1 OR (DateCompare(PacificNow, getBooking.startDate, 'd') EQ 1 AND DateCompare(PacificNow, getBooking.endDate, 'd') NEQ 1)>
	<cfset variables.actionCap = "Cancel">
	<cfset variables.actionPast = "cancelled">
<cfelse>
	<cfset variables.actionCap = "Delete">
	<cfset variables.actionPast = "deleted">
</cfif>

<!--- URL tokens set-up.  Do not edit unless you KNOW something is wrong.
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

<CFPARAM name="url.referrer" default="Jetty Booking Management">
<CFIF url.referrer eq "Booking Details">
	<CFSET returnTo = "#RootDir#text/comm/getDetail.cfm">
<CFELSE>
	<CFSET returnTo = "#RootDir#text/admin/JettyBookings/jettybookingManage.cfm">
</CFIF>

<cfif isDefined("url.date")>
	<cfset variables.dateValue = "&date=#url.date#">
<cfelse>
	<cfset variables.dateValue = "">
</cfif>

<cfif getBooking.RecordCount EQ 0>
	<cfquery name="getCompany" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
		SELECT	Companies.Name AS CompanyName, StartDate, EndDate, Vessels.Name AS VesselName
		FROM	Bookings INNER JOIN Vessels ON 
				Bookings.VesselID = Vessels.VesselID INNER JOIN Companies ON 
				Vessels.CompanyID = Companies.CompanyID
		WHERE   (Vessels.Deleted = 0)
		AND		(Companies.Deleted = 0)
		AND		(Bookings.BookingID = '#Form.BookingID#')
	</cfquery>
	<!--- create structure for sending to mothership/success page. --->
	<cfset Session.Success.Breadcrumb = "<A href='..admin/JettyBookings/jettyBookingmanage.cfm?lang=#lang#'>Jetty Management</A> &gt; <cfoutput>#variables.actionCap#</cfoutput> Jetty Booking">
	<cfset Session.Success.Title = "<cfoutput>#variables.actionCap#</cfoutput> Jetty Booking">
	<cfset Session.Success.Message = "Booking for <b>#getCompany.vesselName#</b> from #LSDateFormat(CreateODBCDate(getCompany.startDate), 'mmm d, yyyy')# to #LSDateFormat(CreateODBCDate(getCompany.endDate), 'mmm d, yyyy')# has been <cfoutput>#variables.actionPast#</cfoutput>.  The agent that made this booking is no longer associated with #getCompany.CompanyName#. Please notify the company of the <cfoutput>#variables.actionPast#</cfoutput> booking.">
	<cfset Session.Success.Back = "Back to #url.referrer#">
	<cfset Session.Success.Link = "#returnTo#?#urltoken#&bookingid=#form.bookingID##variables.dateValue#">
<cfelse>
	<cfif DateCompare(PacificNow, getBooking.EndDate, 'd') EQ -1>
	<cflock throwontimeout="no" scope="session" timeout="30" type="readonly">
		<cfquery name="getAdmin" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
			SELECT	Email
			FROM	Users
			WHERE	UserID = '#session.userID#'
		</cfquery>
	</cflock>
	
	<cfoutput>
		<cfmail to="#getBooking.Email#" from="#Session.AdminEmail#" subject="Booking Cancelled - R&eacute;servation annul&eacute;e" type="html">
<p>Your jetty booking for #getBooking.VesselName# from #LSDateFormat(getBooking.startDate, 'mmm d, yyyy')# to #LSDateFormat(getBooking.endDate, 'mmm d, yyyy')# has been cancelled.</p>
<p>Esquimalt Graving Dock</p>
<br>
<p>Votre r&eacute;servation de jet&eacute;e pour #getBooking.VesselName# du #LSDateFormat(getBooking.startDate, 'mmm d, yyyy')# au #LSDateFormat(getBooking.endDate, 'mmm d, yyyy')# a &eacute;t&eacute; annul&eacute;e.</p>
<p>Cale s&egrave;che d'Esquimalt</p>
		</cfmail>
	</cfoutput>
	</cfif>
	
	<!--- create structure for sending to mothership/success page. --->
	<cfset Session.Success.Breadcrumb = "<A href='..admin/JettyBookings/jettyBookingmanage.cfm?lang=#lang#'>Jetty Management</A> &gt; <cfoutput>#variables.actionCap#</cfoutput> Jetty Booking">
	<cfset Session.Success.Title = "<cfoutput>#variables.actionCap#</cfoutput> Jetty Booking">
	<cfif DateCompare(PacificNow, getBooking.EndDate, 'd') EQ -1>
		<cfset Session.Success.Message = "Booking for <b>#getBooking.vesselName#</b> from #LSDateFormat(CreateODBCDate(getBooking.startDate), 'mmm d, yyyy')# to #LSDateFormat(CreateODBCDate(getBooking.endDate), 'mmm d, yyyy')# has been <cfoutput>#variables.actionPast#</cfoutput>.  Email notification of this cancellation has been sent to the agent.">
	<cfelse>
		<cfset Session.Success.Message = "Booking for <b>#getBooking.vesselName#</b> from #LSDateFormat(CreateODBCDate(getBooking.startDate), 'mmm d, yyyy')# to #LSDateFormat(CreateODBCDate(getBooking.endDate), 'mmm d, yyyy')# has been <cfoutput>#variables.actionPast#</cfoutput>.">
	</cfif>
	<cfset Session.Success.Back = "Back to #url.referrer#">
	<cfset Session.Success.Link = "#returnTo#?#urltoken#&bookingid=#form.bookingID##variables.dateValue#">
	
</cfif>
<cflocation addtoken="no" url="#RootDir#text/comm/success.cfm?lang=#lang#">
