<?php
/**
 * GeSHi - Generic Syntax Highlighter
 * <pre>
 *   File:   geshi/functions.geshi.php
 *   Author: Nigel McNie
 *   E-mail: nigel@geshi.org
 * </pre>
 *
 * For information on how to use GeSHi, please consult the documentation
 * found in the docs/ directory, or online at http://geshi.org/docs/
 *
 * This program is part of GeSHi.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
 *
 * @package    geshi
 * @subpackage core
 * @author     Nigel McNie <nigel@geshi.org>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL
 * @copyright  (C) 2004 - 2006 Nigel McNie
 * @version    $Id: functions.geshi.php 2217 2009-12-06 09:40:59Z benbe $
 *
 */

//Ensure debugging is set to of if not explicitly told to be enabled before!
if(!defined('GESHI_DBG_ENABLE')) {
	define('GESHI_DBG_ENABLE', false);
}

if(true === GESHI_DBG_ENABLE) {
    /**
     * Handles debugging by printing a message according to current debug level,
     * mask of context and other things.
     *
     * @param string The message to print out
     * @param int The context in which this message is to be printed out in - see
     *            the GESHI_DBG_* constants
     * @param boolean Whether to add a newline to the message
     * @param boolean Whether to return the count of errors or not
     * @access private
     */
    function geshi_dbg ($message, $add_nl = true)
    {
        // shortcut
        if (empty($message)) {
            if ($add_nl) {
                echo "\n";
            }
            return;
        }
        //
        // Message can have the following symbols at start
        //
        // @b: bold
        // @i: italic
        // @o: ok (green colour)
        // @w: warn (yellow colour)
        // @e: err (red colour)
        $start = '';
        $end = '';
        if ($message[0] == '@') {
            $end   = '</span>';
            switch (substr($message, 0, 2)) {
                case '@b':
                    $start = '<span style="font-weight:bold;">';
                    break;

                case '@i':
                    $start = '<span style="font-style:italic;">';
                    break;

                case '@o':
                    $start = '<span style="color:green;background-color:#efe;border:1px solid #393;">';
                    break;

                case '@w':
                    $start = '<span style="color:#660;background-color:#ffe;border:1px solid #993;">';
                    break;

                case '@e':
                    $start = '<span style="color:red;background-color:#fee;border:1px solid #933;">';
                    break;

                default:
                    $end = '';
            }
            if (!empty($end)) {
                $message = substr($message, 2);
            }
        } elseif (preg_match('#::(?:.*?)\((?:.*?)\)#s', $message)) {
            $start = '<span style="font-weight:bold;">';
            $end   = '</span>';
        }

        if ($add_nl)
            $end .= "\n";

        echo $start . GeSHi::hsc(str_replace("\n", '', $message)) . $end;
    }
} else {
    function geshi_dbg (){}
}

/**
 * Checks whether a file name is able to be read by GeSHi
 *
 * The file must be within the GESHI_ROOT directory
 *
 * @param  string  The absolute pathname of the file to check
 * @return boolean Whether the file is readable by GeSHi
 * @access private
 */
function geshi_can_include ($file_name)
{
    // Check the file is in the root path
    if (GESHI_ROOT != substr($file_name, 0, strlen(GESHI_ROOT))) {
        return false;
    }

    // Check if the given file exists, is a file and is readable
    if (!(file_exists($file_name) && is_file($file_name) && is_readable($file_name))) {
        return false;
    }

    // Check if the user tries to use .. inside the path
    if (false !== strpos($file_name, '..')) {
        return false;
    }

    // Check if we need to check for symlinks and if all required functions are available
    // The availability check is due to compatibility to M$ Windows as PHP doesn't implement
    // some symlink functions there.
    $can_include = true;
    if (!GESHI_ALLOW_SYMLINK_PATHS && function_exists('is_link')) {
        do {
            // Check for filename being a file OR a directory
            $file_type = filetype($file_name);
            $can_include &= (('file' == $file_type || 'dir' == $file_type) && !is_link($file_name));

            // Change to the parent directory for next test
            $file_name = dirname($file_name);
        } while (GESHI_ROOT == substr($file_name, 0, strlen(GESHI_ROOT) && $can_include));
    }

    return (bool) $can_include;
}

