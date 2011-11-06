CREATE TABLE IF NOT EXISTS `comments` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`pageID` int(11) NOT NULL,
	`author` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
	`authorEmail` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
	`authorURL` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
	`content` text COLLATE utf8_unicode_ci NOT NULL,
	`ip` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
	`published` datetime NOT NULL,
	PRIMARY KEY (`id`),
	KEY `pageID` (`pageID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=0;

CREATE TABLE IF NOT EXISTS `pages` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`slug` varchar(55) COLLATE utf8_unicode_ci NOT NULL,
	`revision` int(4) NOT NULL DEFAULT '1',
	`browserscopeID` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
	`title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
	`info` text COLLATE utf8_unicode_ci NOT NULL,
	`setup` text COLLATE utf8_unicode_ci NOT NULL,
	`teardown` text COLLATE utf8_unicode_ci NOT NULL,
	`initHTML` text COLLATE utf8_unicode_ci NOT NULL,
	`visible` enum('y','n') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'y',
	`author` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
	`authorEmail` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
	`authorURL` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
	`hits` bigint(20) NOT NULL,
	`published` datetime NOT NULL,
	`updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `browserscopeID` (`browserscopeID`),
	KEY `slugRev` (`slug`,`revision`),
	KEY `updated` (`updated`),
	KEY `author` (`author`),
	KEY `visible` (`visible`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=0;

CREATE TABLE IF NOT EXISTS `tests` (
	`testID` int(11) NOT NULL AUTO_INCREMENT,
	`pageID` int(11) NOT NULL,
	`title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
	`code` text COLLATE utf8_unicode_ci NOT NULL,
	`defer` enum('y','n') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'n',
	PRIMARY KEY (`testID`),
	KEY `pageID` (`pageID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=0;
