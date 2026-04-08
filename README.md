## Actividad 2 Fundamentos de DevOps
### Descripcion del proyecto
Este proyecto es un sistema de automatización de infraestructura en AWS desarrollado para el AWS Learner Lab. Proporciona herramientas para la gestión de instancias EC2 mediante Python, respaldos automatizados en S3 con Bash y un orquestador de despliegue que unifica ambos procesos bajo una arquitectura configurable.

__Requisitos del Entorno de Trabajo__
* Python y la libreria Boto3
* AWS CLI configurado con credenciales
* Github CLI (gh) para la gestion de repositorios
* Permisos de ejecucion de scripts de Bash


__ Instrucciones __
1. Configuracion inicial
Editar el archivo de variables del entorno para que coincidan con las credenciales de la infraestructura
``` bash
nano config/config.env
```

2. Gestion de EC2
El script de Python permite listar las instancias y cambiar los estados de estas
``` bash
python3 ec2/gestionar_ec2.py listar
python3 ec2/gestionar_ec2.py iniciar i-xxxxxx
```

3. Respaldo en S3 usando Bash
Comprime un directorio y lo sube al bucket que se determine
``` bash
./s3/backup_s3.sh <directorio> <nombre_bucket>
```

4. Deploy
Ejecuta el flujo completo
``` bash
#dar permisos de ejecucion
chmod +x deploy.sh
./deploy.sh
```
# Flujo de Git (Branches)
* **Main**: Rama estable con el codigo listo para produccion
* **develop**: Rama para integrar funcionalidades nuevas
* **feature/**: Ramas temporales para poder desarrollar modulos especificos (como la logica del ec2 o de los buckets)

# Flujo completo
**Feature -> Commit Progresivo -> Push -> PR -> Merge a Develop -> Merge a Main**


# Estructura del proyecto
``` bash
project-devops/
├── ec2/            
├── s3/             
├── config/        
├── logs/           
├── deploy.sh      
└── README.md       
```

# Verificaciones
* Conectividad AWS valida
* Scripts con manejo de errores y logs
* Variables con parametros
* Historial de Git limpio y progresivo
