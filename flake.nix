{
  description = "Tap";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          name = "Tap";

          buildInputs = with pkgs; [
            ruby_3_4 

            nodejs_24
            sqlite

            # Other dependencies
            imagemagick
          ];
        };
      });
}