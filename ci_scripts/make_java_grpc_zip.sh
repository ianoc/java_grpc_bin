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
./bazel run src/main/java/net/ianoc/javagrpcbin:EditorMain -- $TARGET_TMP_DIR/grpc-java/compiler/BUILD

cd $TARGET_TMP_DIR/grpc-java

cp $ORIGINAL_PWD/injectable_resources/protoc.bzl .

mkdir protoc_binaries

cp $ORIGINAL_PWD/injectable_resources/BUILD_CONTENTS_FOR_PROTOC_BINARIES protoc_binaries/BUILD


cp $ORIGINAL_PWD/downloads/protoc-linux protoc_binaries/protoc-linux
chmod +x protoc_binaries/protoc-linux

cp $ORIGINAL_PWD/downloads/protoc-macos protoc_binaries/protoc-macos
chmod +x protoc_binaries/protoc-macos

zip -r $ORIGINAL_PWD/grpc-java.zip *

+cd $ORIGINAL_PWD
+GENERATED_SHA_256=$(shasum -a 256 grpc-java.zip | awk '{print $1}')
+echo $GENERATED_SHA_256 > grpc-java.zip.sha256
