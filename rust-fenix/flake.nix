{
  description = "Rust dev using fenix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    fenix,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            fenix.overlays.default
          ];
        };

        # get Rust version from toolchain file
        toolchain = with fenix.packages.${system};
          fromToolchainFile {
            file = ./rust-toolchain.toml;
            sha256 = "sha256-e4mlaJehWBymYxJGgnbuCObVlqMlQSilZ8FljG9zPHY=";
          };
      in {
        devShells.default = pkgs.mkShell {
          # build environment
          nativeBuildInputs = with pkgs; [
            clang
            openssl.dev
            pkg-config
            toolchain
          ];

          # runtime environment
          buildInputs = with pkgs;
            [
              bacon
              # git-cliff
              rust-analyzer
              toolchain
            ]
            ++ lib.optionals pkgs.stdenv.isDarwin [
              # linking will fail if clang is not in nativeBuildInputs
              pkgs.darwin.apple_sdk.frameworks.CoreServices
              pkgs.darwin.apple_sdk.frameworks.Security
              pkgs.darwin.apple_sdk.frameworks.SystemConfiguration
              pkgs.libiconv
            ];
        };
      }
    );
}
