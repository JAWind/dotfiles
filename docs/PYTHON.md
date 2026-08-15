# Python (uv)

Python is managed entirely by [uv](https://docs.astral.sh/uv/) — a single, fast
tool that handles interpreter versions, virtual environments, packages, and
command-line tools. There is no Homebrew/system Python in this setup; uv
provides the interpreters. In the editor, **Ruff** and **pylsp** give you
linting/formatting and code intelligence (see [NEOVIM.md](NEOVIM.md)).

## Python versions

```sh
uv python install 3.13     # download and install a Python
uv python list             # list installed / available versions
uv python pin 3.13         # write .python-version for the current project
```

uv installs standalone Python builds under `~/.local/share/uv` — no admin, and
independent of anything the OS ships.

## Projects (the normal workflow)

```sh
uv init myapp              # create a new project (pyproject.toml, .python-version)
cd myapp
uv add requests            # add a dependency (updates pyproject.toml + uv.lock, installs)
uv add --dev pytest ruff   # add dev-only dependencies
uv remove requests         # drop a dependency
uv sync                    # install exactly what's in uv.lock (e.g. after cloning)
uv run python app.py       # run inside the project's venv (no activate needed)
uv run pytest              # run any tool/command in the project env
```

uv creates and manages the project's virtual environment in `.venv/`
automatically — `uv run` uses it without you activating anything. If you prefer
an activated shell: `source .venv/bin/activate`.

## Ad-hoc environments

Not every task needs a full project:

```sh
uv venv                    # create a .venv here
uv pip install httpx       # fast, pip-compatible install into it
```

## Command-line tools (pipx-style)

```sh
uvx ruff check .           # run a tool once, in a throwaway env
uv tool install ruff       # install a tool onto your PATH
uv tool list               # list installed tools
```

## Single-file scripts

uv can run a script with its dependencies declared inline (PEP 723):

```python
# script.py
# /// script
# dependencies = ["rich"]
# ///
from rich import print
print("[bold green]hello[/]")
```

```sh
uv run script.py           # uv resolves + runs in a temp env
```

## Linting & formatting (Ruff)

**Ruff** is the linter/formatter, and it's wired into Neovim as a language
server, so diagnostics appear as you edit and `<leader>ca` offers fixes. From
the command line:

```sh
uvx ruff check .           # lint
uvx ruff check --fix .     # lint and auto-fix
uvx ruff format .          # format
```

Configure Ruff per project in `pyproject.toml`:

```toml
[tool.ruff]
line-length = 88

[tool.ruff.lint]
select = ["E", "F", "I"]   # errors, pyflakes, import sorting
```

## Editor integration

Neovim uses **pylsp** for code intelligence (completion, hover, go-to-def) and
**Ruff** for linting/formatting — both node-free, installed automatically by
Mason on first launch. pylsp's own linters are turned off so Ruff owns
diagnostics. Details in [NEOVIM.md](NEOVIM.md#language-servers).

## Where uv stores things

| Path                          | Contents                          |
|-------------------------------|-----------------------------------|
| `~/.local/share/uv/`          | installed Pythons, tool envs, cache |
| `<project>/.venv/`            | the project's virtual environment |
| `<project>/uv.lock`           | the resolved, pinned dependency lock |

## More

uv does much more (workspaces, build/publish, dependency groups). Full docs:
<https://docs.astral.sh/uv/>.
