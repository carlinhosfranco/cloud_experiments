#!/bin/bash
#Script pata execução das aplicações PARSEC em ambiente de nuvem, em cenário compartilhado e overcommitement
#Autor: Carlos Alberto Franco Maron
#Data: 25/01/2019

#Aplicações do experimento: Vips, StreamCluster e Dedup
#Aplicações de Noise: Ferret, StreamCluster, X264 ou Swaptions
#cenários:
#   Dedicado: app_do_experimento
#   Compartilhado: app_do_experimento + Ferret
#   Overcmt 1.5: app_do_experimento + Ferret + Ferret
#   Overcmt 1.5 MIX: app_do_experimento + Ferret + StreamCluster
#   Overcmt 1.5 w/same: app_do_experimento + Ferret + app_do_experimento
#   Overcmt 2.0: app_do_experimento + Ferret + Ferret + Ferret
#   Overcmt 2.0 MIX: app_do_experimento + Ferret + StreamCluster + X264/Swaptions
#   Overcmt 2.0 w/same: app_do_experimento + Ferret + Ferret + app_do_experimento

#parsecmgmt -a run -p ferret -c gcc-pthreads -i native -n 8

DIR_LOG="./logs"

VIPS_FOLDER="/root/interference_parsec/parsec-3.0/pkgs/apps/vips/run"
STREAMCLUSTER=
DEDUP_FOLDER="/root/interference_parsec/parsec-3.0/pkgs/kernel/dedup/run"
FERRET=
SWAPTIONS=

DIR_COUNT="$(ls /root/interference_parsec/noise_check/ | wc -l)"

######## Configs ########
MACHINE_HOME="$HOME/interference_parsec/"
MACHINE_1="192.168.20.101"
MACHINE_2="192.168.20.102"
MACHINE_3="192.168.20.103"
USER="root"

INPUT="native"

LOGDATE="$(date +%F_%H:%M:%S)"

function dedicated {

    local APP=$1
    local SCENARIO="dedicated"
    local MAIN_LOG=${DIR_LOG}/$APP"_"$SCENARIO.log

    echo "--------- $APP ---------" >> $MAIN_LOG
    LOGDATE="$(date +%F_%H:%M:%S)"
    echo $LOGDATE >> $MAIN_LOG

    #echo "parsecmgmt -a run -p $APP -c gcc-pthreads -i native -n 8 > $MAIN_LOG"
    parsecmgmt -a run -p $APP -c gcc-pthreads -i $INPUT -n 8 >> $MAIN_LOG
    
    LOGDATE="$(date +%F_%H:%M:%S)"
    echo $LOGDATE >> $MAIN_LOG
    echo -e "--------- END ---------\n\n" >> $MAIN_LOG

    #if [ $APP == "vips" ]; then
        
    #    rm -rf $VIPS_FOLDER/*
    
    #elif [ $APP == "dedup" ]; then
        
    #    rm -rf $DEDUP_FOLDER/*
    #fi
}

