<cfif structKeyExists(session, 'uid')>
  <cfquery name="readonlycheck" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
    SELECT ReadOnly
    FROM Users
    WHERE UID = <cfqueryparam value="#Session.UID#" cfsqltype="cf_sql_integer" />
  </cfquery>
  <cfoutput query="readonlycheck">
    <cfset Session.ReadOnly = #ReadOnly#>
  </cfoutput>
</cfif>

<cfset Variables.BookingRequestString = "">
<cfif IsDefined("URL.VNID")>
  <cfset Variables.BookingRequestString = "&amp;VNID=#URL.VNID#">
<cfelseif IsDefined("URL.CID")>
  <cfset Variables.BookingRequestString = "&amp;CID=#URL.CID#">
</cfif>
<cfif IsDefined("URL.Date") AND DateCompare(#url.date#, #PacificNow#, 'd') EQ 1>
  <cfset Variables.BookingRequestString = "#Variables.BookingRequestString#&amp;Date=#URL.Date#">
</cfif>

<CFSET variables.datetoken = "">
<CFIF structKeyExists(url, 'm-m')>
  <CFSET variables.datetoken = variables.datetoken & "&amp;m-m=#url['m-m']#">
</CFIF>
<CFIF structKeyExists(form, 'a-y')>
  <CFSET variables.datetoken = variables.datetoken & "&amp;a-y=#url['a-y']#">
</CFIF>


<!-- Start of app_nav_gauche-nav_left_app-eng.html / Début de app_nav_gauche-nav_left_app-eng.html -->
<cfoutput>
<nav role="navigation"><h2 id="wb-nav">Secondary menu</h2>
<div class="wb-sec">
<!-- SecNavStart -->
<section class="list-group menu list-unstyled"><h3><a href="#EGD_URL#/index-#lang#.html"><abbr title="#language.esqGravingDock#">#language.egd#</abbr></a></h3>
<ul class="list-group menu list-unstyled">
<cfif structKeyExists(session, 'loggedin')>
<li><a class="list-group-item" href="#RootDir#reserve-book/reserve-booking.cfm?lang=#lang#" title="#language.BookingHome#">#language.BookingHome#</a></li>
<li><a class="list-group-item" href="#RootDir#comm/resume-summary_ch.cfm?lang=#lang#">#language.bookingsSummary#</a></li>
<li><a class="list-group-item" href="#RootDir#comm/calend-cale-dock.cfm?lang=#lang##datetoken#">#language.drydockCalendar#</a></li>
<li><a class="list-group-item" href="#RootDir#comm/calend-jet.cfm?lang=#lang##datetoken#">#language.JettyCalendar#</a></li>

<cfif structKeyExists(session, 'readonly') and Session.ReadOnly NEQ 1>
<li><a class="list-group-item" href="#RootDir#reserve-book/resdemande-bookrequest.cfm?lang=#lang##Variables.BookingRequestString#" title="#language.requestBooking#">#language.requestBooking#</a></li>
<li><a class="list-group-item" href="#RootDir#reserve-book/navireajout-vesseladd.cfm?lang=#lang#">#Language.addVessel#</a></li>
</cfif>
<li><a class="list-group-item" href="#RootDir#reserve-book/archives.cfm?lang=#lang#">#language.archivedBookings#</a></li>
<li><a class="list-group-item" href="#RootDir#reserve-book/profilmod-profileedit.cfm?lang=#lang#">#language.EditProfileButton#</a></li>
<li><a class="list-group-item" href="#RootDir#comm/avis-notices.cfm?lang=#lang#">#language.notices#</a></li>
<li><a class="list-group-item" href="#RootDir#comm/tarif-tariff.cfm?lang=#lang#">#language.tariff#</a></li>
<li><a class="list-group-item" href="#RootDir#ols-login/fls-logout.cfm?lang=#lang#">#language.LogoutButton#</a></li>
<cfelseif structKeyExists(session, 'AdminLoggedIn')>
<li><a class="list-group-item" href="#RootDir#reserve-book/reserve-booking.cfm?lang=#lang#" title="#language.BookingHome#">#language.BookingHome#</a></li>
<li><a class="list-group-item" href="#RootDir#comm/resume-summary_ch.cfm?lang=#lang#">#language.bookingsSummary#</a></li>
<li><a class="list-group-item" href="#RootDir#comm/calend-cale-dock.cfm?lang=#lang##datetoken#">#language.drydockCalendar#</a></li>
<li><a class="list-group-item" href="#RootDir#comm/calend-jet.cfm?lang=#lang##datetoken#">#language.JettyCalendar#</a></li>
<li><a class="list-group-item" href="#RootDir#comm/avis-notices.cfm?lang=#lang#">#language.notices#</a></li>
<li><a class="list-group-item" href="#RootDir#comm/tarif-tariff.cfm?lang=#lang#">#language.tariff#</a></li>
<li><a class="list-group-item" href="#RootDir#ols-login/fls-logout.cfm?lang=#lang#">#language.LogoutButton#</a></li>
<cfelse>
<li><a class="list-group-item" href="#RootDir#ols-login/ols-login.cfm?lang=#lang#">#language.bookingApplicationLogin#</a></li>
<li><a class="list-group-item" href="#RootDir#ols-login/utilisateurajout-useradd.cfm?lang=#lang#">#language.addUser#</a></li>
</cfif>
</ul>
</section>
<!-- SecNavEnd -->
</div>
</nav>
</cfoutput>
<!-- End of app_nav_gauche-nav_left_app-eng.html / Fin De app_nav_gauche-nav_left_app-eng.html -->
