<cfif lang EQ "eng">
	<cfset language.title = "Booking Application Login">
	<cfset language.login = "Login">
	<cfset language.description ="Login page for the booking application.">
	<cfset language.browser = "Please ensure that your browser meets the following requirements before proceeding:">
	<cfset language.displayproblem = "The application may not function properly without these components.">
	<cfset language.jserror = "You do not have JavaScript enabled.  Parts of this application will not function properly.">
	<cfset language.forgot = "Forgot password">
	<cfset language.addUser = "Register an account">
	<cfset language.email = "Email">
	<cfset language.password = "Password">
	<cfset language.Remember = "Remember Me">
<cfelse>
	<cfset language.title = "Entrer dans l'application de r&eacute;servation">
	<cfset language.login = "Ouvrir la session">
	<cfset language.description ="Page d'ouverture de session pour la demande de r&eacute;servation.">
	<cfset language.browser = "Veuillez v&eacute;rifier que votre navigateur Web r&eacute;pond aux exigences suivantes avant de continuer&nbsp;:">
	<cfset language.displayproblem = "L'application ne fonctionnera peut-&ecirc;tre pas correctement sans ces composantes.">
	<cfset language.jserror = "La fonction JavaScript n'est pas activ&eacute;e. Des parties de l'application ne fonctionnent pas correctement.">
	<cfset language.forgot = "Oubli du mot de passe">
	<cfset language.addUser = "Cr&eacute;er un compte">
	<cfset language.email = "Courriel">
	<cfset language.password = "Mot de passe">
	<cfset language.Remember = "Rappelez-vous moi">
</cfif>

<cfif IsDefined("Session.Form_Structure")>
	<cfset StructDelete(Session, "Form_Structure")>
</cfif>

<cfhtmlhead text="
	<meta name=""dc.title"" content=""#language.title# - #language.esqGravingDock# - #language.PWGSC#"" />
	<meta name=""keywords"" content=""#language.masterKeywords# #language.Login#"" />
	<meta name=""description"" content=""#language.description#"" />
	<meta name=""dc.subject"" scheme=""gccore"" content=""#language.masterSubjects#"" />
	<title>#language.title# - #language.esqGravingDock# - #language.PWGSC#</title>">
<cfinclude template="#RootDir#includes/tete-header-#lang#.cfm">

<cfif IsDefined("Session.Return_Structure") AND isDefined("url.pass") AND url.pass EQ "true">
	<cfset Variables.onLoad = "javascript:document.login_form.Password.focus();">
<cfelse>
	<cfset Variables.onLoad = "javascript:document.login_form.email.focus();">
</cfif>

<CFIF IsDefined("Cookie.login")>
	<CFSET email = "#Cookie.login#">
<CFELSE>
	<CFSET email = "">
</CFIF>

<cfheader name="Pragma" value="no-cache">
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
<cfcookie name="CFID" value="empty" expires="NOW">
<cfcookie name="CFTOKEN" value="empty" expires="NOW">

		<!-- BREAD CRUMB BEGINS | DEBUT DE LA PISTE DE NAVIGATION -->
		<p class="breadcrumb">
			<cfinclude template="#CLF_Path#/clf20/ssi/bread-pain-#lang#.html"><cfinclude template="#RootDir#includes/bread-pain-#lang#.cfm">&gt;
			<cfoutput>#language.title#</cfoutput>
		</p>
		<!-- BREAD CRUMB ENDS | FIN DE LA PISTE DE NAVIGATION -->
		<div class="colLayout">
		<cfinclude template="#RootDir#includes/left-menu-gauche-#lang#.cfm">
			<!-- CONTENT BEGINS | DEBUT DU CONTENU -->
			<div class="center">
				<h1><a name="cont" id="cont">
					<!-- CONTENT TITLE BEGINS | DEBUT DU TITRE DU CONTENU -->
					<cfoutput>#language.title#</cfoutput>
					<!-- CONTENT TITLE ENDS | FIN DU TITRE DU CONTENU -->
					</a></h1>

				<cfoutput>
					<!--- If the last login failed, show error message --->
					<cfif IsDefined("Session.Return_Structure")>
						<cfinclude template="#RootDir#includes/getStructure.cfm">
						<br />
					</cfif>

					<!-- Display the login form and pass contents to login_action.cfm -->
					<form action="ols-login_action.cfm?lang=#lang#" method="post" id="login_form">
            <fieldset>
              <legend>#language.login#</legend>
              <label for="email">#language.Email#:</label>
              <input type="text" name="email" id="email" size="40" maxlength="100" value="#email#" />
              <label for="password">#language.Password#:</label>
              <input type="password" name="Password" id="password" size="25" maxlength="40" />
              <div>
                <label for="remember">#language.Remember#</label>
                <input name="remember" type="checkbox" id="remember" value="remember" <CFIF IsDefined("Cookie.login")>checked="checked"</CFIF> />
              </div>
              <input type="submit" name="submitForm" value="#language.Login#" class="textbutton" />
            </fieldset>
					</form>
					<div><a href="utilisateurajout-useradd.cfm?lang=#lang#">#language.addUser#</a></div>
					<div><a href="passeoubli-passforgot.cfm?lang=#lang#">#language.Forgot#</a></div>
				</cfoutput>
				</div>
			<!-- CONTENT ENDS | FIN DU CONTENU -->
		</div>

<cfinclude template="#RootDir#includes/foot-pied-#lang#.cfm">

