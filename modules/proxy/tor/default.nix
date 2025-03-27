{ pkgs, ... }:
let bridge1 = "";
	bridge2 = "";
torcc = pkgs.writeText "torcc" ''
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
