#!/bin/bash

# 1. Cargar configuración externa
if [ -f "config/config.env" ]; then
    source config/config.env
    echo "⚙️ Configuración cargada desde config/config.env"
else
    echo "❌ Error: No se encontró config/config.env"
    exit 1
fi

LOG_DEPLOY="logs/deploy.log"
echo "🚀 [$(date)] --- INICIANDO DESPLIEGUE CONFIGURADO ---" | tee -a $LOG_DEPLOY

# 2. Paso 1: EC2 (Usa la variable $INSTANCE_ID del .env)
# Exportamos la región para que Boto3 la detecte sin errores
export AWS_DEFAULT_REGION=$REGION

echo "🖥️ Paso 1: Gestionando EC2..." | tee -a $LOG_DEPLOY
python3 ec2/gestionar_ec2.py iniciar "$INSTANCE_ID" >> $LOG_DEPLOY 2>&1

# 3. Paso 2: S3 (Usa $DIRECTORY y $BUCKET_NAME del .env)
echo "📦 Paso 2: Ejecutando respaldo..." | tee -a $LOG_DEPLOY
./s3/backup_s3.sh "$DIRECTORY" "$BUCKET_NAME"

echo "🏁 [$(date)] --- PROCESO COMPLETADO ---" | tee -a $LOG_DEPLOY
