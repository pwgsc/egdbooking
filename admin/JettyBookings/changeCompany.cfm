<cfhtmlhead text="
	<meta name=""dcterms.title"" content=""PWGSC - ESQUIMALT GRAVING DOCK - Edit Booking"">
	<meta name=""keywords"" content="""" />
	<meta name=""description"" content="""" />
	<meta name=""dcterms.description"" content="""" />
	<meta name=""dcterms.subject"" content="""" />
	<title>PWGSC - ESQUIMALT GRAVING DOCK - Edit Booking</title>">
	<cfset request.title = "Change Company">
<cfinclude template="#RootDir#includes/tete-header-#lang#.cfm">

<cfquery name="getCompanyList" datasource="#DSN#" username="#dbuser#" password="#dbpassword#">
SELECT Companies.CID, Companies.Name
	FROM Companies JOIN Vessels ON Companies.CID = Vessels.CID
	WHERE Companies.Approved = 1 AND Companies.Deleted = 0 AND Vessels.Name = <cfqueryparam value="#vesselNameURL#" cfsqltype="cf_sql_varchar" /> AND Companies.Name <> <cfqueryparam value="#CompanyURL#" cfsqltype="cf_sql_varchar" />
	ORDER BY Companies.Name
</cfquery>

<h1 id="wb-cont">
	<!-- CONTENT TITLE BEGINS | DEBUT DU TITRE DU CONTENU -->
	Change Company
	<!-- CONTENT TITLE ENDS | FIN DU TITRE DU CONTENU -->
</h1>

<CFINCLUDE template="#RootDir#includes/admin_menu.cfm">

<cfif getCompanyList.recordCount LTE "0">

<cfoutput>  #CompanyURL# cannot be changed because #vesselNameURL# isn't available in another company.
</cfoutput>
<cfelse>
	<cfoutput><form action="changeCompany2.cfm" method="post">
		<input type="hidden" value="#vesselNameURL#" name="vesselNameURL" required="Yes" readonly="yes">
		<input type="hidden" value="#BRIDURL#" name="BRIDURL" required="Yes" readonly="yes" />
		<input type="hidden" value="#CompanyURL#" name="CompanyURL" required="Yes" readonly="yes" />
		<input type="hidden" value="#UserNameURL#" name="UserNameURL" required="Yes" readonly="yes" />
	<div class="module-info modwide">
		<h2>#vesselNameURL#</h2>
		<ul>
			<b>Original Company:</b> #CompanyURL#<br/>
			<b>Original Agent:</b> #UserNameURL#<br/>
		</ul>
	</div>
	<br/>
		Change to Company: <select name="newCID" size="1" required="yes">
		  <cfloop query="getCompanyList">
			<option value="#CID#">#Name#</option>
		  </cfloop> </select></td>
	  <br/>
	  <input id="submit" type="submit" value="Submit" class="button button-accent" />	
	</form> </cfoutput> 
</cfif>

<cfinclude template="#RootDir#includes/foot-pied-#lang#.cfm">
