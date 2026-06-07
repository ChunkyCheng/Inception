DIR		= --project-directory srcs
ENV		= --env-file ./.env
COMPOSE = docker compose $(DIR) $(ENV)

VOLUME_DIR = /home/${USER}/data

all:
	@mkdir -p $(VOLUME_DIR)/wp_data
	@mkdir -p $(VOLUME_DIR)/db_data
	@$(COMPOSE) up -d --build

up:
	@mkdir -p $(VOLUME_DIR)/wp_data
	@mkdir -p $(VOLUME_DIR)/db_data
	@$(COMPOSE) up -d

attach:
	@mkdir -p $(VOLUME_DIR)/wp_data
	@mkdir -p $(VOLUME_DIR)/db_data
	@$(COMPOSE) up

down:
	@$(COMPOSE) down

build:
	@$(COMPOSE) build

logs:
	@$(COMPOSE) logs

clean:
	@$(COMPOSE) down -v
	@sudo chown -R ${USER}:${USER} $(VOLUME_DIR)
	@rm -rf $(VOLUME_DIR)

fclean:
	@$(COMPOSE) down --rmi all -v
	@sudo chown -R ${USER}:${USER} $(VOLUME_DIR)
	@rm -rf $(VOLUME_DIR)
