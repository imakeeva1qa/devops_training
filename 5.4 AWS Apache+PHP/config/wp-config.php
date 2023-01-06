<?php
define( 'DB_NAME', 'wordpress' );
define( 'DB_USER', 'wordpress' );
define( 'DB_PASSWORD', 'Wordpress-1234' );
define( 'DB_HOST', 'localhost' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 */
define('AUTH_KEY',         '|hd1;XaLHAQagF7`R%bA0I14Dm )R:-fI&RTa tI3oW,prx(pqfaa5sgIU)$=7.F');
define('SECURE_AUTH_KEY',  '0Y%^b>|:BYEj78}t0qGa2:,|:XpAD[Nux/-HLTwFG8d~+8.wylc=&7{N.n*4bITL');
define('LOGGED_IN_KEY',    'h8gGh|c;OT.ga~8fg-G~zSTH -I6H%/-&D9havj=7ck_Sl`:}D9B9#N2iTnGuiX6');
define('NONCE_KEY',        '=|(D{2LtjvbNEj|H$=tePjO%NHJZ$KluWHYT71Svj|<zU#jnH>9XP1O*UOQh:b4(');
define('AUTH_SALT',        'BuStT*=wLNJi[eDNllt]4|+ix!,x?WJLnk0^60ndrEt,YA-y8^FYc|5Ke/n<!w;N');
define('SECURE_AUTH_SALT', '(xlldiRzF|$XY|@*B3+2G7:C4ib(FIB=R?GfBG0c&.5u$J& Y*2G4k~re^~lHB2a');
define('LOGGED_IN_SALT',   'YZ*lGv|Du``mhmSDqA)joBorf>&QmI@-~W`wtEDw}(mpB(yFrW(1$*.gN/<P^48(');
define('NONCE_SALT',       '`NnfalZ*-dprL:41__T585>VE:Nb`t-6Q8+{,H|X{qPx=#m,S|ij?|y+^1@3]F3m');

/**#@-*/
$table_prefix = 'wp_';

define( 'WP_DEBUG', false );
define('FS_METHOD', 'direct');

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
