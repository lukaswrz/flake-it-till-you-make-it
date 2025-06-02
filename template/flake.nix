{
  # FIXME: Set the description.
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # FIXME: Uncomment these if services are needed.
    # inputs.process-compose.url = "github:Platonic-Systems/process-compose-flake";
    # inputs.services.url = "github:juspay/services-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      hooks,
      treefmt,
      # FIXME: Uncomment these if services are needed.
      # process-compose,
      # services,
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        hooks.flakeModule
        treefmt.flakeModule
        # FIXME: Uncomment this if services are needed.
        # inputs.process-compose.flakeModule
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

          # FIXME: Uncomment this if services are needed.
          # process-compose.myservices = {
          #   imports = [
          #     inputs.services.processComposeModules.default
          #   ];
          # };
        };

      flake = {
        # FIXME: Uncomment this if the flake should export a NixOS module.
        # nixosModules.default = import ./module.nix self;
      };
    };
}
