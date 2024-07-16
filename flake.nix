{
  description = "Wireless download from your MTP-enabled devices";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-python.url = "github:cachix/nixpkgs-python";
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
      # python = nixpkgs-python.packages.x86_64-linux."2.7.18.8";
    in
    rec {
      packages.x86_64-linux.airmtp = pkgs.stdenv.mkDerivation {
        name = "airmtp";
        dontUnpack = true;
        buildInputs = [ pkgs.python2 ];
        installPhase = "install -Dm755 ${./airmtp.py} $out/bin/airmtp";
      };

      packages.x86_64-linux.default = packages.x86_64-linux.airmtp;
    };
}
