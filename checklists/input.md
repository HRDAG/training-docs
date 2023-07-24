# Input

There are a couple different ways we encode the inputs to a task, depending on what's \
appropriate for the project.

### Everyone shares I/O
Ideally, we'd all be able to push/pull updates to input files and be sure we're looking\
at the same content, which means tracking recreatable I/O with version control tools \
like `snap` or `git`.

In general, we prefer to use `snap` for buildable input/ and \
output/ files when the project team shares access to our server, and we track our other \
dependencies like src/ code, Makefiles, and project framework with `git`.

When everyone working in the repo has access to `snap`:
- [] Upstream input is symbolically linked into `task/input/`
- [] Activate symlink has been included in a `snap push` call

### Everyone recreates I/O
When project visibility is flexible and/or the team has inconsistent server access, we \
can use `git` to track the project's **initial input/** files and setup downstream \
Makefiles to look for upstream outputs.

When project structure is likely to change, relative paths are the least brittle:
- [] Ex) via relative path
    ```
    input := ../import/output/mentions.parquet
    ```

Sometimes, the dependency is sufficiently "far" away in the overall structure, and it's \
easier to point directly to it:
- [] Ex) via project root
    ```
    HERE := $(shell git rev-parse --show-toplevel)
    input := $(HERE)/import/output/mentions.parquet
    ```

# done.
