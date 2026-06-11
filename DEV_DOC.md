# Developer Documentation

## Prerequisites

- Docker and Docker Compose installed
- `make` available
- `openssl` available for generating TLS certificates
- Port 443, 21, and 21000-21010 available on the host

---

## Environment Setup

### 1. Clone the repository

```sh
git clone <repo_url>
cd inception
```

### 2. Configure environment variables

```sh
cp srcs/.env.example srcs/.env
```

Edit `srcs/.env` and fill in all required values:

```sh
DB_NAME = "insert_name"
DB_ADMIN = "insert_name"

# Ensure WP_ADMIN_USER, WP_USER, WP_ADMIN_MAIL and WP_USER_MAIL are all unique

WP_DOMAIN = "insert_domain"
WP_TITLE = "insert_tile"
WP_ADMIN_USER = "insert_name"
WP_ADMIN_MAIL = "insert_email"

WP_USER = "insert_name"
WP_USER_MAIL = "insert_email"

VSFTPD_USER = "insert_name"
```

### 3. Create secrets

Create the `secrets/` directory and populate it:

```sh
mkdir -p secrets

echo "yourdbpassword"        > secrets/db_password.txt
echo "yourftppassword"       > secrets/vsftpd_password.txt
echo "yourwpuserpassword"    > secrets/wp_user_password.txt
echo "yourwpadminpassword"   > secrets/wp_admin_password.txt
echo "yourportainerpassword" > secrets/portainer_password.txt
```

Generate a self-signed TLS certificate:

```sh
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout secrets/tls_key.pem \
  -out secrets/tls_cert.pem
```

### 4. Configure local DNS

Add your domain and subdomains to `/etc/hosts`:

```sh
yourdomain
static.yourdomain
adminer.yourdomain
portainer.yourdomain
```

---

## Building and Running

**Build all images:**
```sh
make all
```

**Build and start all containers detached:**
```sh
make up
```

**Build and start attached (see live logs):**
```sh
make attach
```

**Stop and remove containers:**
```sh
make down
```

**Full rebuild from scratch:**
```sh
make re
```

---

## Managing Containers and Volumes

**View all running containers:**
```sh
docker ps
```

**View logs:**
```sh
make logs
```

**Open a shell inside a container:**
```sh
make shell-<service>
```

Available services: `nginx`, `wordpress`, `mariadb`, `redis`, `vsftpd`, `pythonhttp`, `adminer`, `portainer`

For example:
```sh
make shell-wordpress
make shell-mariadb
```

**Remove containers and volumes:**
```sh
make clean
```

**Remove containers, volumes, and all images:**
```sh
make fclean
```

---

## Data Persistence

All persistent data is stored in named Docker volumes, backed by directories on the host at `/home/$USER/data/`:

| Volume | Host path | Contents |
|--------|-----------|----------|
| `wp_data` | `/home/$USER/data/wp_data` | WordPress files, themes, plugins, uploads |
| `db_data` | `/home/$USER/data/db_data` | MariaDB database files |
| `portainer_data` | `/home/$USER/data/bonus/portainer_data` | Portainer configuration and users |

These directories are created automatically by `make up` if they don't exist.

To wipe all data and start fresh:
```sh
make fclean
make up
```

> `make clean` and `make fclean` both remove the volume directories. WordPress and the database will be fully reinstalled on the next `make up`.

---

## Notes

- The FTP passive address is detected automatically from the host machine at startup via `ip route get 1` in the Makefile. No manual configuration is needed.
- All passwords are read from `/run/secrets/` inside containers at runtime — they are never baked into images.