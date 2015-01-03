#!/bin/bash

echo "GOPATH="
echo $GOPATH

go run docfile.go  \
    -templates $GOPATH/src/github.com/revel.github.io/docs/godoc \
    -out $GOPATH/src/github.com/revel/revel.github.io/docs \
    $GOPATH/src/github.com/revel/revel/*.go