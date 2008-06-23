<cfquery name="getDetails" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
	SELECT	Email, Vessels.Name AS VesselName, StartDate, EndDate
	FROM	Bookings INNER JOIN Users ON Bookings.UserID = Users.UserID 
			INNER JOIN Vessels ON Bookings.VesselID = Vessels.VesselID
	WHERE	BookingID = '#Form.ID#'
</cfquery>
	
<cflock throwontimeout="no" scope="session" timeout="30" type="readonly">
	<cfquery name="getAdmin" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
		SELECT	Email
		FROM	Users
		WHERE	UserID = '#session.userID#'
	</cfquery>
</cflock>

<cfif form.Status EQ "C">

	<cfparam name="form.id" default="">
	
	<cfif not isdefined('form.status')>
		<cflocation addtoken="no" url="jettyBookingManage.cfm?lang=#lang#&id=#form.id#&startdate=#DateFormat(url.startdate, 'mm/dd/yyyy')#&enddate=#DateFormat(url.enddate, 'mm/dd/yyyy')#&show=#url.show#">
	</cfif>
	
	<cfif IsDefined("Session.Return_Structure")>
		<cfoutput>#StructDelete(Session, "Return_Structure")#</cfoutput>
	</cfif>
	
	<!---updates booking--->
	<cfquery name="updateBooking" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
		UPDATE 	Jetties
		SET 	Status = 'C'
		WHERE 	BookingID = #form.id#
	</cfquery>
	
	<cfoutput>
	<cfmail to="#getDetails.Email#" from="#Session.AdminEmail#" subject="Booking Confirmed - R&eacute;servation confirm&eacute;e" type="html">
<p>Your requested jetty booking for #getDetails.VesselName# from #DateFormat(getDetails.StartDate, 'mmm d, yyyy')# to #DateFormat(getDetails.EndDate, 'mmm d, yyyy')# has been confirmed.</p>
<p>Esquimalt Graving Dock</p>
<br>
<p>La r&eacute;servation concernant la jet&eacute;e demand&eacute;e pour #getDetails.VesselName# du #DateFormat(getDetails.StartDate, 'mmm d, yyyy')# au #DateFormat(getDetails.EndDate, 'mmm d, yyyy')# a &eacute;t&eacute; confirm&eacute;e.</p>
<p>Cale s&egrave;che d'Esquimalt</p>
	</cfmail>
	</cfoutput>

	<CFSET newStatus = "Confirmed">
	
<cfelseif form.status EQ "P">
	
	<!---updates booking--->
	<cfquery name="updateBooking" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
		UPDATE Jetties
		SET Status = 'P'
		WHERE BookingID = #form.id#
	</cfquery>
	
	
	<cfoutput>
	<cfmail to="#getDetails.Email#" from="#Session.AdminEmail#" subject="Booking Unconfirmed - R&eacute;servation confirm&eacute;e" type="html">
<p>The confirmation on your jetty booking for #getDetails.VesselName# from #DateFormat(getDetails.StartDate, 'mmm d, yyyy')# to #DateFormat(getDetails.EndDate, 'mmm d, yyyy')# has been removed.  The booking status is now pending.</p>
<p>Esquimalt Graving Dock</p>
<br>
<p>La confirmation de votre r&eacute;servation de jet&eacute;e pour #getDetails.VesselName# du #DateFormat(getDetails.StartDate, 'mmm d, yyyy')# au #DateFormat(getDetails.EndDate, 'mmm d, yyyy')# a &eacute;t&eacute; supprim&eacute;e.</p>
<p>Cale s&egrave;che d'Esquimalt</p>La confirmation de votre r&eacute;servation de la cale s&egrave;che pour

	</cfmail>
	</cfoutput>
	
	<CFSET newStatus = "Pending">
	
</cfif>

<!--- <cfset Session.Return_Structure.StartDate = Form.StartDate>
<cfset Session.Return_Structure.EndDate = Form.EndDate>
<cfset Session.Return_Structure.showConfirmed = Form.showConfirmed>
<cfset Session.Return_Structure.showPending = Form.showPending>
<cfset Session.Return_Structure.ID = Form.ID> --->

<CFPARAM name="url.referrer" default="Jetty Booking Management">
<CFIF url.referrer eq "Booking Details">
	<CFSET returnTo = "#RootDir#text/comm/getBookingDetail.cfm">
<CFELSEIF url.referrer eq "Edit Jetty Booking">
	<CFSET returnTo = "#RootDir#text/admin/JettyBookings/editJettyBooking.cfm">
<CFELSE>
	<CFSET returnTo = "#RootDir#text/admin/JettyBookings/jettyBookingManage.cfm">
</CFIF>

<cfif isDefined("url.date")>
	<cfset variables.dateValue = "&date=#url.date#">
<cfelse>
	<cfset variables.dateValue = "">
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

<cfif referrer NEQ "Edit Jetty Booking">
	<!--- create structure for sending to mothership/success page. --->
	<cfset Session.Success.Breadcrumb = "<a href='../admin/JettyBookings/jettyBookingmanage.cfm?lang=#lang#'>Jetty Management</A> &gt; Change Booking Status">
	<cfset Session.Success.Title = "Change Booking Status">
	<cfset Session.Success.Message = "Booking status for <b>#getDetails.vesselName#</b> from #LSDateFormat(CreateODBCDate(getDetails.startDate), 'mmm d, yyyy')# to #LSDateFormat(CreateODBCDate(getDetails.endDate), 'mmm d, yyyy')# is now <b>#newStatus#</b>.  Email notification of this change has been sent to the agent.">
	<cfset Session.Success.Back = "Back to #url.referrer#">
	<cfset Session.Success.Link = "#returnTo#?#urltoken##dateValue#&bookingID=#Form.ID####form.id#">
	<cflocation addtoken="no" url="#RootDir#text/comm/success.cfm?lang=#lang#">
<cfelse>
	<cflocation addtoken="no" url="#returnTo#?#urltoken##dateValue#&bookingID=#Form.ID#">
</cfif>

<!---cflocation addtoken="no" url="jettyBookingmanage.cfm?lang=#lang#&id=#form.id#&startdate=#DateFormat(url.startdate, 'mm/dd/yyyy')#&enddate=#DateFormat(url.enddate, 'mm/dd/yyyy')#&show=#url.show#"--->
