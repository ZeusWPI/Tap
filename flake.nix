{
  description = "Tap";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, ... }@inputs:
    {
      devShells = builtins.mapAttrs (system: pkgs: {
        tap = pkgs.mkShell {
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

            # Formatting nix files
            nixfmt
          ];
        };
        default = self.devShells.${system}.tap;
      }) inputs.nixpkgs.legacyPackages;
    };
}
