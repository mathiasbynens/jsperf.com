<?php $title = 'Browse test cases'; $showAtom = true; require('head.tpl'); ?>
<h1>Browse latest 250 test cases</h1>
<form action="/search" method="get">
	<p>Looking for a specific test case? Search!</p>
	<input type="search" name="q" placeholder="e.g. canvas">
	<input type="submit" value="Search">
</form>
<?php
$result = $db->query('SELECT p1.id AS pID, p1.slug AS url, p1.revision, p1.title, p1.published, p1.updated, (SELECT COUNT(*) FROM pages WHERE slug = url AND visible = "y") AS revisionCount, (SELECT COUNT(*) FROM tests WHERE pageID = pID) AS testCount FROM pages p1 LEFT JOIN pages p2 ON p1.slug = p2.slug AND p1.updated < p2.updated WHERE p2.updated IS NULL AND p1.visible = "y" ORDER BY p1.updated DESC LIMIT 0, 250');
//$result = $db->query('SELECT x.id AS pID, x.slug AS url, x.revision, x.title, x.published, x.updated, y.revisionCount, COALESCE(z.testCount, 0) AS testCount FROM pages x JOIN (SELECT p.slug, MAX(p.updated) AS max_updated, COUNT(*) AS revisionCount FROM pages p WHERE p.visible = "y" GROUP BY p.slug) y ON y.slug = x.slug AND y.max_updated = x.updated LEFT JOIN (SELECT t.pageid, COUNT(*) AS testCount FROM tests t GROUP BY t.pageid) z ON z.pageid = x.id ORDER BY updated DESC LIMIT 0, 300');
if ($result && $result->num_rows > 0) {
$output = '<ul>';
	while ($item = $result->fetch_object()) {
		$output .= '<li><a href="/' . $item->url . ($item->revision > 1 ? '/' . $item->revision : '') . '">' . addCode(he($item->title)) . '</a>: ' . ($item->testCount > 1 ? $item->testCount . ' tests' : '1 test') . ($item->revisionCount > 1 ? ', ' . $item->revisionCount . ' revisions' : '') . ' (last updated <time datetime="' . date('c', strtotime($item->updated)) . '">' . relativeDate($item->updated) . '</data>)';
	}
	$output .= '</ul>';
	echo $output;
}
?>
<?php $ga = true; require('foot.tpl'); ?>