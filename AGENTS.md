# KSK Project Guidelines

This project manages GPG Key Signing Keys (KSK) in an airgapped environment. When contributing or modifying scripts, please adhere to the following guidelines:

## 1. Environment & Security
*   **Airgapped Environment:** Assume these scripts are executed on a secure, airgapped live Linux system (e.g., Ubuntu). Do not introduce dependencies on network access during key operations.
*   **Strict Permissions:** Any directory or file containing sensitive keys (e.g., `gpg-primary`, `gpg-secondary`, `ksk-secure`, `secondary-secure`) MUST be created with strict permissions. Always use `chmod 700` for directories and appropriate restrictions for files.

## 2. Directory Paths & Variables
*   **Use `KSK_WORKDIR`:** Do not hardcode the home directory (`~/`) for working paths. All scripts should be updated to use the `KSK_WORKDIR` environment variable (which should ideally point to a secure in-memory filesystem like `/dev/shm/ksk_work`). Avoid legacy `~/` references where possible.
*   **Use `ksk.conf`:** Rely on `ksk.conf` for shared configuration and environment variables between scripts.

## 3. Shell Scripting Best Practices
*   Use `bash` and include `#!/bin/bash` or `#!/usr/bin/env bash` in all scripts.
*   Ensure robustness by checking if critical directories or files exist before operating on them, and exit with a clear error message if prerequisites are missing.
*   Avoid using external tools unless they are guaranteed to be present on a base Ubuntu live disk.
