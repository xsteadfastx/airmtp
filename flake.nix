{
  description = "Wireless download from your MTP-enabled devices";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = { permittedInsecurePackages = [ "python-2.7.18.8" ]; };
      };

      airmtp = pkgs.stdenv.mkDerivation rec {
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
    in {
      packages.x86_64-linux.airmtp = airmtp;
      packages.x86_64-linux.default = airmtp;

      devShells.x86_64-linux.default =
        pkgs.mkShell { buildInputs = [ pkgs.python2 airmtp ]; };
    };
}

