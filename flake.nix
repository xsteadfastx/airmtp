{
  description = "Wireless download from your MTP-enabled devices";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          permittedInsecurePackages = [
            "python-2.7.18.8"

          ];
        };
      };
    in
    rec {
      packages.x86_64-linux.airmtp = pkgs.stdenv.mkDerivation rec {
        name = "airmtp";
        src = ./.;
        dontUnpack = true;
        buildInputs = [ pkgs.python2 ];
        installPhase = ''
          set -x
          mkdir -p $out/opt/${name}
          cp -R $src/* $out/opt/${name}
          chmod +x $out/opt/${name}/${name}.py
          mkdir $out/bin
          ln -fs $out/opt/${name}/${name}.py $out/bin/${name}
          mkdir $out/opt/${name}/appdata
        '';
      };

      packages.x86_64-linux.default = packages.x86_64-linux.airmtp;
    };
}

