{ pkgs }:
with pkgs;
mkShell {
  buildInputs = [ ]
    ++ lib.optionals stdenv.isDarwin [ ];

  nativeBuildInputs =
    lib.optional stdenv.isLinux pkgs.inotify-tools ++
    lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      CoreFoundation
      CoreServices
    ]) ++
    [
      gnumake
      readline
      openssl
      zlib
      libxml2
      glibcLocales

      # Rust Language Support
      (rust-bin.stable.latest.default.override {
        extensions = [
          "rust-src"
          "rust-analysis"
          "clippy"
        ];
      })
      cargo-edit

      # Elixir Language Support
      beamPackages.erlang
      beamPackages.elixir_1_13
      beamPackages.elixir_ls
    ];

  shellHook = ''
    # Set up `mix` to save dependencies to the local directory
    mkdir -p .nix-mix
    mkdir -p .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH

    export LANG=en_US.UTF-8
    export ERL_AFLAGS="-kernel shell_history enabled"
  '';
}
