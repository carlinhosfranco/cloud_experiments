MASTER="192.168.20.101"
USER="root"

function noise_app {
    
    local APP=$1
    local INPUT="test"

    if [ -e "my_noise_ok" ]; then
        rm -rf my_noise_ok
    fi

    cd /root/interference_parsec/parsec-3.0/
    source env.sh
    cd /root/interference_parsec/

    while [ ! -e "ok" ]; do
        
        parsecmgmt -a run -p $APP -c gcc-pthreads -i $INPUT -n 8 > /dev/null
        #echo "parsecmgmt -a run -p $APP -c gcc-pthreads -i native -n 8" #> /dev/null
        #sleep 4

    done
    ssh $USER@$MASTER touch /root/interference_parsec/noise_check/ok
    #touch my_noise_ok

}

noise_app $1
