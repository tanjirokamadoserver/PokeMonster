#!/bin/bash


CAMINHO="" 
NOMEBACKUP="" 
USER=""  
SENHA="" 
BANCO="" 


#Nao mexer daqui pra baixo
TEMPO="$(date +'%d-%m-%Y-%H-%M')"
#####
#Rodando o backup
#####

mysqldump -u$USER -p$SENHA $BANCO > $CAMINHO"/"$NOMEBACKUP"-"$TEMPO".sql"
