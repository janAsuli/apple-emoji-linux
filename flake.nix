{
  description = "Apple Color Emoji for Linux";

  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (system: with nixpkgs.legacyPackages.${system}; {
        default = stdenvNoCC.mkDerivation rec {
          pname = "apple-emoji-linux";
          version = "17.4";

          src = fetchurl {
            url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v${version}/AppleColorEmoji.ttf";
            hash = "sha256-SG3JQLybhY/fMX+XqmB/BKhQSBB0N1VRqa+H6laVUPE=";
          };

          dontUnpack = true;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/fonts/truetype
            cp $src $out/share/fonts/truetype/AppleColorEmoji.ttf
            
            runHook postInstall
          '';

          meta = with lib; {
            homepage = "https://github.com/samuelngs/apple-emoji-linux";
            description = "Apple Color Emoji for Linux";
            license = licenses.unfree;
            platforms = platforms.all;
          };
        };
      });
    };
}
