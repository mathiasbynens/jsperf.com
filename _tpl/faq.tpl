<?php
$title = 'Frequently asked questions';
require('head.tpl');
$faq = array(
	'what' => (object) array(
		'title' => 'What is jsPerf?',
		'answer' => 'jsPerf aims to provide an easy way to create and share test cases, comparing the performance of different JavaScript snippets by running benchmarks. But even if you don’t add tests yourself, you can still use it as a JavaScript performance knowledge base.'
	),
	'engine' => (object) array(
		'title' => 'Which benchmarking engine is being used?',
		'answer' => 'jsPerf is proudly powered by <a href="//benchmarkjs.com/">Benchmark.js</a>, a <a href="//calendar.perfplanet.com/2010/bulletproof-javascript-benchmarks/" title="Bulletproof JavaScript benchmarks">robust</a> JavaScript benchmarking library that works on nearly all JavaScript platforms, supports high-resolution timers, and returns statistically significant results. Kudos to <a href="//allyoucanleet.com/">John-David Dalton</a> for his awesome work on this project!'
	),
	'script-warnings' => (object) array(
		'title' => 'I’m getting script warnings when running a test in Internet Explorer. What’s up with that?',
		'answer' => 'Rather than limiting a script by time like all other browsers do, IE (up to version 8) limits a script to 5 million instructions. With modern hardware, a CPU-intensive script can trigger this in less than half a second. If you have a reasonably fast system you may run into these dialogs in IE, in which case the best solution is to <a href="//support.microsoft.com/default.aspx?scid=kb;en-us;175500">modify your Windows Registry to increase the number of operations</a> (I have mine set to 80,000,000).'
	),
	'firebug-warning' => (object) array(
		'title' => 'I’m getting a warning message telling me to disable Firebug. What’s up with that?',
		'answer' => 'Enabling Firebug causes all JITs to be disabled, meaning you’ll be running the tests in the interpreter, so things will be very slow. For a fair comparison between browsers, always close Firebug before running any tests.'
	),
	'calibration' => (object) array(
		'title' => 'What happened to the ‘calibration’ feature?',
		'answer' => 'We decided to remove it since after factoring in the adjusted margin of error, the results are indistinguishable from non-calibrated results.'
	),
	'java-applet' => (object) array(
		'title' => 'Why does jsPerf use a Java applet on test pages? Do I have to enable Java to use jsPerf?',
		'answer' => 'The applet you’re talking about is just a clever trick we’re using to expose Java’s nanosecond timer to JavaScript, so we can use it to get more accurate test results. jsPerf will still work fine if you disable Java; it might just take a little longer to run tests. If you want, you can prevent jsPerf from inserting the Java applet into the document by appending <code>#nojava</code> to any test case URL.'
	),
	'ie9-java' => (object) array(
		'title' => 'I cannot seem to access jsPerf using IE9. What gives?',
		'answer' => 'You may get an error message saying “A problem with this webpage caused Internet Explorer to close and reopen the tab”, but really the problem lies with the combination of <a href="//support.microsoft.com/kb/2506617">IE9 and Java Version 6 Update 22 or 23</a>. Luckily, there’s an easy fix: just <a href="//www.java.com/en/download/manual.jsp">download and install the latest version of Java</a>.'
	),
	'lion-java' => (object) array(
		'title' => 'jsPerf is broken in older Firefox versions on Mac OS X Lion!',
		'answer' => 'That’s actually an issue with an incompatible Java plugin. When testing in Firefox 3.x under Lion, make sure to disable the <a href="//javaplugin.sourceforge.net/">Java Embedding Plugin</a> via Firefox → Preferences → General → Manage Add-ons → Plugins. You’ll still be able to use jsPerf, although it won’t use <a href="#java-applet">the fancy nanotimer</a>.'
	),
	'chrome' => (object) array(
		'title' => 'I heard somewhere that Chrome has built-in benchmarking extensions. Can I use these for jsPerf?',
		'answer' => 'Yes, you can <a href="//www.chromium.org/developers/how-tos/run-chromium-with-flags">run Chrome or Chromium with the <code>--enable-benchmarking</code> flag</a> to improve the accuracy of test results in these browsers.'
	),
	'run-single-test' => (object) array(
		'title' => 'Can I re-run a single test?',
		'answer' => 'You can (re-)run specific tests by clicking on their description in the overview table. Quickly clicking several test descriptions causes the first test to start running, while the others will get the pending status.'
	),
	'browserscope' => (object) array(
		'title' => 'The Browserscope results look different from the ones I’m getting. Why?',
		'answer' => 'Browserscope returns the highest known result for each test. Because each test has a margin of error, we submit the results minus the margin or error (the lower limit of the confidence interval, i.e. the lowest suspected value) to Browserscope.' /* Browserscope has a tendency to notch up (but not down) on values. For this reason, jsPerf sends the reported results <em>minus the margin of error</em> (the lower limit confidence interval, i.e. the lowest suspected value) to Browserscope. This way, we report the low end. our mean value is of the time it takes to execute 1 operation, so the margin or error is applied to that and then computed to hz again */
	),
	'autorun' => (object) array(
		'title' => 'I don’t like clicking buttons. Can I make the tests run automatically after opening a page?',
		'answer' => 'Sure, just append <code>#run</code> to the URL of the test case, e.g. <a href="/document-getelementbyid#run" title="Run document.getElementById() benchmarks"><code>http://jsperf.com/document-getelementbyid#run</code></a>.'
	),
	'chart-types' => (object) array(
		'title' => 'Can I predefine a specific chart type when linking to a test case?',
		'answer' => 'Sure you can. For example, if you want the data table to be shown by default, you could append <code>#chart=table</code> to the test case’s URL. The other chart types are <code>bar</code> (the default), <code>column</code>, <code>line</code>, and <code>pie</code>.'
	),
	'result-filters' => (object) array(
		'title' => 'Can I predefine a specific Browserscope result filter when linking to a test case?',
		'answer' => 'Yes. For example, if you want to only show results for mobile browsers by default, you could append <code>#filterBy=mobile</code> to the test case’s URL. The other result filters are <code>popular</code> (the default), <code>all</code>, <code>desktop</code>, <code>major</code>, <code>minor</code>, and <code>prerelease</code>.'
	),
	'setup-teardown' => (object) array(
		'title' => 'Is it possible to execute code before and after each clocked test loop, outside of the timed code region?',
		'answer' => 'That’s what <a href="http://benchmarkjs.com/docs#prototype_setup" title="Benchmark.prototype.setup"><code>Benchmark#setup</code></a> and <a href="http://benchmarkjs.com/docs#prototype_teardown" title="Benchmark.prototype.teardown"><code>Benchmark#teardown</code></a> are for. You can use the Setup and Teardown fields to use the same function(s) for all tests. To target specific tests, you can use <code>setTimeout(function() { ui.benchmarks[<var>0</var>].setup = function(){ … }; }, 1);</code> (and/or <code>teardown</code>) in the Preparation Code field, where <code><var>0</var></code> is the zero-indexed test ID.'
	),
	'async' => (object) array(
		'title' => 'How can I run asynchronous tests?',
		'answer' => 'Just tick the “async” checkbox for each asynchronous test. You will then have access to a <code>deferred</code> object. In your test code, whenever your test is finished, call <code>deferred.resolve()</code>. Here’s an example: <a href="http://jsperf.com/smallest-timeout">http://jsperf.com/smallest-timeout</a>'
	),
	'add-edit' => (object) array(
		'title' => 'Can I add tests to existing testcases, or edit them?',
		'answer' => 'Sure, just append <code>/edit</code> to the URL of the test case. If you’re the original author of the test case you’re editing and it hasn’t been more than 8 hours since you last visited jsPerf, any changes you make will simply overwrite what you entered before. If those conditions don’t apply, every edit you save will create a new revision, i.e. <code>http://jsperf.com/<var>foo</var>/2</code>, <code>http://jsperf.com/<var>foo</var>/3</code>, and so on.'
	),
	'remove-snippet' => (object) array(
		'title' => 'Can I remove a snippet from my test case?',
		'answer' => 'Absolutely. Just <a href="#add-edit">edit the test case</a>, clear the ‘title’ and ‘code’ fields for the snippet you want to remove and save your changes.'
	),
	'test-case-feed' => (object) array(
		'title' => 'How can I follow up on a specific test case? I’d like to get notified when there’s a new revision.',
		'answer' => 'Every test case has its own Atom feed which you can subscribe to using your favorite feed reader. Just append <code>.atom</code> to the main test case’s URL to get it.'
	),
	'author-feed' => (object) array(
		'title' => 'How can I keep track of new or updated test cases made by a specific user?',
		'answer' => 'Every author has its own Atom feed, located at <code>http://jsperf.com/browse/<var>author-name</var>.atom</code>. Omit the <code>.atom</code> suffix to get a clickable list instead. If you’re identified on jsPerf (i.e. if you’ve commented, or created/edited a test case), a “My tests” link will appear in the navigation.'
	),
	'results-json' => (object) array(
		'title' => 'Can I get the Browserscope results of my testcase in JSON format so I can do something cool with them?',
		'answer' => 'Absolutely. On any jsPerf test case, just click the Browserscope logo to get to the results page. Its URL will look something like this: <code>http://www.browserscope.org/user/tests/table/<var>YOUR-TEST-ID</var></code>. That last part is the corresponding Browserscope test ID. To get its JSON output, just append <code>?o=json&callback=<var>foo</var></code>, e.g. <code>http://www.browserscope.org/user/tests/table/<var>YOUR-TEST-ID</var>?o=json&callback=<var>w00t</var></code>. For more details, see <a href="//www.browserscope.org/user/tests/howto">the Browserscope API documentation</a>.',
	),
	'test-availability' => (object) array(
		'title' => 'How long will my tests be available on jsPerf?',
		'answer' => 'Every test case and/or revision that’s added to jsPerf will remain here forever. You can safely link to any jsPerf document; in general, all URLs are supposed to be permalinks.<br>However, this rule does not apply to invalid/spammy tests, because those will likely get removed.'
	),
	'additional-features' => (object) array(
		'title' => 'Will you implement <var>[feature XYZ]</var>?',
		'answer' => 'Why not? I’m <a href="https://github.com/mathiasbynens/jsperf.com/issues" rel="nofollow">open to suggestions</a>, so please let me know if you have an idea that could make jsPerf more awesome.'
	)
);
?>
<h1>Frequently asked questions</h1>
<ul>
<?php foreach($faq as $faqSlug => $q) { ?>
	<li><a href="#<?php echo $faqSlug; ?>"><?php echo $q->title; ?></a></li>
<?php } ?>
</ul>
	<aside id="donate">
		<h1>Support jsPerf!</h1>
		<p>Every hour I spend working on jsPerf is an hour that I’m not billing for. If you find jsPerf useful, a small donation is a great way to show your appreciation. It will allow me to continue hosting, improving and updating jsPerf. You can <strong><a href="//pledgie.com/campaigns/14709">donate via Pledgie</a></strong> if you want to appear on the donor’s list. Alternatively, you can go straight to PayPal:</p>
		<form action="https://www.paypal.com/cgi-bin/webscr" method="post" id="paypal">
			<input type="hidden" name="cmd" value="_s-xclick">
			<input type="hidden" name="encrypted" value="-----BEGIN PKCS7-----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-----END PKCS7-----">
			<input type="submit" class="submit" name="submit" value="Donate via PayPal">
		</form>
	</aside>
<dl id="faq">
<?php foreach($faq as $faqSlug => $q) { ?>
	<dt id="<?php echo $faqSlug; ?>"><?php echo $q->title; ?> <a href="#<?php echo $faqSlug; ?>">#</a></dt>
		<dd><?php echo $q->answer; ?></dd>
<?php } ?>
</dl>
<?php $ga = true; require('foot.tpl'); ?>
