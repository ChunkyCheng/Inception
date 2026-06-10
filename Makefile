DIR				= --project-directory srcs
ENV				= --env-file ./.env
PASV_ADDRESS	= $(shell ip route get 1 | awk '{print $$7; exit}')
COMPOSE 		= PASV_ADDRESS=$(PASV_ADDRESS) docker compose $(DIR) $(ENV)

VOLUME_DIR	= /home/${USER}/data
VOLUMES		= $(VOLUME_DIR)/wp_data $(VOLUME_DIR)/db_data $(VOLUME_DIR)/bonus/portainer_data

SERVICES	:= nginx wordpress mariadb redis vsftpd adminer portainer


## Build images
all:
	@$(COMPOSE) build

## Run containers detached
up:
	@mkdir -p $(VOLUMES)
	@$(COMPOSE) up -d

## Run containers attached
attach:	
	@mkdir -p $(VOLUMES)
	@$(COMPOSE) up

## Stop and removes containers
down:
	@$(COMPOSE) down

## View container logs and attach
logs:
	@if [ $$($(COMPOSE) ls | wc -l) -eq 1 ]; then \
		echo "No services running"; \
	else \
		$(COMPOSE) logs; \
		make -s attach; \
	fi;

## Enter a running container with sh
shell-:
	@printf 'Usage: make shell-<%s>\n' "$(shell echo $(SERVICES) | tr ' ' '|')"
define SHELL_TEMPLATE
shell-$(1):
	@if ! $(COMPOSE) exec $(1) sh; then \
		exit; \
	fi;
endef
$(foreach service,$(SERVICES),$(eval $(call SHELL_TEMPLATE,$(service))))

## Remove volumes
clean:
	@$(COMPOSE) down -v
	@sudo chown -R ${USER}:${USER} $(VOLUME_DIR)
	@rm -rf $(VOLUME_DIR)

## Remove volumes and images
fclean:	
	@$(COMPOSE) down --rmi all -v
	@sudo chown -R ${USER}:${USER} $(VOLUME_DIR)
	@rm -rf $(VOLUME_DIR)

## Remove volumes and images then rebuild
re: fclean all

## Show this help
help:
	@awk '/^## /{desc=substr($$0,4); next} \
	/^[a-zA-Z_-]+:/{split($$1,a,":"); if(desc) \
	printf "  \033[36m%-20s\033[0m %s\n", a[1], desc; desc=""}' $(MAKEFILE_LIST)


