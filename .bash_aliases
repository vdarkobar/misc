# DOCKER
alias dstopcont='sudo docker stop $(docker ps -a -q)'
alias dstopall='sudo docker stop $(sudo docker ps -aq)'
alias drmcont='sudo docker rm $(docker ps -a -q)'
alias dvolprune='sudo docker volume prune'
alias dsysprune='sudo docker system prune -a'
alias ddelimages='sudo docker rmi $(docker images -q)'
alias docerase='dstopcont ; drmcont ; ddelimages ; dvolprune ; dsysprune'
alias docprune='ddelimages ; dvolprune ; dsysprune'
alias dexec='sudo docker exec -ti'
alias docps='sudo docker ps -a'
alias dcrm='dcrun rm'
alias docdf='sudo docker system df'
alias dclogs='sudo docker logs -tf --tail="50" '
alias fixsecrets='sudo chown -R root:root /home/USER/docker/secrets ; sudo chmod -R 600 /home/USER/docker/secrets'

# STACK UP AND DOWN
alias 1down='cd /home/USER/docker ; dcdown1v ; dcdown1'
alias 1up='cd /home/USER/docker ; sudo docker network create t1_proxy ; dcrec1 plexms ; dcup1 ; dcup1v'
alias 2down='cd /home/USER/docker ; dcdown2v ; dcdown2'
alias 2up='cd /home/USER/docker ; sudo docker network create --gateway 192.168.91.1 --subnet 192.168.91.0/24 socket_proxy ; sudo docker network create --gateway 192.168.90.1 --subnet 192.168.90.0/24 t2_proxy ; dcrec2 plexms ; dcup2 ; dcup2v'

# DOCKER TRAEFIK 2
alias dcrun2='cd /home/USER/docker ; sudo docker-compose -f /home/USER/docker/docker-compose-t2.yml '
alias dclogs2='cd /home/USER/docker ; sudo docker-compose -f /home/USER/docker/docker-compose-t2.yml logs -tf --tail="50" '
alias dcup2='dcrun2 up -d'
alias dcdown2='dcrun2 down'
alias dcrec2='dcrun2 up -d --force-recreate'
alias dcstop2='dcrun2 stop'
alias dcrestart2='dcrun2 restart '
alias dcpull2='cd /home/USER/docker ; sudo docker-compose -f /home/USER/docker/docker-compose-t2.yml  pull'

# SHUTDOWN AND RESTART
alias shutdown='sudo shutdown -h now'
alias reboot='sudo reboot'

# NETWORKING
alias portsused='sudo netstat -tulpn | grep LISTEN'

# FILE SIZE AND STORAGE
alias free='free -h'
alias fdisk='sudo fdisk -l'
alias uuid='sudo vol_id -u'
alias ll='ls -alh'
alias dirsize='sudo du -hx --max-depth=1'
