{ pkgs, inputs, ... }: {
	nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];
	environment.systemPackages = [
		(pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
			extensions = [ "rust-src" "rust-analyzer" "rustfmt" ];
			targets = [ "x86_64-apple-darwin" "x86_64-unknown-linux-gnu" "x86_64-pc-windows-gnu" ];
		}))
	];
}
