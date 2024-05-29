{
  description = "robosuite: A Modular Simulation Framework and Benchmark for Robot Learning";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    utils.url = "github:numtide/flake-utils";

    ml-pkgs.url = "github:nixvital/ml-pkgs";
    ml-pkgs.inputs.nixpkgs.follows = "nixpkgs";
    ml-pkgs.inputs.utils.follows = "utils";
  };

  outputs = { self, nixpkgs, utils, ... }@inputs: {
    overlays = {
      dev = nixpkgs.lib.composeManyExtensions [
        inputs.ml-pkgs.overlays.torch-family
        inputs.ml-pkgs.overlays.simulators
        inputs.ml-pkgs.overlays.math
      ];
    };
  } // utils.lib.eachSystem [ "x86_64-linux" ] (
    system:
    let pkgs-dev = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
            cudaCapabilities = [ "7.5" "8.6" ];
            cudaForwardCompat = true;
          };
          overlays = [ self.overlays.dev ];
        }; in {
          devShells.default = pkgs-dev.callPackage ./nix/pkgs/dev-shell {};
        });
}
