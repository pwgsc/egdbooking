<cfcomponent>
	<cfset this.name = "EGD Booking" />
	<cfset this.sessionmanagement = true />
	<cfset this.sessiontimeout = CreateTimeSpan(2,0,0,0) />
	<cfset this.clientmanagement = false />
	<cfset setEncoding("url","iso-8859-1") />

	<cffunction name="onApplicationStart">
		<!---<cfset application.router = createObject('component', 'supermodel2.router') />--->
	</cffunction>
	
	<cffunction name="onRequest" access="public" returntype="void">
		<cfargument name="targetPage" type="String" required="true" />

		<cfinclude template="server_settings.cfm" />
    <cfset this.mappings["/egdbooking"] = FileDir />

    <cfif ServerType EQ "Production" AND cgi.server_port NEQ 443 AND cgi.request_method EQ "get">
      <cflocation url="https://#cgi.server_name##cgi.script_name#?#cgi.query_string#" addtoken="no" />
    </cfif>

    <cfparam name="url.lang" default="eng">
    <cfif findnocase("-e",CGI.script_name) or findnocase("-eng",CGI.script_name)>
      <cfset url.lang = "eng">
    <cfelseif findnocase("-f",CGI.script_name) or findnocase("-fra",CGI.script_name)>
      <cfset url.lang = "fra">
    </cfif>

    <cfif lcase(url.lang) EQ "eng">
      <cfset SetLocale("English (Canadian)")>
      <cfset request.datemask = "mmm d, yyyy" />
      <cfset request.longdatemask = "mmmm d, yyyy" />
    <cfelseif lcase(url.lang) EQ "fra">
      <cfset SetLocale("French (Canadian)")>
      <cfset request.datemask = "d mmmm yyyy" />
      <cfset request.longdatemask = "d mmmm yyyy" />
    </cfif>

    <cfset Variables.MaxLength = 347.67>
    <cfset Variables.MaxWidth = 45.40>

    <cfinclude template="#RootDir#includes/generalLanguageVariables.cfm">
    <cfinclude template="#RootDir#includes/helperFunctions.cfm" />

    <cfif not structKeyExists(session, 'errors')>
      <cfset session['errors'] = structNew() />
    </cfif>

    <cfinclude template="#arguments.targetPage#" />

    <cfif structKeyExists(session, 'errors')>
      <cfset structClear(session['errors']) />
    </cfif>
  </cffunction>

</cfcomponent>


<!---<cfcomponent>
<cfset this.name = "EGD Booking" />
<cfset this.sessionmanagement = true />
<cfset this.sessiontimeout = CreateTimeSpan(2,0,0,0) />
<cfset this.clientmanagement = false />
<cfset setEncoding("url","iso-8859-1") />

<cffunction name="onRequest" access="public" returntype="void">
<cfargument name="targetPage" type="String" required="true" />

<cfinclude template="server_settings.cfm" />
    <cfset this.mappings["/egdbooking"] = FileDir>
<cfquery name="GetUser" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
SELECT *
FROM Users
WHERE email = <cfqueryparam value="demo.user@pwgsc.gc.ca" cfsqltype="cf_sql_varchar" />
AND Deleted = 0
</cfquery>

<CFCOOKIE NAME="LoggedIn" value="Yes" PATH="/EGD" DOMAIN="cse-egd.tpsgc-pwgsc.gc.ca">

<!--- Set the session variables for the session --->
<cflock timeout="60" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
<CFSCRIPT>
Session.UID = Trim(GetUser.UID);
Session.FirstName = Trim(GetUser.Firstname);
Session.LastName = Trim(GetUser.LastName);
Session.EMail = Trim(GetUser.EMail);
</CFSCRIPT>
</cflock>

  <CFSET Session.LoggedIn = "1">
<cflocation url="#RootDir#reserve-book/reserve-booking.cfm?lang=eng">

  </cffunction>
</cfcomponent>--->