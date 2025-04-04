{
  description = "Wireless download from your MTP-enabled devices";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
  };

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        py = inputs.nixpkgs-python.packages.${system}."2.7.18";

        airmtp = pkgs.stdenv.mkDerivation rec {
          name = "airmtp";
          src = ./.;
          dontUnpack = true;
          buildInputs = [ py ];
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
      in
      {
        packages.airmtp = airmtp;
        packages.default = airmtp;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            py
            airmtp
          ];
        };
      }
    );
}
