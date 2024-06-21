#!/bin/sh

# Function to retrieve the value of variables from the ENV.md file
# It will read the input file, extract all the values of the column named Variable
# It will copy the the values, and save to a file named .env.registry
# The file will be used to validate the environment variables
retrieve_env() {
      echo "🔦 Retrieving env..."
    {
      output_file=".env.registry"
      input_file="./docs/ENV.md"

      # Check if the input file exists
      if [ ! -f $input_file ]; then
          echo "🛑 File $input_file not found 🛑"
          exit 1
      fi

      # Check if the output file exists
      if [ -f $output_file ]; then
          rm $output_file
      fi

      # Read the input MD file, and get only the values of the column named Variable and copy to the output file
      cat $input_file | grep -E '^\| [a-zA-Z0-9_]+ ' | awk -F "|" '{gsub(/ /,"",$2); if($2 != "Variable") print $2}' > $output_file

      # Check if the output file is created
      if [ ! -f $output_file ]; then
          echo "🛑 An error occurred while creating $output_file file 🛑"
          exit 1
      fi
    } || {
        echo "🛑 An error occurred while retrieving environment variables. 🛑"
        exit 1
    }
}

validate_env() {
    echo "🚂💨 Start validating..."
    echo "---------------------------------"

    # Check if all the env from ./app/envs/.env.development file are present in .env.registry
    # each env from the .env.registry file should split by = and get the first element
    missing_envs=""
    while IFS= read -r line
    do
      if ! grep -q "^$(echo "$line" | cut -d '=' -f 1)" .env.registry; then
      echo " Missing env in /docs/ENV.md: $(echo "$line" | cut -d '=' -f 1)"
      missing_envs+="$(echo "$line" | cut -d '=' -f 1)\n"
      fi
    done < "/app/envs/.env.development"

    if [ -n "$missing_envs" ]; then
      echo "---------------------------------"
      echo "🛑 Please put all these ENV to /docs/ENV.md🛑"
      exit 1
    fi

    echo "✅ Passed validation"
}

retrieve_env

validate_env
