#!/usr/bin/env bash

set -e


OUTPUT_NAME=$1

ORIGINAL_PWD="$PWD"

TMPDIR="${TMPDIR:-/tmp}"
TARGET_TMP_DIR="$TMPDIR$RND_UID"
mkdir -p $TARGET_TMP_DIR

cd $TARGET_TMP_DIR
git clone https://github.com/protocolbuffers/protobuf.git protobuf
git clone https://github.com/grpc/grpc-java.git grpc-java


cd protobuf
git checkout $PROTOBUF_SHA
git reset --hard
git rev-parse HEAD


cd ../grpc-java
git checkout $GRPC_JAVA_SHA
git reset --hard
git rev-parse HEAD


cp $ORIGINAL_PWD/user.bazelrc .bazelrc
$ORIGINAL_PWD/bazel build --override_repository=com_google_protobuf=$TARGET_TMP_DIR/protobuf compiler:grpc_java_plugin
cp bazel-bin/compiler/grpc_java_plugin $ORIGINAL_PWD/protoc
