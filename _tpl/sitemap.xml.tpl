<?php
header('Content-Type: application/xml;charset=UTF-8');
$result = $db->query('SELECT id AS pID, revision, slug, title, updated, (SELECT COUNT(*) FROM tests WHERE pageID = pID) AS testCount FROM pages WHERE visible = "y" ORDER BY updated DESC');
$output = '';
if ($result && $result->num_rows > 0) {
	while ($item = $result->fetch_object()) {
		$output .= ' <url>' . "\n" . '  <loc>http://' . DOMAIN . '/' . $item->slug . ($item->revision > 1 ? '/' . $item->revision : '') . '</loc>' . "\n" . ' </url>' . "\n";
	}
}
?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
	<url>
		<loc>http://<?php echo DOMAIN; ?>/</loc>
		<changefreq>daily</changefreq>
	</url>
	<url>
		<loc>http://<?php echo DOMAIN; ?>/browse</loc>
		<changefreq>daily</changefreq>
	</url>
	<url>
		<loc>http://<?php echo DOMAIN; ?>/faq</loc>
	</url>
<?php echo $output; ?>
</urlset>