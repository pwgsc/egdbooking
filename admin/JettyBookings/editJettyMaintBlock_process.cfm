<cfoutput>

<cfif isDefined("form.startDate")><cfinclude template="#RootDir#includes/build_form_struct.cfm"></cfif>

<cfinclude template="#RootDir#includes/restore_params.cfm">

<cfhtmlhead text="
	<meta name=""dcterms.title"" content=""PWGSC - ESQUIMALT GRAVING DOCK - Edit Maintenance Block"">
	<meta name=""keywords"" content="""" />
	<meta name=""description"" content="""" />
	<meta name=""dcterms.description"" content="""" />
	<meta name=""dcterms.subject"" content="""" />
	<title>PWGSC - ESQUIMALT GRAVING DOCK - Edit Maintenance Block</title>">
	<cfset request.title = "Edit Maintenance Block">
<cfinclude template="#RootDir#includes/tete-header-#lang#.cfm">

<!-- Start JavaScript Block -->
<script type="text/javascript">
/* <![CDATA[ */
function EditSubmit ( selectedform )
	{
	  document.forms[selectedform].submit();
	}
/* ]]> */
</script>
<!-- End JavaScript Block -->

		
		<div class="colLayout">

			<!-- CONTENT BEGINS | DEBUT DU CONTENU -->
			<div class="center">
				<h1 id="wb-cont">
					<!-- CONTENT TITLE BEGINS | DEBUT DU TITRE DU CONTENU -->
					Edit Maintenance Block
					<!-- CONTENT TITLE ENDS | FIN DU TITRE DU CONTENU -->
					</h1>

				<CFINCLUDE template="#RootDir#includes/admin_menu.cfm">
				<!--- ---------------------------------------------------------------------------------------------------------------- --->
				<cfparam name = "Form.StartDate" default="">
				<cfparam name = "Form.EndDate" default="">
				<cfparam name = "Variables.StartDate" default = "#CreateODBCDate(Form.StartDate)#">
				<cfparam name = "Variables.EndDate" default = "#CreateODBCDate(Form.EndDate)#">
				<cfparam name = "Variables.NorthJetty" default = "0">
				<cfparam name = "Variables.SouthJetty" default = "0">
				<cfparam name = "Variables.BRID" default = "#Form.BRID#">

				<cfif IsDefined("Form.NorthJetty")>
					<cfset Variables.NorthJetty = 1>
				</cfif>
				<cfif IsDefined("Form.SouthJetty")>
					<cfset Variables.SouthJetty = 1>
				</cfif>

				<cfif Variables.StartDate EQ "">
					<cflocation addtoken="no" url="editbooking.cfm?lang=#lang#">
				</cfif>

				<!-- <cfset Variables.StartDate = CreateODBCDate(#Variables.StartDate#)>
				<cfset Variables.EndDate = CreateODBCDate(#Variables.EndDate#)> -->

				<cfif IsDefined("Session.Return_Structure")>
					#StructDelete(Session, "Return_Structure")#
				</cfif>


				<!---Do a check on Double Maintenance Bookings--->
				<cfquery name="checkDblBooking" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
					SELECT 	NorthJetty, SouthJetty, StartDate, EndDate
					FROM 	Bookings, Jetties
					WHERE 	Jetties.BRID = Bookings.BRID
					AND		Bookings.BRID != <cfqueryparam value="#Form.BRID#" cfsqltype="cf_sql_integer" />
					AND		Status = 'M'
					AND		Deleted = '0'
					AND 	(
								(	Bookings.StartDate <= <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> AND <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> <= Bookings.EndDate )
							OR 	(	Bookings.StartDate <= <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> AND <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> <= Bookings.EndDate )
							OR	(	Bookings.StartDate >= <cfqueryparam value="#Variables.StartDate#" cfsqltype="cf_sql_date" /> AND <cfqueryparam value="#Variables.EndDate#" cfsqltype="cf_sql_date" /> >= Bookings.EndDate )
							)
					AND		(
								(	NorthJetty = '1' AND '#Variables.NorthJetty#' = '1')
							OR	( 	SouthJetty = '1' AND '#Variables.SouthJetty#' = '1')
							)
				</cfquery>

				<cfset Variables.StartDate = DateFormat(Variables.StartDate, 'mm/dd/yyy')>
				<cfset Variables.EndDate = DateFormat(Variables.EndDate, 'mm/dd/yyy')>

				<cfset Errors = ArrayNew(1)>
				<cfset Success = ArrayNew(1)>
				<cfset Proceed_OK = "Yes">

				<!--- Validate the form data --->
				<cfif (NOT isDefined("Form.NorthJetty")) AND (NOT isDefined("Form.SouthJetty"))>
					#ArrayAppend(Errors, "You must choose at least one of the jetties for maintenance bookings.")#
					no sections
					<cfset Proceed_OK = "No">
				</cfif>

				<cfif checkDblBooking.RecordCount GT 0>
					<cfif checkDblBooking.NorthJetty AND checkDblBooking.SouthJetty>
						#ArrayAppend(Errors, "There is already a maintenance booking for both jetties from #DateFormat(checkDblBooking.startDate, 'mmm d, yyyy')# to #DateFormat(checkDblBooking.endDate, 'mmm d, yyyy')#.")#
					<cfelseif checkDblBooking.NorthJetty>
						#ArrayAppend(Errors, "There is already a maintenance booking for the North Landing Wharf from #DateFormat(checkDblBooking.startDate, 'mmm d, yyyy')# to #DateFormat(checkDblBooking.endDate, 'mmm d, yyyy')#.")#
					<cfelse>
						#ArrayAppend(Errors, "There is already a maintenance booking for the South Jetty from #DateFormat(checkDblBooking.startDate, 'mmm d, yyyy')# to #DateFormat(checkDblBooking.endDate, 'mmm d, yyyy')#.")#
					</cfif>
					<cfset Proceed_OK = "No">
				</cfif>

				<cfif Variables.StartDate GT Variables.EndDate>
					#ArrayAppend(Errors, "The Start Date must be before the End Date.")#
					<cfset Proceed_OK = "No">
				</cfif>

				<cfif DateDiff("d",Variables.StartDate,Variables.EndDate) LT 0>
					#ArrayAppend(Errors, "The minimum booking time is 1 day.")#
					<cfset Proceed_OK = "No">
				</cfif>

				<cfif DateCompare(PacificNow, Variables.StartDate, 'd') EQ 1 AND DateCompare(PacificNow, Variables.EndDate, 'd') EQ 1>
					#ArrayAppend(Errors, "This maintenance period has ended. Please create a new block.")#
					<cfset Proceed_OK = "No">
				<!--- <cfelseif checkDblBooking.RecordCound GT 0>
					#ArrayAppend(Errors, "There are section already been booked for maintenance during this time.")#
					<cfset Proceed_OK = "No"> --->
				</cfif>


				<cfif Proceed_OK EQ "No">
					<!--- Save the form data in a session structure so it can be sent back to the form page --->
					<cfset Session.Return_Structure.StartDate = Variables.StartDate>
					<cfset Session.Return_Structure.EndDate = Variables.EndDate>
					<cfset Session.Return_Structure.NorthJetty = Variables.NorthJetty>
					<cfset Session.Return_Structure.SouthJetty = Variables.SouthJetty>

					<cfset Session.Return_Structure.Errors = Errors>

					<cflocation url="editJettyMaintBlock.cfm?#urltoken#" addToken="no">
				</cfif>


				<!-- Gets all Bookings that would be affected by the maintenance block -->
				<cfquery name="checkConflicts" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
					SELECT	NorthJetty, SouthJetty, StartDate, EndDate, V.Name AS VesselName, C.Name AS CompanyName
					FROM	Bookings B INNER JOIN Jetties J ON B.BRID = J.BRID
								INNER JOIN Vessels V ON V.VNID = B.VNID
								INNER JOIN Companies C ON C.CID = V.CID
					WHERE	B.Deleted = '0'
						AND	V.Deleted = '0'
						AND	EndDate >= <cfqueryparam value="#CreateODBCDate(Variables.StartDate)#" cfsqltype="cf_sql_date">
						AND StartDate <= <cfqueryparam value="#CreateODBCDate(Variables.EndDate)#" cfsqltype="cf_sql_date">
						AND	(<CFIF Variables.NorthJetty>NorthJetty = '1'</CFIF>
						<CFIF Variables.SouthJetty><CFIF Variables.NorthJetty>OR	</CFIF>SouthJetty = '1'</CFIF>)
				</cfquery>

				<cfset Variables.StartDate = #CreateODBCDate(Variables.StartDate)#>
				<cfset Variables.EndDate = #CreateODBCDate(Variables.EndDate)#>

				<CFIF checkConflicts.RecordCount GT 0>

					<p>The requested date range for the maintenance block <strong class="red">conflicts</strong> with the following bookings:</p>

					<table class="basic smallFont">
					<tr valign="top" align="left">
						<th>Period</th>
						<th>Vessel</th>
						<th>Company</th>
						<th style="width:30%;">Sections</th>
					</tr>

					<cfset counter = 0>
					<cfloop query="checkConflicts">
						<CFIF counter mod 2 eq 1>
							<CFSET rowClass = "highlight">
						<CFELSE>
							<CFSET rowClass = "">
						</CFIF>
						<tr class="#rowClass#" valign="top">
							<td>#LSdateformat(startDate, 'mmm d')#<CFIF Year(StartDate) neq Year(EndDate)>, #DateFormat(startDate, 'yyyy')#</CFIF> - #LSdateformat(endDate, 'mmm d, yyyy')#</td>
							<td>#VesselName#</td>
							<td>#CompanyName#</td>
							<td align="center">
								<cfif NorthJetty EQ 1>North Landing Wharf </cfif>
								<cfif SouthJetty EQ 1>South Jetty </cfif>
							</td>
						</tr>
						<cfset counter = counter + 1>
          </cfloop>
					
					</table>

					<p>If you would like to go ahead and book the maintenance block, please <strong class="red">confirm</strong> the following information, or <strong class="red">go back</strong> to change the information.</p>

				<CFELSE>
					<p>Please confirm the following maintenance block information.</p>
				</CFIF>

				<form action="editJettyMaintBlock_action.cfm?#urltoken#" method="post" id="bookingreq" preservedata="Yes">
				<input type="hidden" name="BRID" value="#Variables.BRID#" />

				<table style="width:80%;" align="center">
					<tr><td align="left"><div style="font-weight:bold;">Booking:</div></td></tr>
					<tr>
						<td id="Start" align="left" style="width:25%;">Start Date:</td>
						<td headers="Start"><input type="hidden" name="StartDate" value="#Variables.StartDate#" />#DateFormat(Variables.StartDate, 'mmm d, yyyy')#</td>
					</tr>
					<tr>
						<td id="End" align="left">End Date:</td>
						<td headers="End"><input type="hidden" name="EndDate" value="#Variables.EndDate#" />#DateFormat(Variables.EndDate, 'mmm d, yyyy')#</td>
					</tr>
					<tr>
						<td id="Sections" align="left">Sections:</td>
						<td headers="Sections">
							<input type="hidden" name="NorthJetty" value="#Variables.NorthJetty#" />
							<input type="hidden" name="SouthJetty" value="#Variables.SouthJetty#" />
							<cfif Variables.NorthJetty EQ 1>
								North Landing Wharf
							</cfif>
							<cfif Variables.SouthJetty EQ 1>
								<cfif Variables.NorthJetty EQ 1>
									&amp;
								</cfif>
								South Jetty
							</cfif>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td colspan="2" align="center">

							<input type="submit" value="Submit" class="button button-accent" />
							<a href="editJettyMaintBlock.cfm?#urltoken#" class="textbutton">Back</a>
							<a href="jettyBookingManage.cfm?#urltoken#" class="textbutton">Cancel</a>
						</td>
					</tr>
				</table>

				</form>
			</div>

		<!-- CONTENT ENDS | FIN DU CONTENU -->
		</div>
<cfinclude template="#RootDir#includes/foot-pied-#lang#.cfm">

</cfoutput>
