<?php
 /**
  * File: Browser.php
  * Author: Chris Schuld (http://chrisschuld.com/)
  * Last Modified: November 08, 2009
  * @version 1.6
  * @package PegasusPHP
  * 
  * Copyright (C) 2008-2009 Chris Schuld  (chris@chrisschuld.com)
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation; either version 2 of
  * the License, or (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details at:
  * http://www.gnu.org/copyleft/gpl.html
  *
  *
  * Typical Usage:
  * 
  *   $browser = new Browser();
  *   if( $browser->getBrowser() == Browser::BROWSER_FIREFOX && $browser->getVersion() >= 2 ) {
  *    echo 'You have FireFox version 2 or greater';
  *   }
  *
  * User Agents Sampled from: http://www.useragentstring.com/
  * 
  * This implementation is based on the original work from Gary White
  * http://apptools.com/phptools/browser/
  * 
  * Gary White noted: "Since browser detection is so unreliable, I am
  * no longer maintaining this script. You are free to use and or
  * modify/update it as you want, however the author assumes no
  * responsibility for the accuracy of the detected values."
  * 
  * Anyone experienced with Gary's script might be interested in these notes:
  * 
  *   Added class constants
  *   Added detection and version detection for Google's Chrome
  *   Updated the version detection for Amaya
  *   Updated the version detection for Firefox
  *   Updated the version detection for Lynx
  *   Updated the version detection for WebTV
  *   Updated the version detection for NetPositive
  *   Updated the version detection for IE
  *   Updated the version detection for OmniWeb
  *   Updated the version detection for iCab
  *   Updated the version detection for Safari
  *   Updated Safari to remove mobile devices (iPhone)
  *   Added detection for iPhone
  *   Added detection for robots
  *   Added detection for mobile devices
  *   Added detection for BlackBerry
  *   Removed Netscape checks (matches heavily with firefox & mozilla)
  * 
  * 
  * ADDITIONAL UPDATES:
  * 
  * 2008-11-07:
  *  + Added Google's Chrome to the detection list
  *  + Added isBrowser(string) to the list of functions special thanks to
  *    Daniel 'mavrick' Lang for the function concept (http://mavrick.id.au)
  * 
  * 2008-12-09:
  *  + Removed unused constant
  *
  * 2009-02-16: (Rick Hale)
  *  + Added version detection for Android phones.
  * 
  * 2009-03-14:
  *  + Added detection for iPods.
  *  + Added Platform detection for iPhones
  *  + Added Platform detection for iPods
  * 
  * 2009-04-22:
  *  + Added detection for GoogleBot
  *  + Added detection for the W3C Validator.
  *  + Added detection for Yahoo! Slurp
  * 
  * 2009-04-27:
  *  + Updated the IE check to remove a typo and bug (thanks John)
  *  
  * 2009-08-18:
  *  + Updated to support PHP 5.3 - removed all deprecated function calls
  *  + Updated to remove all double quotes (") -- converted to single quotes (')
  *  
     * 2009-11-08:
     *  + PHP 5.3 Support
     *  + Added support for BlackBerry OS and BlackBerry browser
     *  + Added support for the Opera Mini browser
     *  + Added additional documenation
     *  + Added support for isRobot() and isMobile()
     *  + Added support for Opera version 10
     *  + Added support for deprecated Netscape Navigator version 9
     *  + Added support for IceCat
     *  + Added support for Shiretoko
     */

 class Browser {
  private $_agent = '';
  private $_browser_name = '';
  private $_version = '';
  private $_platform = '';
  private $_os = '';
  private $_is_aol = false;
        private $_is_mobile = false;
        private $_is_robot = false;
  private $_aol_version = '';

  const BROWSER_UNKNOWN = 'unknown';
  const VERSION_UNKNOWN = 'unknown';
  
  const BROWSER_OPERA = 'Opera';                            // http://www.opera.com/
        const BROWSER_OPERA_MINI = 'Opera Mini';                  // http://www.opera.com/mini/
  const BROWSER_WEBTV = 'WebTV';                            // http://www.webtv.net/pc/
  const BROWSER_IE = 'Internet Explorer';                   // http://www.microsoft.com/ie/
  const BROWSER_POCKET_IE = 'Pocket Internet Explorer';     // http://en.wikipedia.org/wiki/Internet_Explorer_Mobile
  const BROWSER_KONQUEROR = 'Konqueror';                    // http://www.konqueror.org/
  const BROWSER_ICAB = 'iCab';                              // http://www.icab.de/
  const BROWSER_OMNIWEB = 'OmniWeb';                        // http://www.omnigroup.com/applications/omniweb/
  const BROWSER_FIREBIRD = 'Firebird';                      // http://www.ibphoenix.com/
  const BROWSER_FIREFOX = 'Firefox';                        // http://www.mozilla.com/en-US/firefox/firefox.html
  const BROWSER_SHIRETOKO = 'Shiretoko';                    // http://wiki.mozilla.org/Projects/shiretoko
  const BROWSER_MOZILLA = 'Mozilla';                        // http://www.mozilla.com/en-US/
  const BROWSER_AMAYA = 'Amaya';                            // http://www.w3.org/Amaya/
  const BROWSER_LYNX = 'Lynx';                              // http://en.wikipedia.org/wiki/Lynx
  const BROWSER_SAFARI = 'Safari';                          // http://apple.com
  const BROWSER_IPHONE = 'iPhone';                          // http://apple.com
        const BROWSER_IPOD = 'iPod';                              // http://apple.com 
  const BROWSER_CHROME = 'Chrome';                          // http://www.google.com/chrome
        const BROWSER_ANDROID = 'Android';                        // http://www.android.com/
        const BROWSER_GOOGLEBOT = 'GoogleBot';                    // http://en.wikipedia.org/wiki/Googlebot
        const BROWSER_SLURP = 'Yahoo! Slurp';                     // http://en.wikipedia.org/wiki/Yahoo!_Slurp
        const BROWSER_W3CVALIDATOR = 'W3C Validator';             // http://validator.w3.org/
        const BROWSER_BLACKBERRY = 'BlackBerry';                  // http://www.blackberry.com/
        const BROWSER_ICECAT = 'IceCat';                          // http://en.wikipedia.org/wiki/GNU_IceCat
  
        const BROWSER_NETSCAPE_NAVIGATOR = 'Netscape Navigator';  // http://browser.netscape.com/ (DEPRECATED)
  const BROWSER_GALEON = 'Galeon';                          // http://galeon.sourceforge.net/ (DEPRECATED)
  const BROWSER_NETPOSITIVE = 'NetPositive';                // http://en.wikipedia.org/wiki/NetPositive (DEPRECATED)
  const BROWSER_PHOENIX = 'Phoenix';                        // http://en.wikipedia.org/wiki/History_of_Mozilla_Firefox (DEPRECATED)
        
  const PLATFORM_UNKNOWN = 'unknown';
  const PLATFORM_WINDOWS = 'Windows';
  const PLATFORM_WINDOWS_CE = 'Windows CE';
  const PLATFORM_APPLE = 'Apple';
  const PLATFORM_LINUX = 'Linux';
  const PLATFORM_OS2 = 'OS/2';
  const PLATFORM_BEOS = 'BeOS';
  const PLATFORM_IPHONE = 'iPhone';
  const PLATFORM_IPOD = 'iPod';
        const PLATFORM_BLACKBERRY = 'BlackBerry';
  
  const OPERATING_SYSTEM_UNKNOWN = 'unknown';
  
  public function __construct() {
   $this->reset();
   $this->determine();
  }
  /**
   * Reset all properties
   */
  public function reset() {
   $this->_agent = isset($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : "";
   $this->_browser_name = self::BROWSER_UNKNOWN;
   $this->_version = self::VERSION_UNKNOWN;
   $this->_platform = self::PLATFORM_UNKNOWN;
   $this->_os = self::OPERATING_SYSTEM_UNKNOWN;
   $this->_is_aol = false;
            $this->_is_mobile = false;
            $this->_is_robot = false;
   $this->_aol_version = self::VERSION_UNKNOWN;
  }
  
  /**
   * Check to see if the specific browser is valid
   * @param string $browserName
   * @return True if the browser is the specified browser
   */
  function isBrowser($browserName) { return( 0 == strcasecmp($this->_browser_name, trim($browserName))); }

  /**
   * The name of the browser.  All return types are from the class contants
   * @return string Name of the browser
   */
  public function getBrowser() { return $this->_browser_name; }
  /**
   * Set the name of the browser
   * @param $browser The name of the Browser
   */
  public function setBrowser($browser) { return $this->_browser_name = $browser; }
  /**
   * The name of the platform.  All return types are from the class contants
   * @return string Name of the browser
   */
  public function getPlatform() { return $this->_platform; }
  /**
   * Set the name of the platform
   * @param $platform The name of the Platform
   */
  public function setPlatform($platform) { return $this->_platform = $platform; }
  /**
   * The version of the browser.
   * @return string Version of the browser (will only contain alpha-numeric characters and a period)
   */
  public function getVersion() { return $this->_version; }
  /**
   * Set the version of the browser
   * @param $version The version of the Browser
   */
  public function setVersion($version) { $this->_version = preg_replace('[^0-9,.,a-z,A-Z]','',$version); }
  /**
   * The version of AOL.
   * @return string Version of AOL (will only contain alpha-numeric characters and a period)
   */
  public function getAolVersion() { return $this->_aol_version; }
  /**
   * Set the version of AOL
   * @param $version The version of AOL
   */
  public function setAolVersion($version) { $this->_aol_version = preg_replace('[^0-9,.,a-z,A-Z]','',$version); }
  /**
   * Is the browser from AOL?
   * @return boolean True if the browser is from AOL otherwise false
   */
  public function isAol() { return $this->_is_aol; }
  /**
   * Is the browser from a mobile device?
   * @return boolean True if the browser is from a mobile device otherwise false
   */
  public function isMobile() { return $this->_is_mobile; }
  /**
   * Is the browser from a robot (ex Slurp,GoogleBot)?
   * @return boolean True if the browser is from a robot otherwise false
   */
  public function isRobot() { return $this->_is_robot; }
  /**
   * Set the browser to be from AOL
   * @param $isAol
   */
  public function setAol($isAol) { $this->_is_aol = $isAol; }
  /**
   * Get the user agent value in use to determine the browser
   * @return string The user agent from the HTTP header
   */
  public function getUserAgent() { return $this->_agent; }
  /**
   * Set the user agent value (the construction will use the HTTP header value - this will overwrite it)
   * @param $agent_string The value for the User Agent
   */
  public function setUserAgent($agent_string) {
   $this->reset();
   $this->_agent = $agent_string;
   $this->determine();
  }
        protected function setMobile($value=true) {
            $this->_is_mobile = $value;
        }
        protected function setRobot($value=true) {
            $this->_is_robot = $value;
        }
  /**
   * Protected routine to calculate and determine what the browser is in use (including platform)
   */
  protected function determine() {
   $this->checkPlatform();
   $this->checkBrowsers();
   $this->checkForAol();
  }

  /**
   * Protected routine to determine the browser type
   * @return boolean True if the browser was detected otherwise false
   */
  protected function checkBrowsers() {
   return (
      $this->checkBrowserGoogleBot() ||
      $this->checkBrowserSlurp() ||
      $this->checkBrowserInternetExplorer() ||
      $this->checkBrowserShiretoko() ||
      $this->checkBrowserIceCat() ||
      $this->checkBrowserNetscapeNavigator9Plus() ||
      $this->checkBrowserFirefox() ||
      $this->checkBrowserChrome() ||
                        $this->checkBrowserAndroid() ||
      $this->checkBrowserSafari() ||
      $this->checkBrowserOpera() ||
      $this->checkBrowserNetPositive() ||
      $this->checkBrowserFirebird() ||
      $this->checkBrowserGaleon() ||
      $this->checkBrowserKonqueror() ||
      $this->checkBrowserIcab() ||
      $this->checkBrowserOmniWeb() ||
      $this->checkBrowserPhoenix() ||
      $this->checkBrowserWebTv() ||
      $this->checkBrowserAmaya() ||
      $this->checkBrowserLynx() ||
      $this->checkBrowseriPhone() ||
      $this->checkBrowseriPod() ||
                        $this->checkBrowserBlackBerry() ||
      $this->checkBrowserW3CValidator() ||
      $this->checkBrowserMozilla() /* Mozilla is such an open standard that you must check it last */ 
      );
  }

  /**
   * Determine if the user is using a BlackBerry
   * @return boolean True if the browser is the BlackBerry browser otherwise false
   */
  protected function checkBrowserBlackBerry() {
   $retval = false;
   if( preg_match('/blackberry/i',$this->_agent) ) {
    $aresult = explode("/",stristr($this->_agent,"BlackBerry"));
    $aversion = explode(' ',$aresult[1]);
    $this->setVersion($aversion[0]);
    $this->_browser_name = self::BROWSER_BLACKBERRY;
    $this->setMobile();
    $retval = true;
   }
   return $retval;
  }

  /**
   * Determine if the user is using an AOL User Agent
   * @return boolean True if the browser is from AOL otherwise false
   */
  protected function checkForAol() {
   $retval = false;
   if( preg_match('/aol/i', $this->_agent) ) {
    $aversion = explode(' ',stristr($this->_agent, 'AOL'));
    $this->setAol(true);
    $this->setAolVersion(preg_replace('/[^0-9\.a-z]/i', '', $aversion[1]));
    $retval = true;
   }
   else {
    $this->setAol(false);
    $this->setAolVersion(self::VERSION_UNKNOWN);
    $retval = true;
   }
   return $retval;
  }
  
  /**
   * Determine if the browser is the GoogleBot or not
   * @return boolean True if the browser is the GoogletBot otherwise false
   */
  protected function checkBrowserGoogleBot() {
   $retval = false;
   if( preg_match('/googlebot/i',$this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'googlebot'));
    $aversion = explode(' ',$aresult[1]);
    $this->setVersion(str_replace(';','',$aversion[0]));
    $this->_browser_name = self::BROWSER_GOOGLEBOT;
                $this->setRobot();
    $retval = true;
   }
   return $retval;
  }
    
  /**
   * Determine if the browser is the W3C Validator or not
   * @return boolean True if the browser is the W3C Validator otherwise false
   */
  protected function checkBrowserW3CValidator() {
   $retval = false;
   if( preg_match('/W3C-checklink/i',$this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'W3C-checklink'));
    $aversion = explode(' ',$aresult[1]);
    $this->setVersion($aversion[0]);
    $this->_browser_name = self::BROWSER_W3CVALIDATOR;
    $retval = true;
   }
   return $retval;
  }
  
  /**
   * Determine if the browser is the W3C Validator or not
   * @return boolean True if the browser is the W3C Validator otherwise false
   */
  protected function checkBrowserSlurp() {
   $retval = false;
   if( preg_match('/Slurp/i',$this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'Slurp'));
    $aversion = explode(' ',$aresult[1]);
    $this->setVersion($aversion[0]);
    $this->_browser_name = self::BROWSER_SLURP;
                $this->setRobot();
    $retval = true;
   }
   return $retval;
  }
  
  /**
   * Determine if the browser is Internet Explorer or not
   * @return boolean True if the browser is Internet Explorer otherwise false
   */
  protected function checkBrowserInternetExplorer() {
   $retval = false;

   // Test for v1 - v1.5 IE
   if( preg_match('/microsoft internet explorer/i', $this->_agent) ) {
    $this->setBrowser(self::BROWSER_IE);
    $this->setVersion('1.0');
    $aresult = stristr($this->_agent, '/');
    if( preg_match('/308|425|426|474|0b1/i', $aresult) ) {
     $this->setVersion('1.5');
    }
    $retval = true;
   }
   // Test for versions > 1.5
   else if( preg_match('/msie/i',$this->_agent) && !preg_match('/opera/i',$this->_agent) ) {
    $aresult = explode(' ',stristr(str_replace(';','; ',$this->_agent),'msie'));
    $this->setBrowser( self::BROWSER_IE );
    $this->setVersion(str_replace(array('(',')',';'),'',$aresult[1]));
    $retval = true;
   }
   // Test for Pocket IE
   else if( preg_match('/mspie/i',$this->_agent) || preg_match('/pocket/i', $this->_agent) ) {
    $aresult = explode(' ',stristr($this->_agent,'mspie'));
    $this->setPlatform( self::PLATFORM_WINDOWS_CE );
    $this->setBrowser( self::BROWSER_POCKET_IE );
    $this->setMobile();
    
    if( preg_match('/mspie/i', $this->_agent) ) {
     $this->setVersion($aresult[1]);
    }
    else {
     $aversion = explode('/',$this->_agent);
     $this->setVersion($aversion[1]);
    }
    $retval = true;
   }
   return $retval;
  }
  
  /**
   * Determine if the browser is Opera or not
   * @return boolean True if the browser is Opera otherwise false
   */
  protected function checkBrowserOpera() {
   $retval = false;
   if( preg_match('/opera mini/i',$this->_agent) ) {
    $resultant = stristr($this->_agent, 'opera mini');
    if( preg_match('/\//',$resultant) ) {
     $aresult = explode('/',$resultant);
     $aversion = explode(' ',$aresult[1]); 
     $this->setVersion($aversion[0]);
     $this->_browser_name = self::BROWSER_OPERA_MINI;
     $this->setMobile();
                    $retval = true;
    }
    else {
     $aversion = explode(' ',stristr($resultant,'opera mini'));
     $this->setVersion($aversion[1]);
     $this->_browser_name = self::BROWSER_OPERA_MINI;
     $this->setMobile();
     $retval = true;
    }
   }
   else if( preg_match('/opera/i',$this->_agent) ) {
    $resultant = stristr($this->_agent, 'opera');
    if( preg_match('/Version\/(10.*)$/',$resultant,$matches) ) {
     $this->setVersion($matches[1]);
     $this->_browser_name = self::BROWSER_OPERA;
     $retval = true;
    }
    else if( preg_match('/\//',$resultant) ) {
     $aresult = explode('/',$resultant);
     $aversion = explode(' ',$aresult[1]); 
     $this->setVersion($aversion[0]);
     $this->_browser_name = self::BROWSER_OPERA;
     $retval = true;
    }
    else {
     $aversion = explode(' ',stristr($resultant,'opera'));
     $this->setVersion($aversion[1]);
     $this->_browser_name = self::BROWSER_OPERA;
     $retval = true;
    }
   }
   return $retval;
  }
  
  /**
   * Determine if the browser is WebTv or not
   * @return boolean True if the browser is WebTv otherwise false
   */
  protected function checkBrowserWebTv() {
   $retval = false;
   if( preg_match('/webtv/i',$this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'webtv'));
    $aversion = explode(' ',$aresult[1]);
    $this->setVersion($aversion[0]);
    $this->_browser_name = self::BROWSER_WEBTV;
    $retval = true;
   }
   return $retval;
  }
    
  /**
   * Determine if the browser is NetPositive or not
   * @return boolean True if the browser is NetPositive otherwise false
   */
  protected function checkBrowserNetPositive() {
   $retval = false;
   if( preg_match('/NetPositive/i',$this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'NetPositive'));
    $aversion = explode(' ',$aresult[1]);
    $this->setVersion(str_replace(array('(',')',';'),'',$aversion[0]));
    $this->_browser_name = self::BROWSER_NETPOSITIVE;
    $this->_platform = self::PLATFORM_BEOS;
    $retval = true;
   }
   return $retval;
  }
   
  /**
   * Determine if the browser is Galeon or not
   * @return boolean True if the browser is Galeon otherwise false
   */
  protected function checkBrowserGaleon() {
   $retval = false;
   if( preg_match('/galeon/i',$this->_agent) ) {
    $aresult = explode(' ',stristr($this->_agent,'galeon'));
    $aversion = explode('/',$aresult[0]);
    $this->setVersion($aversion[1]);
    $this->setBrowser(self::BROWSER_GALEON);
    $retval = true;
   }
   return $retval;
  }
   
  /**
   * Determine if the browser is Konqueror or not
   * @return boolean True if the browser is Konqueror otherwise false
   */
  protected function checkBrowserKonqueror() {
   $retval = false;
   if( preg_match('/Konqueror/i',$this->_agent) ) {
    $aresult = explode(' ',stristr($this->_agent,'Konqueror'));
    $aversion = explode('/',$aresult[0]);
    $this->setVersion($aversion[1]);
    $this->setBrowser(self::BROWSER_KONQUEROR);
    $retval = true;
   }
   return $retval;
  }
   
  /**
   * Determine if the browser is iCab or not
   * @return boolean True if the browser is iCab otherwise false
   */
  protected function checkBrowserIcab() {
   $retval = false;
   if( preg_match('/icab/i',$this->_agent) ) {
    $aversion = explode(' ',stristr(str_replace('/',' ',$this->_agent),'icab'));
    $this->setVersion($aversion[1]);
    $this->setBrowser(self::BROWSER_ICAB);
    $retval = true;
   }
   return $retval;
  }
   
  /**
   * Determine if the browser is OmniWeb or not
   * @return boolean True if the browser is OmniWeb otherwise false
   */
  protected function checkBrowserOmniWeb() {
   $retval = false;
   if( preg_match('/omniweb/i',$this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'omniweb'));
    $aversion = explode(' ',$aresult[1]);
    $this->setVersion($aversion[0]);
    $this->setBrowser(self::BROWSER_OMNIWEB);
    $retval = true;
   }
   return $retval;
  }
   
  /**
   * Determine if the browser is Phoenix or not
   * @return boolean True if the browser is Phoenix otherwise false
   */
  protected function checkBrowserPhoenix() {
   $retval = false;
   if( preg_match('/Phoenix/i',$this->_agent) ) {
    $aversion = explode('/',stristr($this->_agent,'Phoenix'));
    $this->setVersion($aversion[1]);
    $this->setBrowser(self::BROWSER_PHOENIX);
    $retval = true;
   }
   return $retval;
  }
  
  /**
   * Determine if the browser is Firebird or not
   * @return boolean True if the browser is Firebird otherwise false
   */
  protected function checkBrowserFirebird() {
   $retval = false;
   if( preg_match('/Firebird/i',$this->_agent) ) {
    $aversion = explode('/',stristr($this->_agent,'Firebird'));
    $this->setVersion($aversion[1]);
    $this->setBrowser(self::BROWSER_FIREBIRD);
    $retval = true;
   }
   return $retval;
  }
  
  /**
   * Determine if the browser is Netscape Navigator 9+ or not (http://browser.netscape.com/ - Official support ended on March 1st, 2008)
   * @return boolean True if the browser is Netscape Navigator 9+ otherwise false
   */
  protected function checkBrowserNetscapeNavigator9Plus() {
   $retval = false;
   if( preg_match('/Firefox/i',$this->_agent) && preg_match('/Navigator\/([^ ]*)/i',$this->_agent,$matches) ) {
    $this->setVersion($matches[1]);
    $this->setBrowser(self::BROWSER_NETSCAPE_NAVIGATOR);
    $retval = true;
   }
   return $retval;
  }
  
  /**
   * Determine if the browser is Shiretoko or not (https://wiki.mozilla.org/Projects/shiretoko)
   * @return boolean True if the browser is Shiretoko otherwise false
   */
  protected function checkBrowserShiretoko() {
   $retval = false;
   if( preg_match('/Mozilla/i',$this->_agent) && preg_match('/Shiretoko\/([^ ]*)/i',$this->_agent,$matches) ) {
    $this->setVersion($matches[1]);
    $this->setBrowser(self::BROWSER_SHIRETOKO);
    $retval = true;
   }
   return $retval;
  }
  
  /**
   * Determine if the browser is Ice Cat or not (http://en.wikipedia.org/wiki/GNU_IceCat)
   * @return boolean True if the browser is Ice Cat otherwise false
   */
  protected function checkBrowserIceCat() {
   $retval = false;
   if( preg_match('/Mozilla/i',$this->_agent) && preg_match('/IceCat\/([^ ]*)/i',$this->_agent,$matches) ) {
    $this->setVersion($matches[1]);
    $this->setBrowser(self::BROWSER_ICECAT);
    $retval = true;
   }
   return $retval;
  }
  
  /**
   * Determine if the browser is Firefox or not
   * @return boolean True if the browser is Firefox otherwise false
   */
  protected function checkBrowserFirefox() {
   $retval = false;
   if( preg_match('/Firefox/i',$this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'Firefox'));
    $aversion = explode(' ',$aresult[1]);
    $this->setVersion($aversion[0]);
    $this->setBrowser(self::BROWSER_FIREFOX);
    $retval = true;
   }
   return $retval;
  }
  
  /**
   * Determine if the browser is Mozilla or not
   * @return boolean True if the browser is Mozilla otherwise false
   */
  protected function checkBrowserMozilla() {
   $retval = false;
   if( preg_match('/mozilla/i',$this->_agent) && preg_match('/rv:[0-9].[0-9][a-b]?/i',$this->_agent) && !preg_match('/netscape/i',$this->_agent)) {
    $aversion = explode(' ',stristr($this->_agent,'rv:'));
    preg_match('/rv:[0-9].[0-9][a-b]?/i',$this->_agent,$aversion);
    $this->setVersion(str_replace('rv:','',$aversion[0]));
    $this->setBrowser(self::BROWSER_MOZILLA);
    $retval = true;
   }
   else if( preg_match('/mozilla/i',$this->_agent) && preg_match('/rv:[0-9]\.[0-9]/i',$this->_agent) && !preg_match('/netscape/i',$this->_agent) ) {
    $aversion = explode('',stristr($this->_agent,'rv:'));
             preg_match('/rv:[0-9]\.[0-9]\.[0-9]/i',$this->_agent,$aversion);
             echo 
    $this->setVersion(str_replace('rv:','',$aversion[0]));
    $this->setBrowser(self::BROWSER_MOZILLA);
    $retval = true;
   }
   return $retval;
  }

  /**
   * Determine if the browser is Lynx or not
   * @return boolean True if the browser is Lynx otherwise false
   */
  protected function checkBrowserLynx() {
   $retval = false;
   if( preg_match('/libwww/i',$this->_agent) && preg_match('/lynx/i', $this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'Lynx'));
    $aversion = explode(' ',$aresult[1]);
    $this->setVersion($aversion[0]);
    $this->setBrowser(self::BROWSER_LYNX);
    $retval = true;
   }
   return $retval;
  }
   
  /**
   * Determine if the browser is Amaya or not
   * @return boolean True if the browser is Amaya otherwise false
   */
  protected function checkBrowserAmaya() {
   $retval = false;
   if( preg_match('/libwww/i',$this->_agent) && preg_match('/amaya/i', $this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'Amaya'));
    $aversion = explode(' ',$aresult[1]);
    $this->setVersion($aversion[0]);
    $this->setBrowser(self::BROWSER_AMAYA);
    $retval = true;
   }
   return $retval;
  }
   
  /**
   * Determine if the browser is Chrome or not
   * @return boolean True if the browser is Chrome otherwise false
   */
  protected function checkBrowserChrome() {
   $retval = false;
   if( preg_match('/Chrome/i',$this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'Chrome'));
    $aversion = explode(' ',$aresult[1]);
    $this->setVersion($aversion[0]);
    $this->setBrowser(self::BROWSER_CHROME);
    $retval = true;
   }
   return $retval;
  }  
  
  /**
   * Determine if the browser is Safari or not
   * @return boolean True if the browser is Safari otherwise false
   */
  protected function checkBrowserSafari() {
   $retval = false;
   if( preg_match('/Safari/i',$this->_agent) && ! preg_match('/iPhone/i',$this->_agent) && ! preg_match('/iPod/i',$this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'Version'));
    if( isset($aresult[1]) ) {
     $aversion = explode(' ',$aresult[1]);
     $this->setVersion($aversion[0]);
    }
    else {
     $this->setVersion(self::VERSION_UNKNOWN);
    }
    $this->setBrowser(self::BROWSER_SAFARI);
    $retval = true;
   }
   return $retval;
  }  
  
  /**
   * Determine if the browser is iPhone or not
   * @return boolean True if the browser is iPhone otherwise false
   */
  protected function checkBrowseriPhone() {
   $retval = false;
   if( preg_match('/iPhone/i',$this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'Version'));
    if( isset($aresult[1]) ) {
     $aversion = explode(' ',$aresult[1]);
     $this->setVersion($aversion[0]);
    }
    else {
     $this->setVersion(self::VERSION_UNKNOWN);
    }
    $this->setMobile();
    $this->setBrowser(self::BROWSER_IPHONE);
    $retval = true;
   }
   return $retval;
  }  

  /**
   * Determine if the browser is iPod or not
   * @return boolean True if the browser is iPod otherwise false
   */
  protected function checkBrowseriPod() {
   $retval = false;
   if( preg_match('/iPod/i',$this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'Version'));
    if( isset($aresult[1]) ) {
     $aversion = explode(' ',$aresult[1]);
     $this->setVersion($aversion[0]);
    }
    else {
     $this->setVersion(self::VERSION_UNKNOWN);
    }
    $this->setMobile();
    $this->setBrowser(self::BROWSER_IPOD);
    $retval = true;
   }
   return $retval;
  }  

  /**
   * Determine if the browser is Android or not
   * @return boolean True if the browser is Android otherwise false
   */
  protected function checkBrowserAndroid() {
   $retval = false;
   if( preg_match('/Android/i',$this->_agent) ) {
    $aresult = explode('/',stristr($this->_agent,'Version'));
    if( isset($aresult[1]) ) {
     $aversion = explode(' ',$aresult[1]);
     $this->setVersion($aversion[0]);
    }
    else {
     $this->setVersion(self::VERSION_UNKNOWN);
    }
    $this->setMobile();
    $this->setBrowser(self::BROWSER_ANDROID);
    $retval = true;
   }
   return $retval;
  }  

  /**
   * Determine the user's platform
   */
  protected function checkPlatform() {
   if( preg_match('/iPhone/i', $this->_agent) ) {
    $this->_platform = self::PLATFORM_IPHONE;
   }
   else if( preg_match('/iPod/i', $this->_agent) ) {
    $this->_platform = self::PLATFORM_IPOD;
   }
   else if( preg_match('/BlackBerry/i', $this->_agent) ) {
    $this->_platform = self::PLATFORM_BLACKBERRY;
   }
   else if( preg_match('/win/i', $this->_agent) ) {
    $this->_platform = self::PLATFORM_WINDOWS;
   }
   elseif( preg_match('/mac/i', $this->_agent) ) {
    $this->_platform = self::PLATFORM_APPLE;
   }
   elseif( preg_match('/linux/i', $this->_agent) ) {
    $this->_platform = self::PLATFORM_LINUX;
   }
   elseif( preg_match('/OS\/2/i', $this->_agent) ) {
    $this->_platform = self::PLATFORM_OS2;
   }
   elseif( preg_match('/BeOS/i', $this->_agent) ) {
    $this->_platform = self::PLATFORM_BEOS;
   }
  }
 }
?>