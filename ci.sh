#!/bin/bash
# Usage : ./ci.sh <url_depot_git> [dossier_de_travail]
set -Eeuo pipefail

REPO_URL="${1:-}"
WORKDIR="${2:-$HOME/ci-workspace}"
LOG="$HOME/tp-bash/ci.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"
}

trap 'log "ECHEC ligne $LINENO"; exit 1' ERR

if [ -z "$REPO_URL" ]; then
    echo "Usage : $0 <url_depot> [dossier]" >&2
    exit 1
fi

update_repo() {
    if [ -d "$WORKDIR/.git" ]; then
        log "Depot existant : git pull"
        git -C "$WORKDIR" pull
    else
        log "Clonage de $REPO_URL"
        git clone "$REPO_URL" "$WORKDIR"
    fi
}

run_tests() {
    local echecs=0
    for f in "$WORKDIR"/*.sh; do
        [ -e "$f" ] || continue
        if bash -n "$f"; then
            log "TEST OK : syntaxe de $(basename "$f")"
        else
            log "TEST ECHEC : syntaxe de $(basename "$f")"
            echecs=$((echecs + 1))
        fi
    done
    [ "$echecs" -eq 0 ]
}

log "=== Debut du pipeline ==="
update_repo
if run_tests; then
    log "=== Pipeline reussi ==="
    exit 0
else
    log "=== Pipeline en echec : tests non valides ==="
    exit 1
fi
