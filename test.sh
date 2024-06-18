#!/bin/bash

test_folder="./test"

# Collect ENV from md file
../../scripts/collect_envs.sh ../../../docs/ENVS.md

validate_file() {
    local test_file="$1"

    echo
    echo "🧿 Validating file '$test_file'..."

    dotenv \
        -e $test_file \
            yarn run validate -- --silent

    if [ $? -eq 0 ]; then
        echo "👍 All good!"
        return 0
    else
        echo "🛑 The file is invalid. Please fix errors and run script again."
        echo
        return 1
    fi
}

test_files=($(find "$test_folder" -maxdepth 1 -type f | grep -vE '\/\.env\.common$'))

for file in "${test_files[@]}"; do
    validate_file "$file"
    if [ $? -eq 1 ]; then
        exit 1
    fi
done
