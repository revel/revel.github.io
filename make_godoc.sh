#!/bin/bash

go run docfile.go  \
    -templates $GOPATH/revel.github.io/docs/godoc \
    -out $GOPATH/github.com/revel/revel.github.io/docs \
    github.com/revel/revel/*.go