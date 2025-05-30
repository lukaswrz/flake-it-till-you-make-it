{
  # FIXME: Set the description.
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hooks.url = "github:cachix/git-hooks.nix";
    treefmt.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      hooks,
      treefmt,
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        hooks.flakeModule
        treefmt.flakeModule
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          treefmt = {
            projectRootFile = "flake.nix";

            programs.nixfmt = {
              enable = true;
              package = pkgs.nixfmt-rfc-style;
            };
          };

          pre-commit.settings.hooks = {
            treefmt.enable = true;
          };

          devShells.default = pkgs.mkShellNoCC {
            packages = [
              # FIXME: Put packages here.
            ];

            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };

          # FIXME: Uncomment this if the flake should export a package.
          # packages.default = pkgs.callPackage ./package.nix {};
        };

      flake = {
        # FIXME: Uncomment this if the flake should export a NixOS module.
        # nixosModules.default = import ./module.nix self;
      };
    };
}
