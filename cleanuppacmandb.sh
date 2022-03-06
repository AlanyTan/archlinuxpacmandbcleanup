#!/bin/bash
DEBUG=false
PACMAN_DB_PATH=/var/lib/pacman/local
PACMAN_DB_BACKUP_PATH=${PACMAN_DB_PATH}.OLD

if [ ! -d $PACMAN_DB_BACKUP_PATH ]; then
        mkdir $PACMAN_DB_BACKUP_PATH
fi

shopt -s extglob

find ${PACMAN_DB_PATH}/* -type d | while read FN
do
        FILE_BASE=${FN%%*([-.0-9])}
        $DEBUG && echo "=checking [$FN], will look for duplicates look like [$FILE_BASE]."
        ALREADY_EXIST=false
        ls -dt ${FILE_BASE}*([0-9.-]) | while read NAMESAKE
        do
                $DEBUG && echo "==looking for [$FILE_BASE], found [$NAMESAKE], namesake already exist: [$ALREADY_EXIST]."
                if [ $ALREADY_EXIST = true ]; then
                        $DEBUG && echo "---when looking for [$FILE_BASE], found duplicate [$NAMESAKE], deleting"
                        echo "move [$NAMESAKE] to backup dir."
                        mv $NAMESAKE $PACMAN_DB_BACKUP_PATH
                else
                        #this is the first of deplicate dir names
                        ALREADY_EXIST=true
                        $DEBUG && echo "+++when looking for [$FILE_BASE], $NAMESAKE is found, now looking for duplicates..."
                fi
        done
done
