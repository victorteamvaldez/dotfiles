# Daily Use Guide

How to keep apps and configs in sync across machines with this repo — without
exposing anything sensitive to GitHub.

## Mental model

Every top-level folder is a **topic** (`git/`, `slack/`, `docker/`,
`claude-code/`…). Inside a topic, filename conventions do the work:

| Pattern         | What happens                                                        |
| --------------- | ------------------------------------------------------------------- |
| `*.symlink`     | Symlinked into `$HOME` as a dotfile (`zsh/zshrc.symlink` → `~/.zshrc`) |
| `*.zsh`         | Auto-sourced into the shell on every launch                         |
| `install.sh`    | Run by `script/install` — this is where app installs live           |
| `bin/*`         | Every file in `bin/` is added to `$PATH`                            |

## One-time setup (per machine)

Run these **once** when setting up a new Mac:

```sh
git clone git@github.com:<you>/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap      # symlinks *.symlink → ~, and prompts for git name/email
script/install        # runs every topic's install.sh (installs all your apps)
```

- **`script/bootstrap`** — creates symlinks (`~/.zshrc`, `~/.gitconfig`,
  `~/.gitignore`, …) and, on first run, asks for your GitHub name/email to build
  your private `git/gitconfig.local.symlink`.
- **`script/install`** — walks every `topic/install.sh` and Homebrew-installs
  your apps.

## What to run regularly

| When                                        | Command                                | Why                                    |
| ------------------------------------------- | -------------------------------------- | -------------------------------------- |
| Every day, on any machine                   | `cd ~/.dotfiles && git pull`           | Pull configs/apps you added elsewhere  |
| After `git pull` brings **new apps**        | `script/install`                       | Install the new casks                  |
| After `git pull` brings **new `*.symlink`** | `script/bootstrap`                     | Create the new symlinks                |
| After editing a `*.zsh` file                | *(nothing — just open a new shell)*    | `.zsh` files auto-load                 |
| After any change you make                   | `git add … && git commit && git push`  | Sync it up so other machines get it    |

Rule of thumb: **`git pull` daily**, then `script/install` **only** when new
apps arrived. Editing an alias needs nothing but a new terminal tab.

## How to install / sync a new application

Follow the same pattern as the existing Slack, Notion, etc. topics.

**1. Create the topic folder + installer:**

```sh
cd ~/.dotfiles
mkdir myapp
```

**2. Write `myapp/install.sh`:**

```sh
#!/bin/sh

if test ! $(which brew)
    then echo "User must install homebrew first"
        exit 1
fi

brew install --cask myapp   # find the exact name with: brew search myapp
```

**3. Install it now + commit so it syncs:**

```sh
chmod +x myapp/install.sh
sh myapp/install.sh          # install on this machine right now
git add myapp/
git commit -m "Add myapp"
git push
```

On every other machine: `git pull && script/install` and myapp appears.
`script/install` is safe to re-run — Homebrew skips already-installed casks.

> Tip: for CLI tools use `brew install myapp` instead of `brew install --cask myapp`.

## Protecting sensitive information

Three layers, all already wired into this repo:

**1. The `.local` + `.example` pattern (use this for any secret).**
Real secrets live in a `*.local` file that's git-ignored; a sanitized
`*.example` template is what you commit.

- Already in place: `git/gitconfig.local.symlink.example` is committed; the
  filled-in `git/gitconfig.local.symlink` is ignored by `.gitignore`.
- **To protect a new secret file:** name it `something.local`, add it to
  `.gitignore`, and commit only a `something.local.example` with placeholders.

**2. Your global gitignore is versioned and protects every repo.**
`git/gitignore.symlink` → `~/.gitignore`. It already blocks `.DS_Store`, swap
files, and `**/.claude/settings.local.json`. Add patterns here to keep secrets
out of *all* your projects at once.

**3. Real credentials belong in 1Password, not the repo.**
Keep tokens/keys/passwords in 1Password (there's a `1password/` topic) and
reference them, rather than ever committing them. This repo should hold
*config*, never *credentials*.

**Before every `git push`, quick check:**

```sh
git status            # anything ending in .local or with a token? stop.
git diff --staged     # eyeball for keys/emails/tokens
```
