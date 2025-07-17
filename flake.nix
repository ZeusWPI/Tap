{
  description = "Tap";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/32a4e87942101f1c9f9865e04dc3ddb175f5f32e";
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-node.url = "github:nixos/nixpkgs/6f884c2f43c7bb105816303eb4867da672ec6f39";
  };

  outputs = { self, nixpkgs, flake-utils, nixpkgs-node, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        nodePkgs = import nixpkgs-node { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          name = "Tap";

          buildInputs = with pkgs; [
            ruby
            bundler

            nodePkgs.nodejs-16_x
            yarn

            sqlite
            libmysqlclient
            zlib

            # Other dependencies
            imagemagick
          ];
        };
      });
}