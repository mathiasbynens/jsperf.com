<?php

if (!empty($_POST)) {
	include('_act/postComment.tpl');
}

if (in_array($item->browserscopeID, array(NULL, ''))) {
	$item->browserscopeID = addBrowserscopeTest($item->title, $item->info, 'http://' . DOMAIN . '/' . $item->slug . ($item->revision > 1 ? '/' . $item->revision : ''));
	$sql = 'UPDATE pages SET browserscopeID = "' . $db->real_escape_string($item->browserscopeID) . '" WHERE id = ' . $item->id . "\n";
	$db->query($sql);
}

$benchmark = $showAtom = $jsClass = true; require('tpl-inc/head.tpl'); ?>
<hgroup>
	<h1><?php echo addCode(he($item->title)); ?></h1>
	<h2>JavaScript performance comparison</h2>
</hgroup>
<p class="meta"><?php if ($item->revision > 1) { ?>Revision <?php echo $item->revision; ?> of this test case<?php } else { ?>Test case<?php } ?> created <?php echo author($item->author, $item->authorURL); ?><time datetime="<?php echo date('c', strtotime($item->published)); ?>" pubdate><?php echo relativeDate($item->published); ?></time><?php if (relativeDate($item->published) !== relativeDate($item->updated)) { ?> and last updated <time datetime="<?php echo date('c', strtotime($item->updated)); ?>"><?php echo relativeDate($item->updated); ?></time><?php } if ($item->visible === 'n' && (isset($_SESSION['own'][$item->id]) || isset($_SESSION['admin']))) { ?> <strong><a href="/<?php echo $slug . ($item->revision > 1 ? '/' . $item->revision : '') . '/publish'; ?>">Not published yet!</a></strong> · <a href="/<?php echo $slug . ($item->revision > 1 ? '/' . $item->revision : '') . '/edit'; ?>">Edit</a><?php } ?></p>
<?php if ($item->info) { ?>
<section>
<h2>Info</h2>
<?php
	echo md($item->info);
?>
</section>
<?php } ?>
<?php if ($item->initHTML || $item->setup || $item->teardown) { ?>
<section id="prep-code">
<h2>Preparation code</h2>
<pre><code><?php

class Swap {
	public static $items = array();

	public static function tagsToTokens($tag) {
		// add highlighted script bodies
		array_unshift(Swap::$items, preg_replace('/&nbsp;$/', '', highlight($tag[2])));
		return $tag[1] . '@jsPerfTagToken' . $tag[3];
	}

	public static function tokensToTags() {
		return array_pop(Swap::$items);
	}
}

$reScripts = '#(<script[^>]*?>)([\s\S]*?)(</script>)#i';
$reTokens = '/@jsPerfTagToken/';

// initHTML with script tags stripped out
$stripped = preg_replace($reScripts, '', $item->initHTML);
preg_match_all($reScripts, $item->initHTML, $scripts);

// an array of script tags
$item->scripts = array_shift($scripts);
if (!is_array($item->scripts)) {
  $item->scripts = array();
}

// swap script bodies with tokens
$highlighted = preg_replace_callback($reScripts, 'Swap::tagsToTokens', $item->initHTML);
// highlight the html
$highlighted = highlight($highlighted, 'html');
// swap tokens with highlighted script bodies
$highlighted = preg_replace_callback($reTokens, 'Swap::tokensToTags', $highlighted);

echo $highlighted;

if ($item->setup || $item->teardown) {
	echo ($highlighted ? '<br>' : '') . '<span class="sc2">&lt;<span class="kw2">script</span>></span><br>'
	    . ($item->setup ? '  Benchmark.<span class="me1">prototype</span>.<span class="me1">setup</span> <span class="sy0">=</span> <span class="kw2">function</span><span class="br0">(</span><span class="br0">)</span> <span class="br0">{</span><br>' . highlight(indent(indent($item->setup))) . '<br>  <span class="br0">}</span><span class="sy0">;</span>' . ($item->teardown ? '<br><br>' : '') : '')
	    . ($item->teardown ? '  Benchmark.<span class="me1">prototype</span>.<span class="me1">teardown</span> <span class="sy0">=</span> <span class="kw2">function</span><span class="br0">(</span><span class="br0">)</span> <span class="br0">{</span><br>' . highlight(indent(indent($item->teardown))) . '<br>  <span class="br0">}</span><span class="sy0">;</span>': '')
	    . '<br><span class="sc2">&lt;<span class="sy0">/</span><span class="kw2">script</span>></span>';
} ?></code></pre>
</section>
<?php if ($stripped) { ?>
<section>
<h2>Preparation code output</h2>
<div class="user-output">
<?php echo $stripped; ?>
</div>
</section>
<?php
	}
} ?>
<section id="runner">
<h2>Test runner</h2>
<p id="firebug"><strong>Warning! For accurate results, please disable Firebug before running the tests. <a href="/faq#firebug-warning">(Why?)</a></strong></p>
<p id="java"><strong>Java applet disabled.</strong></p>
<p id="status"><noscript><strong>To run the tests, please <a href="//enable-javascript.com/">enable JavaScript</a> and reload the page.</strong></noscript></p>
<div id="controls"><button id="run" type="button"></button></div>
<table id="test-table">
	<caption>Testing in <span id="user-agent"><?php echo userAgent(); ?></span></caption>
	<thead>
		<tr>
			<th colspan="2">Test</th>
			<th title="Operations per second (higher is better)">Ops/sec</th>
		</tr>
	</thead>
	<tbody>
