{ pkgs, ... }:
let bridge1 = "obfs4 [2607:5300:205:200::fd9]:3303 972A60902543FDD9BC3BF76A795DC009F65427F3 cert=JAWEDu8myB2uUp+VTwC36HS0Y3+ca72rJxl9dOvs7aRS2LqccMO743CVdKX8n2DHC3X3KQ iat-mode=0";
	bridge2 = "obfs4 [2001:470:1f0f:236:0:1989:10:12]:31337 F85EEE917BC94C82DE620D183CE7AA9C7A59FA0A cert=qzYzuuHbDxeLeyfZ9DmK5PU4EfCKSG5Ti6R3+I44A3owPJ4dulA1dT5g2RRxyXQBTqrDbQ iat-mode=0";
	torrc = pkgs.writeText "torcc" ''
		UseBridges 1
		ClientTransportPlugin obfs4 exec ${pkgs.obfs4}/bin/lyrebird
		Bridge ${bridge1}
		Bridge ${bridge2}
	''; in {
	systemd.services.tor-proxy = {
		serviceConfig = {
			ExecStart = "${pkgs.tor}/bin/tor -f ${torrc}";
		};
		wantedBy = [ "graphical-session.target" ];
	};
}
