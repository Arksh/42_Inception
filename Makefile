# Docker Inception Makefile

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cagonzal <cagonzal@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/12/14 12:13:17 by cagonzal          #+#    #+#              #
#    Updated: 2024/11/07 12:40:02 by cagonzal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# COLORS #
NC			=	'\033[0m'
GREEN		=	'\033[0;32m'
RED			=	'\033[0;91m'
BLUE		=	'\033[0;94m'
MAGENTA		=	'\033[0;95m'
CYAN		=	'\033[0;96m'
WHITE		=	'\033[0;97m'
LRED		=	'\033[1;31m'
LGREEN		=	'\033[1;32m'
YELLOW		=	'\033[1;33m'
LBLUE		=	'\033[1;34m'
GRAY		=	'\033[2;37m'
CURSIVE		=	'\033[3m'
TITLE		=	'\033[38;5;33m'

# VARIABLES #
SRC = srcs/
DCF = srcs/docker-compose.yml
ENV = srcs/.env
COMPOSE = docker compose
DOCKER = docker
DOMAIN = cagonzal.42.fr
WEB_VOLUME = web
DB_VOLUME = database

# RULES #
all: build up

build: add_volumes
	@echo $(CURSIVE)$(GRAY)"- Building Inception project..." $(NC)
	@$(COMPOSE) -f $(DCF) build

up: add_host
	@echo $(CURSIVE)$(GRAY)"- Starting Inception project..." $(NC)
	@$(COMPOSE) -f $(DCF) up -d

mup: 
	@echo $(CURSIVE)$(GRAY)"- Starting MariaDB server..." $(NC)
	@$(COMPOSE) -f $(DCF) up -d mariadb
wup: 
	@echo $(CURSIVE)$(GRAY)"- Starting WordPress server..." $(NC)
	@$(COMPOSE) -f $(DCF) up -d wordpress
nup: 
	@echo $(CURSIVE)$(GRAY)"- Starting Nginx server..." $(NC)
	@$(COMPOSE) -f $(DCF) up -d nginx

down: remove_host
	@echo $(CURSIVE)$(GRAY)"- Stopping Inception project..." $(NC)
	@$(COMPOSE) -f $(DCF) down -v

clean: down rm_volumes
	@echo $(CURSIVE)$(GRAY)"- Removing incption files..." $(NC)
	@$(COMPOSE) -f $(DCF) down -v
	@echo $(CURSIVE)$(GRAY) "- Inception removed successfully"

fclean: clean
	@echo $(CURSIVE)$(GRAY)"- Removing Inception..." $(NC)
	@$(COMPOSE) -f $(DCF) down --rmi all --volumes --remove-orphans
	@echo "Project Inception"$(GREEN)"cleaned\n"$(NC)

ps:
	@echo $(CURSIVE)$(GRAY)"- Listing Docker containers..." $(NC)
	@$(DOCKER) ps

logs:
	@echo $(CURSIVE)$(GRAY)"- Showing Docker logs..." $(NC)
	@$(COMPOSE) logs

n_logs:
	@echo $(CURSIVE)$(GRAY)"- Showing Nginx logs..." $(NC)
	@$(DOCKER) logs nginx
w_logs:
	@echo $(CURSIVE)$(GRAY)"- Showing WordPress logs..." $(NC)
	@$(DOCKER) logs wp-php
m_logs:
	@echo $(CURSIVE)$(GRAY)"- Showing MariaDB logs..." $(NC)
	@$(DOCKER) logs mariadb

exec-n:
	@echo $(CURSIVE)$(GRAY)"- Executing Nginx container bash..." $(NC)
	@$(DOCKER) exec -it nginx bash
exec-m:
	@echo $(CURSIVE)$(GRAY)"- Executing MariaDB container bash..." $(NC)
	@$(DOCKER) exec -it mariadb bash
exec-w:
	@echo $(CURSIVE)$(GRAY)"- Executing WordPress-PHP container bash..." $(NC)
	@$(DOCKER) exec -it wp-php bash

add_volumes:
	@echo $(CURSIVE)$(GRAY)"- Creating data volumes..." $(NC)
	@mkdir -p ./srcs/data/$(WEB_VOLUME)
	@mkdir -p ./srcs/data/$(DB_VOLUME)
rm_volumes:
	@echo $(CURSIVE)$(GRAY)"- Removing data volumes..." $(NC)
	@rm -rf ./srcs/data

add_host:
	@echo "Adding host to /etc/hosts..."
	@grep -qxF "127.0.0.1 cagonzal.42.fr" /etc/hosts || echo "127.0.0.1 cagonzal.42.fr" | sudo tee -a /etc/hosts

remove_host:
	@echo "Removing host from /etc/hosts..."
	@sudo sed -i "/127\.0\.0\.1[[:space:]]\+$(DOMAIN)/d" /etc/hosts

prune:
	@echo $(CURSIVE)$(GRAY)"- Pruning Docker system..." $(NC)
	@$(DOCKER) system prune -a -f
	@echo $(CURSIVE)$(GRAY)"- Docker system pruned successfully" $(NC)

re: fclean all

PHONY: all clean fclean re up build down ps logs n_logs w_logs m_logs exec-n exec-m exec-w add_volumes rm_volumes add_host remove_host prune mup wup nup