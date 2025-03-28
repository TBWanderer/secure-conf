{ pkgs }:
pkgs.writeShellScriptBin "sshot" ''
	screenshot_path=$(mktemp --suffix=.png)
	grim -g "$(slurp)" "$screenshot_path"
	
	wl-copy < "$screenshot_path"
	
	thumbnail_path=$(mktemp --suffix=.png)
	convert "$screenshot_path" -resize 100x100 "$thumbnail_path"
	
	notify-send -t 2000 -i "$thumbnail_path" "  Screenshot Captured" "  Screenshot saved and copied to clipboard"
	
	rm "$screenshot_path" "$thumbnail_path"
''
