# Auto-update Homebrew packages with confirmation
auto_update_brew() {
  # First, check if brew command exists
  if ! command -v brew &> /dev/null; then
    return 0 # Silently exit if brew is not installed
  fi

  # Use a standard location for the timestamp file
  local last_update_file="$HOME/.local/share/last_brew_update"
  # Set the interval in seconds (7 days = 604800 seconds)
  local update_interval=604800

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
    # Ask for confirmation. -q reads one character. `reply` is the default variable.
    read -q "reply?Would you like to update Homebrew? [y/N] "
    echo # Move to a new line after input

    # Proceed if the user entered 'y' or 'Y'
    if [[ "$reply" =~ ^[Yy]$ ]]; then
      echo "Updating Homebrew..."
      if brew update && brew upgrade; then
        echo "Homebrew update successful."
        touch "$last_update_file" # Update timestamp on success
      else
        echo "Homebrew update failed."
      fi
    else
      echo "Skipping Homebrew update."
    fi
  fi
}
