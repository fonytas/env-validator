#!/bin/sh

# Function to retrieve the value of variables from the ENV.md file
# It will read the input file, extract all the values of the column named Variable
# It will copy the the values, and save to a file named .env.registry
# The file will be used to validate the environment variables
retrieve_env() {
    output_file=".env.registry"
    input_file="./docs/ENV.md"

    # Check if the input file exists
    if [ ! -f $input_file ]; then
        echo "File $input_file not found"
        exit 1
    fi

    # Check if the output file exists
    if [ -f $output_file ]; then
        rm $output_file
    fi

    # Read the input MD file, and get only the values of the column named Variable and copy to the output file
    cat $input_file | grep -E '^\| [a-zA-Z0-9_]+ ' | awk -F "|" '{gsub(/ /,"",$2); if($2 != "Variable") print $2}' > $output_file
}

retrieve_env