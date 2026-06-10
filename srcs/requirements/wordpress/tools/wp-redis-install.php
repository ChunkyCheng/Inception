<?php
define('ABSPATH', '/var/www/html/');

require_once('/var/www/html/wp-load.php');

$plugin = 'redis-cache/redis-cache.php';
$plugin_dir = WP_CONTENT_DIR . '/plugins/redis-cache';

if (!is_plugin_active($plugin)) {
    echo "Activating Redis Object Cache...\n";
    $result = activate_plugin($plugin);
    if (is_wp_error($result)) {
        echo "Activation failed: " . $result->get_error_message() . "\n";
        exit(1);
    }
    echo "Plugin activated.\n";
}

// Enable object cache drop-in
$dropin_src = $plugin_dir . '/includes/object-cache.php';
$dropin_dst = WP_CONTENT_DIR . '/object-cache.php';

if (!file_exists($dropin_dst)) {
    echo "Enabling object cache drop-in...\n";
    copy($dropin_src, $dropin_dst);
    echo "Drop-in enabled.\n";
}
