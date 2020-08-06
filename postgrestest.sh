#!/bin/bash
#Script para gerar os dumps no diretório DIR
#O nome dos diretórios ficará da forma NomedainstanciaDATA

DATE=`date +%Y%m%d`     # Dia em que o script rodou

DIR="/home/user/pg_bkp"     #Volume em qual os dumps ficarão armazenados

if [ -d "$DIR" ]; then      #Confere se o diretório existe, caso não exista ele cria o diretório
  echo "O diretório existe, iniciando dump"
else 
  echo "Diretório não encontrado"
  echo "Criando diretório"
  mkdir /home/user/pg_bkp
fi

while read INSTANCE; do     #Lê as linhas do arquivo de texto com os nomes das instancias e armazena o dump
    echo $INSTANCE
    mkdir /home/user/pg_bkp/$INSTANCE$DATE
    pg_dump -Fc $INSTANCE > /home/user/pg_bkp/$INSTANCE$DATE
done < examples.txt

find /home/user/pg_bkp -type d -mtime +10 -delete #Encontra a pasta que contêm os dumps mais velhos do que 10 dias e os retira