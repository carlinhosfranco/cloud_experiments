################## Overcomitment 2.0 ##################
#./main_exe.sh vips ferret ferret ferret heavy_noise
#./main_exe.sh streamcluster ferret ferret ferret heavy_noise
#./main_exe.sh dedup ferret ferret ferret heavy_noise

#./main_exe.sh vips ferret streamcluster swaptions mix
#./main_exe.sh streamcluster ferret vips swaptions mix
#./main_exe.sh dedup ferret vips swaptions mix

#./main_exe.sh vips ferret ferret vips same
#./main_exe.sh streamcluster ferret ferret streamcluster same
#./main_exe.sh dedup ferret ferret dedup same
######################################################

################## Overcomitment 1.5 ##################
#./main_exe.sh vips ferret ferret heavy_noise
#./main_exe.sh streamcluster ferret ferret heavy_noise
#./main_exe.sh dedup ferret ferret heavy_noise

#./main_exe.sh vips ferret streamcluster mix
#./main_exe.sh streamcluster ferret vips mix
#./main_exe.sh dedup ferret vips mix

#./main_exe.sh vips ferret vips same
#./main_exe.sh streamcluster ferret streamcluster same
#./main_exe.sh dedup ferret dedup same
######################################################

################## Shared ##################
#./main_exe.sh vips ferret heavy_noise
#./main_exe.sh streamcluster ferret heavy_noise
#./main_exe.sh dedup ferret heavy_noise
#./main_exe.sh dedup dedup same


#./main_exe.sh vips ferret mix
#./main_exe.sh streamcluster ferret mix
#./main_exe.sh dedup ferret mix

#./main_exe.sh vips ferret ferret same
#./main_exe.sh streamcluster ferret ferret same
#./main_exe.sh dedup ferret ferret same
######################################################

################## Dedicated ##################
#./main_exe.sh vips
#./main_exe.sh streamcluster
#./main_exe.sh dedup
######################################################

./main_exe.sh vips ferret ferret ferret heavy_noise
./main_exe.sh streamcluster ferret ferret ferret heavy_noise
./main_exe.sh dedup ferret ferret ferret heavy_noise

./main_exe.sh vips ferret streamcluster swaptions mix
./main_exe.sh streamcluster ferret vips swaptions mix
./main_exe.sh dedup ferret vips swaptions mix

./main_exe.sh vips ferret ferret vips same
./main_exe.sh streamcluster ferret ferret streamcluster same
./main_exe.sh dedup ferret ferret dedup same

mv logs/*.log logs/x1/

for(( i=1; i<11; i++ )) do

    ./main_exe.sh vips ferret ferret ferret heavy_noise
    ./main_exe.sh streamcluster ferret ferret ferret heavy_noise
    ./main_exe.sh dedup ferret ferret ferret heavy_noise

    ./main_exe.sh vips ferret streamcluster swaptions mix
    ./main_exe.sh streamcluster ferret vips swaptions mix
    ./main_exe.sh dedup ferret vips swaptions mix

    ./main_exe.sh vips ferret ferret vips same
    ./main_exe.sh streamcluster ferret ferret streamcluster same
    ./main_exe.sh dedup ferret ferret dedup same

done

mv logs/*.log logs/x10/