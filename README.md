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

### `git_scan_hidden`

Search for any "invisible" characters that may be lurking in some code. Can search by PR number, URL, commit SHA, etc. 

### `gb_safe`

Check if a branch is fully contained in a target branch (i.e., safe to delete locally - all changes already included). Useful if you've done a rebase or squash and the graph is not obviously linear.

---

Excluding imagery, all content is licensed:

GPL-3-or-later 2026 &copy; Really Him
