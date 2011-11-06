<?php
if (!empty($_POST)) {
	//echo '<!--<pre>'; var_dump($_POST); echo '</pre>-->';
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
	// Check input
	if (isOk('title') && isOk('slug') && isOk('test') && '' !== trim($_POST['test'][1]['title']) && '' !== trim($_POST['test'][1]['code']) && isOk('question') && $_POST['question'] === 'no') {
		// Check if slug only contains a-z
		if (ctype_alnum(str_replace('-', '', $_POST['slug']))) {
			// Check if slug is available
			$sql = 'SELECT * FROM pages WHERE slug = "' . $db->real_escape_string($_POST['slug']) . '"';
			$result = $db->query($sql);
			if (in_array($_POST['slug'], $reservedSlugs) || 0 !== $result->num_rows) {
				$slugError = '<span class="error">This slug is already in use. Please choose another one.</span>';
			} else {
				// Slug is available, go ahead and add the test case
				$browserscopeID = addBrowserscopeTest($_POST['title'], $_POST['info'], 'http://' . DOMAIN . '/' . $_POST['slug']);
				$visible = $_POST['visible'] === 'y' ? 'y' : 'n';
				$sql = 'INSERT INTO pages (slug, browserscopeID, title, info, initHTML, setup, teardown, published, author, authorEmail, authorURL, visible) VALUES ("' . $db->real_escape_string($_POST['slug']) . '", ' . ($browserscopeID ? '"' . $db->real_escape_string($browserscopeID) . '"' : 'NULL') . ', "' . $db->real_escape_string($_POST['title']) . '", "' . $db->real_escape_string($_POST['info']) . '", "' . $db->real_escape_string($_POST['prep-html']) . '", "' . $db->real_escape_string($_POST['setup']) . '", "' . $db->real_escape_string($_POST['teardown']) . '", NOW(), "' . $db->real_escape_string($_POST['author']) . '", "' . $db->real_escape_string($_POST['author-email']) . '", "' . $db->real_escape_string($_POST['author-url']) . '", "' . $visible . '")';
				if ($db->query($sql)) {
					// Now add the tests to the test case
					$pageID = $db->insert_id;
					$sql = 'INSERT INTO tests (pageID, title, defer, code) VALUES';
					foreach ($_POST['test'] as $test) {
						$test['defer'] = isset($test['defer']) && ('y' == $test['defer']) ? 'y' : 'n';
						if (!empty($test['title']) && !empty($test['code'])) {
							$sql .= ' (' . $pageID . ', "' . $db->real_escape_string($test['title']) . '", "' . $test['defer'] . '", "' . $db->real_escape_string($test['code']) . '"), ';
						}
					}
					$sql = trim($sql, ', ');
					if ($db->query($sql)) {
						// Tests were added; redirect to new test case
						$_SESSION['own'][$pageID] = true;
						header('Location: http://' . DOMAIN . '/' . $_POST['slug']);
					} else {
						@mail(ADMIN_EMAIL, '[jsPerf] Failed to add tests to testcase: ' . $_POST['title'], 'http://' . DOMAIN . '/' . $_POST['slug'] . "\n" . var_export($_POST, true));
					}
				}
			}
		} else {
			$slugError = '<span class="error">The slug can only contain alphanumeric characters and hyphens.</span>';
		}
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

$home = $jsClass = $mainJS = true; require('head.tpl');

?>
<h1><strong><em title="JavaScript">js</em>Perf</strong> — JavaScript performance playground</h1>
<h2>What is jsPerf?</h2>
<p>jsPerf aims to provide an easy way to create and share <a href="/browse" title="View some examples by browsing the jsPerf test cases">test cases</a>, comparing the performance of different JavaScript snippets by running benchmarks. For more information, see <a href="/faq" title="Frequently asked questions">the FAQ</a>.</p>
<h2>Create a test case</h2>
<form action="/" method="post">
	<fieldset>
		<h3>Your details (optional)</h3>
		<div><label for="author">Name </label><input type="text" name="author" id="author"<?php if ($author) { echo ' value="' . he($author) . '"'; } ?>></div>
		<div><label for="author-email">Email </label><label class="inline"><input type="email" name="author-email" id="author-email"<?php if ($authorEmail) { echo ' value="' . he($authorEmail) . '"'; } ?>> (won’t be displayed; might be used for Gravatar)</label></div>
		<div><label for="author-url">URL </label><input type="url" name="author-url" id="author-url"<?php if ($authorURL) { echo ' value="' . he($authorURL) . '"'; } ?>></div>
	</fieldset>
	<fieldset>
		<h3>Test case details</h3>
		<div><label for="title">Title <em title="This field is required">*</em> </label><input type="text" <?php epv('title'); ?> required><?php if ($titleError) { echo ' ' . $titleError; } ?></div>
		<div>
			<label for="slug">Slug <em title="This field is required">*</em> </label><input type="text" <?php epv('slug'); ?> pattern="[a-z0-9](?:-?[a-z0-9])*" required><?php if ($slugError) { echo ' ' . $slugError; } ?>
			<p class="preview">Test case URL will be <samp>http://<?php echo DOMAIN; ?>/<mark><?php echo (isOk('slug') ? $_POST['slug'] : 'slug'); ?></mark></samp></p>
		</div>
		<div><label for="visible">Published </label><label class="inline"><input type="checkbox" value="y" <?php epv('visible'); ?> checked> (uncheck if you want to fiddle around before making the page public)</label></div>
		<div><label for="info">Description <span>(in case you feel further explanation is needed)</span><span>(Markdown syntax is allowed)</span> </label><?php epv('info', 1); ?></div>
		<div class="question"><label for="question">Are you a spammer? <span>(just answer the question)</span> </label><input type="text" <?php epv('question'); ?>><?php if ($spamError) { echo ' ' . $spamError; } ?></div>
		<fieldset>
			<h3>Preparation code</h3>
			<div>
				<label for="prep-html">Preparation code HTML <span>(this will be inserted in the <code>&lt;body></code> of a valid HTML5 document in standards mode)</span> <span>(useful when testing DOM operations or including libraries)</span> </label><?php epv('prep-html', 1); ?>
				<p id="add-libraries">Include JavaScript libraries as follows: <code>&lt;script src="//cdn.ext/library.js">&lt;/script></code></p>
			</div>
			<div><label for="setup">Define <code>setup</code> for all tests <span>(variables, functions, arrays or other objects that will be used in the tests)</span> <span>(runs before each clocked test loop, outside of the timed code region)</span> <span>(e.g. define local test variables, reset global variables, clear <code>canvas</code>, etc.)</span> <span>(<a href="/faq#setup-teardown">see FAQ</a>)</span> </label><?php epv('setup', 1); ?></div>
			<div><label for="teardown">Define <code>teardown</code> for all tests <span>(runs after each clocked test loop, outside of the timed code region)</span> <span>(<a href="/faq#setup-teardown">see FAQ</a>)</span> </label><?php epv('teardown', 1); ?></div>
		</fieldset>
		<fieldset id="tests">
			<h3>Code snippets to compare</h3>
			<fieldset>
				<h4>Test 1</h4>
				<div><label for="test[1][title]">Title <em title="This field is required">*</em> </label><input type="text" <?php epv('title', false, 1); ?> required><?php if ($codeTitleError) { echo ' ' . $codeTitleError; } ?></div>
				<div><label for="test[1][defer]">Async</label><label class="inline"><input type="checkbox" value="y" <?php epv('defer', false, 1); ?>> (check if this is an <a href="/faq#async">asynchronous test</a>)</label></div>
				<div><label for="test[1][code]">Code <em title="This field is required">*</em> <span>(No need for loops in the test code; we’ll take care of that for you)</span></label><?php epv('code', true, 1); ?><?php if ($codeError) { echo ' ' . $codeError; } ?></div>
			</fieldset>
<?php showTestInput(2); ?>
<?php if (!empty($_POST)) { $i = 0; foreach ($_POST['test'] as $test) { if (++$i > 2) { showTestInput($i); } } } ?>
		</fieldset>
		<div class="buttons"><input type="submit" class="submit" value="Save test case" title="Save and view test case"></div>
	</fieldset>
</form>
<?php require('foot.tpl'); ?>