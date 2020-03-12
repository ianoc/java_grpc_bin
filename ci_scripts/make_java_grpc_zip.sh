#!/usr/bin/env bash

set -e

ORIGINAL_PWD="$PWD"

TMPDIR="${TMPDIR:-/tmp}"
TARGET_TMP_DIR="$TMPDIR$RND_UID"
mkdir -p $TARGET_TMP_DIR

cd $TARGET_TMP_DIR
git clone https://github.com/grpc/grpc-java.git grpc-java
cd grpc-java
git checkout $GRPC_JAVA_SHA
git reset --hard
git rev-parse HEAD
rm -rf .git



cd $ORIGINAL_PWD
./bazel run src/main/java/net/ianoc/javagrpcbin:EditorMain -- $TARGET_TMP_DIR/grpc-java/compiler/BUILD.bazel

cd $TARGET_TMP_DIR/grpc-java

mkdir plugin_binaries

cp $ORIGINAL_PWD/injectable_resources/BUILD_CONTENTS_FOR_PLUGIN_BINARIES plugin_binaries/BUILD
cp $ORIGINAL_PWD/injectable_resources/grpc_plugin.bzl plugin_binaries/
cp $ORIGINAL_PWD/downloads/protoc_grpc_java_plugin-linux plugin_binaries/protoc_grpc_java_plugin-linux
chmod +x plugin_binaries/protoc_grpc_java_plugin-linux

cp $ORIGINAL_PWD/downloads/protoc_grpc_java_plugin-macos plugin_binaries/protoc_grpc_java_plugin-macos
chmod +x plugin_binaries/protoc_grpc_java_plugin-macos

zip -r $ORIGINAL_PWD/grpc-java.zip *

+cd $ORIGINAL_PWD
+GENERATED_SHA_256=$(shasum -a 256 grpc-java.zip | awk '{print $1}')
+echo $GENERATED_SHA_256 > grpc-java.zip.sha256
