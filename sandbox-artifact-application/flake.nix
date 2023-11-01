# sandox-artifact-application/flake.nix
#
# This file packages rydnr/sandbox-artifact-application as a Nix flake.
#
# Copyright (C) 2023-today rydnr's rydnr/sandbox-artifact-application-artifact
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
{
  description = "Application layer for rydnr/sandbox-artifact";
  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    pythoneda-shared-artifact-infrastructure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
      url =
        "github:pythoneda-shared-artifact/infrastructure-artifact/0.0.2?dir=infrastructure";
    };
    pythoneda-shared-artifact-shared = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
      url = "github:pythoneda-shared-artifact/shared-artifact/0.0.1?dir=shared";
    };
    pythoneda-shared-pythoneda-application = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
      inputs.pythoneda-shared-pythoneda-infrastructure.follows =
        "pythoneda-shared-pythoneda-infrastructure";
      url =
        "github:pythoneda-shared-pythoneda/application-artifact/0.0.5?dir=application";
    };
    pythoneda-shared-pythoneda-banner = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      url = "github:pythoneda-shared-pythoneda/banner/0.0.13";
    };
    pythoneda-shared-pythoneda-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      url =
        "github:pythoneda-shared-pythoneda/domain-artifact/0.0.12?dir=domain";
    };
    rydnr-sandbox-artifact = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
      url = "github:rydnr/sandbox-artifact-artifact/0.0.1?dir=sandbox-artifact";
    };
    pythoneda-shared-pythoneda-infrastructure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
      url =
        "github:pythoneda-shared-pythoneda/infrastructure-artifact/0.0.6?dir=infrastructure";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "rydnr";
        repo = "sandbox-artifact-application";
        version = "0.0.1";
        sha256 = "1g02wgb0ygvrk0cw861s9wsi9qvi3n71gwyfa3mlar1zdqzkzr5f";
        pname = "${org}-${repo}";
        pythonpackage = "rydnr.sandbox.artifact.application";
        package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
        entrypoint = "sandbox_artifact_app";
        description = "Application layer for rydnr/sandbox-artifact";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/${org}/${repo}";
        maintainers = with pkgs.lib.maintainers;
          [ "rydnr <github@acm-sl.org>" ];
        archRole = "B";
        space = "D";
        layer = "A";
        nixosVersion = builtins.readFile "${nixos}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixos-${nixosVersion}";
        shared = import "${pythoneda-shared-pythoneda-banner}/nix/shared.nix";
        pkgs = import nixos { inherit system; };
        rydnr-sandbox-artifact-application-for = { python
          , rydnr-sandbox-artifact, pythoneda-shared-artifact-infrastructure
          , pythoneda-shared-artifact-shared
          , pythoneda-shared-pythoneda-application
          , pythoneda-shared-pythoneda-banner, pythoneda-shared-pythoneda-domain
          }:
          let
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
            banner_file = "${package}/artifact_banner.py";
            banner_class = "ArtifactBanner";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            pyprojectTemplateFile = ./pyprojecttoml.template;
            pyprojectTemplate = pkgs.substituteAll {
              authors = builtins.concatStringsSep ","
                (map (item: ''"${item}"'') maintainers);
              desc = description;
              inherit homepage package pname pythonMajorMinorVersion
                pythonpackage version;
              pythonedaSharedArtifactInfrastructure =
                pythoneda-shared-artifact-infrastructure.version;
              pythonedaSharedArtifactShared =
                pythoneda-shared-artifact-shared.version;
              pythonedaSharedPythonedaApplication =
                pythoneda-shared-pythoneda-application.version;
              pythonedaSharedPythonedaBanner =
                pythoneda-shared-pythoneda-banner.version;
              pythonedaSharedPythonedaDomain =
                pythoneda-shared-pythoneda-domain.version;
              rydnrSandboxArtifact = rydnr-sandbox-artifact.version;
              src = pyprojectTemplateFile;
            };
            bannerTemplateFile =
              "${pythoneda-shared-pythoneda-banner}/templates/banner.py.template";
            bannerTemplate = pkgs.substituteAll {
              project_name = pname;
              file_path = banner_file;
              inherit banner_class org repo;
              tag = version;
              pescio_space = space;
              arch_role = archRole;
              hexagonal_layer = layer;
              python_version = pythonMajorMinorVersion;
              nixpkgs_release = nixpkgsRelease;
              src = bannerTemplateFile;
            };

            entrypointTemplateFile =
              "${pythoneda-shared-pythoneda-banner}/templates/entrypoint.sh.template";
            entrypointTemplate = pkgs.substituteAll {
              arch_role = archRole;
              hexagonal_layer = layer;
              nixpkgs_release = nixpkgsRelease;
              inherit homepage maintainers org python repo version;
              pescio_space = space;
              python_version = pythonMajorMinorVersion;
              pythoneda_shared_pythoneda_banner =
                pythoneda-shared-pythoneda-banner;
              pythoneda_shared_pythoneda_domain =
                pythoneda-shared-pythoneda-domain;
              src = entrypointTemplateFile;
            };
            src = pkgs.fetchFromGitHub {
              owner = org;
              rev = version;
              inherit repo sha256;
            };

            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip pkgs.jq poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              rydnr-sandbox-artifact
              pythoneda-shared-artifact-infrastructure
              pythoneda-shared-artifact-shared
              pythoneda-shared-pythoneda-application
              pythoneda-shared-pythoneda-banner
              pythoneda-shared-pythoneda-domain
            ];

            pythonImportsCheck = [ pythonpackage ];

            unpackPhase = ''
              cp -r ${src} .
              sourceRoot=$(ls | grep -v env-vars)
              chmod -R +w $sourceRoot
              cp ${pyprojectTemplate} $sourceRoot/pyproject.toml
              cp ${bannerTemplate} $sourceRoot/${banner_file}
              cp ${entrypointTemplate} $sourceRoot/entrypoint.sh
            '';

            postPatch = ''
              substituteInPlace /build/$sourceRoot/entrypoint.sh \
                --replace "@SOURCE@" "$out/bin/${entrypoint}.sh" \
                --replace "@PYTHONPATH@" "$PYTHONPATH" \
                --replace "@ENTRYPOINT@" "$out/lib/python${pythonMajorMinorVersion}/site-packages/${package}/${entrypoint}.py" \
                --replace "@BANNER@" "$out/bin/banner.sh"
            '';

            postInstall = ''
              pushd /build/$sourceRoot
              for f in $(find . -name '__init__.py'); do
                if [[ ! -e $out/lib/python${pythonMajorMinorVersion}/site-packages/$f ]]; then
                  cp $f $out/lib/python${pythonMajorMinorVersion}/site-packages/$f;
                fi
              done
              popd
              mkdir $out/dist $out/bin
              cp dist/${wheelName} $out/dist
              jq ".url = \"$out/dist/${wheelName}\"" $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json > temp.json && mv temp.json $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json
              cp /build/$sourceRoot/entrypoint.sh $out/bin/${entrypoint}.sh
              chmod +x $out/bin/${entrypoint}.sh
              echo '#!/usr/bin/env sh' > $out/bin/banner.sh
              echo "export PYTHONPATH=$PYTHONPATH" >> $out/bin/banner.sh
              echo "${python}/bin/python $out/lib/python${pythonMajorMinorVersion}/site-packages/${banner_file} \$@" >> $out/bin/banner.sh
              chmod +x $out/bin/banner.sh
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
      in rec {
        apps = rec {
          default = rydnr-sandbox-artifact-application-default;
          rydnr-sandbox-artifact-application-default =
            rydnr-sandbox-artifact-application-python311;
          rydnr-sandbox-artifact-application-python38 = shared.app-for {
            package =
              self.packages.${system}.rydnr-sandbox-artifact-application-python38;
            inherit entrypoint;
          };
          rydnr-sandbox-artifact-application-python39 = shared.app-for {
            package =
              self.packages.${system}.rydnr-sandbox-artifact-application-python39;
            inherit entrypoint;
          };
          rydnr-sandbox-artifact-application-python310 = shared.app-for {
            package =
              self.packages.${system}.rydnr-sandbox-artifact-application-python310;
            inherit entrypoint;
          };
          rydnr-sandbox-artifact-application-python311 = shared.app-for {
            package =
              self.packages.${system}.rydnr-sandbox-artifact-application-python311;
            inherit entrypoint;
          };
        };
        defaultApp = apps.default;
        defaultPackage = packages.default;
        devShells = rec {
          default = rydnr-sandbox-artifact-application-default;
          rydnr-sandbox-artifact-application-default =
            rydnr-sandbox-artifact-application-python311;
          rydnr-sandbox-artifact-application-python38 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python38
              }/bin/banner.sh";
            package = packages.rydnr-sandbox-artifact-application-python38;
            python = pkgs.python38;
            pythoneda-shared-pythoneda-domain =
              pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python38;
            pythoneda-shared-pythoneda-banner =
              pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python38;
            inherit archRole layer nixpkgsRelease org pkgs repo space;
          };
          rydnr-sandbox-artifact-application-python39 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python38
              }/bin/banner.sh";
            package = packages.rydnr-sandbox-artifact-application-python39;
            python = pkgs.python39;
            pythoneda-shared-pythoneda-domain =
              pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python39;
            pythoneda-shared-pythoneda-banner =
              pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python39;
            inherit archRole layer nixpkgsRelease org pkgs repo space;
          };
          rydnr-sandbox-artifact-application-python310 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python38
              }/bin/banner.sh";
            package = packages.rydnr-sandbox-artifact-application-python310;
            python = pkgs.python310;
            pythoneda-shared-pythoneda-domain =
              pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python310;
            pythoneda-shared-pythoneda-banner =
              pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python310;
            inherit archRole layer nixpkgsRelease org pkgs repo space;
          };
          rydnr-sandbox-artifact-application-python311 = shared.devShell-for {
            banner = "${
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python38
              }/bin/banner.sh";
            package = packages.rydnr-sandbox-artifact-application-python311;
            python = pkgs.python311;
            pythoneda-shared-pythoneda-domain =
              pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python311;
            pythoneda-shared-pythoneda-banner =
              pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python311;
            inherit archRole layer nixpkgsRelease org pkgs repo space;
          };
        };
        packages = rec {
          default = rydnr-sandbox-artifact-application-default;
          rydnr-sandbox-artifact-application-default =
            rydnr-sandbox-artifact-application-python311;
          rydnr-sandbox-artifact-application-python38 =
            rydnr-sandbox-artifact-application-for {
              python = pkgs.python38;
              pythoneda-shared-artifact-infrastructure =
                pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python38;
              pythoneda-shared-artifact-shared =
                pythoneda-shared-artifact-shared.packages.${system}.pythoneda-shared-artifact-shared-python38;
              pythoneda-shared-pythoneda-application =
                pythoneda-shared-pythoneda-application.packages.${system}.pythoneda-shared-pythoneda-application-python38;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python38;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python38;
              rydnr-sandbox-artifact =
                rydnr-sandbox-artifact.packages.${system}.rydnr-sandbox-artifact-python38;
            };
          rydnr-sandbox-artifact-application-python39 =
            rydnr-sandbox-artifact-application-for {
              python = pkgs.python39;
              pythoneda-shared-artifact-infrastructure =
                pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python39;
              pythoneda-shared-artifact-shared =
                pythoneda-shared-artifact-shared.packages.${system}.pythoneda-shared-artifact-shared-python39;
              pythoneda-shared-pythoneda-application =
                pythoneda-shared-pythoneda-application.packages.${system}.pythoneda-shared-pythoneda-application-python39;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python39;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python39;
              rydnr-sandbox-artifact =
                rydnr-sandbox-artifact.packages.${system}.rydnr-sandbox-artifact-python39;
            };
          rydnr-sandbox-artifact-application-python310 =
            rydnr-sandbox-artifact-application-for {
              python = pkgs.python310;
              pythoneda-shared-artifact-infrastructure =
                pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python310;
              pythoneda-shared-artifact-shared =
                pythoneda-shared-artifact-shared.packages.${system}.pythoneda-shared-artifact-shared-python310;
              pythoneda-shared-pythoneda-application =
                pythoneda-shared-pythoneda-application.packages.${system}.pythoneda-shared-pythoneda-application-python310;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python310;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python310;
              rydnr-sandbox-artifact =
                rydnr-sandbox-artifact.packages.${system}.rydnr-sandbox-artifact-python310;
            };
          rydnr-sandbox-artifact-application-python311 =
            rydnr-sandbox-artifact-application-for {
              python = pkgs.python311;
              pythoneda-shared-artifact-infrastructure =
                pythoneda-shared-artifact-infrastructure.packages.${system}.pythoneda-shared-artifact-infrastructure-python311;
              pythoneda-shared-artifact-shared =
                pythoneda-shared-artifact-shared.packages.${system}.pythoneda-shared-artifact-shared-python311;
              pythoneda-shared-pythoneda-application =
                pythoneda-shared-pythoneda-application.packages.${system}.pythoneda-shared-pythoneda-application-python311;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python311;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python311;
              rydnr-sandbox-artifact =
                rydnr-sandbox-artifact.packages.${system}.rydnr-sandbox-artifact-python311;
            };
        };
      });
}
