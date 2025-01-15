{
  lib,
  buildGoModule,
}:

let
  fs = lib.fileset;
in
buildGoModule rec {
  pname = "confgen";
  version = "0.0.0";

  src = ./..;

  vendorHash = "sha256-m8KF2QgHTQMlsP+OZOQtd3FZiKWz6mHM6GX5sfh2ylQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  env.CGO_ENABLED = 0;
}
