MASTER="192.168.20.101"
USER="root"

MY_IP="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')"

function noise_app {
    
    local APP=$1
    local INPUT="native"

    if [ -e "my_noise_ok" ]; then
        rm -rf my_noise_ok
    fi

    cd /mnt/parsec/interference_parsec/parsec-3.0/
    source env.sh
    cd /mnt/parsec/interference_parsec

    while [ ! -e "ok" ]; do
        
        parsecmgmt -a run -p $APP -c gcc-pthreads -i $INPUT -n 8 > /dev/null
        #echo "parsecmgmt -a run -p $APP -c gcc-pthreads -i native -n 8" #> /dev/null
        #sleep 4

    done

    ssh $USER@$MASTER touch /mnt/parsec/interference_parsec/noise_check/$MY_IP
    #touch my_noise_ok

}

noise_app $1