/**
 * A replacement for strpos and stripos that can also handle regular expression
 * string positions.
 *
 * @param string The string in which to search for the $needle
 * @param string The string to search for. If this string starts with "REGEX"
 *               then a regular expression search is performed.
 * @param int    The offset in the string in which to start searching.  Look-
 *               behind assertions in a regex that refer to characters prior to
 *               this point will not match.
 * @param boolean Whether the search is case sensitive or not
 * @param boolean Whether the match table is needed (almost never, and it makes
 *                things slower, but probably not noticeably).
 * @return array An array of data:
 * <pre> 'pos' => position in string of needle,
 * 'len' => length of match
 * 'tab' => a tabular array containing the parenthesised sub-matches of a
 *   regular expression.  [0] is the complete match, [1] the first parenthesized
 *   sub-match, and so on.
 * </pre>
 * @access private
 */
function geshi_get_position ($haystack, $needle, $offset = 0,
  $case_sensitive = false, $need_table = false)
{
    if ('REGEX' != substr($needle, 0, 5)) {
        if (!$case_sensitive) {
            return array('pos' => stripos($haystack, $needle, $offset),
              'len' => strlen($needle));
        } else {
            return array('pos' => strpos($haystack, $needle, $offset),
              'len' => strlen($needle));
        }
    }

    $regex = substr($needle, 5);
    $haystack_offset = substr($haystack, $offset);
    $table = array();
    $length = 0;
    $flags = PREG_SPLIT_OFFSET_CAPTURE;
    if ($need_table) $flags |= PREG_SPLIT_DELIM_CAPTURE;
    // @todo [blocking 1.1.4]  This line is marked by BenBE as one of the
    // slowest. There's not too much that can be done to speed up the line
    // per se, but possibly something similar to the "here's a character
    // you can check to see if this is ever going to pass" might be useful.
    $splits = preg_split($regex, $haystack_offset, 2, $flags);
    if (count($splits) > 1) {
        $first = array_shift($splits);
        $last = array_pop($splits);
        $pos = strlen($first[0]);
        $length = $last[1] - $pos;
        $pos += $offset;
        if ($need_table) {
            $table[] = substr($haystack_offset, $pos, $length);
            foreach ($splits as $match) $table[] = $match[0];
        }
    } else $pos = false;
    return array('pos' => $pos, 'len' => $length, 'tab' => $table);
}

/**
 * Which, if any, of the strings in the array $substrs occurs at offset $offset
 * in the string $str?
 * If $flags contains GESHI_WHICHSS_MAXIMAL, then the largest of multiple
 * matches will be returned, otherwise and by default: the first encountered.
 * If $flags contains GESHI_WHICHSS_CASEINSENSITIVE then the comparison will be
 * case-insensitive; otherwise and by default it will be case-sensitive.
 * If $flags contains GESHI_WHICHSS_TRYREGEX then the remaining portion of any
 * string in $substrs that starts with 'REGEX' will be treated as a (Perl-
 * compatible) regular expression to match, anchored to the start of the string
 * at $offset.  Look-behind assertions that refer to parts of the string prior
 * to $offset will not work.  If $flags contains GESHI_WHICHSS_SKIPANCHORINSERT
 * then the anchor insertion on each regex in $substr will not be performed -
 * it will be assumed to have already been performed but in any case only
 * matches at the start of the string will ever be returned.
 * @return Null if no match is found, otherwise the matching substring, with
 * case as in the $substrs element rather than the matching portion of $str.
 */
