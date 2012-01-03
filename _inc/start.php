<?php

function __autoload($classname){
	include_once(strtolower($classname) . '.php');
}

require('config.php');

// Whenever I want to test new CSS/JS/templates, I just add my IP to the array.
// Everyone else will still get the normal jsPerf.
// It’s an array so I can easily add testers if I want to.
$debug = in_array($_SERVER['REMOTE_ADDR'], array('81.123.45.123', '127.0.0.1'));

// In case a deploy goes wrong:
/*
if (!$debug) {
	header('HTTP/1.1 503 Service Temporarily Unavailable');
	die('jsPerf is temporarily unavailable.');
}
*/

session_name('jsPerf');
ini_set('use_only_cookies', '1'); // Don’t use query string
ini_set('session.cookie_httponly', true); // So session cookies won’t appear in document.cookie
ini_set('session.hash_function', '1'); // Use 160-bit SHA-1 encryption
ini_set('session.hash_bits_per_character', '6'); // 0-9, a-z, A-Z, "-", ","
ini_set('session.cookie_lifetime', '28800'); // 28,800 seconds = 8 hours
ini_set('session.gc_maxlifetime', '28800'); // 28,800 seconds = 8 hours
session_start();

ini_set('user_agent', 'jsPerf');
date_default_timezone_set('Europe/Brussels');
setlocale(LC_ALL, 'en_US');

// Normalize $_POST, $_GET, $_COOKIE and $_REQUEST in case magic quotes are enabled
// This script is very inefficient so please use directives instead!
// Before anything else, make sure magic_quotes_gpc() is out of the picture.
if (get_magic_quotes_gpc()) {
	function die_magic_quotes_die_die_die(&$value) {
		$value = stripslashes($value);
	}
	array_walk_recursive($_GET, 'die_magic_quotes_die_die_die');
	array_walk_recursive($_POST, 'die_magic_quotes_die_die_die');
	array_walk_recursive($_COOKIE, 'die_magic_quotes_die_die_die');
	array_walk_recursive($_REQUEST, 'die_magic_quotes_die_die_die');
}

if ($debug || isset($_SESSION['admin'])) {
	error_reporting(E_ALL);
	ini_set('display_errors', 1);
} else {
	error_reporting(0);
}

$reservedSlugs = array(
	'about',
	'add',
	'all',
	'api',
	'browse',
	'browse.atom',
	'browseAuthor',
	'contributors',
	'dart',
	'deleteComment',
	'disclaimer',
	'donate',
	'editComment',
	'embed',
	'faq',
	'help',
	'list',
	'testimonials',
	'mathias',
	'popular',
	'new',
	'search',
	'search.atom',
	'sitemap.xml'
);

$reservedActions = array(
	'edit',
	'delete',
	'publish',
	'embed',
	'dev'
);

function userAgent() {
	$browser = new Browser();
	return str_replace(array('Internet Explorer', 'iPhone'), array('IE', 'Mobile Safari'), $browser->getBrowser()) . ' ' . $browser->getVersion();
}

function removeFromBegin($str, $remove) {
	$regex = sprintf('/^%s/', preg_quote($remove, '/'));
	return preg_replace($regex, '', $str);
}

function author($name, $url, $isComment = false) {
	if ($name !== '') {
		return ($isComment ? '': 'by ') . ($url !== '' ? '<a href="' . he(removeFromBegin($url, 'http:')) . '"' . ($url === 'http://mathiasbynens.be/' ? '' : ' rel="nofollow"') . '>' . he($name) . '</a> ' : he($name) . ' ');
	}
}

function slug($str) {
	// Some versions of MAMP claim to support iconv, but actually return an empty string
	if (function_exists('iconv') && iconv('UTF-8', 'ASCII//TRANSLIT', 'a')) {
		$str = iconv('UTF-8', 'ASCII//TRANSLIT', $str);
	}
	return preg_replace('/[^a-zA-Z0-9 -]/', '', str_replace(' ', '-', strtolower($str)));
}

function he($str) { // shortcut function for htmlspecialchars() with UTF-8 settings
	return htmlspecialchars($str, ENT_QUOTES, 'UTF-8');
}

function hed($str) { // shortcut function for html_entity_decode() with UTF-8 settings
	return html_entity_decode($str, ENT_COMPAT, 'UTF-8');
}

function addCode($str) {
	return preg_replace('/`([^`]*)`/s', '<code>$1</code>', $str);
}

function removeBackticks($str) {
	// Only remove backticks that would otherwise be replaced by a <code> element
	return preg_replace('/`(.*?)`/s', '\1', $str);
}

