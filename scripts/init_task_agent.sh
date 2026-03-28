#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
FORCE=0
POSITIONAL=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [--dry-run] [--force] <repo_root> <agent_name> [live_agents_root]"
      exit 0
      ;;
    *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done

set -- "${POSITIONAL[@]}"

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 [--dry-run] [--force] <repo_root> <agent_name> [live_agents_root]"
  exit 1
fi

REPO_ROOT="$1"
AGENT_NAME="$2"
LIVE_AGENTS_ROOT="${3:-/root/.openclaw/workspace/agents}"
RUNTIME_DIR="$REPO_ROOT/agent-runtime/$AGENT_NAME"
LIVE_DIR="$LIVE_AGENTS_ROOT/$AGENT_NAME"

log() {
  echo "$*"
}

run_mkdir() {
  if [ "$DRY_RUN" -eq 1 ]; then
    log "dry-run mkdir -p $*"
  else
    mkdir -p "$@"
  fi
}

write_stub_if_missing() {
  local path="$1"
  local title="$2"
  if [ -e "$path" ]; then
    return 0
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    log "dry-run create file: $path"
    return 0
  fi
  cat > "$path" <<EOF
# $title
EOF
}

ensure_link() {
  local src="$1"
  local dst="$2"

  if [ -L "$dst" ]; then
    local current_target
    current_target="$(readlink -f "$dst")"
    local expected_target
    expected_target="$(readlink -f "$src")"
    if [ "$current_target" = "$expected_target" ]; then
      log "linked ok: $(basename "$dst")"
      return 0
    fi
    if [ "$FORCE" -ne 1 ]; then
      echo "error: $dst is a symlink to $current_target, expected $expected_target" >&2
      echo "rerun with --force to replace it, or fix it manually." >&2
      return 1
    fi
    log "force replacing bad symlink: $dst"
    if [ "$DRY_RUN" -ne 1 ]; then
      rm -f "$dst"
    fi
  elif [ -e "$dst" ]; then
    if [ "$FORCE" -ne 1 ]; then
      echo "error: existing file would be replaced by symlink: $dst" >&2
      echo "rerun with --force if replacement is intended." >&2
      return 1
    fi
    log "force replacing existing file: $dst"
    if [ "$DRY_RUN" -ne 1 ]; then
      rm -f "$dst"
    fi
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    log "dry-run link: $dst -> $src"
  else
    ln -s "$src" "$dst"
    log "linked: $(basename "$dst") -> $src"
  fi
}

run_mkdir "$RUNTIME_DIR" "$LIVE_DIR"

for f in PROMPT.md OPERATING-GUIDE.md MEMORY.md; do
  write_stub_if_missing "$RUNTIME_DIR/$f" "$f for $AGENT_NAME"
  ensure_link "$RUNTIME_DIR/$f" "$LIVE_DIR/$f"
done

for f in AGENTS.md SOUL.md USER.md TOOLS.md; do
  if [ ! -e "$LIVE_DIR/$f" ]; then
    write_stub_if_missing "$LIVE_DIR/$f" "$f for $AGENT_NAME"
    log "created live file: $LIVE_DIR/$f"
  else
    log "kept existing live file: $LIVE_DIR/$f"
  fi
done

log "Initialized task agent: $AGENT_NAME"
log "Source of truth: $RUNTIME_DIR"
log "Live dir:        $LIVE_DIR"