define('GESHI_WHICHSS_MAXIMAL', 1);
define('GESHI_WHICHSS_CASEINSENSITIVE', 2);
define('GESHI_WHICHSS_TRYREGEX', 4);
define('GESHI_WHICHSS_SKIPANCHORINSERT', 8);
function geshi_whichsubstr($str, $substrs, $offset = 0, $flags = 0) {
    /* Constants */
    static $re_starter_c = 'REGEX';
    static $re_starter_len_c = 5/*strlen($re_starter_c)*/;

    $ret = null;
    $max_len = -1;
    foreach ($substrs as $substr) {
        if (($flags & GESHI_WHICHSS_TRYREGEX) &&
          strncmp($substr,$re_starter_c,$re_starter_len_c)==0) {
            $re = substr($substr, $re_starter_len_c);
            if (!($flags & GESHI_WHICHSS_SKIPANCHORINSERT)) {
                $re = geshi_anchor_re($re);
            }
            $haystack = $offset > 0 ? substr($str, $offset) : $str;
            $match = preg_match($re, $haystack, $matches, PREG_OFFSET_CAPTURE) ?
              $matches[0][0] : null;
            $len = strlen($match);
            /* This code is reached only if GESHI_WHICHSS_SKIPANCHORINSERT was
             * specified without a pre-existing anchor and with a match that
             * started beyond $offset.
             */
            if ($match !== null && $matches[0][1]) $len = $match = null;
        } else {
            $len = strlen($substr);
            if (!($flags & GESHI_WHICHSS_CASEINSENSITIVE)) {
                $match = substr($str,$offset,$len) == $substr ? $substr : null;
            } else if (strcasecmp(substr($str, $offset, $len), $substr) == 0) {
                $match = $substr;
            } else $match = null;
        }
        if ($match !== null) {
            if (!($flags & GESHI_WHICHSS_MAXIMAL)) {
                $ret = $match;
                break;
            } else if ($len > $max_len) {
                $ret = $match;
                $max_len = $len;
            }
        }
    }
    return $ret;
}

/**
 * Safely inserts an anchor into the regex $regex so that it only matches at the
 * start of the searched string.
 * @return string The regex with anchor inserted.
 */
function geshi_anchor_re($regex) {
    $delim = $regex[0];
    $endPos = strrpos($regex, $delim);
    $endChars = substr($regex, $endPos);
    return "$delim^(".substr($regex, 1, $endPos - 1).')'.$endChars;
}

/**
 * @todo [blocking 1.1.5] Octal/hexadecimal numbers are common, so should have functions
 *       for those, and make sure that integers/doubles do not collide
 * @access private
 */

function geshi_is_whitespace ($token)
{
    return !preg_match('/[^\s]/', $token);
}

/**
 * Returns the GeSHi_Styler object used to help with parsing
 *
 * @param boolean $force_new If true, forces the creation of
 *                           a new GeSHi_Parser object
 * @return GeSHi_Styler
 * @access private
 */
function geshi_styler ($force_new = false)
{
    static $styler = null;
    if (!$styler || $force_new) {
        $styler = new GeSHiStyler;
    }
    return $styler;
}


