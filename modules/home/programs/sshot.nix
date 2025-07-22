{ pkgs }:
pkgs.writeShellScriptBin "sshot" ''
	screenshot_path=$(mktemp --suffix=.png)
	# screenshot_path_2=$(mktemp --suffix=.png)
	slurp_area=$(${pkgs.slurp}/bin/slurp)
	sleep 0.15

	${pkgs.grim}/bin/grim -g "$slurp_area" "$screenshot_path" && ${pkgs.wl-clipboard}/bin/wl-copy < "$screenshot_path"
	# ${pkgs.satty}/bin/satty \
	# 	--filename "$screenshot_path_1" \
	# 	--copy-command ${pkgs.wl-clipboard}/bin/wl-copy \
	# 	--early-exit \
	# 	--fullscreen
	
	thumbnail_path=$(mktemp --suffix=.png)
	${pkgs.imagemagickBig}/bin/convert \
		"$screenshot_path" \
		-resize 100x100 \
		"$thumbnail_path" && \
	${pkgs.libnotify}/bin/notify-send \
		-t 2000 \
		-i "$thumbnail_path" \
		"  Screenshot Captured" \
		"  Screenshot saved and copied to clipboard"
	
	rm "$screenshot_path" "$thumbnail_path"
''
