<?php
$title = 'Dart Summary';
require('head.tpl');
$points = array(
	'what' => (object) array(
		'title' => 'What’s all this about?',
		'answer' => 'On November 10th and 11th of 2010, a number of Google teams representing a variety of viewpoints on client-side languages <a href="//xkcd.com/927/" rel="nofollow">met to agree on a common vision for the future of JavaScript</a>. The following are a few highlights taken almost word for word from a <a href="//markmail.org/message/uro3jtoitlmq6x7t" rel="nofollow">leaked internal email</a> summarizing the topics discussed at that summit as well as reaction from <a href="//en.wikipedia.org/wiki/Brendan_Eich" rel="nofollow">Brendan Eich</a> and <a href="//infrequently.org/about-me/" rel="nofollow">Alex Russell</a>.'
	),
	'public-facade' => (object) array(
		'title' => 'How will Google act publically?',
		'answer' => '<a href="//wiki.ecmascript.org/doku.php?id=harmony:proposals" rel="nofollow">ES-Harmony</a> will continue to be evangelized by Google externally as the evolution of JavaScript.'
	),
	'private-subversion' => (object) array(
		'title' => 'Ok, but what’s really their plan?',
		'answer' => 'The goal of the Dart (formerly Dash) effort is ultimately to replace JavaScript as the lingua franca of web development on the open web platform. Google will proactively evangelize Dart with web developers and all other browser vendors and actively push for its standardization and adoption across the board.'
	),
	'spin-zone' => (object) array(
		'title' => 'How will Google spin this?',
		'answer' => 'While Dart is catching on with other browsers, Google will promote it as <strong>the language</strong> for <strong>serious</strong> web development on the web platform.'
	),
	'sweet-talk' => (object) array(
		'title' => 'What if other browsers don’t follow Google with Dart?',
		'answer' => 'Google’s own <a href="http://en.wikipedia.org/wiki/Lars_Bak_(computer_programmer)" rel="nofollow">Lars Bak</a> has promised to “sweet talk” the other browser vendors.'
	),
/*
	'brain-trust' => (object) array(
		'title' => 'Who’s named as authors of the summit summary?',
		'answer' => '<a href="//twitter.com/brada" rel="nofollow">Brad&nbsp;Abrams</a>, <a href="//twitter.com/ErikArvidsson" rel="nofollow">Erik&nbsp;Arvidsson</a>, <a href="mailto:bak@google.com">Lars&nbsp;Bak</a>, <a href="mailto:darin@google.com">Darin&nbsp;Fisher</a>, <a href="//twitter.com/dglazkov" rel="nofollow">Dimitri&nbsp;Glazkov</a>, <a href="mailto:dgrove@google.com">Dan&nbsp;Grove</a>, <a href="mailto:peterhal@google.com">Peter&nbsp;Hallam</a>, <a href="//twitter.com/bruce_at_google" rel="nofollow">Bruce&nbsp;Johnson</a>, <a href="//twitter.com/jkomoros" rel="nofollow">Alex&nbsp;Komoroske</a>, <a href="mailto:johnlenz@google.com" rel="nofollow">John&nbsp;Lenz</a>, <a href="mailto:kasperl@google.com" rel="nofollow">Kasper&nbsp;Lund</a>, <a href="mailto:erights@google.com" rel="nofollow">Mark&nbsp;Miller</a>, <a href="mailto:iposva@google.com">Ivan&nbsp;Posva</a>, <a href="//twitter.com/slightlylate" rel="nofollow">Alex&nbsp;Russell</a>, and <a href="//twitter.com/jgw" rel="nofollow">Joel&nbsp;Webber</a>, who collectively represent <a href="//www.ecma-international.org/memento/TC39.htm" rel="nofollow">TC39</a> (the ECMAScript standards body), WebKit, Parkour, Brightly, JSPrime, JS++, Closure, JSCompiler, V8, Dart, Joy, and GWT, among others.'
	),
*/
	'a-minute-with' => (object) array(
		'title' => 'What does Brendan Eich think about all this?',
		'answer' => 'From <a href="//brendaneich.com/2011/08/my-txjs-talk-twitter-remix/" rel="nofollow">Brendan’s blog</a>:<blockquote><p>Here is something that the Google <a href="//markmail.org/message/uro3jtoitlmq6x7t" rel="nofollow">leak about Dart</a> (née Dash) telegraphs: many Googlers, especially V8 principals, do not like JS and don’t believe it can evolve “in time” (whatever that might mean — and Google of course influences JS’s evolution directly, so they can put a finger on the scale here).</p><p>They’re wrong, and I’m glad that at least some of the folks at Google working in TC39 actually believe in JS — specifically its ability to evolve soon enough and well enough to enable both more predictable performance and programming in the large.</p><p>There’s a better-is-better bias among Googlers, but the Web is a brutal, shortest-path, <a href="//dreamsongs.com/WorseIsBetter.html" rel="nofollow">Worse-is-Better</a> evolving system.</p><p>I’ve spent the last 16 years betting on the Web. Evolving systems can face collapses, die-offs, exigent circumstances. I don’t see JS under imminent threat of death due to such factors, though. Ironic that Google would put a death mark on it.</p></blockquote>From <a href="//news.ycombinator.com/item?id=2982949" rel="nofollow">Hacker News</a>:<blockquote><p>“Even Brendan Eich admitted&hellip;”. As if I would not expect, nay demand, that Gilad and Lars would do better -- much better -- than JS!</p><p>For the record, I’m not worried about JS being replaced by a better language. I am working to do that within Ecma TC39, by evolving JS aggressively.</p><p>The leaked Google doc’s assertion that this is impossible and that a “clean break” is required to make significant improvements is nonsense, a thin rationale for going it alone rather than cooperating fully.</p><p>The big issue I have with Dart, which [some] seem to consider inconsequential, is whether Google forks the web developer community, not just its own paid developers, with Dart, and thereby fragments web content.</p><p>A Dart to JS compiler will never be “decent” compared to having the Dart VM in the browser. Yet I guarantee you that Apple and Microsoft (and Opera and Mozilla, but the first two are enough) will never embed the Dart VM.</p><p>So “Works best in Chrome” and even “Works only in Chrome” are new norms promulgated intentionally by Google. We see more of this fragmentation every day. As a user of Chrome and Firefox (and Safari), I find it painful to experience, never mind the political bad taste.</p><p>Ok, counter-arguments. What’s wrong with playing hardball to advance the web, you say? As my blog tries to explain, the standards process requires good social relations and philosophical balance among the participating competitors.</p><p>Google’s approach with Dart is thus pretty much all wrong and doomed to leave Dart in excellent yet non-standardized and non-interoperable implementation status. Dart is GBScript to NaCl/Pepper’s ActiveG.</p><p>Could Google, unlike Microsoft ten or so years ago, prevail? Only by becoming the new monopoly power on the web. We know how that story ends.</p><p>/be</p></blockquote>'
	),
	'slightlylate' => (object) array(
		'title' => 'What’s Alex Russell’s response to the leak?',
		'answer' => 'From <a href="//infrequently.org/2011/09/google-the-future-of-javascript/" rel="nofollow">Alex’s blog</a>:<blockquote><p>Making the rounds is an accidentally leaked early draft of notes from a meeting last year that discusses both Dart and JavaScript. I work on many web platform-related things at Google, including serving as a representative to TC39, the body that standardizes the JavaScript language. I wasn’t at the meetings having previously committed to presenting at <a href="//2010.full-frontal.org/" rel="nofollow">FFJS</a>, but my views were represented by others and my name is on the document. As I said, though, it was a draft and doesn’t reflect either the reality of what has happened in the meantime or even the decisions that were taken as a result. And it certainly doesn’t reflect my personal views.</p></blockquote>He continues:<blockquote><p>So what’s the deal with Google and JavaScript?</p><p>Simply stated, Google is absolutely committed to making JavaScript better, and we’re pushing hard to make it happen.</p><p>Erik Arvidsson, Mark Miller, Waldemar Horwat, Andreas Rossberg, Nebojša Ćirić, Mark Davis, Jungshik Shin and I attend TC39 meetings, work on implementations, and try to push JS forward in good faith. And boy, does it need a push.</p></blockquote>'
	)
);
?>
<h1>Dart Summary</h1>
<ul>
<?php foreach($points as $pointsSlug => $q) { ?>
	<li><a href="#<?php echo $pointsSlug; ?>"><?php echo $q->title; ?></a></li>
<?php } ?>
</ul>
	<aside id="donate">
		<h1>Support JavaScript!</h1>
		<p>Speak out if you dig JavaScript and believe it can succeed.</p>
		<a href="//twitter.com/share" class="twitter-share-button" data-text="A Dart through the heart —" data-url="http://jsperf.com/dart" data-count="none" data-via="jsprf">Tweet</a>
		<script src="//platform.twitter.com/widgets.js"></script>
	</aside>
<dl id="faq">
<?php foreach($points as $pointsSlug => $q) { ?>
	<dt id="<?php echo $pointsSlug; ?>"><?php echo $q->title; ?> <a href="#<?php echo $pointsSlug; ?>">#</a></dt>
		<dd><?php echo $q->answer; ?></dd>
<?php } ?>
</dl>
<?php $ga = true; require('foot.tpl'); ?>