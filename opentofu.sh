#!/bin/bash
tofu fmt

# Save the current working directory
current_dir=$(pwd)
echo "Current working directory: $current_dir"

# Function to find possible modules directories
find_modules_dirs() {
  local dir="$1"
  local modules_dirs=()
  while [ "$dir" != "/" ]; do
    if [ -d "$dir/modules" ]; then
      modules_dirs+=("$dir/modules")
    fi
    dir=$(dirname "$dir")
  done
  echo "${modules_dirs[@]}"
}

# Find possible modules directories
modules_dirs=($(find_modules_dirs "$current_dir"))

# If multiple modules directories are found, let the user choose
if [ ${#modules_dirs[@]} -gt 1 ]; then
  echo "Multiple modules directories found. Please select one:"
  select selected_dir in "${modules_dirs[@]}"; do
    if [ -n "$selected_dir" ]; then
      modules_dir="$selected_dir"
      break
    else
      echo "Invalid selection. Please try again."
    fi
  done
elif [ ${#modules_dirs[@]} -eq 1 ]; then
  modules_dir="${modules_dirs[0]}"
else
  echo "Modules directory not found. Continuing without mounting modules directory."
  modules_dir=""
fi

if [ -n "$modules_dir" ]; then
  echo "Selected modules directory: $modules_dir"
  docker_command="docker run --platform linux/amd64 -it --rm \
    -v \"$current_dir:/workspace\" \
    -v \"$modules_dir:/modules\" \
    -v ~/.aws:/root/.aws \
    opentofu-env /bin/bash -c 'echo /workspace; ls -R /workspace; echo /modules; ls -R /modules; tofu init && tofu plan'"
else
  docker_command="docker run --platform linux/amd64 -it --rm \
    -v \"$current_dir:/workspace\" \
    -v ~/.aws:/root/.aws \
    opentofu-env /bin/bash -c 'echo /workspace; ls -R /workspace; tofu init && tofu plan'"
fi

# Execute Docker command
echo "Executing Docker command:"
eval $docker_command