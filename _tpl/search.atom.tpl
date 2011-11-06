<?php
$sql = '
SELECT x.id AS pID, x.slug AS url, x.revision, x.title, x.info, x.published, x.updated, y.revisionCount, COALESCE(z.testCount, 0) AS testCount FROM pages x JOIN (SELECT p.slug, MAX(p.updated) AS max_updated, COUNT(*) AS revisionCount FROM pages p WHERE p.visible = "y" GROUP BY p.slug) y ON y.slug = x.slug AND y.max_updated = x.updated LEFT JOIN (SELECT t.pageid, COUNT(*) AS testCount FROM tests t GROUP BY t.pageid) z ON z.pageid = x.id
WHERE        x.title LIKE "%' . $db->real_escape_string($search) . '%"
													OR x.title LIKE "' . $db->real_escape_string($search) . '"
													OR x.info LIKE "%' . $db->real_escape_string($search) . '%"
													OR x.info LIKE "' . $db->real_escape_string($search) . '"
ORDER BY updated DESC LIMIT 20';
$result = $db->query($sql);
$item = $result->fetch_object();
header('Content-Type: application/atom+xml;charset=UTF-8');
header('Last-Modified: ' . date('r', strtotime($item->updated)));
?>
<feed xmlns="http://www.w3.org/2005/Atom" xml:lang="en">
	<title>jsPerf tests about <?php echo he($search); ?></title>
	<subtitle>The latest twenty new or updated jsPerf test cases about <?php echo he($search); ?></subtitle>
	<link rel="self" type="application/atom+xml" href="http://<?php echo DOMAIN; ?>/search.atom?q=<?php echo urlencode($search); ?>" />
	<link rel="alternate" type="text/html" href="http://<?php echo DOMAIN; ?>/search?q=<?php echo urlencode($search); ?>" />
	<updated><?php echo date('c', strtotime($item->updated)); ?></updated>
	<id>tag:<?php echo DOMAIN; ?>,2010:/search/<?php echo $search; ?></id>
<?php
if ($result && $result->num_rows > 0) {
	while ($item) {
?>
	<entry>
		<title><?php echo he($item->title); ?></title>
		<author>
			<name><?php echo he($author); ?></name>
		</author>
		<link rel="alternate" type="text/html" href="http://<?php echo DOMAIN; ?>/<?php echo $item->url . ($item->revision > 1 ? '/' . $item->revision : ''); ?>" />
		<summary><?php echo ('' == $item->info ? 'No description entered' : he($item->info)); ?></summary>
		<id>tag:<?php echo DOMAIN; ?>,2010:/<?php echo $item->url . ($item->revision > 1 ? '/' . $item->revision : ''); ?></id>
		<published><?php echo date('c', strtotime($item->published)); ?></published>
		<updated><?php echo date('c', strtotime($item->updated)); ?></updated>
	</entry>
<?php
		$item = $result->fetch_object();
	}
}
?>
</feed>