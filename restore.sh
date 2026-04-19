#!/bin/bash
# restore.sh - Restore database from backup
# Usage: ./restore.sh backup_file.sql.gz
# Example: ./restore.sh backups/db_20260418_143000.sql.gz

set -e

if [ $# -eq 0 ]; then
    echo "Usage: ./restore.sh <backup_file.sql.gz>"
    echo ""
    echo "Available backups:"
    ls -lh backups/db_*.sql.gz 2>/dev/null || echo "No database backups found"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "=========================================="
echo "⚠️  DATABASE RESTORE WARNING ⚠️"
echo "=========================================="
echo "This will OVERWRITE the current database:"
echo "Backup: $BACKUP_FILE"
echo "Size: $(du -h "$BACKUP_FILE" | cut -f1)"
echo ""
read -p "Type 'yes' to confirm restore: " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "❌ Restore cancelled"
    exit 1
fi

echo "Starting restore..."

# Decompress and restore
if gunzip -c "$BACKUP_FILE" | docker compose exec -T db psql -U postgres -d bookmarks; then
    echo "✅ Database restored successfully"
else
    echo "❌ Database restore failed"
    exit 1
fi

echo "=========================================="
