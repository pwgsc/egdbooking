<cfinclude template="#RootDir#includes/companyInfoVariables.cfm">

<cfif lang EQ "eng">
	<cfset language.createComp = "Create New Company">
	<cfset language.keywords = "#language.masterKeywords#" & ", Add New Company">
	<cfset language.description = "Allows user to create a new company.">
	<cfset language.subjects = "#language.masterSubjects#">
	<cfset language.createUser = "Create New User">
<cfelse>
	<cfset language.createComp = "Cr&eacute;er une nouvelle entreprise">
	<cfset language.keywords = "#language.masterKeywords#" & ", Ajout d'une entreprise">
	<cfset language.description = "Permet &agrave; l'utilisateur de cr&eacute;er un nouveau compte pour une entreprise.">
	<cfset language.subjects = "#language.masterSubjects#">
	<cfset language.createUser = "Cr&eacute;er un nouvel utilisateur">

</cfif>

<cfhtmlhead text="
	<meta name=""dc.title"" lang=""eng"" content=""#language.PWGSC# - #language.EsqGravingDockCaps# - #language.CreateComp#"">
	<meta name=""keywords"" lang=""eng"" content=""#language.keywords#"">
	<meta name=""description"" lang=""eng"" content=""#language.description#"">
	<meta name=""dc.subject"" scheme=""gccore"" lang=""eng"" content=""#language.subjects#"">
	<meta name=""dc.date.published"" content=""2005-07-25"">
	<meta name=""dc.date.reviewed"" content=""2005-07-25"">
	<meta name=""dc.date.modified"" content=""2005-07-25"">
	<meta name=""dc.date.created"" content=""2005-07-25"">
	<title>#language.PWGSC# - #language.EsqGravingDockCaps# - #language.CreateComp#</title>">

<cfset Variables.onLoad = "javascript:document.addCompanyForm.name.focus();">
<cfinclude template="#RootDir#includes/checkFilledIn_js.cfm">

