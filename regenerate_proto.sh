#!/usr/bin/env sh

# compile protobufs for go server
mkdir -p server/pkg
protoc -I protos/ --go_out=server/pkg/protos --go_opt=paths=source_relative --go-grpc_out=server/pkg/protos --go-grpc_opt=paths=source_relative calendar.proto

# compile protobus for cpp client
mkdir -p firmware/lib/protos
protoc -I protos/ --plugin=$HOME/src/common/nanopb/generator/protoc-gen-nanopb --nanopb_out=firmware/lib/protos calendar.proto