function noise_app {
    
    local APP=$1

    if [ -e "my_noise_ok" ]; then
        rm -rf my_noise_ok
    fi

    cd $HOME/scrips_iscc_parsec/parsec-3.0/
    source env.sh
    $HOME/interference_parsec/

    while [ ! -e "ok" ]; do
        
        parsecmgmt -a run -p $APP -c gcc-pthreads -i native -n 8 > /dev/null
        #echo "parsecmgmt -a run -p $APP -c gcc-pthreads -i native -n 8" #> /dev/null
        sleep 4

    done

    touch my_noise_ok

}

noise_app $1