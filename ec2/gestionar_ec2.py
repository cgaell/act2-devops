import boto3
import sys

# Inicializar el cliente de EC2
# Boto3 usará automáticamente las credenciales del IAM Role de Learner Lab
ec2 = boto3.client('ec2')

def listar_instancias():
    print("=== Listado de Instancias EC2 ===")
    try:
        response = ec2.describe_instances()
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                print(f"ID: {instance['InstanceId']} | "
                      f"Estado: {instance['State']['Name']} | "
                      f"Tipo: {instance['InstanceType']}")
    except Exception as e:
        print(f"❌ Error al listar: {e}")

def gestionar_instancia(accion, instance_id):
    try:
        if accion == "iniciar":
            ec2.start_instances(InstanceIds=[instance_id])
            print(f"🚀 Iniciando instancia: {instance_id}")
        elif accion == "detener":
            ec2.stop_instances(InstanceIds=[instance_id])
            print(f"🛑 Deteniendo instancia: {instance_id}")
        elif accion == "terminar":
            ec2.terminate_instances(InstanceIds=[instance_id])
            print(f"🗑️ Terminando instancia: {instance_id}")
    except Exception as e:
        print(f"❌ Error al ejecutar {accion}: {e}")

def main():
    # Validación de parámetros mínimos
    if len(sys.argv) < 2:
        print("Uso: python3 gestionar_ec2.py [listar|iniciar|detener|terminar] [id_instancia]")
        return

    comando = sys.argv[1].lower()

    if comando == "listar":
        listar_instancias()
    elif comando in ["iniciar", "detener", "terminar"]:
        if len(sys.argv) < 3:
            print(f"⚠️ Error: Se requiere el ID de la instancia para '{comando}'")
        else:
            gestionar_instancia(comando, sys.argv[2])
    else:
        print(f"❓ Comando '{comando}' no reconocido.")

if __name__ == "__main__":
    main()
