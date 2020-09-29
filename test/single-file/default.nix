let

  nix-openscad = import ../.. { };

in
nix-openscad {
  src = ./.;
}
