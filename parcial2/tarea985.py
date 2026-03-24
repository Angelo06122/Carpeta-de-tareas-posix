import os
import sys

def limpiar_pantalla():
    if os.name == 'nt':
        os.system('cls')
    else:
        os.system('clear')

def main():
    while True:
        print("\n" + "="*50)
        print(" HERRAMIENTA DE INTERACCIÓN CON EL MÓDULO 'os' ")
        print("="*50)
        print("1. Obtener el directorio actual")
        print("2. Listar archivos en el directorio actual")
        print("3. Crear un nuevo directorio")
        print("4. Mostrar información del sistema operativo")
        print("5. Salir")
        print("="*50)
        
        opcion = input("Selecciona una opción (1-5): ")
        
        if opcion == '1':
            print(f"\n[+] Directorio actual: {os.getcwd()}")
            
        elif opcion == '2':
            print("\n[+] Archivos y carpetas:")
            elementos = os.listdir('.')
            for elemento in elementos:
                print(f"    - {elemento}")
                
        elif opcion == '3':
            nombre_carpeta = input("\n[?] Introduce el nombre de la nueva carpeta: ")
            try:
                os.mkdir(nombre_carpeta)
                print(f"\n[+] ¡Carpeta '{nombre_carpeta}' creada con éxito!")
            except FileExistsError:
                print(f"\n[-] Error: La carpeta '{nombre_carpeta}' ya existe.")
            except Exception as e:
                print(f"\n[-] Error inesperado: {e}")
                
        elif opcion == '4':
            print(f"\n[+] Nombre interno del SO para Python: {os.name}")
            
        elif opcion == '5':
            print("\nSaliendo de la herramienta... ¡Éxito en tu entrega!")
            sys.exit(0)
            
        else:
            print("\n[-] Opción no válida. Por favor, intenta de nuevo.")

if __name__ == "__main__":
    limpiar_pantalla()
    main()