/**
* this functions creates an optimized regular expression list
* of an array of strings.
*
* Example:
* <code>$list = array('faa', 'foo', 'foobar');
*          => string 'f(aa|oo(bar)?)'</code>
*
* @param $list array of (unquoted) strings
* @param $regexp_delimiter your regular expression delimiter, @see preg_quote()
* @return string for regular expression
* @author Milian Wolff <mail@milianw.de>
* @access private
*/
function geshi_optimize_regexp_list(array $list, $regexp_delimiter = '/') {
    $regex_chars = array('.', '\\', '+', '*', '?', '[', '^', ']', '$',
        '(', ')', '{', '}', '=', '!', '<', '>', '|', ':', $regexp_delimiter);
    sort($list);
    $regexp_list = array('');
    $list_key = 0;

    // prevent "Compilation failed: regular expression is too large" errors
    $max_len = 35000;
    $cur_len = 0;

    // the tokens which we will use to generate the regexp list
    $tokens = array();
    $prev_keys = array();
    // go through all entries of the list and generate the token list
    for ($i = 0, $i_max = count($list); $i < $i_max; ++$i) {
        $level = 0;
        $entry = preg_quote((string) $list[$i], $regexp_delimiter);
        $pointer = &$tokens;
        // properly assign the new entry to the correct position in the token array
        // possibly generate smaller common denominator keys
        while (true) {
            // get the common denominator
            if (isset($prev_keys[$level])) {
                if ($prev_keys[$level] == $entry) {
                    // this is a duplicate entry, skip it
                    continue 2;
                }
                $char = 0;
                while (isset($entry[$char]) && isset($prev_keys[$level][$char])
                        && $entry[$char] == $prev_keys[$level][$char]) {
                    ++$char;
                }
                if ($char > 0) {
                    // this entry has at least some chars in common with the current key
                    if ($char == strlen($prev_keys[$level])) {
                        // current key is totally matched, i.e. this entry has just some bits appended
                        $pointer = &$pointer[$prev_keys[$level]];
                    } else {
                        // only part of the keys match
                        $new_key_part1 = substr($prev_keys[$level], 0, $char);
                        $new_key_part2 = substr($prev_keys[$level], $char);
                        if (in_array($new_key_part1[0], $regex_chars)
                            || in_array($new_key_part2[0], $regex_chars)) {
                            // this is bad, a regex char as first character
                            $pointer[$entry] = array('' => true);
                            array_splice($prev_keys, $level, count($prev_keys), $entry);
                            continue;
                        } else {
                            // relocate previous tokens
                            $pointer[$new_key_part1] = array($new_key_part2 => $pointer[$prev_keys[$level]]);
                            unset($pointer[$prev_keys[$level]]);
                            $pointer = &$pointer[$new_key_part1];
                            // recreate key index
                            array_splice($prev_keys, $level, count($prev_keys), array($new_key_part1, $new_key_part2));
                        }
                    }
                    ++$level;
                    $entry = substr($entry, $char);
                    continue;
                }
                // else: fall trough, i.e. no common denominator was found
            }
            if ($level == 0 && !empty($tokens)) {
                // we can dump current tokens into the string and throw them away afterwards
                $new_entry = geshi_optimize_regexp_list_tokens_to_string($tokens);

                $entry_len = strlen($new_entry);
                if ($max_len < $cur_len + $entry_len) {
                    $regexp_list[++$list_key] = $new_entry;
                    $cur_len = $entry_len;
                } else {
                    if (!empty($regexp_list[$list_key])) {
                        $new_entry = '|' . $new_entry;
                    }
                    $regexp_list[$list_key] .= $new_entry;
                    $cur_len += $entry_len;
                }

                $tokens = array();
            }
            // no further common denominator found
            $pointer[$entry] = array('' => true);
            array_splice($prev_keys, $level, count($prev_keys), $entry);
            break;
        }
        unset($list[$i]);
    }
    // make sure the last tokens get converted as well
    $new_entry = geshi_optimize_regexp_list_tokens_to_string($tokens);

    $entry_len = strlen($new_entry);
    if ($max_len < $cur_len + $entry_len) {
        $regexp_list[++$list_key] = $new_entry;
        $cur_len = $entry_len;
    } else {
        if (!empty($regexp_list[$list_key])) {
            $new_entry = '|' . $new_entry;
        }
        $regexp_list[$list_key] .= $new_entry;
        $cur_len += $entry_len;
    }

    $tokens = array();
    return $regexp_list;
}
/**
* this function creates the appropriate regexp string of an token array
* you should not call this function directly, @see $this->optimize_regexp_list().
*
* @param &$tokens array of tokens
* @param $recursed bool to know wether we recursed or not
* @return string
* @author Milian Wolff <mail@milianw.de>
* @access private
*/
function geshi_optimize_regexp_list_tokens_to_string(&$tokens, $recursed = false) {
    $list = '';
    foreach ($tokens as $token => $sub_tokens) {
        $list .= $token;
        $close_entry = isset($sub_tokens['']);
        unset($sub_tokens['']);
        if (!empty($sub_tokens)) {
            $list .= '(?:' . geshi_optimize_regexp_list_tokens_to_string($sub_tokens, true) . ')';
            if ($close_entry) {
                // make sub_tokens optional
                $list .= '?';
            }
        }
        $list .= '|';
    }
    if (!$recursed) {
        // do some optimizations
        // common trailing strings
        // BUGGY!
        //$list = preg_replace_callback('#(?<=^|\:|\|)\w+?(\w+)(?:\|.+\1)+(?=\|)#', create_function(
        //    '$matches', 'return "(?:" . preg_replace("#" . preg_quote($matches[1], "#") . "(?=\||$)#", "", $matches[0]) . ")" . $matches[1];'), $list);
        // (?:p)? => p?
        $list = preg_replace('#\(\?\:(.)\)\?#', '\1?', $list);
        // (?:a|b|c|d|...)? => [abcd...]?
        // TODO: a|bb|c => [ac]|bb
        static $callback_2;
        if (!isset($callback_2)) {
            $callback_2 = create_function('$matches', 'return "[" . str_replace("|", "", $matches[1]) . "]";');
        }
        $list = preg_replace_callback('#\(\?\:((?:.\|)+.)\)#', $callback_2, $list);
    }
    // return $list without trailing pipe
    return substr($list, 0, -1);
}

?>