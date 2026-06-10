<?php
$host = getenv('WORDPRESS_DB_HOST');
$user = getenv('WORDPRESS_DB_USER');
$pass = trim(file_get_contents('/run/secrets/db_password'));
$name = getenv('WORDPRESS_DB_NAME');

try {
    $c = new mysqli($host, $user, $pass, $name);
    $r = $c->query('SHOW TABLES LIKE "wp_users"');
    exit($r && $r->num_rows > 0 ? 0 : 1);
} catch (Exception $e) {
    exit(1);
}
