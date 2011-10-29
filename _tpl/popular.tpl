<?php $title = 'Popular test cases'; require('head.tpl'); ?>
<h1>Popular test cases</h1>
<?php
$output = '<h2 id=recent>Recent</h2><ul>';
$result = $db->query('SELECT id AS pID, slug AS url, author, revision, title, published, updated, hits FROM pages WHERE updated BETWEEN DATE_SUB(NOW(), INTERVAL 30 DAY) AND NOW() ORDER BY hits DESC LIMIT 0, 30');
if ($result && $result->num_rows > 0) {
 while ($item = $result->fetch_object()) {
  $output .= '<li><a href="/' . $item->url . ($item->revision > 1 ? '/' . $item->revision : '') . '">' . addCode(he($item->title)) . '</a>' . ($item->author !== '' ? ' by ' . he($item->author) : '') . ' ('. (isset($_SESSION['admin']) ? $item->hits . ' unique visitors — ' : '') . 'last updated <time datetime="' . date('c', strtotime($item->updated)) . '">' . relativeDate($item->updated) . '</time>)';
 }
 $output .= '</ul>';
}

$output .= '<h2 id=all-time>All time</h2><ul>';
$result = $db->query('SELECT id AS pID, slug AS url, author, revision, title, published, updated, hits FROM pages ORDER BY hits DESC LIMIT 0, 30');
if ($result && $result->num_rows > 0) {
 while ($item = $result->fetch_object()) {
  $output .= '<li><a href="/' . $item->url . ($item->revision > 1 ? '/' . $item->revision : '') . '">' . addCode(he($item->title)) . '</a>' . ($item->author !== '' ? ' by ' . he($item->author) : '') . ' ('. (isset($_SESSION['admin']) ? $item->hits . ' unique visitors — ' : '') . 'last updated <time datetime="' . date('c', strtotime($item->updated)) . '">' . relativeDate($item->updated) . '</time>)';
 }
 $output .= '</ul>';
}

echo $output;
?>
<?php $ga = true; require('foot.tpl'); ?>