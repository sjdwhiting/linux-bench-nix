{
  description = "Linux bench for testing CIS benchmarks";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs }: let
    allSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
      pkgs = import nixpkgs { inherit system; };
    });
  in {
    packages = forAllSystems ({ pkgs }: {
      default = pkgs.buildGoModule {
        pname = "linux-bench";
        version = "main";

        src = pkgs.fetchFromGitHub {
          owner = "aquasecurity";
          repo = "linux-bench";
          rev = "main";
          sha256 = "sha256-C39zoT8mKDqOMqXYKpBZpgDoJ9rHUkAzbl1cmlE/ROU=";
        };

        vendorHash = "sha256-dlynz7mOiN+5ndYkmCUQu/Z31AwmJ+J2S3EBjQG5nWI=";

        # Explicit build command to ensure the binary is built
        buildPhase = ''
          go build -o linux-bench .
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp linux-bench $out/bin/
          cp -r cfg $out/bin/cfg
        '';
      };
    });
  };
}
