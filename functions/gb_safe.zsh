gbsafe() {
  # Is branch fully contained in target branch?
  # (i.e., safe to delete locally)
  # Useful if you've done a rebase or squash
  # and the graph is not obviously linear.
  local branch="${1:-HEAD}"
  local target="${2:-origin/main}"

  if git cherry -v "$target" "$branch" | grep -q '^\+'; then
    echo "NOT safe to delete ($branch has commits not in $target)"
    return 1
  else
    echo "Safe to delete ($branch fully merged into $target)"
    return 0
  fi
}
