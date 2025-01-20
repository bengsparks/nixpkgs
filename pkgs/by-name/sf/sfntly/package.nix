{ fetchFromGitHub, stdenvNoCC, ant, jre8, makeWrapper }:
stdenvNoCC.mkDerivation {
    pname = "sfntly";
    version = "0.0.1";

    src = fetchFromGitHub {
      owner = "googlefonts";
      repo = "sfntly";
      rev = "a56f578";
      hash = "sha256-EtPGJSfZbti/g/4TzAxJCSj2DFYNpn4uLPqAWcPLF1Y=";
    };

    nativeBuildInputs = [ ant jre8 makeWrapper ];

    buildPhase = ''
      cd java
      ant
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      # cp -r dist/tools/{conversion,fontinfo,sfnttool,subsetter} $out/share/java
      cp -r dist/ $out/share/java

      makeWrapper ${jre8}/bin/java $out/bin/sfnttool \
        --add-flags "-cp $out/share/java/tools/sfnttool/sfnttool.jar com.google.typography.font.tools.sfnttool.SfntTool"

      makeWrapper ${jre8}/bin/java $out/bin/fontinfo \
        --add-flags "-cp $out/share/java/tools/fontinfo/fontinfo.jar com.google.typography.font.tools.fontinfo.FontInfoMain"

      runHook postInstall
    '';
}
