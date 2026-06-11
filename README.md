# Inception

> _This project has been created as part of the 42 curriculum by jchuah_

## Description

The aim of Inception is to set up a simple WordPress website through a containerized system. It achieves this using Alpine-based Docker containers:

| Container | Role |
|-----------|------|
| **nginx** | Web server - handles HTTPS and routes requests |
| **wordpress** | PHP-FPM - generates HTML pages |
| **mariadb** | Database - stores WordPress content |
| **redis** | Cache - reduces database load |
| **vsftpd** | FTP server - direct filesystem access to WordPress |
| **pythonhttp** | Python http server - serves a static site |
| **adminer** | Database UI - browser-based database management |
| **portainer** | Docker UI - container management through the browser |

---

## Setup Instructions

### 1. Environment

Copy the example environment file and fill in your values:

```sh
cp srcs/.env.example srcs/.env
```

### 2. Secrets

Create a `secrets/` directory and populate it with the following files:

```
secrets/
├── db_password.txt
├── vsftpd_password.txt
├── wp_user_password.txt
├── wp_admin_password.txt
├── portainer_password.txt
├── tls_key.pem
└── tls_cert.pem
```

Each `.txt` file should contain only the password, with no trailing newline. The TLS certificate and key can be self-signed:

```sh
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout secrets/tls_key.pem \
  -out secrets/tls_cert.pem
```

### 3. Hosts

Add your domains to `/etc/hosts` so it resolves locally:

```sh
yourdomain
static.yourdomain
adminer.yourdomain
portainer.yourdomain
```

---

## Usage

| Command | Description |
|---------|-------------|
| `make up` | Build images and start all containers |
| `make down` | Stop and remove containers |
| `make help` | List all available make commands |

Once running, services are available at:

| Service | URL |
|---------|-----|
| WordPress | `https://yourdomain` |
| WordPress Admin | `https://yourdomain/wp-admin` |
| FTP | `ftp://yourlogin.42.fr:21` |
| Static Site | `https://static.yourdomain` |
| Adminer | `https://adminer.yourdomain` |
| Portainer | `https://portainer.yourdomain` |

---

## Resources

- [Docker Getting Started](https://docs.docker.com/get-started/)
- [WordPress Configuration](https://developer.wordpress.org/advanced-administration/wordpress/wp-config/)
- [MariaDB Documentation](https://mariadb.com/docs)
- [Nginx Beginner's Guide](https://nginx.org/en/docs/beginners_guide.html)

> AI was used to aid in coding all `.php` files as the language is new to me. It was also used in debugging and redundancy checks and for the html of my static site.

---

## Key Concepts

### Docker vs Virtual Machine

Docker packages applications and their dependencies in an isolated filesystem called a container. This differs from a virtual machine, which simulates hardware and runs an entire operating system. As a result, Docker containers start up much faster and use significantly less disk space and memory than virtual machines.

### Secrets vs Environment Variables

Environment variables exist within the container's environment and can be inspected by anyone with access to the container. Secrets are files mounted into the container as read-only at `/run/secrets/` and are only accessible by reading the file directly — they are never exposed in environment listings or `docker inspect` output.

### Docker Network vs Host Network

A Docker network is a virtual private network shared only between the containers you explicitly connect to it. Containers on the same network can reach each other by name, but are isolated from everything outside. A host network removes that isolation — the container shares the host machine's network interface directly, meaning it can reach anything the host can but loses the separation that makes containers secure. This project uses a dedicated Docker network so containers can communicate internally without being exposed to the outside.

### Docker Volume vs Bind Mounts

A Docker volume is a storage area managed entirely by Docker, stored in Docker's own directory on the host. A bind mount maps a specific path on the host filesystem directly into the container. Volumes are preferred for persistent application data because Docker manages their lifecycle, they work consistently across environments, and they aren't tied to a specific host path. Bind mounts are useful for development where you want to edit files on the host and have changes reflected immediately in the container. This project uses named volumes exclusively to keep data portable and host-independent.