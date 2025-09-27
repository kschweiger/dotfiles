# Auto-update specified cargo packages
auto_update_cargo_tools() {
  # First, check if cargo command exists
  if ! command -v cargo &> /dev/null; then
    return 0 # Silently exit if cargo is not installed
  fi

  # Exit if no tool names were provided
  if [[ $# -eq 0 ]]; then
    return 0
  fi

  # Use a standard location for the timestamp file
  local last_update_file="$HOME/.local/share/last_cargo_update"
  # Set the interval in seconds (7 days = 604800 seconds)
  local update_interval=604800
  local should_update=false

  # Ensure the directory for the timestamp file exists
  mkdir -p "$(dirname "$last_update_file")"

  # Check if the timestamp file exists
  if [[ ! -f "$last_update_file" ]]; then
    # File doesn't exist, this is the first run.
    should_update=true
  else
    # File exists, check its age.
    local last_update_time
    if [[ "$(uname)" == "Darwin" ]]; then
      last_update_time=$(stat -f "%m" "$last_update_file")
    else
      last_update_time=$(stat -c "%Y" "$last_update_file")
    fi

    local current_time=$(date +%s)
    local time_since_last_update=$((current_time - last_update_time))

    if (( time_since_last_update > update_interval )); then
      should_update=true
    fi
  fi

  if [[ "$should_update" = true ]]; then
    # Ask for confirmation.
    read -q "reply?Would you like to update Cargo packages? [y/N] "
    echo # Move to a new line after input

    if [[ "$reply" =~ ^[Yy]$ ]]; then
      echo "Checking for cargo package updates..."

      # Get the list of all installed packages once to be efficient
      local installed_list
      installed_list=$(cargo install --list)

      # Loop over the tool names passed as arguments
      for name in "$@"; do
        # Check if the package name appears at the start of a line in the list
        if echo "$installed_list" | grep -q "^$name v"; then
          echo "Updating '$name'..."
          if ! cargo install --locked "$name"; then
            echo "Failed to update '$name'."
          fi
        fi
      done
      touch "$last_update_file" # Update timestamp after attempting updates
    else
      echo "Skipping Cargo package update."
    fi
  fi
}