function shared {
    
    local APP=$1
    local APP_2=$2
    
    local SCENARIO="shared"

    local MAIN_LOG=${DIR_LOG}/$APP"_"$SCENARIO.log

    #ssh -n $USER@$MACHINE_1 "$HOME/interference_parsec/noise_exe.sh $APP_2&"&
    ssh $USER@$MACHINE_1 "bash /root/interference_parsec/noise_exe.sh $APP_2 &" &

    echo "--------- $APP ---------" >> $MAIN_LOG
    LOGDATE="$(date +%F_%H:%M:%S)"

    echo -e "\t $LOGDATE" >> $MAIN_LOG
    echo -e "\t $SCENARIO Apps: $APP $APP_2" >> $MAIN_LOG

    parsecmgmt -a run -p $APP -c gcc-pthreads -i $INPUT -n 8 >> $MAIN_LOG
    #echo "parsecmgmt -a run -p $APP -c gcc-pthreads -i $INPUT -n 8 >> $MAIN_LOG"

    LOGDATE="$(date +%F_%H:%M:%S)"
    echo $LOGDATE >> $MAIN_LOG
    echo -e "--------- END ---------\n\n" >> $MAIN_LOG 

    ssh $USER@$MACHINE_1 touch /root/interference_parsec/ok

    while [ $DIR_COUNT -ne 1 ]; do
        
        sleep 1
        DIR_COUNT="$(ls /root/interference_parsec/noise_check/ | wc -l)"
        
    done
    
    ssh $USER@$MACHINE_1 rm -r /root/interference_parsec/ok
    rm -rf /root/interference_parsec/noise_check/*

    #echo $MAIN_LOG

}

function overcmt_15 {

    local SCENARIO="overcmt_15"
    
    local APP=$1
    local APP_2=$2
    local APP_3=$3

    local MODE=$4

    local MAIN_LOG=${DIR_LOG}/$APP"_"$SCENARIO"_"$MODE.log

    #echo "parsecmgmt -a run -p $APP -c gcc-pthreads -i native -n 8 > $MAIN_LOG"
    ssh -n $USER@$MACHINE_1 "bash /root/interference_parsec/noise_exe.sh $APP_2&"&
    ssh -n $USER@$MACHINE_2 "bash /root/interference_parsec/noise_exe.sh $APP_3&"&

    echo "--------- $APP ---------" >> $MAIN_LOG
    LOGDATE="$(date +%F_%H:%M:%S)"
    echo -e "\t $LOGDATE" >> $MAIN_LOG
    echo -e "\t $SCENARIO Apps: $APP $APP_2 $APP_3 Mode: $MODE" >> $MAIN_LOG

    parsecmgmt -a run -p $APP -c gcc-pthreads -i $INPUT -n 8 >> $MAIN_LOG
    #echo "parsecmgmt -a run -p $APP -c gcc-pthreads -i native -n 8 > $MAIN_LOG"
    
    LOGDATE="$(date +%F_%H:%M:%S)"
    echo $LOGDATE >> $MAIN_LOG
    echo -e "--------- END ---------\n\n" >> $MAIN_LOG 

    ssh $USER@$MACHINE_1 touch /root/interference_parsec/ok
    ssh $USER@$MACHINE_2 touch /root/interference_parsec/ok

    while [ $DIR_COUNT -ne 2 ]; do
        sleep 4
        DIR_COUNT="$(ls /root/interference_parsec/noise_check/ | wc -l)"
    done
    
    ssh $USER@$MACHINE_1 rm -r /root/interference_parsec/ok
    ssh $USER@$MACHINE_2 rm -r /root/interference_parsec/ok
    rm -rf /root/interference_parsec/noise_check/*
    
}

function overcmt_20 {

    local SCENARIO="overcmt_20"

    local APP=$1
    local APP_2=$2
    local APP_3=$3
    local APP_4=$4

    local MODE=$5

    local MAIN_LOG=${DIR_LOG}/$APP"_"$SCENARIO"_"$MODE.log
    
    #echo "parsecmgmt -a run -p $APP -c gcc-pthreads -i native -n 8 > $MAIN_LOG"
    ssh -n $USER@$MACHINE_1 "bash /root/interference_parsec/noise_exe.sh $APP_2&"&
    ssh -n $USER@$MACHINE_2 "bash /root/interference_parsec/noise_exe.sh $APP_3&"&
    ssh -n $USER@$MACHINE_3 "bash /root/interference_parsec/noise_exe.sh $APP_4&"&

    echo "--------- $APP ---------" >> $MAIN_LOG
    LOGDATE="$(date +%F_%H:%M:%S)"
    echo -e "\t $LOGDATE" >> $MAIN_LOG
    echo -e "\t $SCENARIO Apps: $APP $APP_2 $APP_3 $APP_4 Mode: $MODE" >> $MAIN_LOG

    parsecmgmt -a run -p $APP -c gcc-pthreads -i $INPUT -n 8 >> $MAIN_LOG
    #echo "parsecmgmt -a run -p $APP -c gcc-pthreads -i native -n 8 > $MAIN_LOG"

    LOGDATE="$(date +%F_%H:%M:%S)"
    echo $LOGDATE >> $MAIN_LOG
    echo -e "--------- END ---------\n\n" >> $MAIN_LOG

    ssh $USER@$MACHINE_1 touch /root/interference_parsec/ok
    ssh $USER@$MACHINE_2 touch /root/interference_parsec/ok
    ssh $USER@$MACHINE_3 touch /root/interference_parsec/ok

    while [ $DIR_COUNT -ne 3 ]; do
        
        sleep 4
        DIR_COUNT="$(ls /root/interference_parsec/noise_check/ | wc -l)"

    done
    
    ssh $USER@$MACHINE_1 rm -r /root/interference_parsec/ok    
    ssh $USER@$MACHINE_2 rm -r /root/interference_parsec/ok    
    ssh $USER@$MACHINE_3 rm -r /root/interference_parsec/ok
    
    rm -rf /root/interference_parsec/noise_check/*

}

if [ $# -le 1 ]; then
    
    dedicated $1

elif [ $# -le 3 ]; then
    
    shared $1 $2

elif [ $# -le 4 ]; then

    overcmt_15 $1 $2 $3 $4

elif [ $# -le 5 ]; then
    
    overcmt_20 $1 $2 $3 $4 $5

else

echo -e "Missing Arguments"

fi
