<?php

/*
$result = $db->query('   SELECT x.id AS pID,
          x.slug AS url,
          x.revision,
          x.title,
          x.published,
          x.updated,
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
 ORDER BY updated DESC LIMIT 20');
*/

$result = $db->query('SELECT id AS pID, slug AS url, revision, title, published, updated, author, (SELECT COUNT(*) FROM pages WHERE slug = url AND visible = "y") AS revisionCount, (SELECT COUNT(*) FROM tests WHERE pageID = pID) AS testCount FROM pages WHERE author LIKE "%' . str_replace('-', '%', $db->real_escape_string($author)) . '%" OR author LIKE "' . str_replace('-', '%', $db->real_escape_string($author)) . '" AND updated IN (SELECT MAX(updated) FROM pages WHERE visible = "y" GROUP BY slug) AND visible = "y" ORDER BY updated DESC LIMIT 20');

$item = $result->fetch_object();
header('Content-Type: application/atom+xml;charset=UTF-8');
header('Last-Modified: ' . date('r', strtotime($item->updated)));
?>
<feed xmlns="http://www.w3.org/2005/Atom" xml:lang="en">
 <title>jsPerf tests by <?php echo he($item->author); ?></title>
 <subtitle>The latest twenty new or updated jsPerf test cases by <?php echo he($item->author); ?></subtitle>
 <link rel="self" type="application/atom+xml" href="http://<?php echo DOMAIN; ?>/browse/<?php echo $author; ?>.atom" />
 <link rel="alternate" type="text/html" href="http://<?php echo DOMAIN; ?>/browse/<?php echo $author; ?>" />
 <updated><?php echo date('c', strtotime($item->updated)); ?></updated>
 <id>tag:<?php echo DOMAIN; ?>,2010:/browse/<?php echo $author; ?></id>
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