{
  description = "A flake for building lrzhs, a set of Haskell bindings for librustzcash";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/release-23.05;
    flake-utils.url = "github:numtide/flake-utils";
    crane = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = github:ipetkov/crane;
    };
  };

  outputs = { 
    self, 
    nixpkgs, 
    flake-utils,
    crane,
    ...
  }: flake-utils.lib.eachDefaultSystem(system: let
    pkgs = import nixpkgs { inherit system; };

    craneLib = crane.lib.${system};
    lrzhs_ffi = craneLib.buildPackage {
      src = craneLib.cleanCargoSource ./rust/.;

      buildInputs = pkgs.lib.optionals pkgs.stdenv.isDarwin [
        pkgs.darwin.apple_sdk.frameworks.Security
        pkgs.libiconv
      ];

      doCheck = true;
    };

    haskell = pkgs.haskellPackages;

    haskell-overlay = final: prev: {
      lrzhs = pkgs.haskellPackages.callCabal2nix "lrzhs" ./. { 
        inherit lrzhs_ffi;
      };
    };

    hspkgs = haskell.override {
      overrides = haskell-overlay;
    };
  in {
    packages = {
      default = self.packages.${system}.lrzhs;
      lrzhs = hspkgs.lrzhs;
      inherit lrzhs_ffi;
    };

    devShells = {
      default = pkgs.mkShell {
        inputsFrom = 
          builtins.attrValues self.packages.${system};

        buildInputs = [
          lrzhs_ffi
        ];

        nativeBuildInputs = with hspkgs; [
          haskell-language-server
          cabal-install
        ];

        LD_LIBRARY_PATH = ["${lrzhs_ffi}/lib/"];
      };
    };
  });
}
