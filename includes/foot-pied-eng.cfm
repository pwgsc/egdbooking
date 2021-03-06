<div class="clear"></div>
<!-- EndEditableContent -->
</div>

<div id="wb-sec" class="no-print"><div id="wb-sec-in">
<cfinclude template="#RootDir#includes/left-menu-gauche-eng.cfm" />
</div>
</div>

<!-- MainContentEnd -->
</main>

<div class="container no-print">
<div class="row pagedetails">
<div class="col-sm-5 col-xs-12 datemod">
<dl id="wb-dtmd">
<dt>Date modified:&#32;</dt>
<dd><time property="dateModified"><cfoutput query="GetFile">#DateFormat(GetFile.DateLastModified, "yyyy-mm-dd")#</cfoutput></time></dd>
</dl>
</div>
<div class="clear visible-xs"></div>
<div class="col-sm-4 col-xs-6">
<a href="http://www.canada.ca/en/contact/feedback.html" class="btn btn-default"><span class="glyphicon glyphicon-comment mrgn-rght-sm"></span>Feedback</a>
</div>
<div class="col-sm-3 col-xs-6 text-right">
<!-- <div class="wb-share" data-wb-share='{"lnkClass": "btn btn-default"}'></div> -->
</div>
<div class="clear visible-xs"></div>
</div>
</div>

<aside class="gc-nttvs container no-print">
<h2>Government of Canada activities and initiatives</h2>
<div class="wb-eqht row mrgn-bttm-md" data-ajax-replace="https://cdn.canada.ca/gcweb-cdn-live/features/features-en.html">
    <p><ul><li><a href="http://www.canada.ca/en/">Visit the Canada.ca home page to see activities and initiatives in the Government of Canada.</a></li></ul></p>
</div>
</aside>

<div id="wb-foot"><div id="wb-foot-in">

<cfoutput>
<footer role="contentinfo" id="wb-info">
<nav role="navigation" class="container visible-sm visible-md visible-lg wb-navcurr">
    <h2 class="wb-inv">About this site</h2>
    <div class="row">
        <div class="col-sm-3 col-lg-3">
            <section>
                <h3>Contacts</h3>
                <ul class="list-unstyled">
                    <li><a class="gl-footer" href="http://www.canada.ca/en/contact.html">Contact information</a></li>
                </ul>
            </section>
            <section>
                <h3>News</h3>
                <ul class="list-unstyled">
                    <li><a class="gl-footer" href="http://news.gc.ca/web/index-en.do">Newsroom</a></li>
                
                    <li><a class="gl-footer" href="http://news.gc.ca/web/nwsprdct-en.do?mthd=tp&amp;crtr.tp1D=1&amp;_ga=1.163843263.1403012476.1399396777">News releases</a></li>
                
                    <li><a class="gl-footer" href="http://news.gc.ca/web/nwsprdct-en.do?mthd=tp&amp;crtr.tp1D=3&amp;_ga=1.202532049.1365865838.1443638203">Media advisories</a></li>
                
                    <li><a class="gl-footer" href="http://news.gc.ca/web/nwsprdct-en.do?mthd=tp&amp;crtr.tp1D=970&amp;_ga=1.201983249.1403012476.1399396777">Speeches</a></li>
                
                    <li><a class="gl-footer" href="http://news.gc.ca/web/nwsprdct-en.do?mthd=tp&amp;crtr.tp1D=980&amp;_ga=1.125501834.1403012476.1399396777">Statements</a></li>
                </ul>
            </section>
        </div>

        <section class="col-sm-3 col-lg-3">
            <h3>Government</h3>
            <ul class="list-unstyled">
                <li><a class="gl-footer" href="http://www.canada.ca/en/government/system.html">How government works</a></li>
            
                <li><a class="gl-footer" href="http://www.canada.ca/en/government/dept.html">Departments and agencies</a></li>
            
                <li><a class="gl-footer" href="http://pm.gc.ca/eng">Prime Minister</a></li>
            
                <li><a class="gl-footer" href="http://www.canada.ca/en/government/ministers.html">Ministers</a></li>
            
                <li><a class="gl-footer" href="http://www.canada.ca/en/government/publicservice.html">Public service and military</a></li>
            
                <li><a class="gl-footer" href="http://www.canada.ca/en/government/system/laws.html">Treaties, laws and regulations</a></li>
            
                <li><a class="gl-footer" href="http://www.canada.ca/en/government/libraries.html">Libraries</a></li>
            
                <li><a class="gl-footer" href="http://www.canada.ca/en/government/publications.html">Publications</a></li>
            
                <li><a class="gl-footer" href="http://www.canada.ca/en/government/statistics.html">Statistics and data</a></li>
            
                <li><a class="gl-footer" href="http://www1.canada.ca/en/newsite.html">About Canada.ca</a></li>
            </ul>
        </section>

        <section class="col-sm-3 col-lg-3 brdr-lft">
            <h3>Transparency</h3>
            <ul class="list-unstyled">
                <li><a class="gl-footer" href="http://www.canada.ca/en/transparency/reporting.html">Government-wide reporting</a></li>
            
                <li><a class="gl-footer" href="http://open.canada.ca/en">Open government</a></li>
            
                <li><a class="gl-footer" href="http://www.tbs-sct.gc.ca/pd-dp/gr-rg/index-eng.asp">Proactive disclosure</a></li>
            
                <li><a class="gl-footer" href="http://www.canada.ca/en/transparency/terms.html">Terms and conditions</a></li>
            
                <li><a class="gl-footer" href="http://www.canada.ca/en/transparency/privacy.html">Privacy</a></li>
            </ul>
        </section>

        <div class="col-sm-3 col-lg-3 brdr-lft">
            <section>
    <h3>Feedback</h3>
    <p>
        <a class="gl-footer" href="http://www1.canada.ca/en/contact/feedback.html">
            <img src="#RootDir#GCWeb/assets/feedback.png" alt="Feedback about this Web site">
        </a>
    </p>
</section>
            <section>
    <h3>Social media</h3>
    <p>
        <a class="gl-footer" href="http://www.canada.ca/en/social.html">
            <img src="#RootDir#GCWeb/assets/social.png" alt="Social media">
        </a>
    </p>
</section>
<section>
    <h3>Mobile centre</h3>
    <p>
        <a class="gl-footer" href="http://www.canada.ca/en/mobile.html">
            <img src="#RootDir#GCWeb/assets/mobile.png" alt="Mobile centre">
        </a>
    </p>
</section>
        </div>
    </div>
</nav>

<div class="brand">
    <div class="container">
        <div class="row">
            <div class="col-xs-6 visible-sm visible-xs tofpg">
                <a class="gl-footer" href="##wb-cont">Top of page
                    <span class="glyphicon glyphicon-chevron-up"></span>
                </a>
            </div>
            <div class="col-xs-6 col-md-12 text-right">
                <object type="image/svg+xml" tabindex="-1" role="img" data="#RootDir#GCWeb/assets/wmms-blk.svg" aria-label="Symbol of the Government of Canada">Canada</object>
            </div>
        </div>
    </div>
</div>

</footer>
</cfoutput>
</div></div>

</body>
</html>

