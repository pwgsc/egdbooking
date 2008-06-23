<cfhtmlhead text="
	<meta name=""dc.title"" lang=""eng"" content=""pwgsc - esquimalt graving dock - Drydock Booking Management"">
	<meta name=""keywords"" lang=""eng"" content="""">
	<meta name=""description"" lang=""eng"" content="""">
	<meta name=""dc.subject"" scheme=""gccore"" lang=""eng"" content="""">
	<meta name=""dc.date.published"" content=""2005-07-25"">
	<meta name=""dc.date.reviewed"" content=""2005-07-25"">
	<meta name=""dc.date.modified"" content=""2005-07-25"">
	<meta name=""dc.date.created"" content=""2005-07-25"">
	<title>PWGSC - ESQUIMALT GRAVING DOCK - Drydock Booking Management</title>
	<style type=""text/css"" media=""screen,print"">@import url(#RootDir#css/events.css);</style>
	">

<!---clear form structure--->
<cfif IsDefined("Session.Form_Structure")>
	<cfset StructDelete(Session, "Form_Structure")>
</cfif>

<!--- these look totally useless.  Lois Chan, July 2005 --->
<!---cfif IsDefined("form.startDate")>
	<cfset url.StartDate = "#form.StartDate#">
</cfif>
<cfif IsDefined("form.EndDate")>
	<cfset url.EndDate = "#form.EndDate#">
</cfif--->

<!--checking if enddate is defined instead of show is not a mistake!-->
<cfif IsDefined("form.EndDate") AND IsDate("form.EndDate")>
	<cfif IsDefined("form.show")>
		<cfset url.show = #form.show#>
	</cfif>
</cfif>

<!--- Want URL variables to take precedence over form variables for proper linking purposes --->
<cfif IsDefined("url.startDate") and IsDate(URLDecode(url.startDate))>
	<!---CFOUTPUT>#url.startDate#</CFOUTPUT--->
	<cfset form.startDate = url.startDate>
	<cfset Variables.startDate = url.startDate>
</cfif>
<cfif IsDefined("url.endDate") and IsDate(URLDecode(url.endDate))>
	<!---CFOUTPUT>#url.endDate#</CFOUTPUT--->
	<cfset form.endDate = url.endDate>
	<cfset Variables.endDate = url.endDate>
<cfelse>
	<!---added to default to max enddate so all bookings are shown--->
	<cfset form.endDate = "12/31/2031">
</cfif>

<cfparam name="form.startDate" default="#DateFormat(PacificNow, 'mm/dd/yyyy')#">
<cfparam name="form.endDate" default="#DateFormat(DateAdd('d', 30, PacificNow), 'mm/dd/yyyy')#">
<cfparam name="Variables.startDate" default="#form.startDate#">
<cfparam name="Variables.endDate" default="#form.endDate#">


<!---Drydock Status--->
<cfquery name="countPending" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
		SELECT count(*) as numPend
		FROM Docks, Bookings
		WHERE (
				(Bookings.StartDate = '#dateformat(variables.startDate, "mm/dd/yyyy")#' AND Bookings.EndDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#')
				OR	(Bookings.startDate <= '#dateformat(variables.startDate, "mm/dd/yyyy")#'	AND Bookings.endDate >= '#dateformat(variables.endDate, "mm/dd/yyyy")#') 
				OR	(Bookings.startDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#'	AND Bookings.endDate >= '#dateformat(variables.endDate, "mm/dd/yyyy")#') 				
				OR 	(Bookings.endDate >= '#dateformat(variables.startDate, "mm/dd/yyyy")#'	AND Bookings.endDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#')	
			)
		AND Docks.BookingID = Bookings.BookingID AND (Status = 'P' OR Status = 'X' OR Status = 'Y' OR Status = 'Z') AND Bookings.Deleted = '0'
</cfquery>
<cfquery name="countTentative" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
		SELECT count(*) as numTent
		FROM Docks, Bookings
		WHERE (
				(Bookings.StartDate = '#dateformat(variables.startDate, "mm/dd/yyyy")#' AND Bookings.EndDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#')
				OR	(Bookings.startDate <= '#dateformat(variables.startDate, "mm/dd/yyyy")#'	AND Bookings.endDate >= '#dateformat(variables.endDate, "mm/dd/yyyy")#') 
				OR	(Bookings.startDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#'	AND Bookings.endDate >= '#dateformat(variables.endDate, "mm/dd/yyyy")#') 				
				OR 	(Bookings.endDate >= '#dateformat(variables.startDate, "mm/dd/yyyy")#'	AND Bookings.endDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#')	
			)
		AND Docks.BookingID = Bookings.BookingID AND Status = 'T' AND Bookings.Deleted = '0'
		<!--- Eliminates any Tentative bookings with a start date before today --->
		AND ((Docks.status <> 'T') OR (Docks.status = 'T' AND Bookings.startDate >= #PacificNow#))
</cfquery>
<cfquery name="countConfirmed" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
		SELECT count(*) as numConf
		FROM Docks, Bookings
		WHERE (
				(Bookings.StartDate = '#dateformat(variables.startDate, "mm/dd/yyyy")#' AND Bookings.EndDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#')
				OR	(Bookings.startDate <= '#dateformat(variables.startDate, "mm/dd/yyyy")#'	AND Bookings.endDate >= '#dateformat(variables.endDate, "mm/dd/yyyy")#') 
				OR	(Bookings.startDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#'	AND Bookings.endDate >= '#dateformat(variables.endDate, "mm/dd/yyyy")#') 				
				OR 	(Bookings.endDate >= '#dateformat(variables.startDate, "mm/dd/yyyy")#'	AND Bookings.endDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#')	
			)
		AND Docks.BookingID = Bookings.BookingID AND Status = 'C' AND Bookings.Deleted = '0'
</cfquery>

<cfparam name="form.show" default="c,t,p">
<cfparam name="url.show" default="#form.show#">
<cfparam name="Variables.show" default="#url.show#">

<cfset showPend = false>
<cfset showTent = false>
<cfset showConf = false>

<cfscript>
	if (REFindNoCase('p', url.show) neq 0) {
		// wants to show pending bookings
		showPend = true;
	}
	if (REFindNoCase('t', url.show) neq 0) {
		// wants to show tentative bookings
		showTent = true;
	}
	if (REFindNoCase('c', url.show) neq 0) {
		// wants to show confirmed bookings
		showConf = true;
	}
</cfscript>

<!-- Start JavaScript Block -->
<script language="JavaScript" type="text/javascript">
<!--
function EditSubmit ( selectedform )
{
  document.forms[selectedform].submit() ;
}
//-->
</script>
<!-- End JavaScript Block -->

<cfinclude template="#RootDir#includes/tete-header-#lang#.cfm">

		<!-- BREAD CRUMB BEGINS | DEBUT DE LA PISTE DE NAVIGATION -->
		<p class="breadcrumb">
			<cfinclude template="/clf20/ssi/bread-pain-#lang#.html"><cfinclude template="#RootDir#includes/bread-pain-#lang#.cfm"> &gt; 
			<a href="#RootDir#text/admin/menu.cfm?lang=#lang#">Admin</a> &gt; 
			Drydock Booking Management
		</p>
		<!-- BREAD CRUMB ENDS | FIN DE LA PISTE DE NAVIGATION -->
		<div class="colLayout">
		<cfinclude template="#RootDir#includes/left-menu-gauche-#lang#.cfm">
			<!-- CONTENT BEGINS | DEBUT DU CONTENU -->
			<div class="center">
				<h1><a name="cont" id="cont">
					<!-- CONTENT TITLE BEGINS | DEBUT DU TITRE DU CONTENU -->
					Drydock Booking Management
					<!-- CONTENT TITLE ENDS | FIN DU TITRE DU CONTENU -->
					</a></h1>

				<cfinclude template="#RootDir#includes/admin_menu.cfm"><br>
				
				<cfinclude template="#RootDir#includes/calendar_js.cfm">
				
				<p>Please enter a range of dates for which you would like to see the bookings:</p>
				<form action="bookingmanage.cfm?lang=#lang#" method="get" name="dateSelect">
					<input type="hidden" name="lang" value="<cfoutput>#lang#</cfoutput>">
					<table align="center" style="width: 100%;" >
						<tr>
							<td id="Startdate">
								<label for="start">Start Date:</label>
							</td>
							<td headers="" colspan="2">
								<cfoutput>
									<input type="text" name="startDate" size="15" maxlength="10" value="#DateFormat(variables.startDate, 'mm/dd/yyyy')#" class="textField" onchange="setLaterDate('self', 'dateSelect', #Variables.bookingLen#)" onfocus="setEarlierDate('self', 'dateSelect', #Variables.bookingLen#)"> <font class="light">#language.dateform#</font>
								</cfoutput>
								<a href="javascript:void(0);" onclick="javascript:getCalendar('dateSelect', 'start')" class="textbutton">calendar</a>
							</td>
						</tr>
						<tr>
							<td id="Enddate">
								<label for="end">End Date:</label>
							</td>
							<td headers="" colspan="2">
								<cfoutput>
									<input type="text" name="endDate" size="15" maxlength="10" value="#DateFormat(variables.endDate, 'mm/dd/yyyy')#" class="textField" onchange="setEarlierDate('self', 'dateSelect', #Variables.bookingLen#)" onfocus="setLaterDate('self', 'dateSelect', #Variables.bookingLen#)"> <font class="light">#language.dateform#</font>
								</cfoutput>
								<a href="javascript:void(0);" onclick="javascript:getCalendar('dateSelect', 'end')" class="textbutton">calendar</a>
							</td>
						</tr>
						<tr>
							<td>Show only:</td>
							<td headers="Pending" align="right" width="15%"><input type="checkbox" id="showPend" name="show" value="p"<cfif showPend eq true> checked</cfif>></td>
							<td id="Pending" align="left"><label for="showPend" class="pending">Pending</label></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td headers="Tentative" align="right"><input type="checkbox" id="showTent" name="show" value="t"<cfif showTent eq true> checked</cfif>></td>
							<td id="Tentative" align="left"><label for="showTent" class="tentative">Tentative</label></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td headers="Confirmed" align="right"><input type="checkbox" id="showConf" name="show" value="c"<cfif showConf eq true> checked</cfif>></td>
							<td id="Confirmed" align="left"><label for="showConf" class="confirmed">Confirmed</label></td>
						</tr>
						<tr>
							<td colspan="3" align="right"><!--a href="javascript:validate('dateSelect');" class="textbutton">Submit</a--><input type="submit" class="textbutton" value="submit"></td>
						</tr>
					</table>
				
					<!---div align="center">
						<!--a href="javascript:document.dateSelect.submitForm.click();" class="textbutton">Submit</a><br-->
						<a href="javascript:validate('dateSelect');" class="textbutton">Submit</a><br>
					</div--->
				
				</form>
				<br>
				
				<cfif form.startDate NEQ "" and form.endDate NEQ "">
					<cfif isDate(form.startDate)>
						<cfset proceed = "yes">
					</cfif>
				</cfif>
				
				<cfif isdefined('proceed') and proceed EQ "yes">
					
					<cfparam name="form.expandAll" default="">
					<cfoutput><form action="bookingmanage.cfm?#urltoken#" method="post" name="expandAll">
						<input type="hidden" name="startDate" value="#variables.startdate#">
						<input type="hidden" name="endDate" value="#variables.endDate#">
						<cfif form.expandAll NEQ "yes">
							<input type="hidden" name="expandAll" value="yes">
						<cfelse>
							<input type="hidden" name="expandAll" value="no">
						</cfif>
						<!---input type="hidden" name="showTent" value="<cfoutput>#variables.showTent#</cfoutput>">
						<input type="hidden" name="showConf" value="<cfoutput>#variables.showConf#</cfoutput>">
						<input type="hidden" name="showPend" value="<cfoutput>#variables.showPend#</cfoutput>"--->
						<input type="hidden" name="show" value="#url.show#">
					</form>
							
				<!---	<cfquery name="countPending" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
					SELECT count(*) as numPend
					FROM Bookings INNER JOIN Docks ON Bookings.BookingID = Docks.BookingID
					WHERE ((Bookings.startDate >= '#dateformat(variables.startDate, "mm/dd/yyyy")#'
								AND Bookings.startDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#') 
							OR (Bookings.startDate <= '#dateformat(variables.startDate, "mm/dd/yyyy")#'
								AND Bookings.endDate >= '#dateformat(variables.endDate, "mm/dd/yyyy")#') 
							OR (Bookings.endDate >= '#dateformat(variables.startDate, "mm/dd/yyyy")#'
								AND Bookings.endDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#'))		
							AND Bookings.Deleted = 0
							AND Status = 'P'
					</cfquery>
				--->
							
					<!---<div align="right"><a href="javascript:EditSubmit('expandAll');">Expand All</a></div>--->
					<h2>Drydock <cfif #countPending.numPend# NEQ 0>(#countPending.numPend# #language.pending#)</cfif></h2>
					</cfoutput>
					
					<table width="100%" cellspacing="0" cellpadding="0" style="padding-bottom: 5px; ">
						<tr>
							<cfoutput><td align="left" width="50%"><a href="addbooking.cfm?#urltoken#" class="textbutton">Add New Drydock Booking</a></td></cfoutput>
							<cfif form.expandAll NEQ "yes">
								<td align="right" width="50%"><a href="javascript:EditSubmit('expandAll');">Expand All</a></td>
							<cfelse>
								<td align="right" width="50%"><a href="javascript:EditSubmit('expandAll');">Collapse All</a></td>
							</cfif>
						</tr>
					</table>
					<P align="center">Total:&nbsp;&nbsp;
						<cfoutput>
						<i class="pending">Pending - #countPending.numPend#</i>&nbsp;&nbsp;
						<i class="tentative">Tentative - #countTentative.numTent#</i>&nbsp;&nbsp;
						<i class="confirmed">Confirmed - #countConfirmed.numConf#</i>
						</cfoutput>
					</p>
						
					<cfquery name="getBookings" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
						SELECT 	Bookings.EndHighlight AS EndHighlight, Bookings.*, Vessels.Name AS VesselName, Docks.Status
						FROM 	Bookings INNER JOIN Vessels ON Bookings.VesselID = Vessels.VesselID
									INNER JOIN Docks ON Bookings.BookingID = Docks.BookingID
						WHERE  ((Bookings.startDate >= '#dateformat(variables.startDate, "mm/dd/yyyy")#'
								AND Bookings.startDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#') 
							OR (Bookings.startDate <= '#dateformat(variables.startDate, "mm/dd/yyyy")#'
								AND Bookings.endDate >= '#dateformat(variables.endDate, "mm/dd/yyyy")#') 
							OR (Bookings.endDate >= '#dateformat(variables.startDate, "mm/dd/yyyy")#'
								AND Bookings.endDate <= '#dateformat(variables.endDate, "mm/dd/yyyy")#'))		
							AND Bookings.Deleted = 0
							AND Vessels.Deleted = 0
							<!--- Eliminates any Tentative bookings with a start date before today --->
							AND ((Docks.status <> 'T') OR (Docks.status = 'T' AND Bookings.startDate >= #PacificNow#))
								
						<cfif variables.showPend EQ true AND variables.showTent EQ false AND variables.showConf EQ false>
							AND (Docks.Status = 'P' OR Docks.Status = 'Y' OR Docks.Status = 'X' OR Docks.Status = 'Z')
						</cfif>
						<cfif variables.showTent EQ true AND variables.showPend EQ false AND variables.showConf EQ false>
							AND Docks.Status = 'T'
						</cfif>
						<cfif variables.showConf EQ true AND variables.showPend EQ false AND variables.showTent EQ false>
							AND Docks.Status = 'C'
						</cfif>	
						<cfif variables.showPend EQ true AND variables.showTent EQ true AND variables.showConf EQ false>
							AND ((Docks.Status = 'P' OR Docks.Status = 'Y' OR Docks.Status = 'X' OR Docks.Status = 'Z') OR (Docks.Status = 'T'))
						</cfif>	
						<cfif variables.showPend EQ true AND variables.showTent EQ false AND variables.showConf EQ true>
							AND ((Docks.Status = 'C') OR (Docks.Status = 'P' OR Docks.Status = 'Y' OR Docks.Status = 'X' OR Docks.Status = 'Z'))
						</cfif>	
						<cfif variables.showPend EQ false AND variables.showTent EQ true AND variables.showConf EQ true>
							AND ((Docks.Status = 'C') OR (Docks.Status = 'T'))
						</cfif>	
						ORDER BY Bookings.startDate, Bookings.endDate, Vessels.Name
					</cfquery>
						
					<cfif getBookings.RecordCount GT 0>
						<cfoutput query="getBookings">
						<cfset Variables.id = #BookingID#>
							<form name="booking#id#" action="bookingmanage.cfm?#urltoken###id#id#" method="post">
								<input type="hidden" name="startDate" value="#form.startDate#">
								<input type="hidden" name="endDate" value="#form.endDate#">
								<cfif (isDefined("form.ID") AND form.ID EQ #id#) OR (isDefined('url.bookingid') AND url.bookingid EQ id)>
									<input type="hidden" name="ID" value="0">
								<cfelse>
									<input type="hidden" name="ID" value="#id#">
								</cfif>
								<input type="hidden" name="show" value="#variables.show#">
							</form>
						</cfoutput>
					</cfif>
					<table class="calendar" cellpadding="3" cellspacing="0" width="100%">
						<tr align="center" style="background-color:#cccccc;">
							<th id="Start" class="calendar" style="width: 20%;">Start Date</th>
							<th id="End" class="calendar" style="width: 20%;">End Date</th>
							<th id="Vessel" class="calendar" style="width: 45%;">Vessel Name</th>
							<th id="Status" class="calendar" style="width: 15%;">Status</th>
						</tr>
						<cfif getBookings.RecordCount GT 0>
							<cfoutput query="getBookings">
								<cfset Variables.id = #BookingID#>
								
				<!--- 				<form name="booking#id#" action="bookingmanage.cfm?#urltoken####id#" method="post">
									<input type="hidden" name="startDate" value="#form.startDate#">
									<input type="hidden" name="endDate" value="#form.endDate#">
									<cfif isDefined("form.ID") AND form.ID EQ #id#>
										<input type="hidden" name="ID" value="0">
									<cfelse>
										<input type="hidden" name="ID" value="#id#">
									</cfif>
									<input type="hidden" name="show" value="#variables.show#">
								</form> --->
								
									<form method="post" action="deleteBooking_confirm.cfm?#urltoken#" name="delete#ID#">
										<input type="hidden" name="BookingID" value="#id#">
									</form>
									<form method="post" action="chgStatus_2c.cfm?#urltoken#" name="chgStatus_2c#ID#">
										<input type="hidden" name="BookingID" value="#id#">
									</form>
									
									<form method="post" action="chgStatus_2p.cfm?#urltoken#" name="chgStatus_2p#ID#">
										<input type="hidden" name="BookingID" value="#id#">
									</form>
									
									<form method="post" action="chgStatus_2t.cfm?#urltoken#" name="chgStatus_2t#ID#">
										<input type="hidden" name="BookingID" value="#id#">
									</form>
					
									<form method="post" action="deny.cfm?#urltoken#" name="deny#ID#">
										<input type="hidden" name="BookingID" value="#id#">
									</form>
					
									<form method="post" action="editbooking.cfm?#urltoken#" name="editBooking#ID#">
										<input type="hidden" name="BookingID" value="#id#">
									</form>
									
									<form method="post" action="feesForm_admin.cfm?#urltoken#" name="viewForm#ID#">
										<input type="hidden" name="BookingID" value="#id#">
									</form>
									
									
						<tr>
							<td headers="start" class="calendar" nowrap>#LSdateformat(startDate, "mmm d, yyyy")#</td>
							<td headers="end" class="calendar" nowrap>#LSdateformat(endDate, "mmm d, yyyy")#</td>
							<td headers="vessel" class="calendar"><a href="javascript:EditSubmit('booking#id#');" name="id#id#" id="id#id#"><cfif #EndHighlight# GTE PacificNow>* </cfif>#VesselName#</a></td>
							<td headers="status" class="calendar"><cfif status EQ "C"><div class="confirmed">Confirmed</div><cfelseif status EQ "T"><div class="tentative">Tentative</div><cfelseif status EQ "P"><div class="pending">Pending T</div><cfelseif status EQ "Y" OR status EQ "Z"><div class="pending">Pending C</div><cfelseif status EQ "X"><a href="javascript:EditSubmit('delete#ID#');"><div class="pending">Pending X</div></a></cfif></td>
						</tr>
								
						<cfif (isDefined('form.id') AND form.id EQ id) OR (isDefined('url.bookingid') AND url.bookingid EQ id) OR form.expandAll EQ "yes">
						
		<!--- 					<cfquery name="getData" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
								SELECT 	Bookings.StartDate, Bookings.EndDate, Vessels.Name AS VesselName, Vessels.*, 
										Users.LastName + ', ' + Users.FirstName AS UserName, 
										Companies.Name AS CompanyName, Docks.Section1, Docks.Section2, Docks.Section3,
										Docks.Status, BookingTime
								FROM 	Bookings, Docks, Vessels, Users, Companies, UserCompanies
								WHERE	Bookings.VesselID = Vessels.VesselID
								AND		Vessels.CompanyID = Companies.CompanyID
								AND		Companies.CompanyID = UserCompanies.CompanyID 
								AND		UserCompanies.UserID = Users.UserID
								AND		Bookings.BookingID = '#ID#'
								AND		Docks.BookingID = Bookings.BookingID
							</cfquery> --->
							<cfquery name="getData" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
								SELECT 	Bookings.EndHighlight AS EndHighlight, Bookings.StartDate, Bookings.EndDate, Vessels.Name AS VesselName, Vessels.*, 
										Users.LastName + ', ' + Users.FirstName AS UserName, 
										Companies.Name AS CompanyName, Docks.Section1, Docks.Section2, Docks.Section3,
										Docks.Status, BookingTime, BookingTimeChange, BookingTimeChangeStatus
								FROM 	Bookings, Docks, Vessels, Users, Companies
								WHERE	Bookings.VesselID = Vessels.VesselID
								AND		Vessels.CompanyID = Companies.CompanyID
		
								AND		Bookings.UserID = Users.UserID
								AND		Bookings.BookingID = '#ID#'
								AND		Docks.BookingID = Bookings.BookingID
							</cfquery>
				
							
							<tr><td colspan="5" class="calendar">
							
								<table class="showDetails" width="70%" border="0" cellpadding="1" cellspacing="0" align="center">
									<tr>
										<td><strong><em>Details</em></strong></td>
										<td align="right"><a href="javascript:EditSubmit('editBooking#ID#');">Edit Booking</a></td>
									</tr>
									<tr>
										<td id="Start" width="30%">Start Date:</td>
										<td headers="Start">#dateformat(getData.startDate, "mmm d, yyyy")#</td>
									</tr>
									<tr>
										<td id="End">End Date:</td>
										<td headers="End">#dateformat(getData.endDate, "mmm d, yyyy")#</td>
									</tr>
									<tr>
										<td id="Days">## of Days:</td>
										<td headers="Days">#datediff('d', getData.startDate, getData.endDate) + 1#</td>
									</tr>
									<tr>
										<td id="Vessel">Vessel:</td>
										<td headers="Vessel"><cfif #EndHighlight# GTE PacificNow>* </cfif>#getData.vesselName#</td>
									</tr>
										<tr>
											<td id="">&nbsp;&nbsp;&nbsp;<i>Length:</i></td>
											<td headers=""><i>#getData.length# m</i></td>
										</tr>
										<tr>
											<td id="Width">&nbsp;&nbsp;&nbsp;<i>Width:</i></td>
											<td headers="Width"><i>#getData.width# m</i></td>
										</tr>
										<tr>
											<td id="Tonnage">&nbsp;&nbsp;&nbsp;<i>Tonnage:</i></td>
											<td headers="Tonnage"><i>#getData.tonnage#</i></td>
										</tr>
									<tr>
										<td id="Agent">Agent:</td>
										<td headers="Agent">#getData.UserName#</td>
									</tr>
									<tr>
										<td id="Company">Company:</td>
										<td headers="Company">#getData.companyName# <a class="textbutton" href="changeCompany.cfm?BookingIDURL=#BookingID#&CompanyURL=#getData.companyName#&vesselNameURL=#getData.vesselName#&UserNameURL=#getData.UserName#">Change</a></td>
									</tr>
									<tr>
										<td id="Time">Booking Time:</td>
										<td headers="Time">#DateFormat(getData.bookingTime,"mmm d, yyyy")# #TimeFormat(getData.bookingTime,"long")#</td>
									</tr>
									<tr>
										<td id="Time">Last Change:</td>
										<td headers="Time">#getData.bookingTimeChangeStatus#<br />#DateFormat(getData.bookingTimeChange,"mmm d, yyyy")# #TimeFormat(getData.bookingTimeChange,"long")#</td>
									</tr>
									<tr>
										<td id="Section">Section(s):</td>
										<td headers="Section">
											<cfif getData.Section1>Section 1</cfif>
											<cfif getData.Section2><cfif getData.Section1> &amp; </cfif>Section 2</cfif>
											<cfif getData.Section3><cfif getData.Section1 OR getData.Section2> &amp; </cfif>Section 3</cfif>
											<cfif NOT getData.Section1 AND NOT getData.Section2 AND NOT getData.Section3>Unassigned</cfif>
										</td>
									</tr>
									<tr>
										<td>Highlight for:</td>
										<td> 
										<cfform action="highlight_action.cfm?BookingID=#BookingID#" method="post" name="updateHighlight">
										<cfif EndHighlight NEQ "">
										<cfset datediffhighlight = DateDiff("d", PacificNow, EndHighlight)>
										<cfset datediffhighlight = datediffhighlight+"1">
										<cfif datediffhighlight LTE "0"><cfset datediffhighlight = "0"></cfif>
										<cfelse>
										<cfset datediffhighlight = "0">
										</cfif>
										<cfinput id="EndHighlight" name="EndHighlight" type="text" value="#datediffhighlight#" size="3" maxlength="3" required="yes" class="textField" message="Please enter an End Highlight Date."> Days
										<input type="submit" name="submitForm" class="textbutton" value="Update">
										</cfform> 
										</td>
									</tr>
									<tr>
										<td>Highlight Until:</td>
										<td> 
										<cfif datediffhighlight NEQ "0">#DateFormat(EndHighlight, "mmm dd, yyyy")#</cfif><br />
										</td>
									</tr>
									<tr><td colspan="2">&nbsp;</td><tr>
										<td id="Status" valign="top">Status:</td>
										<td headers="Status">
											<cfif getData.Status EQ "C">
												<strong>Confirmed</strong>
												<a href="javascript:EditSubmit('chgStatus_2t#ID#');" class="textbutton">Make Tentative</a>
												<a href="javascript:EditSubmit('chgStatus_2p#ID#');" class="textbutton">Make Pending</a>
											<cfelseif getData.Status EQ "T">
												<a href="javascript:EditSubmit('chgStatus_2c#ID#');" class="textbutton">Make Confirmed</a>
												<strong>Tentative</strong>
												<a href="javascript:EditSubmit('chgStatus_2p#ID#');" class="textbutton">Make Pending</a>
											<cfelse>
												<a href="javascript:EditSubmit('chgStatus_2c#ID#');" class="textbutton">Make Confirmed</a>
												<a href="javascript:EditSubmit('chgStatus_2t#ID#');" class="textbutton">Make Tentative</a>	
												<strong>Pending</strong>
												<cfif getData.Status EQ "Y">
													<a href="javascript:EditSubmit('deny#ID#');" class="textbutton">Deny Request</a>
												</cfif>
											</cfif>
										</td>
									</tr>
									<tr><td colspan="2">&nbsp;</td></tr>
									
									<cfif DateCompare(PacificNow, getData.startDate, 'd') NEQ 1 OR (DateCompare(PacificNow, getData.startDate, 'd') EQ 1 AND DateCompare(PacificNow, getData.endDate, 'd') NEQ 1)>
										<cfset variables.actionCap = "Cancel Booking">
									<cfelse>
										<cfset variables.actionCap = "Delete Booking">
									</cfif>
									
									<tr>
										<td align="center" colspan="2">
										<a href="javascript:EditSubmit('viewForm#ID#');" class="textbutton">View / Edit Tariff Form</a>
										<a href="javascript:EditSubmit('delete#ID#');" class="textbutton">#variables.actionCap#</a><br /><br />
										<a href="javascript:EditSubmit('deny#ID#');" class="textbutton">Deny Request</a>
										<div style="height:20;">&nbsp;</div></td>
									</tr>
								</table>
							
							</td></tr>
								</cfif>
							</cfoutput>
							
						<cfelse>
							<tr style="font-size:10pt;">
								<td colspan="4" class="calendar">
									There are no bookings for this date range.
								</td>
							</tr>
						</cfif>
						
					</table>
					<table width="100%" cellspacing="0" cellpadding="0" style="padding-top: 5px; ">
						<tr>
							<cfoutput><td align="left" width="50%"><a href="addbooking.cfm?#urltoken#" class="textbutton">Add New Drydock Booking</a><div style="height:0;">&nbsp;</div></td></cfoutput>
							<cfif form.expandAll NEQ "yes">
								<td align="right" width="50%"><a href="javascript:EditSubmit('expandAll');">Expand All</a><div style="height:0;">&nbsp;</div></td>
							<cfelse>
								<td align="right" width="50%"><a href="javascript:EditSubmit('expandAll');">Collapse All</a><div style="height:0;">&nbsp;</div></td>
							</cfif>
						</tr>
					</table>
					<hr />
					<h2>Maintenance</h2>
				
					<table width="100%" cellspacing="0" cellpadding="0" style="padding-bottom: 5px; ">
						<tr>
							<cfoutput><td align="left" width="50%"><a href="addMaintBlock.cfm?#urltoken#" class="textbutton">Add New Maintenance Block</a></td></cfoutput>
						</tr>
					</table>
				
					<cfquery name="getMaintenance" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
						SELECT  Bookings.*, Docks.Section1, Docks.Section2, Docks.Section3
						FROM 	Bookings INNER JOIN Docks ON Bookings.BookingID = Docks.BookingID
						WHERE	(
									(Bookings.startDate >= '#dateformat(form.startDate, "mm/dd/yyyy")#'	AND Bookings.startDate <= '#dateformat(form.endDate, "mm/dd/yyyy")#') 
								OR	(Bookings.startDate <= '#dateformat(form.startDate, "mm/dd/yyyy")#'	AND Bookings.endDate >= '#dateformat(form.endDate, "mm/dd/yyyy")#') 
								OR 	(Bookings.endDate >= '#dateformat(form.startDate, "mm/dd/yyyy")#'	AND Bookings.endDate <= '#dateformat(form.endDate, "mm/dd/yyyy")#')
								)		
						AND 	Bookings.Deleted = 0
						AND 	Docks.Status = 'M'	
						ORDER BY Bookings.startDate, Bookings.endDate	
					</cfquery>
					
					<cfif getMaintenance.RecordCount GT 0>
						<cfoutput query="getMaintenance">
							<cfset Variables.id = #BookingID#>
							<form name="MaintenanceEdit#id#" action="editMaintBlock.cfm?#urltoken#" method="post">
								<input type="hidden" name="BookingID" value="#id#">
							</form>
							<form name="MaintenanceDel#id#" action="deleteMaintBlock_confirm.cfm?#urltoken#" method="post">
								<input type="hidden" name="BookingID" value="#id#">
							</form>
						</cfoutput>
					</cfif>
					<table class="calendar" cellpadding="3" cellspacing="0" width="100%">
						<tr style="background-color:#cccccc;">
							<th id="Start" class="calendar" style="width: 20%;">Start Date</th>
							<th id="End" class="calendar" style="width: 20%;">End Date</th>
							<th id="Section" class="calendar" style="width: 40%;">Section</th>
							<th class="calendar" colspan="2" style="width: 20%;">&nbsp;</th>
						</tr>
						<cfif getMaintenance.RecordCount GT 0>
							<cfoutput query="getMaintenance">
								<cfif DateCompare(PacificNow, getMaintenance.startDate, 'd') NEQ 1 OR (DateCompare(PacificNow, getMaintenance.startDate, 'd') EQ 1 AND DateCompare(PacificNow, getMaintenance.endDate, 'd') NEQ 1)>
									<cfset variables.actionCap = "Cancel">
								<cfelse>
									<cfset variables.actionCap = "Delete">
								</cfif>
					
								<cfset Variables.id = #BookingID#>
								<tr style="font-size:10pt;">
									<td headers="Start" class="calendar" nowrap>#dateformat(startDate, "mmm d, yyyy")#</td>
									<td headers="End" class="calendar" nowrap>#dateformat(endDate, "mmm d, yyyy")#</td>
									<td headers="Section" class="calendar">
										<cfif getMaintenance.Section1 AND getMaintenance.Section2 AND getMaintenance.Section3>
											All Sections
										<cfelse>
											<cfif getMaintenance.Section1>Section 1</cfif>
											<cfif getMaintenance.Section2><cfif getMaintenance.Section1> &amp; </cfif>Section 2</cfif>
											<cfif getMaintenance.Section3><cfif getMaintenance.Section1 OR getMaintenance.Section2> &amp; </cfif>Section 3</cfif>
										</cfif>
									</td>
									<td class="calendar"><a href="javascript:EditSubmit('MaintenanceEdit#id#');">Edit</a></td>
									<td class="calendar"><a href="javascript:EditSubmit('MaintenanceDel#id#');">#variables.actionCap#</a></td>
								</tr>
							</cfoutput>
						<cfelse>
							<tr style="font-size:10pt;">
								<td colspan="5" class="calendar">
									There are no maintenance blocks for this date range.
								</td>
							</tr>
						</cfif>
					</table>
					<table width="100%" cellspacing="0" cellpadding="0" style="padding-top: 5px; ">
						<tr>
							<cfoutput><td align="left" width="50%"><a href="addMaintBlock.cfm?#urltoken#" class="textbutton">Add New Maintenance Block</a><div style="height:0;">&nbsp;</div></td></cfoutput>
						</tr>
					</table>
					
				</cfif>
			</div>
		<!-- CONTENT ENDS | FIN DU CONTENU -->
		</div>
<cfinclude template="#RootDir#includes/foot-pied-#lang#.cfm">
