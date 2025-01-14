#!/bin/bash

# List of Go tools to update
tools=(
    "github.com/golang/dep/cmd/dep"
    "golang.org/x/tools/cmd/goimports"
    "github.com/golangci/golangci-lint/cmd/golangci-lint"
    "github.com/go-delve/delve/cmd/dlv"
    "github.com/goreleaser/goreleaser"
    "github.com/spf13/cobra/cobra"
    "github.com/spf13/viper"
)

# Update each tool
for tool in "${tools[@]}"; do
    echo "Updating $tool..."
    go get -u "$tool"
done

echo "All Go tools have been updated successfully!"
