{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  gettext,
  glib,
  pkg-config,
  libdrm,
  libGL,
  atkmm,
  pcre,
  gtkmm4,
  pugixml,
  libgbm,
  pciutils,

  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adriconf";
  version = "2.7.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "adriconf";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-0XTsYeS4tNAnGhuJ81fmjHhFS6fVq1lirui5b+ojxTQ=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'if (ENABLE_UNIT_TESTS)' 'if (BUILD_TESTING)'

    substituteInPlace CMakeLists.txt \
      --replace-fail 'configure_file(CMakeLists.txt.in' '# configure_file(CMakeLists.txt.in' \
      --replace-fail 'execute_process(COMMAND ' '# execute_process(COMMAND ' \
      --replace-fail 'WORKING_DIRECTORY "''${CMAKE_BINARY_DIR}/googletest-download" )' '# WORKING_DIRECTORY "''${CMAKE_BINARY_DIR}/googletest-download" )' \
      --replace-fail 'add_subdirectory("' '# add_subdirectory("'

    substituteInPlace tests/CMakeLists.txt \
      --replace-fail 'enable_testing()' 'include(CTest)' \
      --replace-fail 'target_compile_options(runUnitTests PRIVATE -Wall -Wextra -pedantic)' 'add_test(NAME runUnitTests COMMAND runUnitTests)'
  '';

  nativeBuildInputs = [
    cmake
    gettext # msgfmt
    glib # glib-compile-resources
    pkg-config
  ];
  buildInputs = [
    libdrm
    libGL
    atkmm
    pcre
    gtkmm4
    pugixml
    libgbm
    pciutils
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  checkInputs = [ gtest ];

  doCheck = true;

  postInstall = ''
    install -Dm444 ../flatpak/org.freedesktop.adriconf.metainfo.xml \
      -t $out/share/metainfo/
    install -Dm444 ../flatpak/org.freedesktop.adriconf.desktop \
      -t $out/share/applications/
    install -Dm444 ../flatpak/org.freedesktop.adriconf.png \
      -t $out/share/icons/hicolor/256x256/apps/
  '';

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/mesa/adriconf/";
    changelog = "https://gitlab.freedesktop.org/mesa/adriconf/-/releases/v${version}";
    description = "GUI tool used to configure open source graphics drivers";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.linux;
    mainProgram = "adriconf";
  };
})