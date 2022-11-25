<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wordpress' );

/** Database password */
define( 'DB_PASSWORD', 'Wordpress-1234' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '5dWpj9$#dJ1s]^;`,/V,j(xff-UwUV(Ff]h1I]B,izfR{NLU#|SG5`w+^|(zll2d');
define('SECURE_AUTH_KEY',  ']?z7y1N`:DTo[yXvixFJ<DR]zQy0N*F2-(7~|?OR6sm04r]X+)W_UFyA[<%hK94~');
define('LOGGED_IN_KEY',    'nlN+e|uIwoGA O=!Wk[xre.(Jy-AtazX+b~N>EV;n.2YnFuPJ([Mi/b*MtNtOWBz');
define('NONCE_KEY',        'M.GRB|e=.o8jwf^&LnoHT~.4ySxD*RL_I#1oi,}[z+Q|*8^ YxfkB/(;TqcPfGw@');
define('AUTH_SALT',        'VS-QcMQ8]5]>B9dnwd9`! sZT5h9,z(jb:&g9x7+i?[THH,-wUi:f]q?9(_%[+%C');
define('SECURE_AUTH_SALT', 'P(I+$]987,tM(E2-/+dx;b/yfs%S9+8:GrG%l(13l^#*x_ERX>ngm&#`+ay_sm~ ');
define('LOGGED_IN_SALT',   '<- m*$jieLaDN08Zl5-mxfDPKGgO9<}GL?BRH|@bOX/ UwgO9)*x}(5I<Hd48:!.');
define('NONCE_SALT',       'q0>B+;{Yizdr%VLp(}$tvl7}R=*j%!i[oE 34zULW1O=>CH!imz#8~9O/8}Pw=vG');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */

define('FS_METHOD', 'direct');

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
