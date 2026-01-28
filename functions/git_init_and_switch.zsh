git_init_and_switch() {
  # 1) Init an empty repo and immediately make an empty commit
  # 2) Add a "kitchen-sink" .gitignore file and commit that
  # 3) Immediately switch over to a develop branch

  # Don’t proceed if already a git repo
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Already inside a git repo; aborting." >&2
    return 1
  fi

  # Just make your ceremonial "Initial Commit" before doing anything stupid
  git init || return 1
  git commit -m "Initial Commit" --allow-empty || return 1

  # Grab a general-purpose .gitignore template and chuck it in.
  # After all, who cares if your Python project has 
  # `.node_modules` in the .gitignore?
  # All your coworkers are robots anyway.
  local template="./.gitignore.example"
  if [[ ! -f "$template" ]]; then
    echo "Missing gitignore template: $template" >&2
    return 1
  fi

  cat "$template" > .gitignore

  # Commit the .gitignore
  git add .gitignore
  git commit -m "chore: add gitignore" || return 1

  # Immediately switch over to another branch.
  # Now you can do whatever you want and main will stay pristine.
  git checkout -b develop
}
