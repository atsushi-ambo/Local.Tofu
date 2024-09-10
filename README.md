# OpenTofu Docker Environment and Configuration for Macbook

This repository provides a Docker environment for working with OpenTofu, as well as instructions for configuring your `.zshrc` to streamline your workflow.

## Setup Instructions for Docker Environment

1. **Build the Docker Image:**

   Use the following command to build the Docker image. Ensure the path points to your local OpenTofu directory:

   ```sh
   docker build --platform linux/amd64 -t opentofu-env ~/yourrepo/
   ```

2. **Environment Details:**

   - **Base Image:** Ubuntu 22.04
   - **Dependencies:** curl, gnupg, lsb-release, git
   - **OpenTofu Installation:** Automated via script from [OpenTofu](https://get.opentofu.org)

3. **Working Directory:**

   The working directory inside the container is set to `/workspace`.

4. **Entrypoint:**

   By default, the container runs:
   ```sh
   tofu init && tofu plan
   ```

## Script Details

The provided script (`opentofu.sh`) automates the setup and execution process:

1. **Format with `tofu fmt`:**

   Ensures your configuration files are properly formatted.

2. **Identify Modules Directories:**

   The script searches for `modules` directories in the current working directory hierarchy.

3. **Docker Run Command:**

   Depending on whether a `modules` directory is found, it executes Docker with mounted volumes:

   - Current directory (`/workspace`)
   - Found `modules` directory (optional)
   - AWS credentials (`~/.aws`)

   Example with modules:
   ```sh
   docker run --platform linux/amd64 -it --rm \
     -v "$current_dir:/workspace" \
     -v "$modules_dir:/modules" \
     -v ~/.aws:/root/.aws \
     opentofu-env /bin/bash -c 'echo /workspace; ls -R /workspace; echo /modules; ls -R /modules; tofu init && tofu plan'
   ```

## Usage

1. **Execute the Script:**

   Run the shell script to automatically find modules directories and execute the Docker container:

   ```sh
   ./opentofu.sh
   ```

2. **Customizing the Script:**

   Modify the script as necessary for your specific environment and requirements.

## Notes

- Ensure Docker is installed and running on your machine.
- The script assumes AWS credentials are stored at `~/.aws`.
- Adjust paths and configurations as per your project structure.

## Configuration Instructions for `.zshrc`

To ensure a smooth experience with OpenTofu, you may need to modify your `.zshrc` file. Below are the recommended steps and configurations.

### Modifying `.zshrc`

1. **Open `.zshrc` File:**

   Use a text editor to open your `.zshrc` file. You can use `nano`, `vim`, or any editor of your choice:

   ```sh
   nano ~/.zshrc
   ```

2. **Add OpenTofu Alias:**

   Add the following alias to your `.zshrc` to quickly run your OpenTofu script:

   ```sh
   # OpenTofu alias
   alias tofuplan="~/yourrepo/opentofu.sh"
   ```
3. **Save and Close the File:**

   After making the changes, save the file (`CTRL + O` in `nano`, `:wq` in `vim`) and close it.

4. **Apply Changes:**

   Reload the `.zshrc` file to apply your changes without restarting the terminal:

   ```sh
   source ~/.zshrc
   ```

By adding these configurations, you streamline your workflow and enable quick access to OpenTofu commands. Adjust as needed for your personal setup.
