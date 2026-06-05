DIR		= --project-directory srcs
COMPOSE = docker compose $(DIR)

VOLUME_DIR = /home/${USER}/data

all: up

up:
	@mkdir -p $(VOLUME_DIR)/wp_data
	@mkdir -p $(VOLUME_DIR)/db_data
	@$(COMPOSE) up -d

attach: up
	@$(COMPOSE) up

down:
	@$(COMPOSE) down

build:
	@$(COMPOSE) build

clean:
	@$(COMPOSE) down -v
	@sudo chown -R ${USER}:${USER} $(VOLUME_DIR)
	@rm -rf $(VOLUME_DIR)

fclean:
	@$(COMPOSE) down --rmi all -v
	@sudo chown -R ${USER}:${USER} $(VOLUME_DIR)
	@rm -rf $(VOLUME_DIR)
