# TODO

## In Progress

- [ ] Implement Script Library architecture (see SPEC.md)

## Implementation Tasks

- [ ] Create `lib/common.sh` — shared debug + config utilities
- [ ] Create `scripts.sh` — Script Library overview command (`scripts` / `scripts --debug`)
- [ ] Create master `setup.sh` — PATH loop + tool delegation
- [ ] Create `blog/setup.sh` — XDG config writer for blog tool
- [ ] Create `blog/new.sh` — create new Hugo page bundle
- [ ] Create `blog/publish.sh` — git add/commit/push blog repo
- [ ] Wire `blog/setup.sh` into master `setup.sh`
- [ ] Remove `variablestore.sh` and fix `mk-claude-project.sh` dependency

## Wishlist / Backlog

- [ ] claude projects should have git initialised with first commit, empty TODO, empty SPEC
- [ ] Make the jlink flasher available with XDG config files
- [ ] Can JLink detect and confirm that the target device matches the given MCU?
- [ ] `list-scripts.sh` breaks on change of directory — fix
- [ ] Easy navigation of the file system when creating repomix
- [ ] What is `sh` and why does that prevent needing to give admin permissions (docs)
