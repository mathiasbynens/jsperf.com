<?php
if ($_SERVER['HTTP_HOST'] != DOMAIN) {
 header('Location: http://' . DOMAIN . $_SERVER['REQUEST_URI'], null, 301);
}

$home = $jsClass = $benchmark = $showAtom = $mainJS = $author = $update = $nameError = $mailError = $msgError = $slugError = $spamError = $codeError = $codeTitleError = $titleError = $error = $author = $authorEmail = $authorURL = $ga = $embed = false;

if (isset($_GET['slug'])) {
 $slug = $_GET['slug'];
 $rev = isset($_GET['rev']) ? (int) $_GET['rev'] : 1;
 $action = isset($_GET['action']) ? $_GET['action'] : false;
 $id = isset($_GET['id']) ? (int) $_GET['id'] : false;
 $atom = isset($_GET['atom']);
 $author = isset($_GET['author']) ? $_GET['author'] : false;
 $search = in_array($slug, array('search', 'search.atom')) ? isset($_GET['q']) ? $_GET['q'] : '' : false;

 if (in_array($slug, $reservedSlugs)) {
  if (!$search && !in_array($_SERVER['REQUEST_URI'], array('/' . $slug, '/' . $slug . '.atom', '/browse/' . $author, '/browse/' . $author . '.atom', '/edit-comment/' . $id, '/delete-comment/' . $id))) {
   header('Location: http://' . DOMAIN . '/' . $slug, null, 301);
  }
  include($slug . ($atom ? '.atom' : '') . '.tpl');
  return;
 } else {
  $url = '/' . ($author ? 'browse/' . $author . ($atom ? '.atom' : '') : $slug . ($atom ? '.atom' : ($rev > 1 ? '/' . $rev : '') . ($action ? '/' . $action : '')));
  if ($url != $_SERVER['REQUEST_URI'] && !$id && !$search) {
   header('Location: http://' . DOMAIN . $url, null, 301);
  }
 }

 $result = $db->query('SELECT *, (SELECT MAX(revision) FROM pages WHERE slug = "' . $db->real_escape_string($slug) . '") AS maxRev FROM pages WHERE slug = "' . $db->real_escape_string($slug) . '" AND revision = ' . $rev);
 if ($result && $result->num_rows > 0) {
  $item = $result->fetch_object();
  $title = $item->title;
  $result = $db->query('SELECT * FROM tests WHERE pageID = ' . $item->id . ' ORDER BY testID ASC');
  $tests = array();
  if ($result && $result->num_rows > 0) {
   while ($test = $result->fetch_object()) {
    $tests[] = $test;
   }
   if ($slug && $action && $action != 'dev') {
    include($action . '.tpl');
    return;
   } else {
    $result = $db->query('SELECT published, updated, author, authorEmail, revision, visible, title FROM pages WHERE slug = "' . $db->real_escape_string($slug) . '" ORDER BY published ASC');
    $revisions = array();
    if ($result && $result->num_rows > 0) {
     while ($revision = $result->fetch_object()) {
      $revisions[] = $revision;
     }
    }
    $comments = array();
    $sql = 'SELECT * FROM comments WHERE pageID = ' . $item->id . ' ORDER BY published ASC';
    if ($result = $db->query($sql)) {
     if ($result && $result->num_rows > 0) {
      while ($r = $result->fetch_object()) {
       $comments[] = $r;
      }
     }
    }
    if ($atom) {
     require('testPage.atom.tpl');
    } else if ($action == 'dev') {
     // avoid getting indexed
     header('HTTP/1.1 503 Service Unavailable');
     require('dev.tpl');
    } else {
     if (!isset($_SESSION['hits'][$item->id])) {
      $db->query('UPDATE pages SET hits = hits + 1 WHERE id = ' . $item->id);
      $_SESSION['hits'][$item->id] = true;
     }
     require('testPage.tpl');
    }
   }
  } else {
   @mail(ADMIN_EMAIL, '[jsPerf] Test case without tests, lolwat', $slug);
   require('404.tpl');
  }
 } else {
  // Error: slug not found
  require('404.tpl');
 }
} else {
 require('index.tpl');
}

?>