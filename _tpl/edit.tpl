<?php

$update = isset($_SESSION['own'][$item->id]) || isset($_SESSION['admin']);

if (!empty($_POST)) {
 if (!isset($_SESSION['admin'])) {
  if (isOk('author')) {
   $author = $_POST['author'];
   $_SESSION['authorSlug'] = slug($_POST['author']);
  }
  if (isOk('author-email')) {
   $authorEmail = $_POST['author-email'];
  }
  if (isOk('author-url')) {
   $authorURL = $_POST['author-url'];
  }
 }
 // Check input
 if (isOk('title') && isOk('test') && '' !== trim($_POST['test'][1]['code']) && isOk('question') && $_POST['question'] === 'no') {
  $rev = ++$item->maxRev;
  $visible = (isset($_POST['visible']) && $_POST['visible'] === 'y') ? 'y' : 'n';
  $browserscopeID = addBrowserscopeTest($_POST['title'], $_POST['info'], 'http://' . DOMAIN . '/' . $slug . '/' . $rev);
  $sql = $update
         ? 'UPDATE pages SET browserscopeID = ' . ($browserscopeID ? '"' . $db->real_escape_string($browserscopeID) . '"' : 'NULL') . ', title = "' . $db->real_escape_string($_POST['title']) . '", info = "' . $db->real_escape_string($_POST['info']) . '", initHTML = "' . $db->real_escape_string($_POST['prep-html']) . '", setup = "' . $db->real_escape_string($_POST['setup']) . '", teardown = "' . $db->real_escape_string($_POST['teardown']) . '", updated = NOW(), author = "' . $db->real_escape_string($_POST['author']) . '", authorEmail = "' . $db->real_escape_string($_POST['author-email']) . '", authorURL = "' . $db->real_escape_string($_POST['author-url']) . '", visible = "' . $visible . '" WHERE id = ' . $item->id
         : 'INSERT INTO pages (slug, browserscopeID, revision, title, info, initHTML, setup, teardown, published, author, authorEmail, authorURL, visible) VALUES ("' . $db->real_escape_string($slug) . '", ' . ($browserscopeID ? '"' . $db->real_escape_string($browserscopeID) . '"' : 'NULL') . ', ' . $rev . ', "' . $db->real_escape_string($_POST['title']) . '", "' . $db->real_escape_string($_POST['info']) . '", "' . $db->real_escape_string($_POST['prep-html']) . '", "' . $db->real_escape_string($_POST['setup']) . '", "' . $db->real_escape_string($_POST['teardown']) . '", NOW(), "' . $db->real_escape_string($_POST['author']) . '", "' . $db->real_escape_string($_POST['author-email']) . '", "' . $db->real_escape_string($_POST['author-url']) . '", "' . $visible . '")';
  $db->query($sql);
  $pageID = $update ? $item->id : $db->insert_id;
  //var_dump($db->insert_id);
  foreach ($_POST['test'] as $test) {
   $test['defer'] = isset($test['defer']) && ('y' == $test['defer']) ? 'y' : 'n';
   if (empty($test['title']) && empty($test['code'])) {
    // Delete this snippet
    if ($update && isset($test['id'])) {
     $sql = 'DELETE FROM tests WHERE pageID = ' . $item->id . ' AND testID = ' . (int) $test['id'];
     $db->query($sql);
    } // If this is a new revision we’re creating, simply don’t insert the row
   } else {
    if (isset($test['id'])) {
     // If applicable, update existing test, else create a new revision
     $sql = $update
            ? 'UPDATE tests SET title = "' . $db->real_escape_string($test['title']) . '", defer = "' . $test['defer'] . '", code = "' . $db->real_escape_string($test['code']) . '" WHERE pageID = ' . $item->id . ' AND testID = ' . (int) $test['id']
            : 'INSERT INTO tests (pageID, title, defer, code) VALUES (' . $pageID . ', "' . $db->real_escape_string($test['title']) . '", "' . $test['defer'] . '", "' . $db->real_escape_string($test['code']) . '")';
     $db->query($sql);
    } else {
     // Add new test
     $sql = 'INSERT INTO tests (pageID, title, defer, code) VALUES (' . $pageID . ', "' . $db->real_escape_string($test['title']) . '", "' . $test['defer'] . '", "' . $db->real_escape_string($test['code']) . '")';
     $db->query($sql);
    }
   }
  }
  // Test case edited; redirect to updated page
  if (!$update) {
   $_SESSION['own'][$pageID] = true;
  }
  header('Location: http://' . DOMAIN . '/' . $slug . ($update ? ($item->revision > 1 ? '/' . $item->revision : '') : '/' . $rev));
 } else {
  $error = true;
  if (!isOk('question') || $_POST['question'] !== 'no') {
   $spamError = '<span class="error">Please enter ‘no’ to prove you’re not a spammer.</span>';
  }
  if ('' === trim($_POST['test'][1]['code'])) {
   $codeError = '<p class="error">Please enter a code snippet.</p>';
  }
  if ('' === trim($_POST['test'][1]['title'])) {
   $codeTitleError = '<span class="error">Please enter a title for this code snippet.</span>';
  }
  if (!isOk('title') || '' === trim($_POST['title'])) {
   $titleError = '<span class="error">You must enter a title for this test case.</span>';
  }
 }
}

