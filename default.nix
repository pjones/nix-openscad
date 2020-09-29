{ pkgs ? import <nixpkgs> { }
}:

{
  # Source code directory, usually `./'.  Passed to `mkDerivation'.
  src

  # List of files to process.  The default is an empty list which means
  # to process all `*.scad' files.
, scadFiles ? [ ]

  # The name of the derivation.
, name ? "project"
}:
let
  lib = pkgs.lib;

  buildScript =
    pkgs.writeShellScript
      "openscad-build"
      (builtins.readFile ./scripts/build.sh);

  installScript =
    pkgs.writeShellScript
      "openscad-install"
      (builtins.readFile ./scripts/install.sh);
in
pkgs.stdenvNoCC.mkDerivation {
  inherit src;
  name = "openscad-${name}";

  buildInputs = with pkgs; [
    openscad
  ];

  buildPhase = ''
    ${buildScript} ${lib.escapeShellArgs scadFiles}
  '';

  installPhase = ''
    ${installScript} "$out/stl" stl
  '';
}
