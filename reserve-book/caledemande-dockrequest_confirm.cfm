<cfif isDefined("form.startDateA")><cfinclude template="#RootDir#includes/build_form_struct.cfm"></cfif>
<cfinclude template="#RootDir#includes/restore_params.cfm" />
<cfinclude template="#RootDir#includes/errorMessages.cfm" />

<cfif not StructKeyExists(Form, 'StartDateA') || not StructKeyExists(Form, 'EndDateA')>
  <cflocation url="#RootDir#reserve-book/Caledemande-dockrequest.cfm?lang=#lang#" addtoken="no" />
</cfif>


<cfif lang EQ "eng">
	<cfset language.keywords = language.masterKeywords & ", Drydock Booking Information" />
	<cfset language.description = "Allows user to submit a new booking request, drydock section." />
	<cfset language.subjects = language.masterSubjects & "" />
	
	<cfset language.VesselLabel = "Vessel:">
	<cfset language.startDateLabel = "Start Date:">
	<cfset language.endDateLabel = "End Date:">
	<cfset language.requestedStatusLabel = "Requested Status:">
<cfelse>
	<cfset language.keywords = language.masterKeywords & ", renseignements pour la r&eacute;servation de la cale s&egrave;che" />
	<cfset language.description = "Permet &agrave; l'utilisateur de pr&eacute;senter une nouvelle demande de r&eacute;servation sur le site Web de la cale s&egrave;che d'Esquimalt - section de la cale s&egrave;che." />
	<cfset language.subjects = language.masterSubjects & "" />
	
	<cfset language.VesselLabel = "Navire&nbsp:">
	<cfset language.startDateLabel = "Date de d&eacute;but&nbsp;:">
	<cfset language.endDateLabel = "Date de fin&nbsp:">
	<cfset language.requestedStatusLabel = "&Eacute;tat demand&eacute;&nbsp:">
</cfif>

<cfoutput>

<cfhtmlhead text="
	<meta name=""dcterms.title"" content=""#language.NewBooking# - #language.esqGravingDock# - #language.PWGSC#"" />
	<meta name=""keywords"" content=""#language.keywords#"" />
  <meta name=""description"" content=""#language.description#"" />
	<meta name=""dcterms.description"" content=""#language.description#"" />
	<meta name=""dcterms.subject"" content=""#language.subjects#"" />
	<title>#language.NewBooking# - #language.esqGravingDock# - #language.PWGSC#</title>">