$title = 'Editing ' . $title; $jsClass = $mainJS = true; require('head.tpl'); ?>
<h1>Editing <a href="/<?php echo $slug; ?>"><?php echo addCode(he($item->title)); ?></a></h1>
<p><?php echo $update ? 'Since it’s your test case, this edit will overwrite the current revision without creating a new URL.' : 'This edit will create a new revision.'; ?></p>
<form method="post">
 <fieldset>
  <h3>Your details (optional)</h3>
  <div><label for="author">Name </label><input type="text" name="author" id="author"<?php if (isset($_SESSION['admin'])) { echo ' value="' . he($item->author). '"'; } else if (isset($_COOKIE['author'])) { echo ' value="' . he($_COOKIE['author']) . '"'; } else if ($author) { echo ' value="' . he($author) . '"'; } ?>></div>
  <div><label for="author-email">Email </label><label class="inline"><input type="email" name="author-email" id="author-email"<?php if (isset($_SESSION['admin'])) { echo ' value="' . he($item->authorEmail). '"'; } else if (isset($_COOKIE['author-email'])) { echo ' value="' . he($_COOKIE['author-email']) . '"'; } else if ($authorEmail) { echo ' value="' . he($authorEmail) . '"'; } ?>> (won’t be displayed; might be used for Gravatar)</label></div>
  <div><label for="author-url">URL </label><input type="url" name="author-url" id="author-url"<?php if (isset($_SESSION['admin'])) { echo ' value="' . he($item->authorURL). '"'; } else if (isset($_COOKIE['author-url'])) { echo ' value="' . he($_COOKIE['author-url']) . '"'; } else if ($authorURL) { echo ' value="' . he($authorURL) . '"'; } ?>></div>
 </fieldset>
 <fieldset>
  <h3>Test case details</h3>
  <div><label for="title">Title <em title="This field is required">*</em> </label><input type="text" name="title" id="title" value="<?php echo he($item->title); ?>" required><?php if ($titleError) { echo ' ' . $titleError; } ?></div>
  <div><label for="visible">Published </label><label class="inline"><input type="checkbox" name="visible" id="visible" value="y"<?php if ($item->visible === 'y') { ?> checked<?php } ?>> <?php if ($item->visible === 'y') { ?>(uncheck if you want to fiddle around before making the page public)<?php } else { ?>(check when your test case is finished)<?php }?></label></div>
  <div><label for="info">Description <span>(in case you feel further explanation is needed)</span><span>(Markdown syntax is allowed)</span> </label><textarea name="info" id="info"><?php echo he($item->info); ?></textarea></div>
  <div class="question"><label for="question">Are you a spammer? <span>(just answer the question)</span> </label><input type="text" name="question" id="question"><?php if ($spamError) { echo ' ' . $spamError; } ?></div>
  <fieldset>
   <h3>Preparation code</h3>
   <div>
    <label for="prep-html">Preparation code HTML <span>(this will be inserted in the <code>&lt;body></code> of a valid HTML5 document in standards mode)</span> <span>(useful when testing DOM operations or including libraries)</span> </label><textarea name="prep-html" id="prep-html"><?php echo he($item->initHTML); ?></textarea>
    <p id="add-libraries">Include JavaScript libraries as follows: <code>&lt;script src="//cdn.ext/library.js">&lt;/script></code></p>
   </div>
   <div><label for="setup">Define <code>setup</code> for all tests <span>(variables, functions, arrays or other objects that will be used in the tests)</span> <span>(runs before each clocked test loop, outside of the timed code region)</span> <span>(e.g. define local test variables, reset global variables, clear <code>canvas</code>, etc.)</span> <span>(<a href="/faq#setup-teardown">see FAQ</a>)</span> </label><textarea name="setup" id="setup"><?php echo he($item->setup); ?></textarea></div>
   <div><label for="teardown">Define <code>teardown</code> for all tests <span>(runs after each clocked test loop, outside of the timed code region)</span> <span>(<a href="/faq#setup-teardown">see FAQ</a>)</span> </label><textarea name="teardown" id="teardown"><?php echo he($item->teardown); ?></textarea></div>
  </fieldset>
  <fieldset id="tests">
   <h3>Code snippets to compare</h3>
<?php $i = 0; foreach ($tests as $test) { ?>
   <fieldset>
    <h4>Test <?php echo ++$i; ?></h4>
    <div><label for="test[<?php echo $i; ?>][title]">Title </label><input type="text" name="test[<?php echo $i; ?>][title]" id="test[<?php echo $i; ?>][title]" value="<?php echo he($test->title); ?>"></div>
    <div><label for="test[<?php echo $i; ?>][defer]">Async </label><label class="inline"><input type="checkbox" value="y" <?php epv('defer', false, $i); if ('y' == $test->defer) { ?> checked<?php } ?>> (check if this is an <a href="/faq#async">asynchronous test</a>)</label></div>
    <div><label for="test[<?php echo $i; ?>][code]">Code </label><textarea name="test[<?php echo $i; ?>][code]" id="test[<?php echo $i; ?>][code]" class="code-js"><?php echo he($test->code); ?></textarea><input type="hidden" name="test[<?php echo $i; ?>][id]" value="<?php echo $test->testID; ?>"></div>
   </fieldset>
<?php } ?>
  </fieldset>
  <div class="buttons"><input type="submit" class="submit" value="Save test case" title="Save and view test case"></div>
 </fieldset>
</form>
<?php require('foot.tpl'); ?>