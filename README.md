# Ansible Core Docker Image

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)
[![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=flat&logo=ansible&logoColor=white)](https://www.ansible.com/)

A production-ready Docker image for Ansible Core with HashiCorp Vault support and 10+ pre-installed collections for simple automation, management configuration, and more.

## Features

- **Multiple Ansible Core versions**: Choose between stable (2.18) or latest (2.19)
- **HashiCorp Vault integration**: Built-in `hvac` library for seamless secrets management
- **10+ Pre-installed collections**: Ready-to-use collections
- **Lightweight**: Based on Python slim images
- **CI/CD ready**: Perfect for automated pipelines

## Supported Versions

| Image Tag | Python Version | Ansible Core |
|-----------|----------------|--------------|
| `latest`, `2`, `2.19`, `2.19.4` | 3.12 | 2.19.4 |
| `2.18`, `2.18.11` | 3.11 | 2.18.11 |

## Quick Start

### Basic Usage

Run an Ansible ad-hoc command:

```bash
docker run --rm ghcr.io/optimode/ansible-core:latest ansible --version
```

Run a playbook from your local directory:

```bash
docker run --rm \
  -v $(pwd):/workspace \
  ghcr.io/optimode/ansible-core:latest \
  ansible-playbook playbook.yml
```

### Interactive Shell

Start an interactive session:

```bash
docker run --rm -it \
  -v $(pwd):/workspace \
  ghcr.io/optimode/ansible-core:latest
```

## Pre-installed Collections

This image comes with 15+ Ansible collections covering a wide range of platforms and technologies:

### Container
- **Docker**: `community.docker`
- **Podman**: `containers.podman`

### Databases
- **MySQL**: `community.mysql`
- **PostgreSQL**: `community.postgresql`
- **MongoDB**: `community.mongodb`

### Security & Secrets
- **HashiCorp Vault**: `community.hashi_vault`
- **Cryptography**: `community.crypto`


### Virtualization
- **Proxmox**: `community.proxmox`

<details>
<summary>View complete collection list</summary>

```yaml
ansible.netcommon, ansible.posix, ansible.utils, community.crypto, 
community.dns,community.docker, community.general, community.hashi_vault,
community.mongodb, community.mysql,community.postgresql, community.proxmox, 
community.proxysql,community.routeros, containers.podman,

```
</details>

## Building the Image

### Quick Build

Use the provided build framework: (optibuild)[https://github.com/optimode/optibuild]
Install optibuild, create or modify build.conf file.

Only build: 
```bash
/path/to/optibuild --verbose -c /path/to/ansible-core/build.conf build
```

### Custom Build

Build a specific version, modify build.conf or create an additional build-specific-version.conf file.

```bash
/path/to/optibuild --verbose -c /path/to/ansible-core/build-specific-version.conf build
```

### Build Arguments

| Argument | Description | Required | Default |
|----------|-------------|----------|---------|
| `PYTHON_VERSION` | Python base image version | No | `3.11` |
| `ANSIBLE_VERSION` | Ansible Core version to install | Yes | - |
| `URL` | Project URL (OCI label) | No | - |
| `SOURCE` | Source repository (OCI label) | No | - |
| `BUILD_DATE` | Build timestamp (OCI label) | No | - |
| `AUTHORS` | Image authors (OCI label) | No | - |
| `VENDOR` | Vendor name (OCI label) | No | - |
| `REVISION` | Git commit hash (OCI label) | No | - |

## Advanced Usage

### Using SSH Keys

Mount your SSH keys for remote host access:

```bash
docker run --rm \
  -v $(pwd):/workspace \
  -v ~/.ssh:/home/ansible/.ssh:ro \
  ghcr.io/optimode/ansible-core:latest \
  ansible-playbook -i inventory.ini playbook.yml
```

### Using Ansible Vault

Pass vault password via file:

```bash
docker run --rm \
  -v $(pwd):/workspace \
  -v $(pwd)/.vault-pass:/home/ansible/.vault-pass:ro \
  ghcr.io/optimode/ansible-core:latest \
  ansible-playbook --vault-password-file=/home/ansible/.vault-pass playbook.yml
```

Or via environment variable:

```bash
docker run --rm \
  -v $(pwd):/workspace \
  -e ANSIBLE_VAULT_PASSWORD=mysecret \
  ghcr.io/optimode/ansible-core:latest \
  ansible-playbook playbook.yml
```

### HashiCorp Vault Integration

The image includes `hvac` library for Vault integration. Configure via environment:

```bash
docker run --rm \
  -v $(pwd):/workspace \
  -e VAULT_ADDR=https://vault.example.com:8200 \
  -e VAULT_TOKEN=s.xxxxxxxxxxxxxx \
  ghcr.io/optimode/ansible-core:latest \
  ansible-playbook playbook.yml
```

### Custom Inventory

Use dynamic inventory or custom inventory files:

```bash
docker run --rm \
  -v $(pwd):/workspace \
  ghcr.io/optimode/ansible-core:latest \
  ansible-playbook -i inventory/production.yml deploy.yml
```

### Installing Additional Collections

Install collections at runtime:

```bash
docker run --rm \
  -v $(pwd):/workspace \
  ghcr.io/optimode/ansible-core:latest \
  bash -c "ansible-galaxy collection install my.collection && ansible-playbook playbook.yml"
```

Or build a custom image:

```dockerfile
FROM ghcr.io/optimode/ansible-core:latest

COPY my-collections.yml /tmp/
RUN ansible-galaxy collection install -r /tmp/my-collections.yml
```

### Running as Different User

```bash
docker run --rm \
  --user $(id -u):$(id -g) \
  -v $(pwd):/workspace \
  ghcr.io/optimode/ansible-core:latest \
  ansible-playbook playbook.yml
```

### CI/CD Integration

#### GitHub Actions

```yaml
name: Deploy with Ansible
on: [push]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Ansible Playbook
        run: |
          docker run --rm \
            -v ${{ github.workspace }}:/workspace \
            -e ANSIBLE_VAULT_PASSWORD=${{ secrets.VAULT_PASSWORD }} \
            ghcr.io/optimode/ansible-core:latest \
            ansible-playbook -i inventory/production.yml deploy.yml
```

#### GitLab CI

```yaml
deploy:
  image: ghcr.io/optimode/ansible-core:latest
  script:
    - ansible-playbook -i inventory/production.yml deploy.yml
  only:
    - main
```

### Environment Variables

Common Ansible environment variables you can use:

| Variable | Description | Example |
|----------|-------------|---------|
| `ANSIBLE_CONFIG` | Path to ansible.cfg | `/workspace/ansible.cfg` |
| `ANSIBLE_INVENTORY` | Default inventory path | `/workspace/inventory` |
| `ANSIBLE_VAULT_PASSWORD` | Vault password | `mysecretpass` |
| `ANSIBLE_HOST_KEY_CHECKING` | SSH host key checking | `False` |
| `ANSIBLE_STDOUT_CALLBACK` | Output format | `yaml` |
| `ANSIBLE_FORCE_COLOR` | Force colored output | `true` |
| `VAULT_ADDR` | HashiCorp Vault address | `https://vault:8200` |
| `VAULT_TOKEN` | Vault authentication token | `s.xxxxx` |

## Examples

### Example 1: Simple Playbook Execution

```bash
# Create a simple playbook
cat > playbook.yml <<EOF
---
- hosts: localhost
  tasks:
    - name: Print Ansible version
      debug:
        msg: "Running Ansible {{ ansible_version.full }}"
EOF

# Run it
docker run --rm -v $(pwd):/workspace ghcr.io/optimode/ansible-core:latest \
  ansible-playbook playbook.yml
```

## Installed Packages

### Python Packages

- `ansible` - Full Ansible package with core
- `ansible-lint` - Best practices checker for Ansible
- `hvac` - HashiCorp Vault client library
- `jmespath` - JSON query language for data parsing
- `netaddr` - Network address manipulation
- `docker` - Docker SDK for Python

### System Packages

- `git` - Version control system
- `openssh-client` - SSH client for remote connections
- `sshpass` - Non-interactive SSH password authentication
- `rsync` - Fast file synchronization tool

## Troubleshooting

### Permission Issues

If you encounter permission errors with mounted volumes:

```bash
# Run as your current user
docker run --rm --user $(id -u):$(id -g) -v $(pwd):/workspace ghcr.io/optimode/ansible-core:latest ansible-playbook playbook.yml
```

### SSH Connection Issues

Enable SSH debugging:

```bash
docker run --rm -v $(pwd):/workspace ghcr.io/optimode/ansible-core:latest \
  ansible-playbook -vvv playbook.yml
```

### Collection Not Found

Verify installed collections:

```bash
docker run --rm ghcr.io/optimode/ansible-core:latest ansible-galaxy collection list
```

Install missing collection:

```bash
docker run --rm ghcr.io/optimode/ansible-core:latest \
  ansible-galaxy collection install namespace.collection
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Adding New Collections

To add collections to the base image, update `requirements-collections.yml`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Maintainer

**Optimode** (Laszlo Malina)
GitHub: [@optimode](https://github.com/optimode)

## Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [HashiCorp Vault](https://www.vaultproject.io/)
- [Docker Hub](https://hub.docker.com/)

## Support

If you encounter issues or have questions:

1. Check the [Troubleshooting](#troubleshooting) section
2. Review [Ansible documentation](https://docs.ansible.com/)
3. Open an issue on [GitHub](https://github.com/optimode/ansible-core/issues)

---

**Built with** ❤️ **by Optimode**
