# git-miscellany
<span>
<picture>
    <img src="https://gpg-badge.hesreallyhim.com/hesreallyhim.svg" height="24" />
</picture> &nbsp; &nbsp; <picture>
    <img src="./.github/assets/RITL.svg" height="26"/>
</picture>
</span>

<br/>

Miscellaneous collection of git helpers, utils, aliases.

Not rigorously tested, YMMV, use at your own risk. Mostly using zsh v5.9 on macOS Terminal, FWIW.

## Functions

### `gb_safe`

Check if a branch is fully contained in a target branch (i.e., safe to delete locally - all changes already included). Useful if you've done a rebase or squash and the graph is not obviously linear.

### `git_init_and_switch`

1. Initialize an empty git repository in the current directory.
2. Create an empty initial commit.
3. Add a general-purpose, "kitchen-sink" `.gitignore` file and commit it.
4. Immediately switch over to a development branch.

I basically use this every time I start a new repo - in two seconds, I've set up a clean `main`, and then I jump straight over to a new branch where I can muck about and not worry about messing up the default branch.

### `git_scan_hidden`

Search for any "invisible" characters that may be lurking in some code. Can search by PR number, URL, commit SHA, etc. 


## Hooks

### pre-commit

#### `pre-commit.notebook`

This can be useful when working with Jupyter notebooks, especially authoring notebooks. Basically it "scrubs" the notebooks clean before they are committed (removes/resets outputs, etc.), so that the committed notebook is in a pristine state.  

#### `pre-push.notebook`

This also runs `nb-clean check` on any notebooks in the directory you're working in to make sure that all notebooks are scrubbed all sparkling clean before being published.

---

Excluding imagery, all content is licensed:

GPL-3-or-later 2026 &copy; Really Him
