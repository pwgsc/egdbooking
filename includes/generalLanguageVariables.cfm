<cfif lang eq "eng" OR (IsDefined('Session.AdminLoggedIn') AND Session.AdminLoggedIn eq true)>
	<cfset language.PWGSC = "PWGSC">
	<cfset language.pacificRegion = "Pacific Region">
	<cfset language.esqGravingDock = "Esquimalt Graving Dock">
	<cfset language.esqGravingDockCaps = "ESQUIMALT GRAVING DOCK">
	<cfset language.submit = "submit">
	<cfset language.cancel = "Cancel">
	<cfset language.admin = "Admin">
	<cfset language.confirm = "Confirm">
	<cfset language.drydock = "Drydock">
	<cfset language.jetty = "Jetty">
	<cfset language.northLandingWharf = "North Landing Wharf">
	<cfset language.southJetty = "South Jetty">
	<cfset language.back = "Back">
	<cfset language.vessel = "Vessel">
	<cfset language.status = "Status">
	<cfset language.tentative = "tentative">
	<cfset language.pending = "pending">
	<cfset language.confirmed = "confirmed">
	<cfset language.bookings = "Bookings">
	<cfset language.booking = "Booking">
	<cfset language.calendar = "This calendar provides a day by day availability summary for the Esquimalt Graving Dock">
	<cfset language.calendars = "calendars">
	<cfset language.dateform = "(MM/DD/YYYY)">
	<cfset language.welcomePage = "Welcome Page">
	<cfset language.login = "Login">
	<cfset language.masterKeywords = "Esquimalt Graving Dock, EGD, Booking Request">
	<cfset language.masterSubjects = "Wharfs; Water Transport; Ships; Ferries; Pleasure Craft; Vessels; Maintenance; Management">
  <cfset language.dateSelect = "Date Selection" />
  <cfset language.year = "Year" />
  <cfset language.month = "Month" />
<cfelse>
	<cfset language.PWGSC = "TPSGC">
	<cfset language.pacificRegion = "R&eacute;gion du Pacifique">
	<cfset language.esqGravingDock = "Cale s&egrave;che d'Esquimalt">
	<cfset language.esqGravingDockCaps = "CALE S&Eacute;CHE D'ESQUIMALT">
	<cfset language.submit = "Soumettre">
	<cfset language.cancel = "Annuler">
	<cfset language.admin = "Admin">
	<cfset language.confirm = "Confirmer">
	<cfset language.drydock = "Cale s&egrave;che">
	<cfset language.jetty = "Jet&eacute;e">
	<cfset language.northLandingWharf = "Quai de d&eacute;barquement nord">
	<cfset language.southJetty = "Jet&eacute;e sud">
	<cfset language.back = "Retour">
	<cfset language.vessel = "Navire">
	<cfset language.status = "&Eacute;tat">
	<cfset language.tentative = "provisoire">
	<cfset language.pending = "en traitement">
	<cfset language.confirmed = "confirm&eacute;">
	<cfset language.bookings = "R&eacute;servations">
	<cfset language.booking = "R&eacute;servation">
	<cfset language.calendar = "Ce calendrier offre un r&eacute;sum&eacute; au jour le jour de disponibilit&eacute; pour le Cale s&egrave;che d'Esquimalt">
	<cfset language.calendars = "calendriers">
	<cfset language.dateform = "(MM/JJ/AAAA)">
	<cfset language.welcomePage = "Page de bienvenue">
	<cfset language.login = "Ouvrir la session">
	<cfset language.masterKeywords = "Cale s&egrave;che d'Esquimalt, CSE, Demande de r&eacute;servation">
	<cfset language.masterSubjects = "Quai; Transport maritime; Navire; Traversier; Bateau de plaisance; Embarcation; Entretien; Gestion">
  <cfset language.dateSelect = "Choix de la date" />
  <cfset language.year = "Ann&eacute;e" />
  <cfset language.month = "Mois" />
</cfif>

	<cfif lang EQ 'eng'>
		<cfset language.bookingHomeButton = "Booking Home">
		<cfset language.drydockCalButton = "Drydock Calendar">
		<cfset language.jettyCalButton = "Jetties Calendar">
		<cfset language.requestBooking = "Request Booking">
		<cfset language.editProfileButton = "Edit Profile">
		<cfset language.help = "Help">
    <cfset language.bookingsSummary = "Bookings Summary">
		<cfset language.logoutButton = "Logout">
	<cfelse>
		<cfset language.bookingHomeButton = "Accueil - R&eacute;servation">
		<cfset language.drydockCalButton = "Calendrier de la cale s&egrave;che">
		<cfset language.jettyCalButton = "Calendrier des jet&eacute;es">
		<cfset language.requestBooking = "Pr&eacute;senter une r&eacute;servation">
		<cfset language.editProfileButton = "Modifier le profil">
		<cfset language.help = "Aide">
    <cfset language.bookingsSummary = "R&eacute;sum&eacute; des R&eacute;servations">
		<cfset language.logoutButton = "Fermer la session">
	</cfif>