<cfinclude template="#RootDir#includes/tete-header-#lang#.cfm">

		<!-- BREAD CRUMB BEGINS | DEBUT DE LA PISTE DE NAVIGATION -->
		<p class="breadcrumb">
			<cfinclude template="/clf20/ssi/bread-pain-#lang#.html"><cfinclude template="#RootDir#includes/bread-pain-#lang#.cfm">&gt;
			<CFOUTPUT>
			<a href="#RootDir#text/ols-login/login.cfm?lang=#lang#">#language.login#</a> &gt; 
			<a href="#RootDir#text/ols-login/addUserCompanies.cfm?lang=#lang#&info=#url.info#&companies=#url.companies#">#language.createUser#</a> &gt; 
			#language.CreateComp#
			</CFOUTPUT>
		</p>
		<!-- BREAD CRUMB ENDS | FIN DE LA PISTE DE NAVIGATION -->
		<div class="colLayout">
		<cfinclude template="#RootDir#includes/left-menu-gauche-#lang#.cfm">
			<!-- CONTENT BEGINS | DEBUT DU CONTENU -->
			<div class="center">
				<h1><a name="cont" id="cont">
					<!-- CONTENT TITLE BEGINS | DEBUT DU TITRE DU CONTENU -->
					<CFOUTPUT>#language.CreateComp#</CFOUTPUT>
					<!-- CONTENT TITLE ENDS | FIN DU TITRE DU CONTENU -->
					</a></h1>

					<CFOUTPUT>
					<cfparam name="Variables.name" default="">
					<cfparam name="Variables.address1" default="">
					<cfparam name="Variables.address2" default="">
					<cfparam name="Variables.city" default="">
					<cfparam name="Variables.province" default="">
					<cfparam name="Variables.country" default="">
					<cfparam name="Variables.zip" default="">
					<cfparam name="Variables.phone" default="">
					<cfparam name="Variables.fax" default="">
	
					<cfinclude template="#RootDir#includes/restore_params.cfm">
					<cfif isDefined("session.form_structure") AND isDefined("form.name")>
						<cfset variables.name="#form.name#">
						<cfset variables.address1="#form.address1#">
						<cfset variables.address2="#form.address2#">
						<cfset variables.city="#form.city#">
						<cfset variables.province="#form.province#">
						<cfset variables.country="#form.country#">
						<cfset variables.zip="#form.zip#">
						<cfset variables.phone="#form.phone#">
						<cfset variables.fax="#form.fax#">
					</cfif>
	
					<cfif isDefined("Session.Return_Structure")>
						<cfinclude template="#RootDir#includes/getStructure.cfm">
					</cfif>
	
					<cfform action="addCompany_action.cfm?lang=#lang#&info=#url.info#&companies=#url.companies#" name="addCompanyForm" method="post" onSubmit="if(!checkFilledIn('addCompanyForm')) { return false; }">
						<table align="center">
							<tr>
								<td id="name_header"><label for="name">#language.companyName#:</label></td>
								<td header="name_header"><cfinput name="name" id="name" type="text" size="40" maxlength="75" required="yes" value="#Variables.name#" CLASS="textField" message="#language.nameError#"></td>
							</tr>
							<tr>
								<td id="address1_header"><label for="address1">#language.Address# 1:</label></td>
								<td header="address1_header"><cfinput name="address1" id="address1" type="text" size="40" maxlength="75" required="yes" value="#Variables.address1#" CLASS="textField" message="#language.addressError#"></td>
							</tr>
							<tr>
								<td id="address2_header"><label for="address2">#language.Address# 2 #language.optional#:</label></td>
								<td header="address2_header"><cfinput name="address2" id="address2" type="text" size="40" maxlength="75" value="#Variables.address2#" CLASS="textField"></td>
							</tr>
							<tr>
								<td id="city_header"><label for="city">#language.City#:</label></td>
								<td header="city_header"><cfinput name="city" id="city" type="text" size="25" maxlength="40" required="yes" value="#Variables.city#" CLASS="textField" message="#language.cityError#"></td>
							</tr>
							<tr>
								<td id="province_header"><label for="province">#language.Province#:</label></td>
								<td header="province_header"><cfinput name="province" id="province" type="text" size="25" maxlength="40" required="no" value="#Variables.province#" CLASS="textField" message="#language.provinceError#"></td>
							</tr>
							<tr>
								<td id="country_header"><label for="country">#language.Country#:</label></td>
								<td header="country_header"><cfinput name="country" id="country" type="text" size="25" maxlength="40" required="yes" value="#Variables.country#" CLASS="textField" message="#language.countryError#"></td>
							</tr>
							<tr>
								<td id="zip_header"><label for="zip">#language.zip#:</label></td>
								<td header="zip_header"><cfinput name="zip" id="zip" type="text" size="12" maxlength="10" required="no" value="#Variables.zip#" CLASS="textField" message="#language.zipError#"></td>
							</tr>
							<tr>
								<td id="phone_header"><label for="phone">#language.Phone#:</label></td>
								<td header="phone_header"><cfinput name="phone" id="phone" type="text" size="25" maxlength="32" required="yes" value="#Variables.phone#" CLASS="textField" message="#language.phoneError#"></td>
							</tr>
							<tr>
								<td id="fax_header"><label for="fax">#language.Fax# #language.optional#:</label></td>
								<td headers="fax_header"><cfinput id="fax" name="fax" type="text" size="10" maxlength="32" CLASS="textField"></td>
							</tr>
							<tr>
								<td colspan="2" align="center" style="padding-top:20px;">
									<input type="submit" name="submitForm" class="textbutton" value="#language.Submit#" />
									<input type="button" value="#language.Cancel#" onclick="self.location.href='addUserCompanies.cfm?lang=#lang#&info=#url.info#&companies=#url.companies#'" class="textbutton" />							</td>
							</tr>
						</table>
					</cfform>
				</CFOUTPUT>
			</div>
			<!-- CONTENT ENDS | FIN DU CONTENU -->
		</div>
<cfinclude template="#RootDir#includes/foot-pied-#lang#.cfm">
