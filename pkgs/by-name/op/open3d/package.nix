{
  lib,
  fetchFromGitHub,
  stdenv,

  # CMake
  cmake,
  ninja,
  python3,
  pkg-config,

  # C++
  assimp,
  boost,
  boringssl,
  curl,
  eigen,
  fmt,
  glew,
  glfw,
  gtest,
  imgui,
  jsoncpp,
  libGL,
  libjpeg_turbo,
  libpng,
  msgpack-cxx,
  nanoflann,
  openblas,
  openssl,
  qhull,
  tbb,
  tinyobjloader,
  vtk,
  zeromq,
  zlib,
}:
let
  liblzf = stdenv.mkDerivation (finalAttrs: {
    pname = "liblzf";
    version = "3.6";

    src = fetchTarball {
      url = "http://dist.schmorp.de/liblzf/liblzf-${finalAttrs.version}.tar.gz";
      sha256 = "sha256:0x3aig3b97r7kybc4qsvcm6dzi3ab5wr7cqxbr00px0kh1yik4wv";
    };
  });

  filament = stdenv.mkDerivation (finalAttrs: {
    pname = "filament";
    version = "1.0";

    src = fetchTarball {
      url = "https://github.com/isl-org/filament/archive/d1d873d27f43ba0cee1674a555cc0f18daac3008.tar.gz";
      sha256 = "sha256:0dfrh464hhp53zjzric5f7c82s0pwc22q6vngkmni7n8w3abkps4";
    };

    nativeBuildInputs = [
      cmake
      ninja
      python3
    ];

    cmakeFlags = [
      "-DCCACHE_PROGRAM=OFF"
      "-DFILAMENT_ENABLE_JAVA=OFF"
      "-DUSE_STATIC_LIBCXX=ON"
      "-DFILAMENT_SUPPORTS_VULKAN=OFF"
      "-DFILAMENT_SKIP_SAMPLES=ON"
      "-DFILAMENT_OPENGL_HANDLE_ARENA_SIZE_IN_MB=20"
      "-DSPIRV_WERROR=OFF"
      "-DFILAMENT_USE_EXTERNAL_GLES3=OFF"
      (lib.cmakeFeature "filament_cxx_flags" "")
    ];

    outputs = [ "out" "dev" ];

    doCheck = true;
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "Open3D";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "isl-org";
    repo = "Open3D";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jWjtfDcjDBOQHH4s2e1P8ye19JlucYIZPi0pgvOsdcA=";
    # hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    curl.dev
  ];

  buildInputs = [
    (python3.withPackages (ps: []))
    assimp
    boost
    boringssl
    eigen
    # filament
    fmt
    glew
    glfw
    gtest
    imgui
    jsoncpp
    # liblzf
    libGL
    libjpeg_turbo.dev
    libpng.dev
    msgpack-cxx
    nanoflann
    openblas.dev
    openssl.dev
    qhull
    # TinyGLTF
    tbb
    tinyobjloader
    vtk
    zeromq
    zlib.dev
  ];

  patches = [
    # Dependencies are vendored as ExternalProjects inside Open3d.
    # We want to reuse the dependencies from nixpkgs instead to avoid unnecessary
    # build overhead and to ensure they are up to date.
    # This patch disables the vendored dependencies (by excluding `3rd-party`),
    # finds them inside the build environment and aliases them so they can be accessed
    # without prefixing namespaces.
    # The last step is necessary to keep the patch size to a minimum, otherwise we'd have
    # to add the namespace identifiers everywhere a dependency is used.
    ./windows.patch
  ];

  postPatch = ''
    mv ${filament}/out/ $src/3rdparty/filament
  '';

  cmakeFlags = [
    # Demonstration
    "-DBUILD_SHARED_LIBS=OFF"

    # TODO: Move to passthru tests?
    "-DBUILD_UNIT_TESTS=ON"
    # "-DBUILD_BENCHMARKS=ON"

    # TODO: Temporary
    "-DBUILD_PYTHON_MODULE=OFF"

    # First batch from CMakeLists.txt
    "-DUSE_SYSTEM_ASSIMP=ON"
    "-DUSE_SYSTEM_CURL=ON"
    "-DUSE_SYSTEM_CUTLASS=ON"
    "-DUSE_SYSTEM_EIGEN3=ON"
    "-DUSE_SYSTEM_EMBREE=ON"
    "-DUSE_SYSTEM_FILAMENT=OFF"
    "-DUSE_SYSTEM_FMT=ON"
    "-DUSE_SYSTEM_GLEW=ON"
    "-DUSE_SYSTEM_GLFW=ON"
    "-DUSE_SYSTEM_GOOGLETEST=ON"
    "-DUSE_SYSTEM_IMGUI=ON"
    "-DUSE_SYSTEM_JPEG=ON"
    "-DUSE_SYSTEM_JSONCPP=ON"
    "-DUSE_SYSTEM_LIBLZF=ON"
    "-DUSE_SYSTEM_MSGPACK=ON"
    "-DUSE_SYSTEM_NANOFLANN=ON"
    "-DUSE_SYSTEM_OPENSSL=ON"
    "-DUSE_SYSTEM_PNG=ON"
    "-DUSE_SYSTEM_PYBIND11=ON"
    "-DUSE_SYSTEM_QHULLCPP=ON"
    "-DUSE_SYSTEM_STDGPU=ON"
    "-DUSE_SYSTEM_TBB=ON"
    "-DUSE_SYSTEM_TINYGLTF=ON"
    "-DUSE_SYSTEM_TINYOBJLOADER=ON"
    "-DUSE_SYSTEM_VTK=ON"
    "-DUSE_SYSTEM_ZEROMQ=ON"

    # Sensor options
    # "-DBUILD_LIBREALSENSE=ON"
    "-DUSE_SYSTEM_LIBREALSENSE=ON"
    # "-DBUILD_AZURE_KINECT=ON"

    "-DUSE_BLAS=ON"
    "-DUSE_SYSTEM_BLAS=ON"
  ];
})
