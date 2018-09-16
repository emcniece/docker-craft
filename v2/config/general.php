<?php
/**
 * General Configuration
 *
 * All of your system's general configuration settings go in here.
 * You can see a list of the default settings in craft/app/etc/config/defaults/general.php
 */
return array(
    'devMode' => false,
    'usePathInfo' => true,
    'omitScriptNameInUrls' => true,
    'allowAutoUpdates' => false,
    'addTrailingSlashesToUrls' => true,
    'maxUploadFileSize' => 2147483648, // 256MB
    'defaultImageQuality' => 75,
    'imageDriver' => 'imagick',
    'generateTransformsBeforePageLoad' => true,
    'sendPoweredByHeader' => false,
    'cacheMethod' => 'redis'
);
