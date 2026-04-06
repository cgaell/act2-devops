#!/bin/bash

# --- Configuración de Logs ---
LOG_DEPLOY="logs/deploy.log"
mkdir -p logs # Asegura que la carpeta exista

echo "🚀 [$(date)] --- INICIANDO DESPLIEGUE (CI/CD SIMULADO) ---" | tee -a $LOG_DEPLOY

# --- Recibir Parámetros ---
# $1: Acción EC2 (iniciar/detener)
# $2: ID Instancia
# $3: Directorio a respaldar
# $4: Bucket S3
ACCION_EC2=$1
INSTANCE_ID=$2
DIR_BACKUP=$3
BUCKET_S3=$4

# --- Validación de Parámetros ---
if [ $# -ne 4 ]; then
    echo "❌ Error: Faltan parámetros." | tee -a $LOG_DEPLOY
    echo "Uso: $0 <accion_ec2> <id_instancia> <directorio> <bucket_s3>"
    exit 1
fi

# --- PASO 1: Gestión de Infraestructura (Python + Boto3) ---
echo "🖥️ Paso 1: Ejecutando gestión de EC2 ($ACCION_EC2)..." | tee -a $LOG_DEPLOY
python3 ec2/gestionar_ec2.py "$ACCION_EC2" "$INSTANCE_ID" >> $LOG_DEPLOY 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Gestión de EC2 enviada correctamente." | tee -a $LOG_DEPLOY
else
    echo "⚠️ Nota: Hubo un detalle con EC2 (revisa logs), continuando con respaldo..." | tee -a $LOG_DEPLOY
fi

# --- PASO 2: Respaldo de Datos (Bash + AWS CLI) ---
echo "📦 Paso 2: Ejecutando respaldo en S3..." | tee -a $LOG_DEPLOY
./s3/backup_s3.sh "$DIR_BACKUP" "$BUCKET_S3"

if [ $? -eq 0 ]; then
    echo "✅ Respaldo en S3 completado con éxito." | tee -a $LOG_DEPLOY
else
    echo "❌ Error crítico en el respaldo de S3. Abortando flujo." | tee -a $LOG_DEPLOY
    exit 1
fi

echo "🏁 [$(date)] --- DESPLIEGUE FINALIZADO EXITOSAMENTE ---" | tee -a $LOG_DEPLOY
echo "----------------------------------------------------" >> $LOG_DEPLOY
