{
  description = "Tap";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
            ruby_4_0
            nodejs_24
            foreman

            sqlite
            chromedriver
            ungoogled-chromium

            # for mysql2 gem
            libmysqlclient

            # for psych gem
            libyaml

            # Other dependencies
            imagemagick
          ];
        };
      });
}
