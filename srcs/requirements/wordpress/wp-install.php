<?php
define('WP_INSTALLING', true);
$_SERVER['HTTP_HOST'] = 'jchuah.42.fr';
$_SERVER['REQUEST_URI'] = '/';
require '/var/www/html/wp-load.php';
require '/var/www/html/wp-admin/includes/upgrade.php';

wp_install(
    getenv('WORDPRESS_TITLE'),
    getenv('WORDPRESS_ADMIN_USER'),
    getenv('WORDPRESS_ADMIN_EMAIL'),
    true,
    '',
    trim(file_get_contents('/run/secrets/wp_admin_password'))
);

$user_id = wp_create_user(
    getenv('WORDPRESS_USER'),
    trim(file_get_contents('/run/secrets/wp_user_password')),
    getenv('WORDPRESS_USER_EMAIL')
);

$user = new WP_User($user_id);
$user->set_role('editor');
