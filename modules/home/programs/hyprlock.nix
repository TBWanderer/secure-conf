{ sys, ... }: 
let
	wallpapers = ../../wallpapers;
in {
	stylix.targets.hyprlock.enable = false;
	programs.hyprlock = {
		enable = true;
		extraConfig = ''
			background {
			    monitor =
			    path = ${wallpapers}/blue-forest.png
			    blur_passes = 2
			    contrast = 1
			    brightness = 0.5
			    vibrancy = 0.2
			    vibrancy_darkness = 0.2
			}
			
			general {
			    hide_cursor = true
			    grace = 0
			    disable_loading_bar = true
			}
			
			input-field {
			    monitor =
			    size = 250, 60
			    outline_thickness = 2
			    dots_size = 0.2
			    dots_spacing = 0.35
			    dots_center = true
			    outer_color = rgba(0, 0, 0, 0)
			    inner_color = rgba(0, 0, 0, 0.2)
			    font_color = rgb(${sys.lib.stylix.colors.base05})
			    fade_on_empty = false
			    rounding = -1
			    check_color = rgb(${sys.lib.stylix.colors.base0A})
			    placeholder_text = Input Password...
			    hide_input = false
			    position = 0, -200
			    halign = center
			    valign = center
			}
			
			label {
			  monitor =
			  text = cmd[update:1000] echo "$(date +"%A, %B %d")"
			  color = rgb(${sys.lib.stylix.colors.base05})
			  font_size = 22
			  font_family = JetBrainsMono NF
			  position = 0, 300
			  halign = center
			  valign = center
			}
			
			label {
			  monitor = 
			  text = cmd[update:1000] echo "$(date +"%-I:%M")"
			  color = rgb(${sys.lib.stylix.colors.base05})
			  font_size = 95
			  font_family = JetBrainsMono NF
			  position = 0, 200
			  halign = center
			  valign = center
			}
		'';
	};
}
