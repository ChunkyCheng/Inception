# User Documentation

## Services

This stack provides the following services:

| Service | URL | Description |
|---------|-----|-------------|
| **WordPress** | `https://yourdomain` | The main website |
| **WordPress Admin** | `https://yourdomain/wp-admin` | Content management panel |
| **Adminer** | `https://adminer.yourdomain` | Database management UI |
| **Portainer** | `https://portainer.yourdomain` | Docker container management UI |
| **Static Site** | `https://static.yourdomain` | Service dashboard and links |
| **FTP** | `ftp://yourdomain:21` | Direct filesystem access to WordPress files |

> All web services use HTTPS. Your browser may warn about a self-signed certificate — this is expected. Proceed past the warning.

---

## Starting and Stopping

**Start all services:**
```sh
make up
```

**Stop all services:**
```sh
make down
```

**View logs:**
```sh
make logs
```

---

## Accessing the Website

Open your browser and navigate to `https://yourdomain`.

To access the WordPress administration panel, go to `https://yourdomain/wp-admin` and log in with your admin credentials.

To manage the database directly, open Adminer at `https://adminer.yourdomain`. It will log you in automatically using the configured database credentials.

To manage Docker containers, open Portainer at `https://portainer.yourdomain` and log in with your Portainer admin credentials.

---

## Credentials

All credentials are stored as plain text files in the `secrets/` directory at the root of the project:

| File | Used for |
|------|----------|
| `secrets/wp_admin_password.txt` | WordPress admin login |
| `secrets/wp_user_password.txt` | WordPress subscriber login |
| `secrets/db_password.txt` | MariaDB database password |
| `secrets/vsftpd_password.txt` | FTP login |
| `secrets/portainer_password.txt` | Portainer admin login |

Environment variables such as usernames, domain name, and database name are configured in `srcs/.env`.

---

## Checking Services

**Check all containers are running:**
```sh
docker ps
```

All containers should show a status of `Up`. If any show `Restarting` or `Exited`, check the logs:

```sh
make logs
```

**Open a shell inside a specific container:**
```sh
make shell-nginx
make shell-wordpress
make shell-mariadb
make shell-redis
make shell-adminer
make shell-vsftpd
make shell-portainer
make shell-pythonhttp
```

**Check Redis is caching:**
```sh
make shell-redis
redis-cli ping
```

Should return `PONG`.
