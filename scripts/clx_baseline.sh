CPUPATH=/sys/devices/system/cpu
MHZPATH=/root/scripts/mhz
# How many mhz should it run after changing to each freq scale?
ITERATION=2

MAXFREQ=$(cat $CPUPATH/cpu0/cpufreq/cpuinfo_max_freq)
MINFREQ=$(cat $CPUPATH/cpu0/cpufreq/cpuinfo_min_freq)
CPURANGE=$[$(cat /proc/cpuinfo | grep processor | wc -l)-1]
ORIGINAL_GOVERNOR=performance
# Restore settings
echo "Restore CPU frequency settings"
for i in $(seq 0 79)
do
   echo 2300000 > $CPUPATH/cpu${i}/cpufreq/scaling_max_freq
   echo 2300000 > $CPUPATH/cpu${i}/cpufreq/scaling_min_freq
   echo 2300000 > $CPUPATH/cpu${i}/cpufreq/scaling_max_freq
done

