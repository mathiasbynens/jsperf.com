<?php
$result = $db->query('SELECT p1.id AS pID, p1.slug AS url, p1.revision, p1.title, p1.info, p1.published, p1.updated, (SELECT COUNT(*) FROM pages WHERE slug = url AND visible = "y") AS revisionCount, (SELECT COUNT(*) FROM tests WHERE pageID = pID) AS testCount FROM pages p1 LEFT JOIN pages p2 ON p1.slug = p2.slug AND p1.updated < p2.updated WHERE p2.updated IS NULL AND p1.visible = "y" ORDER BY p1.updated DESC LIMIT 20');
//$result = $db->query('SELECT x.id AS pID, x.slug AS url, x.revision, x.title, x.published, x.updated, y.revisionCount, x.info, COALESCE(z.testCount, 0) AS testCount FROM pages x JOIN (SELECT p.slug, MAX(p.updated) AS max_updated, COUNT(*) AS revisionCount FROM pages p WHERE p.visible = "y" GROUP BY p.slug) y ON y.slug = x.slug AND y.max_updated = x.updated LEFT JOIN (SELECT t.pageid, COUNT(*) AS testCount FROM tests t GROUP BY t.pageid) z ON z.pageid = x.id ORDER BY updated DESC LIMIT 20');

$item = $result->fetch_object();
header('Content-Type: application/atom+xml;charset=UTF-8');
header('Last-Modified: ' . date('r', strtotime($item->updated)));
?>
<feed xmlns="http://www.w3.org/2005/Atom" xml:lang="en">
 <title>jsPerf</title>
 <subtitle>The latest twenty new or updated jsPerf test cases</subtitle>
 <link rel="self" type="application/atom+xml" href="http://<?php echo DOMAIN; ?>/browse.atom" />
 <link rel="alternate" type="text/html" href="http://<?php echo DOMAIN; ?>/browse" />
 <updated><?php echo date('c', strtotime($item->updated)); ?></updated>
 <id>tag:<?php echo DOMAIN; ?>,2010:/browse</id>
<?php
if ($result && $result->num_rows > 0) {
 while ($item) {
?>
 <entry>
  <title><?php echo he($item->title); ?></title>
  <author>
   <name>jsPerf</name>
  </author>
  <link rel="alternate" type="text/html" href="http://<?php echo DOMAIN; ?>/<?php echo $item->url . ($item->revision > 1 ? '/' . $item->revision : ''); ?>" />
  <summary><?php echo ($item->info ? he($item->info) : 'No description entered'); ?></summary>
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