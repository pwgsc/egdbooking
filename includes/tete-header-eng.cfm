<cfoutput>
<!DOCTYPE html>
<!--[if IE 7]><html lang="en" class="no-js ie7"><![endif]-->
<!--[if IE 8]><html lang="en" class="no-js ie8"><![endif]-->
<!--[if gt IE 8]><!-->
<html lang="en" class="no-js">
<!--<![endif]-->

<cfset PageFileName = listlast(cgi.CF_TEMPLATE_PATH,slash)>
<cfset PageDir = listDeleteAt(cgi.CF_TEMPLATE_PATH, listLen(cgi.CF_TEMPLATE_PATH,slash), slash)>
<cfdirectory action="LIST" directory="#PageDir#" name="GetFile" filter="#PageFileName#">
<cfset PageFileName = listlast(cgi.CF_TEMPLATE_PATH,slash)>
<head>
<!-- Web Experience Toolkit (WET) / Boîte à outils de l'expérience Web (BOEW)
wet-boew.github.com/wet-boew/License-eng.txt / wet-boew.github.com/wet-boew/Licence-fra.txt -->
<!-- WET 3.0, PWGSC 1.0 file: 2col-nav-eng.html -->
<!-- MetadataStart -->
<!-- <meta http-equiv="X-UA-Compatible" content="IE=9" /> -->
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta charset="utf-8" />
<meta name="dcterms.creator" content="Government of Canada, Public Works and Government Services Canada" />
<meta name="dcterms.modified" title="W3CDTF" content="#DateFormat(GetFile.DateLastModified, "yyyy-mm-dd")#" />
<meta name="dcterms.language" title="ISO639-2" content="eng" />
<meta name="dcterms.issued" title="W3CDTF" content="2007-09-20" />
<!-- MetadataEnd -->

<!--[if gte IE 9 | !IE ]><!-->
<link href="#RootDir#GCWeb/assets/favicon.ico" rel="icon" type="image/x-icon" />
<link rel="stylesheet" href="#RootDir#GCWeb/css/theme.min.css" />
<!--<![endif]-->
<!--[if lt IE 9]>
<link href="#RootDir#GCWeb/assets/favicon.ico" rel="shortcut icon" />
<link rel="stylesheet" href="#RootDir#GCWeb/css/ie8-theme.min.css" />
<![endif]-->
<noscript><link rel="stylesheet" href="#RootDir#wet-boew/css/noscript.min.css" /></noscript>

<!-- CustomScriptsCSSStart -->
<link href="#RootDir#css/custom.css" rel="stylesheet" type="text/css" />
<link href="#RootDir#css/jquery-ui.css" media="screen" rel="stylesheet" type="text/css" />
<cfif structKeyExists(Session, 'AdminLoggedIn') AND Session.AdminLoggedIn>
  <script src="#RootDir#scripts/prototype.js" type="text/javascript"></script>
  <script src="#RootDir#scripts/calendar.js" type="text/javascript"></script>
  <script src="#RootDir#scripts/common.js" type="text/javascript"></script>
</cfif>
<script type="text/javascript" src="#RootDir#scripts/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="#RootDir#scripts/jquery-ui-1.8.17.custom.min.js"></script>
<script type="text/javascript" src="#RootDir#scripts/jquery.ui.datepicker-en.js"></script>
<script type="text/javascript" src="#RootDir#scripts/application.js"></script>
<!-- CustomScriptsCSSEnd -->

<!-- Google Tag Manager DO NOT REMOVE OR MODIFY - NE PAS SUPPRIMER OU MODIFIER -->
<script>dataLayer1 = [];</script>
<!-- End Google Tag Manager -->
</head>

<body class="home" vocab="http://schema.org/" typeof="WebPage">
<!-- Google Tag Manager DO NOT REMOVE OR MODIFY - NE PAS SUPPRIMER OU MODIFIER -->
<noscript><iframe title="Google Tag Manager" src="//www.googletagmanager.com/ns.html?id=GTM-TLGQ9K" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start': new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0], j=d.createElement(s),dl=l!='dataLayer1'?'&l='+l:'';j.async=true;j.src='//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer1','GTM-TLGQ9K');</script>
<!-- End Google Tag Manager -->
<ul id="wb-tphp">
<li class="wb-slc">
<a class="wb-sl" href="##wb-cont">Skip to main content</a>
</li>
<li class="wb-slc visible-sm visible-md visible-lg">
<a class="wb-sl" href="##wb-info">Skip to "About this site"</a>
</li>
</ul>