<?php $i = 0; foreach ($tests as $test) { ?>
		<tr>
			<th scope="row" id="title-<?php echo ++$i; ?>"><div><?php echo addCode(he($test->title)); if (strstr($item->initHTML, 'function init()')) { ?> <span id="extra-<?php echo $i; ?>"></span><?php } ?></div></th>
			<td class="code"><pre><code><?php if ('y' == $test->defer) { ?><strong class="co1">// async test</strong><br><?php } echo highlight($test->code); ?></code></pre></td>
			<td id="results-<?php echo $i; ?>" class="results">pending…</td>
		</tr>
<?php } ?>
	</tbody>
</table>
<?php if ($item->maxRev <= 1) { ?>
<p>You can <a href="/<?php echo $slug . ($rev > 1 ? '/' . $rev : '') . '/edit'; ?>" rel="nofollow">edit these tests or add even more tests to this page</a> by appending <code>/edit</code> to the URL.</p>
<?php } ?>
</section>
<?php if ($item->browserscopeID) { ?>
<section>
<h2 id="results">Compare results of other browsers</h2>
<div id="bs-results"></div>
</section>
<?php } ?>
<?php if ($item->maxRev > 1) { ?>
<section>
<h2>Revisions</h2>
<p>You can <a href="/<?php echo $slug . ($rev > 1 ? '/' . $rev : '') . '/edit'; ?>" rel="nofollow">edit these tests or add even more tests to this page</a> by appending <code>/edit</code> to the URL. Here’s a list of current revisions for this page:</p>
<ul>
<?php foreach ($revisions as $r) { if ($r->visible === 'y' || isset($_SESSION['admin'])) { ?>
	<li<?php if ($item->revision === $r->revision) { ?> class="current"<?php } ?>><a href="/<?php echo $slug; if ($r->revision > 1) { ?>/<?php echo $r->revision; } ?>">Revision <?php echo $r->revision; ?></a>: published <?php if ($r->author) { echo 'by ' . he($r->author) . ' '; } ?><time datetime="<?php echo date('c', strtotime($r->published)); ?>" pubdate><?php echo relativeDate($r->published); ?></time><?php if (relativeDate($r->published) !== relativeDate($r->updated)) { ?> and last updated <time datetime="<?php echo date('c', strtotime($r->updated)); ?>"><?php echo relativeDate($r->updated); ?></time><?php } ?></li>
<?php } } ?>
</ul>
</section>
<?php } ?>
<?php include('comments.tpl'); ?>
<?php require('tpl-inc/foot.tpl'); ?>