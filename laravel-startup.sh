#!/bin/bash
# FROM: https://blog.devsense.com/2022/laravel-on-docker/
# PURPOSE: Create Laravel project and inject VSCode PHP Tools extension
# USAGE: ./create-laravel-app.sh <app-name>

set -euo pipefail

# ---- helpers ---------------------------------------------------------------

# insert_after_line_once <file> <match_string>
# Reads the insert block from STDIN (heredoc). Works with multi-line text on macOS.
insert_after_line_once() {
  local file="$1"
  local match="$2"

  if [ ! -f "$file" ]; then
    echo "Error: File not found: $file" >&2
    return 1
  fi

  if ! grep -Fq -- "$match" "$file"; then
    echo "Warn: match string not found in $file -> '$match'"
    return 0
  fi

  # Capture STDIN (the insert block) into a temp file
  local ins_tmp
  ins_tmp="$(mktemp)"
  cat > "$ins_tmp"

  # Optional light dedupe: if the first non-empty line already appears
  # right after the match, you could enhance this, but keeping it simple here.

  # Read the insert file first (FNR==NR) to assemble the full block in 'ins',
  # then process the target file, printing 'ins' right after the match line.
  awk -v m="$match" '
    FNR==NR {
      ins = (NR==1 ? $0 : ins ORS $0)
      next
    }
    index($0, m) { print; print ins; next }
    { print }
  ' "$ins_tmp" "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"

  rm -f "$ins_tmp"
  echo "Inserted into $file after: $match"
}


# ---- main ------------------------------------------------------------------

if [ $# -lt 1 ]; then
  echo "Usage: $0 <app-name>"
  echo "Example: $0 example-app"
  exit 1
fi

APP_NAME="$1"

echo "Creating Laravel app: $APP_NAME ..."
curl -s "https://laravel.build/${APP_NAME}?with=mysql,redis&devcontainer" | bash

FILE="$APP_NAME/.devcontainer/devcontainer.json"
# Ensure target file exists before editing
if [ ! -f "$FILE" ]; then
  echo "Error: File not found at $FILE"
  exit 1
fi

# 1) Insert VS Code PHP Tools extension after the extensions array opener
echo '				"DEVSENSE.phptools-vscode",' | insert_after_line_once "$FILE" '"extensions": ['

awk '
  /"postCreateCommand"/ {
    # Ensure the line ends with a comma
    if ($0 !~ /, *$/) {
      sub(/ *$/, ",")
    }
    print
    print "\t\"postStartCommand\": \"composer require --dev barryvdh/laravel-ide-helper\""
    next
  }
  { print }
' "$FILE" > "${FILE}.tmp" && mv "${FILE}.tmp" "$FILE"

FILE="$APP_NAME/composer.json"
# Ensure target file exists before editing
if [ ! -f "$FILE" ]; then
  echo "Error: File not found at $FILE"
  exit 1
fi

# 2) Enable PHP auto-completions
insert_after_line_once "$FILE" '"post-update-cmd": [' <<'EOF'
		"@php artisan ide-helper:generate",
		"@php artisan ide-helper:models --write",
		"@php artisan ide-helper:meta",
EOF

# (Example) You can call the function again for another file/line:
# insert_after_line_once \
#   "$APP_NAME/.vscode/extensions.json" \
#   '"recommendations": [' \
#   '        "DEVSENSE.phptools-vscode",'

# Enable debugging (append if not already present)
{
  echo ""
  echo "SAIL_XDEBUG_MODE=debug"
  echo 'SAIL_XDEBUG_CONFIG="start_with_request=true"'
} >> "$APP_NAME/.env"

echo "✅ Laravel app '$APP_NAME' setup complete."
