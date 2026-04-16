<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'wpuser');
define('DB_PASSWORD', 'Passw0rd');
define('DB_HOST', 'pg1');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

$table_prefix = 'wp_';

define('AUTH_KEY',         'lab-auth-key-123');
define('SECURE_AUTH_KEY',  'lab-secure-auth-key-123');
define('LOGGED_IN_KEY',    'lab-logged-in-key-123');
define('NONCE_KEY',        'lab-nonce-key-123');
define('AUTH_SALT',        'lab-auth-salt-123');
define('SECURE_AUTH_SALT', 'lab-secure-auth-salt-123');
define('LOGGED_IN_SALT',   'lab-logged-in-salt-123');
define('NONCE_SALT',       'lab-nonce-salt-123');

define('WP_DEBUG', false);

if ( ! defined('ABSPATH') ) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
