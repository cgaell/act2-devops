#!/bin/bash

# --- Configuración de variables ---
DIRECTORIO=$1
BUCKET=$2
FECHA=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVO_BACKUP="backup_$FECHA.tar.gz"
LOG_FILE="logs/backup_s3.log"

# --- Validaciones iniciales ---
if [ -z "$DIRECTORIO" ] || [ -z "$BUCKET" ]; then
    echo "❌ Error: Faltan parámetros."
    echo "Uso: $0 <directorio> <nombre_del_bucket>"
    exit 1
fi

if [ ! -d "$DIRECTORIO" ]; then
    echo "❌ Error: El directorio '$DIRECTORIO' no existe."
    exit 1
fi

# --- Inicio del proceso ---
echo "[$(date)] --- Iniciando Respaldo ---" >> $LOG_FILE

# 1. Compresión de archivos
echo "📦 Comprimiendo $DIRECTORIO..." | tee -a $LOG_FILE
tar -czf $ARCHIVO_BACKUP $DIRECTORIO 2>> $LOG_FILE

if [ $? -eq 0 ]; then
    echo "✅ Compresión exitosa: $ARCHIVO_BACKUP" >> $LOG_FILE
else
    echo "❌ Fallo en la compresión" >> $LOG_FILE
    exit 1
fi

# 2. Subida a S3
echo "🚀 Subiendo a S3 (Bucket: $BUCKET)..." | tee -a $LOG_FILE
aws s3 cp $ARCHIVO_BACKUP s3://$BUCKET/ 2>> $LOG_FILE

if [ $? -eq 0 ]; then
    echo "✅ Subida completada con éxito." | tee -a $LOG_FILE
    # 3. Limpieza de archivo local (opcional pero recomendado)
    rm $ARCHIVO_BACKUP
    echo "🧹 Archivo temporal eliminado." >> $LOG_FILE
else
    echo "❌ Error al subir a S3. Revisa tus permisos o el nombre del bucket." | tee -a $LOG_FILE
fi

echo "[$(date)] --- Fin del Proceso ---" >> $LOG_FILE
echo "---------------------------------" >> $LOG_FILE
