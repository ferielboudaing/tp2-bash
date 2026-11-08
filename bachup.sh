
set -Eeuo pipefail

DOSSIER="${1:-}"
DEST="${2:-$HOME/backups}"
LOG="$HOME/tp-bash/backup.log"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE="$DEST/backup_$DATE.tar.gz"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"
}

if [ -z "$DOSSIER" ] || [ ! -d "$DOSSIER" ]; then
    echo "Erreur : dossier '$DOSSIER' introuvable. Usage : $0 <dossier> [dest]" >&2
    exit 1
fi


 
mkdir -p "$DEST"
log "Debut de la sauvegarde de $DOSSIER"
tar -czf "$ARCHIVE" "$DOSSIER"
log "Archive creee : $ARCHIVE"

for fichier in "$DEST"/backup_*.tar.gz; do
    [ -e "$fichier" ] || continue
    if [ -n "$(find "$fichier" -mtime +7)" ]; then
        rm -- "$fichier"
        log "Ancienne sauvegarde supprimee : $fichier"
    fi
done

log "Fin du script (succes)"
exit 0
