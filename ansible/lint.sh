#!/bin/bash

#cmd=$(ansible-lint --format pep8 -v --show-relpath --force-color  roles/ --exclude roles/datadog.datadog)

set -e

print_center() {
  echo ""
  # avoids exit code != 0 when  there is no interactive terminal (e.g. in pipelines)
  if [ -t 1 ] && [ -n "$TERM" ]; then
    termwidth="$(tput cols)"
  else
    termwidth=80
  fi

  padding="$(printf '%0.1s' -{1..500})"
  printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

lint() {
  ansible-lint --format pep8 -v --show-relpath \
                --force-color  "$1"
}

# Lint playbooks
for file in ./*.playbook.yml; do

    f=$(basename "$file")

    print_center "Linting Playbook: $(basename "$f")"
    lint "$f"
done

# Lint roles (linting might be redundant, but whatever)
for subdir in roles/*; do
    if [ -d "$subdir" ]; then
        print_center "Linting Role: $(basename "$subdir")"
        role="roles/$(basename "$subdir")"
        lint $role
    fi
done
