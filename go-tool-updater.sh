#!/bin/bash

# Ensure Go is installed
if ! command -v go &> /dev/null; then
    echo "Error: Go is not installed. Please install Go first."
    exit 1
fi

# List of Go tools to update with their command names for version checking
declare -A tools=(
    ["github.com/golang/dep/cmd/dep"]="dep"
    ["golang.org/x/tools/cmd/goimports"]="goimports"
    ["github.com/golangci/golangci-lint/cmd/golangci-lint"]="golangci-lint"
    ["github.com/go-delve/delve/cmd/dlv"]="dlv"
    ["github.com/goreleaser/goreleaser"]="goreleaser"
    ["github.com/spf13/cobra-cli"]="cobra-cli"
    ["github.com/spf13/viper"]="viper" # Note: viper is a library, not a CLI tool
)

# Track update status
updated=0
failed=0

echo "Starting Go tools update process..."
echo "-----------------------------------"

# Update each tool
for tool in "${!tools[@]}"; do
    cmd_name="${tools[$tool]}"
    echo -n "Updating $tool ($cmd_name)..."

    # Get current version (if applicable)
    if command -v "$cmd_name" &> /dev/null; then
        current_version=$("$cmd_name" --version 2>&1 | head -n 1)
        echo -n " (Current: ${current_version:-unknown})"
    fi

    # Attempt to update
    if go install "$tool@latest" &> /dev/null; then
        # Verify update by checking new version (if applicable)
        if command -v "$cmd_name" &> /dev/null; then
            new_version=$("$cmd_name" --version 2>&1 | head -n 1)
            echo " ✓ Updated to ${new_version:-latest}"
            ((updated++))
        else
            echo " ✓ Installed (no version info)"
            ((updated++))
        fi
    else
        echo " ✗ Failed to update"
        ((failed++))
    fi
done

echo "-----------------------------------"
echo "Update Summary:"
echo "Successfully updated: $updated tool(s)"
echo "Failed updates: $failed tool(s)"

# Exit with appropriate status code
if [ $failed -eq 0 ]; then
    echo "All Go tools processed successfully!"
    exit 0
else
    echo "Some updates failed. Please check the output above for details."
    exit 1
fi
