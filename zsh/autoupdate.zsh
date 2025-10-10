# Generic auto-update function
# Arguments:
# 1: Name of the tool (e.g., "Homebrew")
# 2: Command to check for existence (e.g., "brew")
# 3: The full update command to run (e.g., "brew update && brew upgrade")
# 4: Filename for the timestamp (e.g., "last_brew_update")
_auto_update() {
  local name="$1"
  local check_cmd="$2"
  local update_cmd="$3"
  local timestamp_filename="$4"
  local should_update=false

  # First, check if the command exists
  if ! command -v "$check_cmd" &> /dev/null; then
    return 0 # Silently exit if not installed
  fi

  # Use a standard location for the timestamp file
  local last_update_file="$HOME/.local/share/$timestamp_filename"
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
    read -q "reply?Would you like to update $name? [y/N] "
    echo # Move to a new line after input

    # Proceed if the user entered 'y' or 'Y'
    if [[ "$reply" =~ ^[Yy]$ ]]; then
      echo "Updating $name..."
      if eval "$update_cmd"; then
        echo "$name update successful."
        touch "$last_update_file" # Update timestamp on success
      else
        echo "$name update failed."
      fi
    else
      echo "Skipping $name update."
    fi
  fi
}

# Auto-update Homebrew packages with confirmation
auto_update_brew() {
  _auto_update "Homebrew" "brew" "brew update && brew upgrade" "last_brew_update"
}
# Auto-update Homebrew packages with confirmation
auto_update_pyenv() {
  _auto_update "pyenv" "pyenv" "pyenv update" "last_pyenv_update"
}
