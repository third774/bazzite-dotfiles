# bazzite-dotfiles

Bazzite/Linux dotfiles arranged to mirror their paths under `$HOME`.

## Layout

Put managed files and directories beneath `home/`, preserving their destination path:

```text
home/
├── .config/
│   └── ghostty/
├── .local/
│   └── bin/
└── .bashrc
```

For example, `home/.config/ghostty` is linked to `$HOME/.config/ghostty`.

## Install

Run:

```sh
./install.sh
```

The installer recursively links entries from `home/`. It preserves existing real directories such as `$HOME/.config`, but refuses to replace files or symlinks that point somewhere else.
