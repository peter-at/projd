{
  description = "Doc development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-parts = {
    url = "github:hercules-ci/flake-parts";
    inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      mkFHSEnvShell = pkgs: fhsEnvAttrs: (pkgs.buildFHSEnv fhsEnvAttrs).env;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem =
        { pkgs, ... }:
        let
          pypkgs = pkgs.python312Packages;
        in
        rec {
          devShells.default = devShells.projd;

          devShells.projd =
          let
            homedir = builtins.getEnv "HOME";
            inherit (inputs.nixpkgs.lib) assertMsg;
	    inherit (builtins) stringLength;
            conda-envfile = pkgs.writeText "projd-env.yml" ''
              name: projd
              channels:
              - conda-forge
              - nodefaults
              dependencies:
              # runtimes
              - python =3.12
              # package managers
              - pip
              # others
              - pystructurizr
              '';
          in
	  assert assertMsg (stringLength homedir != 0) "Need to use 'nix develop --impure' to get HOME env.";
          pkgs.mkShell {
            name = "projd";
            packages =
              (with pkgs; [
	        yj
	        micromamba
		temurin-bin-17
		maven
		nodejs_18
		# docker_27
              ]);

            shellHook = ''
              set -e
              eval "$(micromamba shell hook --shell=posix)"
              export MAMBA_ROOT_PREFIX=${homedir}/.mamba
	      # projd enviornmnet
	      [ -d $MAMBA_ROOT_PREFIX/envs/projd ] || micromamba create -y -n projd -f ${conda-envfile}
              micromamba activate projd
              set +e
            '';
          };
        };
    };
}
