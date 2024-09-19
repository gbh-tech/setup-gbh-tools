<!-- omit in toc -->
# setup-gbh-tools-action

Install gbh-tech CLI tools.

<!-- omit in toc -->
## Content

- [Usage](#usage)
- [Command-line options](#command-line-options)

## Usage

To install the latest stable versions of Docker CLI, Docker Engine, and their dependencies:

- download the script

```bash
curl -fsSL https://raw.githubusercontent.com/gbh-tech/setup-gbh-tools/main/install.sh -o setup-gbh-tools.sh
```

- verify the script's content

```bash
cat setup-gbh-tools.sh
```

- run the script either as root, or using sudo to perform the installation.

```bash
sudo sh setup-gbh-tools.sh --name envi --version v1.1.0
```

## Command-line options

- `Version`: Use the --version option to install a specific version.
- `name`: Name of the gbh-tool to install
