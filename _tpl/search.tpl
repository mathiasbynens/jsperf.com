<?php
$title = $search ? he($search) . ' · search results' : 'Search test cases'; $showAtom = true; require('head.tpl');
if ($search) {
?>
<h1>Search results for “<?php echo he($search); ?>”</h1>
<?php
 $sql = '
 SELECT x.id AS pID, x.slug AS url, x.revision, x.title, x.published, x.updated, y.revisionCount, COALESCE(z.testCount, 0) AS testCount FROM pages x JOIN (SELECT p.slug, MAX(p.updated) AS max_updated, COUNT(*) AS revisionCount FROM pages p WHERE p.visible = "y" GROUP BY p.slug) y ON y.slug = x.slug AND y.max_updated = x.updated LEFT JOIN (SELECT t.pageid, COUNT(*) AS testCount FROM tests t GROUP BY t.pageid) z ON z.pageid = x.id
 WHERE        x.title LIKE "%' . $db->real_escape_string($search) . '%"
              OR x.title LIKE "' . $db->real_escape_string($search) . '"
              OR x.info LIKE "%' . $db->real_escape_string($search) . '%"
              OR x.info LIKE "' . $db->real_escape_string($search) . '"
 ORDER BY updated DESC';
 $result = $db->query($sql);

 if ($result && $result->num_rows > 0) {
 $output = '<ul>';
  while ($item = $result->fetch_object()) {
   $output .= '<li><a href="/' . $item->url . ($item->revision > 1 ? '/' . $item->revision : '') . '">' . addCode(he($item->title)) . '</a>: ' . ($item->testCount > 1 ? $item->testCount . ' tests' : '1 test') . ($item->revisionCount > 1 ? ', ' . $item->revisionCount . ' revisions' : '') . ' (last updated <time datetime="' . date('c', strtotime($item->updated)) . '">' . relativeDate($item->updated) . '</time>)';
  }
  $output .= '</ul>';
  echo $output;
 }
} else {
?>
<h1>Search jsPerf</h1>
<form action="/search" method="get">
 <p>Looking for a specific test case? Search!</p>
 <input name="q" placeholder="e.g. canvas">
 <input type="submit" value="Search">
</form>
<?php
}
$ga = true; require('foot.tpl');
?>