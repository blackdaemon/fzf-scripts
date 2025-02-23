<p align="center">
</p>
<p align="center"><h1 align="center"><code>FZF SCRIPTS</code></h1></p>
<p align="center">
	<em><code>Collection of my fzf scripts</code></em>
</p>
<p align="center">
	<!-- local repository, no metadata badges. --></p>
<p align="center">Built with the tools and technologies:</p>
<p align="center">
	<img src="https://img.shields.io/badge/GNU%20Bash-4EAA25.svg?style=default&logo=GNU-Bash&logoColor=white" alt="GNU%20Bash">
	<img src="https://img.shields.io/badge/Docker-2496ED.svg?style=default&logo=Docker&logoColor=white" alt="Docker">
</p>
<br>

##  Table of Contents

- [Overview](#overview)
- [Scripts](#scripts)
  - [ev.sh](#ev-sh)
- [Testing](#testing)
  - [Prerequisites](#prerequisites)
  - [Running tests](#running-tests)

---

##  Overview

Collection of different fzf scripts I created.

---

##  Scripts

### ev.sh

Browse environment variables and then push to commandline:

  - `enter`:  Variable export statement ready to edit (cursor placed after `=`)
  - `tab`:    Variable set statement
  - `ctrl-n`: Variable name
  - `ctrl-v`: Variable value
  - `ctrl-u`: Variable unset statement

To use it, source the `ev.sh` in your .bashrc (or `.zhsrc`) file:

```sh
source path/to/ev.sh
```

Activate in commandline using hotkey `ctrl+alt e`.

The hotkey can be changed at the end of the `ev.sh` script.


##  Testing

The scripts are developed in  `bash` but are compatible with `zsh`. 
To test them from `bash` in `zsh` I use docker image (see [Testing](#testing)).

### Prerequisites

**Using `docker`** &nbsp; [<img align="center" src="https://img.shields.io/badge/Docker-2CA5E0.svg?style={badge_style}&logo=docker&logoColor=white" />](https://www.docker.com/)

### Running tests

To test scripts in zsh shell, run the test zsh docker image:

```sh
tests/test_in_zsh.sh
```
