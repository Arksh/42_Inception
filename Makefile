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
COMPOSE = sudo docker compose
DOCKER = sudo docker
WEB_VOLUME = web
DB_VOLUME = database

# RULES #
all: build

build: add_volumes
# 	@echo $(CURSIVE)$(GRAY)"- Building Inception project..." $(NC)
	$(COMPOSE) -f $(DCF) build

up: add_host
	$(COMPOSE) -f $(DCF) up -d

mup: 
	$(COMPOSE) -f $(DCF) up -d mariadb

wup: 
	$(COMPOSE) -f $(DCF) up -d wordpress

nup: 
	$(COMPOSE) -f $(DCF) up -d nginx

down: remove_host
	$(COMPOSE) -f $(DCF) down -v

clean: down rm_volumes
	@echo $(CURSIVE)$(GRAY)"- Removing incption files..." $(NC)
	$(COMPOSE) -f $(DCF) down -v
	$(DOCKER) system prune -a -f
	@echo $(CURSIVE)&(GRAY) "- Inception removed successfully"

fclean: clean
	@echo $(CURSIVE)$(GRAY)"- Removing Inception..." $(NC)
	$(COMPOSE) -f $(DCF) down --rmi all --volumes --remove-orphans
	@echo "Project Inception"$(GREEN)"cleaned\n"$(NC)

ps:
	$(DOCKER) ps

logs:
	$(COMPOSE) logs

n_logs:
	$(DOCKER) logs nginx
w_logs:
	$(DOCKER) logs wp-php
m_logs:
	$(DOCKER) logs mariadb

exec-n:
	$(DOCKER) exec -it nginx bash
exec-m:
	$(DOCKER) exec -it mariadb bash
exec-w:
	$(DOCKER) exec -it wp-php bash

add_volumes:
	@mkdir -p ./srcs/data/$(WEB_VOLUME)
	@mkdir -p ./srcs/data/$(DB_VOLUME)
rm_volumes:
	@sudo rm -rf ./srcs/data

add_host:
	@echo "Adding host to /etc/hosts..."
	@grep -qxF "127.0.0.1 $(DOMAIN)" etc/hosts || echo "127.0.0.1 $(DOMAIN)" | sudo tee -a etc/hosts

remove_host:
	@echo "Removing host from /etc/hosts..."
	@sudo sed -i "/127.0.0.1 $(DOMAIN)/d" etc/hosts

re: fclean all

PHONY.: all clean fclean re up 