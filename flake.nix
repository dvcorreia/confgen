{
  description = "A Go configuration code generator";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      supportedSystems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        }
      );
    in
    {
      overlay = final: prev: {
        confgen = prev.callPackage ./nix/package.nix { };
      };

      packages = forAllSystems (system: {
        default = (nixpkgsFor.${system}).confgen;
      });

      devShells = forAllSystems (
        system: with nixpkgsFor.${system}; {
          default = mkShell {
            packages = [
              git
            ];
            inputsFrom = [ confgen ];
          };
        }
      );

      formatter = forAllSystems (system: (nixpkgsFor.${system}).nixfmt-rfc-style);
    };
}
