#!/bin/bash
# backup.sh - Automated backup of database and media files
# Usage: ./backup.sh
# Runs: Backup database and media, cleanup old backups (7 days)

set -e

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$BACKUP_DIR/backup.log"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=========================================="
log "Starting backup process..."
log "=========================================="

# 1. Database backup
log "Backing up PostgreSQL database..."
if docker compose exec -T db pg_dump -U postgres bookmarks 2>/dev/null | \
   gzip > "$BACKUP_DIR/db_${TIMESTAMP}.sql.gz"; then
    SIZE=$(du -h "$BACKUP_DIR/db_${TIMESTAMP}.sql.gz" | cut -f1)
    log "✅ Database backup complete (Size: $SIZE)"
else
    log "❌ Database backup failed"
    exit 1
fi

# 2. Media files backup
if [ -d "./media" ] && [ "$(ls -A ./media)" ]; then
    log "Backing up media files..."
    if tar -czf "$BACKUP_DIR/media_${TIMESTAMP}.tar.gz" ./media 2>/dev/null; then
        SIZE=$(du -h "$BACKUP_DIR/media_${TIMESTAMP}.tar.gz" | cut -f1)
        log "✅ Media backup complete (Size: $SIZE)"
    else
        log "❌ Media backup failed"
        exit 1
    fi
else
    log "⚠️  No media files to backup"
fi

# 3. Cleanup old backups (older than 7 days)
log "Cleaning up old backups..."
OLD_BACKUPS=$(find "$BACKUP_DIR" -type f -name "*.sql.gz" -o -name "*.tar.gz" | wc -l)
find "$BACKUP_DIR" -type f \( -name "*.sql.gz" -o -name "*.tar.gz" \) -mtime +7 -delete
CURRENT_BACKUPS=$(find "$BACKUP_DIR" -type f -name "*.sql.gz" -o -name "*.tar.gz" | wc -l)
log "✅ Cleanup complete (Removed $((OLD_BACKUPS - CURRENT_BACKUPS)) old backups)"

log "=========================================="
log "✅ Backup process finished successfully"
log "=========================================="
