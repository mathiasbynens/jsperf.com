<?php

/*
$result = $db->query('   SELECT x.id AS pID,
										x.slug AS url,
										x.revision,
										x.title,
										x.published,
										x.updated,
										x.author,
										y.revisionCount,
										COALESCE(z.testCount, 0) AS testCount
					FROM pages x
					JOIN (SELECT p.slug,
																		MAX(p.updated) AS max_updated,
																		COUNT(*) AS revisionCount
													FROM pages p
												WHERE p.visible = "y"
									GROUP BY p.slug) y ON y.slug = x.slug
																											AND y.max_updated = x.updated
AND author LIKE "%' . str_replace('-', '%', $author) . '%" OR author LIKE "' . str_replace('-', '%', $author) . '"
LEFT JOIN (SELECT t.pageid,
																		COUNT(*) AS testCount
													FROM tests t
									GROUP BY t.pageid) z ON z.pageid = x.id
	ORDER BY updated DESC');
*/

$result = $db->query('SELECT id AS pID, slug AS url, revision, title, published, updated, author, (SELECT COUNT(*) FROM pages WHERE slug = url AND visible = "y") AS revisionCount, (SELECT COUNT(*) FROM tests WHERE pageID = pID) AS testCount FROM pages WHERE author LIKE "%' . str_replace('-', '%', $db->real_escape_string($author)) . '%" OR author LIKE "' . str_replace('-', '%', $db->real_escape_string($author)) . '" AND updated IN (SELECT MAX(updated) FROM pages WHERE visible = "y" GROUP BY slug) AND visible = "y" ORDER BY updated DESC');

if ($result && $result->num_rows > 0) {
$output = '<ul>';
	while ($item = $result->fetch_object()) {
		$authorName = $item->author;
		$output .= '<li><a href="/' . $item->url . ($item->revision > 1 ? '/' . $item->revision : '') . '">' . addCode(he($item->title)) . '</a>: ' . ($item->testCount > 1 ? $item->testCount . ' tests' : '1 test') . ($item->revisionCount > 1 ? ', ' . $item->revisionCount . ' revisions' : '') . ' (last updated <time datetime="' . date('c', strtotime($item->updated)) . '">' . relativeDate($item->updated) . '</time>)';
	}
	$output .= '</ul>';
} else {
	require('404.tpl');
	die();
}

$title = 'Test cases by ' . he($authorName);
require('head.tpl');

?>
<h1>Test cases by <?php echo he($authorName); ?></h1>
<?php echo $output; ?>
<?php $ga = true; require('foot.tpl'); ?>