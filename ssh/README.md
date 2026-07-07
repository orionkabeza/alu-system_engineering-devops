# SSH

## Background

A server is a computer (physical or virtual) that provides a service to other
computers ("clients") over a network. Physical servers usually live in
datacenters: purpose-built facilities with redundant power, cooling, and
network connectivity, owned either by a company itself or rented from a cloud
provider. In this project, each student is assigned a remote Ubuntu 20.04
server hosted in such a datacenter, reachable only over the network.

Since the server has no keyboard or screen attached that you can walk up to,
you administer it remotely using **SSH (Secure Shell)**: a network protocol
that opens an encrypted channel between your machine (the client) and the
server, letting you run commands as if you were sitting in front of it. SSH
replaces older, insecure remote-access protocols (like Telnet) that sent
credentials and data in plaintext.

SSH supports two main authentication methods:
- **Password authentication** — you type the remote user's password.
- **Public-key authentication** — you prove your identity using a
  cryptographic key pair instead of a password. This is what this project
  focuses on, since it's more secure (no password to brute-force or leak)
  and can be fully automated (no human needed to type a password).

A key pair consists of:
- A **private key** — stays only on your machine, never shared, ideally
  protected by a passphrase.
- A **public key** — safe to share; you give a copy to any server you want
  to be able to log into. The server stores it in
  `~/.ssh/authorized_keys` for the target user.

When you connect, the server challenges your client to prove it holds the
private key matching a public key it already trusts — without the private
key ever leaving your machine.

## Project Tasks — Step by Step

### 0. Use a private key (`0-use_a_private_key`)

**Goal:** connect to the assigned server using an existing private key.

Steps:
1. Get the server's IP address and username from the intranet's "My
   Servers" section.
2. Write a Bash script that runs `ssh`, pointing it at the private key
   `~/.ssh/school`, connecting as `ubuntu`.
3. Constraint: only single-character `ssh` flags are allowed, and `-l`
   (used to specify the login/remote user) is banned — so the remote user
   must be given via the `user@host` syntax instead.
4. Make the script executable: `chmod +x 0-use_a_private_key`.

Result: running the script drops you into a shell on the remote server
without ever being asked for a password.

### 1. Create an SSH key pair (`1-create_ssh_key_pair`)

**Goal:** generate a new RSA key pair from scratch.

Steps:
1. Write a Bash script that calls `ssh-keygen` to create a key pair.
2. Requirements for the generated key:
   - Private key filename: `school`
   - Key strength: 4096 bits
   - Passphrase: `betty` (set non-interactively, no manual prompt)
3. Make the script executable.
4. Test it in an empty/scratch directory (not inside `~/.ssh`), so it
   doesn't collide with or overwrite the real working key used in Task 0.

Result: running the script produces `school` (private) and `school.pub`
(public) in the current directory, with the fingerprint/randomart printed
to confirm success.

### 2. Client configuration file (`2-ssh_config`)

**Goal:** configure the local SSH client so connecting "just works" with no
manual flags and no password fallback.

Steps:
1. Edit (or create) the local SSH client config at `~/.ssh/config`.
2. Configure it to:
   - Always use `~/.ssh/school` as the identity file.
   - Refuse password authentication entirely (`PasswordAuthentication no`),
     forcing key-based auth only.
3. Copy that config's contents into this repo as the plain-text file
   `2-ssh_config` (this is a config file, not an executable script).
4. Verify with `ssh -v ubuntu@<server-ip>` — the verbose output should show
   the client trying the `school` identity file and authenticating via
   `publickey`, with no password prompt.

### 3. Let me in! (no script — manual server change)

**Goal:** grant another public key access to your server.

Steps:
1. SSH into your server (using Task 0's working setup).
2. Append the given public key to `~/.ssh/authorized_keys` for the `ubuntu`
   user on the server (create the file/directory if it doesn't exist,
   with permissions `700` for `~/.ssh` and `600` for `authorized_keys`).
3. This does not produce a file for this repo's `ssh/` directory — it's a
   server-side change confirmed by whoever needs to log in with that key
   being able to connect successfully.

## Key Concepts to Be Able to Explain

- **What is a server** — a machine providing a service to clients over a
  network; usually lives in a datacenter with redundant power/cooling/network.
- **What is SSH** — an encrypted protocol for securely accessing and
  administering a remote machine's shell.
- **Creating an SSH RSA key pair** — `ssh-keygen -t rsa -b <bits> -f
  <filename>`, producing a private key and a `.pub` public key.
- **Connecting with a key pair** — `ssh -i <private_key> user@host`, or
  configuring `~/.ssh/config` so no flags are needed at all.
- **`#!/usr/bin/env bash` vs `#!/bin/bash`** — `env bash` searches `$PATH`
  for the first `bash` found, making the script portable across systems
  where bash isn't always installed at `/bin/bash`. `/bin/bash` hardcodes a
  path that may not exist or may point to an outdated version on some
  systems.