function addBrowserscopeTest($title = '', $description = '', $url = '') {
	$bURL = 'http://www.browserscope.org/user/tests/create?api_key=' . BROWSERSCOPE_API_KEY . '&name=' . urlencode($title) . '&description=' . urlencode(substr($description, 0, 60)) . '&url=' . urlencode($url);
	if ($json = file_get_contents($bURL)) {
		// $http_response_header is a magic variable containing the resulting headers of file_get_contents()
		// var_dump($http_response_header);
		$json = json_decode($json);
		return $json->test_key;
	}
	return false;
}

function md($str) {
	require_once('markdown.php');
	$str = preg_replace_callback('!```(.*?)```!s', function($data) {
		return str_replace("\n", "\n    ", $data[1]);
	}, $str);
	return Markdown($str);
}

// more like indentByOneLevel, amirite
function indentByOne($str) {
	return '  ' . $str;
}

function indent($str) {
	$lines = explode("\n", $str);
	$lines = array_map('indentByOne', $lines);
	return implode("\n", $lines);
}

function niceTime($num, $unit) {
	return $num . ' ' . $unit . ($num != 1 ? 's' : '') . ' ago';
}

function relativeDate($date) {
	$diff = time() - strtotime($date);
	if ($diff < 5) {
		return 'just now';
	}
	if ($diff < 60) {
		return niceTime($diff, 'second');
	}
	$diff = round($diff / 60);
	if ($diff < 60) {
		return niceTime($diff, 'minute');
	}
	$diff = round($diff / 60);
	if ($diff < 24) {
		return niceTime($diff, 'hour');
	}
	$diff = round($diff / 24);
	if ($diff < 7) {
		return niceTime($diff, 'day');
	}
	$diff = round($diff / 7);
	if ($diff < 4) {
		return niceTime($diff, 'week');
	}
	return 'on ' . date('jS F Y', strtotime($date));
}

function shorten($str, $length = 160, $minword = 3) {
	$sub = '';
	$len = 0;
	foreach (explode(' ', $str) as $word) {
		$part = (($sub != '') ? ' ' : '') . $word;
		$sub .= $part;
		$len += strlen($part);
		if (strlen($word) > $minword && strlen($sub) >= $length) {
			break;
		}
	}
	return $sub . (($len < strlen($str)) ? '…' : '');
}

function isOk($var) {
	return isset($_POST[$var]) && !empty($_POST[$var]);
}

function epv($var, $textarea = false, $testID = false, $req = false) {
	if ($textarea) {
		if ($testID) {
			$output = '<textarea name="test[' . $testID . '][' . $var . ']" id="test[' . $testID . '][' . $var . ']" class="code-js"' . ($testID < 3 ? ' required' : '') . '>' . (isset($_POST['test'][$testID][$var]) ? $_POST['test'][$testID][$var] : '') . '</textarea>';
		} else {
			$output = '<textarea name="' . $var . '" id="' . $var . '"' . ($req ? ' required' : '') . '>' . (isset($_POST[$var]) ? he($_POST[$var]) : '') . '</textarea>';
		}
	} else if ($testID) {
		$output = 'name="test[' . $testID . '][' . $var . ']" id="test[' . $testID . '][' . $var . ']"';
		if (isset($_POST['test'][$testID]) && isset($_POST['test'][$testID][$var])) {
			$output .= ' value="' . he($_POST['test'][$testID][$var]) . '"' . ($testID < 3 ? ' required' : '');
		}
	} else {
		$output = 'name="' . $var . '" id="' . $var . '"';
		if (isset($_POST[$var])) {
			$output .= ' value="' . he($_POST[$var]) . '"';
		}
	}
	echo $output;
}

function showTestInput($i) {
?>
			<fieldset>
				<h4>Test <?php echo $i; ?></h4>
				<div><label for="test[<?php echo $i; ?>][title]">Title <em title="This field is required">*</em> </label><input type="text" <?php epv('title', false, $i); ?> required></div>
				<div><label for="test[<?php echo $i; ?>][defer]">Async </label><label class="inline"><input type="checkbox" value="y" <?php epv('defer', false, $i); ?>> (check if this is an <a href="/faq#async">asynchronous test</a>)</label></div>
				<div><label for="test[<?php echo $i; ?>][code]">Code <em title="This field is required">*</em> </label><?php epv('code', true, $i); ?></div>
			</fieldset>
<?php
}

function highlight($str, $lang = 'javascript') {
	include_once('geshi.php');
	$geshi = new GeSHi($str, $lang);
	$geshi->enable_classes();
	$geshi->set_header_type(GESHI_HEADER_NONE);
	//echo $geshi->get_stylesheet();
	return str_replace('<br />' . "\n", '<br>', $geshi->parse_code());
}

$db = new mysqli(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE);
$db->set_charset('utf8');

?>