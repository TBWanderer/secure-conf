{ pkgs, lib, ... }:
{
	services = {
		hyprpaper.enable = lib.mkForce false;
		wpaperd.enable = true;
	};
	stylix.targets.hyprland.enable = false;
	wayland.windowManager.hyprland = {
		enable = true;
		extraConfig = ''
			monitor=,1920x1080@144,0x0,1
			
			$terminal = alacritty --working-directory /home/x/
			$fileManager = nemo
			$menu = rofi -show drun
			
			exec-once = wpaperd
			exec-once = wl-paste --watch cliphist store

			general { 
			    gaps_in = 5
			    gaps_out = 10
			
			    border_size = 1
				

			    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
			    col.inactive_border = rgba(595959aa)
			    
			    resize_on_border = false 
			    
			    allow_tearing = false
			
			    layout = dwindle
			}
			
			
			decoration {
			    rounding = 10
			    
			    active_opacity = 0.9
			    inactive_opacity = 0.9
			
			    
			    blur {
			        enabled = true
			        size = 3
			        passes = 1
			        
			        vibrancy = 0.1696
			    }
			}
			
			
			decoration:shadow {
				enabled = false
			}
			animations {
			    enabled = true
			
			    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
			
			    animation = windows, 1, 7, myBezier
			    animation = windowsOut, 1, 7, default, popin 80%
			    animation = border, 1, 10, default
			    animation = borderangle, 1, 8, default
			    animation = fade, 1, 7, default
			    animation = workspaces, 1, 6, default
			}
			
			
			dwindle {
			    pseudotile = true 
			    preserve_split = true 
			}
			
			master {
			    new_status = master
			}
			
			misc { 
			    force_default_wallpaper = -1 
			    disable_hyprland_logo = false 
			}
			
			input {
			    kb_layout = us,ru
			    kb_variant =
			    kb_model =
			    kb_options = caps:escape,grp:win_space_toggle
			    kb_rules =
			
			    follow_mouse = 1
			
			    sensitivity = 0 
			
			    touchpad {
			        natural_scroll = false
			    }
			}
			
			
			gestures {
			    workspace_swipe = true
			}
			
			$mod = SUPER 

			bind = $mod, C, killactive 
			bind = $mod SHIFT, L, exec, hyprlock
			bind = $mod, O, pin
			bind = $mod, f, togglefloating, 
			bind = $mod, M, exit
			bind = $mod, y, togglesplit,
			bind = $mod, u, fullscreen,
			
			
			bind = $mod, RETURN, exec, alacritty msg create-window || alacritty
			bind = $mod, A, exec, cool-retro-term --fullscreen

			bind = $mod, E, exec, nemo
			bind = ALT, SPACE, exec, rofi -show run
			bind = $mod, R, exec, rofi -show drun
			bind = $mod, V, exec, cliphist list | rofi -dmenu -p "Cliphist search:" -window-title "Cliphist" -sync | cliphist decode | wl-copy
			
			bind = , PRINT, exec, ${import ./sshot.nix {inherit pkgs; }}/bin/sshot
			bind = CTRL SHIFT, PRINT, exec, pkill wf-recorder
			
			bind = $mod, h, movefocus, l
			bind = $mod, l, movefocus, r
			bind = $mod, k, movefocus, u
			bind = $mod, j, movefocus, d
			
			bind = $mod CTRL SHIFT, h, movewindow, l
			bind = $mod CTRL SHIFT, l, movewindow, r
			bind = $mod CTRL SHIFT, k, movewindow, u
			bind = $mod CTRL SHIFT, j, movewindow, d
			
			bind = $mod, 1, workspace, 1
			bind = $mod, 2, workspace, 2
			bind = $mod, 3, workspace, 3
			bind = $mod, 4, workspace, 4
			bind = $mod, 5, workspace, 5
			bind = $mod, 6, workspace, 6
			bind = $mod, 7, workspace, 7
			bind = $mod, 8, workspace, 8
			bind = $mod, 9, workspace, 9
			bind = $mod, 0, workspace, 10
			
			bind = $mod SHIFT, 1, movetoworkspace, 1
			bind = $mod SHIFT, 2, movetoworkspace, 2
			bind = $mod SHIFT, 3, movetoworkspace, 3
			bind = $mod SHIFT, 4, movetoworkspace, 4
			bind = $mod SHIFT, 5, movetoworkspace, 5
			bind = $mod SHIFT, 6, movetoworkspace, 6
			bind = $mod SHIFT, 7, movetoworkspace, 7
			bind = $mod SHIFT, 8, movetoworkspace, 8
			bind = $mod SHIFT, 9, movetoworkspace, 9
			bind = $mod SHIFT, 0, movetoworkspace, 10

			bind = $mod, mouse_down, workspace, e+1
			bind = $mod, mouse_up, workspace, e-1
			
			bindm = $mod, mouse:272, movewindow
			bindm = $mod, mouse:273, resizewindow
			
			# Ресайз
			bind = $mod CTRL, h, resizeactive,-50 0
			bind = $mod CTRL, l, resizeactive,50 0
			bind = $mod CTRL, k, resizeactive,0 -50
			bind = $mod CTRL, j, resizeactive,0 50
			
			bind = $mod CTRL, p, exec, powermenu
			
			bind = , XF86AudioMute, exec,  ${pkgs.pamixer}/bin/pamixer -t
        	bind = , XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i2
        	bind = , XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d2
        	bind = , XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause
        	bind = , XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play
        	bind = , XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous
        	bind = , XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next

			windowrulev2 = suppressevent maximize, class:.* 
		'';
	};
}
