# kdiff3-apply-colorscheme

Apply the current KDE Plasma color scheme to KDiff3's diff view colors.

- Supports both the native and the Flatpak (`org.kde.kdiff3`) KDiff3
- Backs up `kdiff3rc` before modifying it
- Only touches color keys; all other settings are preserved as-is
- Console output is limited to the applied colors and the write result, one line each

## Requirements

- Python 3 (standard library only)
- KDE Plasma (reads `~/.config/kdeglobals`)

## Installation

```sh
./install.sh                  # install to ~/.local/bin
./install.sh /usr/local/bin   # install to a custom directory (may need sudo)
./install.sh -u               # uninstall
```

## Usage

Close KDiff3 first: it writes its in-memory settings back to `kdiff3rc` on exit, which would overwrite the new colors. The script refuses to run while KDiff3 is running.

```sh
kdiff3-apply-colorscheme              # update every installed KDiff3
kdiff3-apply-colorscheme -t native    # native only
kdiff3-apply-colorscheme -t flatpak   # Flatpak only
kdiff3-apply-colorscheme -n           # dry run: print colors, write nothing
```

Example output:

```
Color scheme: BreezeLight
  FgColor                   #232629
  BgColor                   #ffffff
  DiffBgColor               #e5e5e5
  ...
native:  /home/user/.config/kdiff3rc (backup: kdiff3rc.bak-20261113-144554)
flatpak: not installed
```

In a terminal, a color swatch is shown after each value. Swatches are omitted when output is redirected or `NO_COLOR` is set.

Re-run the script after switching the Plasma color scheme.

## Config file locations

| Variant | Path                                                        |
| ------- | ----------------------------------------------------------- |
| native  | `$XDG_CONFIG_HOME/kdiff3rc` (default `~/.config/kdiff3rc`)  |
| Flatpak | `~/.var/app/org.kde.kdiff3/config/kdiff3rc`                 |

## Color mapping

Colors are taken from `[Colors:View]` and `[Colors:Selection]` in `kdeglobals`; missing keys are filled in from the matching `.colors` scheme file.

| KDiff3 key                     | Source                                          |
| ------------------------------ | ----------------------------------------------- |
| `FgColor`                      | View foreground                                 |
| `BgColor`                      | View background                                 |
| `DiffBgColor`                  | View background mixed with 12% foreground       |
| `CurrentRangeBgColor`          | View background mixed with 15% selection        |
| `CurrentRangeDiffBgColor`      | `DiffBgColor` mixed with 25% selection          |
| `ColorA` / `ColorB` / `ColorC` | Link / Positive / Neutral foreground (readable) |
| `ColorForConflict`             | Negative foreground (readable)                  |
| `ManualAlignmentRangeColor`    | View background mixed with 35% Neutral          |
| `NewestFileColor` / `MidAgeFileColor` / `OldestFileColor` | Positive / Neutral / Negative |
| `MissingFileColor`             | Inactive foreground                             |

"Readable" means: if the contrast against the diff backgrounds is below 3:1, the color is shifted toward white (dark schemes) or black (light schemes) until it reaches 3:1.

## Restoring

Before every write, a backup named `kdiff3rc.bak-YYYYmmdd-HHMMSS` is created in the same directory. If the content would not change, nothing is written and no backup is made. To restore:

```sh
cp ~/.config/kdiff3rc.bak-20261113-144554 ~/.config/kdiff3rc
```
