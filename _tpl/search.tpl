<?php
$title = $search ? he($search) . ' · search results' : 'Search test cases'; $showAtom = true; require('head.tpl');
if ($search) {
?>
<h1>Search results for “<?php echo he($search); ?>”</h1>
<?php
	$sql = '
	SELECT * FROM (
		SELECT x.id AS pID, x.slug AS url, x.revision, x.title, x.updated, COUNT(x.slug) AS revisionCount
		FROM pages x
		WHERE x.title LIKE "%' . $db->real_escape_string($search) . '%" OR x.info LIKE "%' . $db->real_escape_string($search) . '%"
		GROUP BY x.slug
		ORDER BY updated DESC
		LIMIT 0, 50
	) y LEFT JOIN (
		SELECT t.pageid, COUNT(t.pageid) AS testCount
		FROM tests t
		GROUP BY t.pageid
	) z ON z.pageid = y.pID';
	$result = $db->query($sql);

	if ($result && $result->num_rows > 0) {
	$output = '<ul>';
		while ($item = $result->fetch_object()) {
			$output .= '<li><a href="/' . $item->url . ($item->revision > 1 ? '/' . $item->revision : '') . '">' . addCode(he($item->title)) . '</a>: ' . ($item->testCount > 1 ? $item->testCount . ' tests' : '1 test') . ($item->revisionCount > 1 ? ', ' . $item->revisionCount . ' revisions' : '') . ' (last updated <time datetime="' . date('c', strtotime($item->updated)) . '">' . relativeDate($item->updated) . '</time>)';
		}
		$output .= '</ul>';
		echo $output;
?>
<p>Showing only the most recent 50 results. For more, <a href="https://encrypted.google.com/search?q=site%3Ajsperf.com+<?php echo rawurlencode($search); ?>">try Google</a>.</p>
<?php
	}
} else {
?>
<h1>Search jsPerf</h1>
<form action="/search" method="get">
	<p>Looking for a specific test case? Search!</p>
	<input type="search" name="q" placeholder="e.g. canvas">
	<input type="submit" value="Search">
</form>
<?php
}
$ga = true; require('foot.tpl');
?>