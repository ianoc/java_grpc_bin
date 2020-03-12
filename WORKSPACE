workspace(name = "java_grpc_bin")

BAZEL_VERSION = "2.1.1"
BAZEL_INSTALLER_VERSION_linux_SHA = "d6cea18d59e9c90c7ec417b2645834f968132de16d0022c7439b1e60438eb8c9"
BAZEL_INSTALLER_VERSION_darwin_SHA = "b4c94148f52854b89cff5de38a9eeeb4b0bcb3fb3a027330c46c468d9ea0898b"

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

load("//3rdparty:target_file.bzl", "build_external_workspace")
build_external_workspace("third_party_jvm")

load("//3rdparty:workspace.bzl", "maven_dependencies")
maven_dependencies()

