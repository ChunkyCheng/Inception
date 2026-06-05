DIR		= --project-directory srcs
COMPOSE = docker compose $(DIR)

all: up

up:
	@$(COMPOSE) up -d

down:
	@$(COMPOSE) down

build:
	@$(COMPOSE) build

fclean:
	@$(COMPOSE) down --rmi all -v
