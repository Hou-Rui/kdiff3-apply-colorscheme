# AGENTS.md

## Project

A single-file Python script, `kdiff3-apply-colorscheme`, that reads the current KDE Plasma color scheme and writes it into KDiff3's `kdiff3rc` (both native and Flatpak variants).

| File                        | Purpose                                        |
| --------------------------- | ---------------------------------------------- |
| `kdiff3-apply-colorscheme`  | Main script (no extension, directly executable) |
| `install.sh`                | POSIX sh installer, defaults to `~/.local/bin` |
| `README.md`                 | User documentation, including the color mapping table |

## Constraints

- Keep it a single file using only the Python standard library; no third-party dependencies.
- Do not use `configparser` to read or write kdiff3rc (it changes key case and cannot handle `[A][B]` nested groups or escaped values). Read with `parse_kconfig`; write with `update_section`, which replaces lines in place and only changes color keys in `[KDiff3 Options]`. All other lines (including binary escaped values such as `mainWindow-state`) must stay byte-for-byte identical.
- Always back up before writing (`kdiff3rc.bak-<timestamp>`); if the content is unchanged, do not write and do not back up.
- Refuse to write while KDiff3 is running (it overwrites the config on exit).
- Console output: concise, one line per item, no emoji. ANSI swatches only on a TTY and when `NO_COLOR` is unset. Error messages go to stderr and start with `error:`.
- When changing the color mapping (`build_kdiff3_colors`), update the mapping table in `README.md` accordingly.

## Testing

Never test against the real `~/.config/kdiff3rc`; use a temporary HOME:

```sh
T=$(mktemp -d); mkdir -p "$T/.config"
cp ~/.config/kdiff3rc "$T/.config/"
printf '[General]\nColorScheme=BreezeLight\n' > "$T/.config/kdeglobals"
HOME=$T XDG_CONFIG_HOME= ./kdiff3-apply-colorscheme -t native
diff ~/.config/kdiff3rc "$T/.config/kdiff3rc"   # only color lines should differ
HOME=$T XDG_CONFIG_HOME= ./kdiff3-apply-colorscheme -t native   # should print (unchanged)
rm -rf "$T"
```

Use `-n` (dry run) to inspect computed colors only. Syntax checks (avoid `py_compile`, it leaves a `__pycache__` behind):

```sh
python3 -c 'import ast,sys; ast.parse(open(sys.argv[1]).read())' kdiff3-apply-colorscheme
shellcheck install.sh
```