<header role="banner">
<div id="wb-bnr" class="container no-print">
<section id="wb-lng" class="visible-md visible-lg text-right">
<h2 class="wb-inv">Language selection</h2>
<div class="row">
<div class="col-md-12">
<ul class="list-inline margin-bottom-none">
<li><a href="#RootDir#language.cfm" lang="fr">Fran&ccedil;ais</a></li>
</ul>
</div>
</div>
</section>
<div class="row">
<div class="brand col-xs-8 col-sm-9 col-md-6">
<a href="http://www.canada.ca/en/index.html"><object type="image/svg+xml" tabindex="-1" data="#RootDir#GCWeb/assets/sig-blk-en.svg">Government of Canada</object><span class="wb-inv"> Government of Canada</span></a>
</div>
<section class="wb-mb-links col-xs-4 col-sm-3 visible-sm visible-xs" id="wb-glb-mn">
<h2>Search and menus</h2>
<ul class="list-inline text-right chvrn">
<li><a href="##mb-pnl" title="Search and menus" aria-controls="mb-pnl" class="overlay-lnk" role="button"><span class="glyphicon glyphicon-search"><span class="glyphicon glyphicon-th-list"><span class="wb-inv">Search and menus</span></span></span></a></li>
</ul>
<div id="mb-pnl"></div>
</section>
<section id="wb-srch" class="col-xs-6 text-right visible-md visible-lg">
<h2>Search</h2>
<form action="https://www.canada.ca/en/sr.html" method="get" name="cse-search-box" role="search" class="form-inline">
<input name="st" value="s" type="hidden">
<input name="s5bm3ts21rch" value="x" type="hidden">
<input name="num" value="10" type="hidden">
<input name="st1rt" value="1" type="hidden">
<input name="langs" value="en" type="hidden">
<input name="cdn" value="canada" type="hidden">
<input name="hq" type="hidden">
<div class="form-group">
<label for="wb-srch-q" class="wb-inv">Search website</label>
<input id="wb-srch-q" list="wb-srch-q-ac" class="wb-srch-q form-control" name="q" type="search" value="" size="27" maxlength="150" placeholder="Search Canada.ca">
<datalist id="wb-srch-q-ac">
<!--[if lte IE 9]><select><![endif]-->
<!--[if lte IE 9]></select><![endif]-->
</datalist>
</div>
<div class="form-group submit">
<button type="submit" id="wb-srch-sub" class="btn btn-primary btn-small" name="wb-srch-sub"><span class="glyphicon-search glyphicon"></span><span class="wb-inv">Search</span></button>
</div>
</form>
</section>
</div>
</div>
<nav role="navigation" id="wb-sm" data-ajax-replace="https://cdn.canada.ca/gcweb-cdn-live/sitemenu/sitemenu-en.html" data-trgt="mb-pnl" class="wb-menu visible-md visible-lg" typeof="SiteNavigationElement">
<div class="container nvbar">
<h2>Topics menu</h2>
<div class="row">
<ul class="list-inline menu">
<li><a href="http://www.esdc.gc.ca/en/jobs/index.page">Jobs</a></li>
<li><a href="http://www.cic.gc.ca/english/index.asp">Immigration</a></li>
<li><a href="http://travel.gc.ca">Travel</a></li>
<li><a href="http://www.canada.ca/en/services/business/index.html">Business</a></li>
<li><a href="http://www.canada.ca/en/services/benefits/index.html">Benefits</a></li>
<li><a href="http://healthycanadians.gc.ca/index-eng.php">Health</a></li>
<li><a href="http://www.canada.ca/en/services/taxes/index.html">Taxes</a></li>
<li><a href="http://www.canada.ca/en/services/index.html">More services</a></li>
</ul>
</div>
</div>
</nav>

<nav role="navigation" id="wb-bc" property="breadcrumb" class="no-print">
<h2>You are here:</h2>
<div class="container">
<div class="row">
<ol class="breadcrumb">
<cfinclude template="#RootDir#includes/bread-pain-eng.cfm" />
</ol>
</div>
</div>
</nav>

<!-- HeaderEnd -->
</header>

<main role="main" property="mainContentOfPage" class="container" id="wb-main"><div id="wb-main-in">
<!-- MainContentStart -->
<!--[if gte IE 9 | !IE ]><!-->
<script src="#RootDir#wet-boew/js/wet-boew.min.js"></script><!-- <span class="wb-init" id="wb-rsz">&nbsp;</span> -->
<!--<![endif]-->
<!--[if lt IE 9]>
<script src="#RootDir#wet-boew/js/ie8-wet-boew2.min.js"></script>
<![endif]-->
</cfoutput>
