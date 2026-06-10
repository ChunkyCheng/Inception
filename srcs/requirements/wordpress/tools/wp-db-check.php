<?php
$host = getenv('WORDPRESS_DB_HOST');
$user = getenv('WORDPRESS_DB_USER');
$pass = trim(file_get_contents('/run/secrets/db_password'));
$name = getenv('WORDPRESS_DB_NAME');

try {
    $c = new mysqli($host, $user, $pass, $name);
    exit(0);
} catch (Exception $e) {
    exit(1);
}
