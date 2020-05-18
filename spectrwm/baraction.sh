#!/bin/bash
# baraction.sh for spectrwm status bar
# From http://wiki.archlinux.org/index.php/Scrotwm
# Modified by Guillem Ramirez Miranda

SLEEP_SEC=5
#loops forever outputting a line every SLEEP_SEC secs
while :; do

	#Battery level
	bat_dir=`find / -type d -iname "BAT0" 2> /dev/null`
	eval $(awk '{printf "BAT_PRESENT=%s", $1};' $bat_dir/present)

	if [[ $BAT_PRESENT -eq 1 ]]; then			
		eval $(awk -F "=" '/^POWER_SUPPLY_CAPACITY=/ {printf "BAT_CAP=%s;",$2}; /^POWER_SUPPLY_STATUS=/ {printf "BAT_STAT=%s;", $2};' $bat_dir/uevent)
		POWER_STR="$BAT_CAP/100 $BAT_STAT"
	else
		POWER_STR=\\0
	fi

	#Temps
	eval $(sensors 2>/dev/null | sed s/[°+]//g | awk '/^Core 0/ {printf "CORE0TEMP=%s;", $3}; /^Core 1/ {printf "CORE1TEMP=%s;",$3}; /^fan1/ {printf "FANSPD=%s;",$2};' -)
	TEMP_STR="Tcpu=$CORE0TEMP,$CORE1TEMP F=$FANSPD"
	
	#Wifi
	eval $( iw dev wlp2s0 info | awk '/ssid/ { printf "WLAN_ESSID=%s;", $2}; /txpower/ { printf "WLAN_POWER=%s;", $2};' )
	eval $(cat /proc/net/wireless | sed s/[.]//g | awk '/wlp2s0/ {printf "WLAN_QULTY=%s; WLAN_SIGNL=%s; WLAN_NOISE=%s", $3,$4,$5};' -)
	BCSCRIPT="scale=0;a=100*$WLAN_QULTY/70;print a"
	WLAN_QPCT=`echo $BCSCRIPT | bc -l`
	WLAN_STR="$WLAN_ESSID: Q=$WLAN_QPCT% S/N="$WLAN_SIGNL"/"$WLAN_NOISE"dBm T="$WLAN_POWER"dBm"

	#Feqs
	CPUFREQ_STR=`echo "Freq:"$(cat /proc/cpuinfo | grep 'cpu MHz' | sed 's/.*: //g; s/\..*//g;')`
	CPULOAD_STR="Load:$(uptime | sed 's/.*://; s/,//g')"

	#Mem
	eval $(awk '/^MemTotal/ {printf "MTOT=%s;", $2}; /^MemFree/ {printf "MFREE=%s;",$2}' /proc/meminfo)
	MUSED=$(( $MTOT - $MFREE ))
	MUSEDPT=$(( ($MUSED * 100) / $MTOT ))
	MEM_STR="Mem:${MUSEDPT}%"

        echo -e "$POWER_STR  $TEMP_STR  $CPUFREQ_STR  $CPULOAD_STR  $MEM_STR  $WLAN_STR"

	sleep $SLEEP_SEC
done
