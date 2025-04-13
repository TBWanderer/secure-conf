{ pkgs, ... }:
pkgs.writeShellScriptBin "cava" ''
   set -e

   bar="▁▂▃▄▅▆▇█"
   dict="s/;//g;"
   i=0
   while [ $i -lt ''${#bar} ]
   do
      dict="''${dict}s/$i/''${bar:$i:1}/g;"
      i=$((i=i+1))
   done

   pipe="/tmp/cava.fifo"
   if [ -p $pipe ]; then
      unlink $pipe
   fi
   mkfifo $pipe

   config_file="/tmp/polybar_cava_config"
   echo "
   [general]
   bars = 20
   framerate = 60

   [output]
   method = raw
   raw_target = $pipe
   data_format = ascii
   ascii_max_range = 7
   " > $config_file

   ${pkgs.cava}/bin/cava -p $config_file &

   while read -r cmd; do
      echo $cmd | sed $dict
   done < $pipe
''

pkgs.writeShellScriptBin "battery" ''
	battery="BAT0"
	status=$(cat /sys/class/power_supply/$battery/status)
	capacity=$(cat /sys/class/power_supply/$battery/capacity)
	values=(20 40 60 80 100)
	icons=(" " " " " " " " " ")
	charging_icon=""
	full_icon=""
	icon=""


	if [ "$status" = "Charging" ]; then
		icon=$charging_icon
	elif [ "$status" = "Full" ]; then
		icon=$full_icon
	else
		for i in {0..4}; do
			if [ "$capacity" -le "''${values[$i]}" ] && [ "$result" = "" ]; then
				icon=''${icons[$i]}
    			break
			fi
		done
	fi

	echo "$capacity% $icon"
''
