<?php

if (in_array($item->browserscopeID, array(NULL, ''))) {
	$sql = 'UPDATE pages SET browserscopeID = "' . $db->real_escape_string(addBrowserscopeTest($item->title, $item->info, 'http://' . DOMAIN . '/' . $item->slug . ($item->revision > 1 ? '/' . $item->revision : ''))) . '" WHERE id = ' . $item->id . "\n";
	$db->query($sql);
}

// Don’t let robots index non-published test cases
if ($item->visible === 'n' && (isset($_SESSION['own'][$item->id]) || isset($_SESSION['admin']))) {
	$noIndex = true;
}

$benchmark = $jsClass = $embed = true; require('tpl-inc/head.tpl'); ?>
<hgroup>
	<h1><a href="/<?php echo $slug . ($item->revision > 1 ? '/' . $item->revision : ''); ?>"><?php echo addCode(he($item->title)); ?></a> — compare results</h1>
	<h2>JavaScript performance comparison</h2>
</hgroup>
<?php if ($item->browserscopeID) { ?>
<section>
<h2 id="results"></h2>
<div id="bs-results"></div>
</section>
<?php } ?>
<?php require('tpl-inc/foot.tpl'); ?>