<cfset request.title = language.NewBooking />
<cfinclude template="#RootDir#includes/tete-header-#lang#.cfm">

				<h1 id="wb-cont">#language.newBooking#</h1>


				<CFINCLUDE template="#RootDir#includes/user_menu.cfm">

				<cfif IsDefined("Session.Return_Structure")>
					#StructDelete(Session, "Return_Structure")#
				</cfif>

				<cfset Errors = ArrayNew(1)>
				<cfset Success = ArrayNew(1)>
				<cfset Proceed_OK = "Yes">

				<!--- Validate the form data --->
        <cfif not isDate(Form.StartDateA)>
          <cfset session['errors']['StartDateA'] = language.invalidStartError />
					<cfset Proceed_OK = "No" />
        <cfelseif not isDate(Form.EndDateA)>
          <cfset session['errors']['EndDateA'] = language.invalidEndError />
					<cfset Proceed_OK = "No" />
				<cfelseif DateCompare(Form.StartDateA,Form.EndDateA) EQ 1>
          <cfset session['errors']['StartDateA'] = language.endBeforeStartError />
          <cfset session['errors']['EndDateA'] = language.endBeforeStartError />
					<cfset Proceed_OK = "No" />
        </cfif>

        <cfset Variables.VNID = Form.booking_VNID>

        <cfif not isNumeric(form.booking_VNID)>
          <cfset form.booking_VNID = 0 />
        </cfif>

        <cfquery name="getVessel" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
          SELECT 	VNID, Length, Width, Vessels.Name AS VesselName, Companies.Name AS CompanyName
          FROM 	Vessels, Companies
          WHERE 	VNID = <cfqueryparam value="#Form.booking_VNID#" cfsqltype="cf_sql_integer" />
          AND		Companies.CID = Vessels.CID
          AND 	Vessels.Deleted = 0
          AND		Companies.Deleted = 0
        </cfquery>

        <cfif getVessel.RecordCount EQ 0>
          <cfset session['errors']['booking_VNIDA'] = language.noVesselError />
          <cfset Proceed_OK = "No">
        </cfif>

        <cfif Proceed_OK EQ "No">
          <cfset Session.Return_Structure.VNID = Form.booking_VNID>
          <cfset Session.Return_Structure.Status = Form.Status>
          <cfset Session.Return_Structure.Errors = Errors>

          <cflocation url="#RootDir#reserve-book/caledemande-dockrequest.cfm?lang=#lang#" addtoken="no">
        </cfif>

        <cfset Variables.StartDate = CreateODBCDate(Form.StartDateA)>
        <cfset Variables.EndDate = CreateODBCDate(Form.EndDateA)>
        <!---Check to see that vessel hasn't already been booked during this time--->
        <!--- 25 October 2005: This query now only looks at the drydock bookings --->
        <cfquery name="checkDblBooking" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
          SELECT 	Bookings.VNID, Vessels.Name, Bookings.StartDate, Bookings.EndDate
          FROM 	Bookings
                INNER JOIN Vessels ON Bookings.VNID = Vessels.VNID
                INNER JOIN Docks ON Bookings.BRID = Docks.BRID
          WHERE 	Bookings.VNID = <cfqueryparam value="#Variables.VNID#" cfsqltype="cf_sql_integer" />
          AND
          <!---Explanation of hellishly long condition statement: The client wants to be able to overlap the start and end dates
            of bookings, so if a booking ends on May 6, another one can start on May 6.  This created problems with single day
            bookings, so if you are changing this query...watch out for them.  The first 3 lines check for any bookings longer than
            a day that overlaps with the new booking if it is more than a day.  The next 4 lines check for single day bookings that
            fall within a booking that is more than one day.--->
              (
                (	Bookings.StartDate <= <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> AND <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> < Bookings.EndDate AND <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> <> <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> AND Bookings.StartDate <> Bookings.EndDate)
              OR 	(	Bookings.StartDate < <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> AND <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> <= Bookings.EndDate AND <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> <> <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> AND Bookings.StartDate <> Bookings.EndDate)
              OR	(	Bookings.StartDate >= <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> AND <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> >= Bookings.EndDate AND <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> <> <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> AND Bookings.StartDate <> Bookings.EndDate)
              OR  (	(Bookings.StartDate = Bookings.EndDate OR <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> = <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" />) AND Bookings.StartDate <> <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> AND Bookings.EndDate <> <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> AND
                    ((	Bookings.StartDate <= <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> AND <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> < Bookings.EndDate)
                  OR 	(	Bookings.StartDate < <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> AND <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> <= Bookings.EndDate)
                  OR	(	Bookings.StartDate >= <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> AND <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> >= Bookings.EndDate)))
              )
          AND		Bookings.Deleted = 0
          AND Docks.Status = 'C'
        </cfquery>

        <!--- 25 October 2005: The next two queries have been modified to only get results from the drydock bookings --->
        <cfquery name="getNumStartDateBookings" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
          SELECT	Bookings.BRID, Vessels.Name, Bookings.StartDate
          FROM	Bookings
                INNER JOIN Docks ON Bookings.BRID = Docks.BRID
                INNER JOIN Vessels ON Bookings.VNID = Vessels.VNID
          WHERE	StartDate = <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" />
                AND Bookings.VNID = <cfqueryparam value="#Variables.VNID#" cfsqltype="cf_sql_integer" />
                AND Bookings.Deleted = 0
        </cfquery>

        <cfquery name="getNumEndDateBookings" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
          SELECT	Bookings.BRID, Vessels.Name, Bookings.EndDate
          FROM	Bookings
                INNER JOIN Docks ON Bookings.BRID = Docks.BRID
                INNER JOIN Vessels ON Bookings.VNID = Vessels.VNID
          WHERE	EndDate = <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" />
                AND Bookings.VNID = <cfqueryparam value="#Variables.VNID#" cfsqltype="cf_sql_integer" />
                AND Bookings.Deleted = 0
        </cfquery>

        <cfif DateCompare(PacificNow, Form.StartDateA, 'd') NEQ -1>
          <cfset session['errors']['StartDateA'] = language.futureStartError />
          <cfset Proceed_OK = "No">
        <cfelseif (isDefined("checkDblBooking.VNID") AND checkDblBooking.VNID NEQ "")>
          <cfset session['errors']['StartDateA'] =  "#checkDblBooking.Name# #language.dblBookingError# #myDateFormat(checkDblBooking.StartDate, 'mm/dd/yyy')# #language.to# #myDateFormat(checkDblBooking.EndDate, 'mm/dd/yyy')#." />
          <cfset Proceed_OK = "No">
        <cfelseif getNumStartDateBookings.recordCount GTE 1>
          <cfset session['errors']['StartDateA'] = "#getNumStartDateBookings.Name# #language.tplBookingError# #myDateFormat(getNumStartDateBookings.StartDate, 'mm/dd/yyy')#." />
          <cfset Proceed_OK = "No">
        <cfelseif getNumEndDateBookings.recordCount GTE 1>
          <cfset session['errors']['EndDateA'] = "#getNumEndDateBookings.Name# #language.tplBookingError# #myDateFormat(getNumEndDateBookings.EndDate, 'mm/dd/yyy')#." />
          <cfset Proceed_OK = "No">
        </cfif>

        <cfif DateDiff("d",Form.StartDateA,Form.EndDateA) LT 0>
          <cfset session['errors']['StartDateA'] = language.bookingTooShortError />
          <cfset Proceed_OK = "No">
        </cfif>

        <cfif getVessel.Width GT Variables.MaxWidth>
          <cfset session['errors']['width'] = "#language.theVessel#, #getVessel.VesselName#, #language.tooLarge#." />
          <cfset Proceed_OK = "No">
        </cfif>

        <cfif getVessel.Length GT Variables.MaxLength>
          <cfset session['errors']['length'] = "#language.theVessel#, #getVessel.VesselName#, #language.tooLarge#." />
          <cfset Proceed_OK = "No">
        </cfif>

        <cfif Proceed_OK EQ "No">
          <!--- Save the form data in a session structure so it can be sent back to the form page --->
          <cfset Session.Return_Structure.StartDate = Form.StartDateA>
          <cfset Session.Return_Structure.EndDate = Form.EndDateA>
          <cfset Session.Return_Structure.VNID = Form.booking_VNID>
          <cfset Session.Return_Structure.Status = Form.Status>
		  
		  <cfset session['errors']['form1erroralert'] = "form1erroralert">
          <cfset Session.Return_Structure.Errors = Errors>

          <cflocation url="#RootDir#reserve-book/caledemande-dockrequest.cfm?lang=#lang#" addtoken="no">
        </cfif>


        <!--- Gets all Bookings that would be affected by the requested booking --->
        <cfinclude template="#RootDir#reserve-book/includes/towerCheck.cfm">
        <cfset Variables.spaceFound = findSpace(-1, #Variables.StartDate#, #Variables.EndDate#, #getVessel.Length#, #getVessel.Width#)>
        <p>
          <cfif NOT variables.spaceFound>
            #language.bookingConflicts#
          <cfelse>
            #language.bookingAvailable#
          </cfif>
        </p>
        <form action="#RootDir#reserve-book/caledemande-dockrequest_action.cfm?lang=#lang#" method="post" id="bookingreq" preservedata="Yes">
        <h2>#language.new#</h2>
          <fieldset>
            <legend>#language.booking#</legend>

            <p class="color-accent">#language.vesselLabel# #getVessel.VesselName#</p>
            <p class="color-accent">#language.StartDateLabel# #myDateFormat(Variables.StartDate, request.datemask)#</p>
			<p class="color-accent">#language.EndDateLabel# #myDateFormat(Variables.EndDate, request.datemask)#</p>
			<p class="color-accent">#language.requestedStatusLabel# <cfif form.status eq "tentative">#language.tentative#<cfelse>#language.confirmed#</cfif></p>
			
			<input type="hidden" id="VNID" name="VNID" value="#Variables.VNID#" />
            <input type="hidden" id="StartDate" name="StartDate" value="#Variables.StartDate#" />
            <input type="hidden" id="EndDate" name="EndDate" value="#Variables.EndDate#" />
            <input type="hidden" id="Status" name="Status" value="#Form.Status#" />
            
          </fieldset>

          <div class="buttons">
            <input type="submit" value="#language.Submit#" class="button button-accent" />
          </div>
        </form>
		<!-- CONTENT ENDS | FIN DU CONTENU -->
</cfoutput>

<cfinclude template="#RootDir#includes/foot-pied-#lang#.cfm">
