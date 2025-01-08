
  description = "Linux bench for use testing for CIS benchmarks";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
 };

  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default = pkgs.buildGoModule {
          name = "linux-bench";
          src = pkgs.fetchFromGitHub {
	    owner = "aquasecurity";
	    repo = "linux-bench";
	    rev = "main";
	    sha256 = "sha256-C39zoT8mKDqOMqXYKpBZpgDoJ9rHUkAzbl1cmlE/ROU=";
	  };
	  vendorHash = "sha256-dlynz7mOiN+5ndYkmCUQu/Z31AwmJ+J2S3EBjQG5nWI=";
        };
      });
    };
}
