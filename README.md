# Conversor-de-Numeros
Este código es un programa escrito en lenguaje ensamblador x86-64 ELF64. A travez de consola permite convertir números entre diferentes bases numéricas: Decimal, Binario, Octal y Hexadecimal

## Conversor de Bases Numéricas en Ensamblador (x86-64)
Este repositorio contiene un programa ejecutable (ELF64) escrito en lenguaje ensamblador puro para arquitecturas x86-64 en sistemas operativos Linux
El programa funciona como una utilidad interactiva de línea de comandos que permite al usuario convertir números entre diferentes bases matemáticas: Decimal, Binario, Octal y Hexadecimal

### ¿Cómo funciona el programa? (Flujo de Ejecución)
El programa está diseñado mediante un sistema de menús interactivos y rutinas de conversión reutilizables. Los pasos generales de ejecución son:

1.- Menú Principal (_start): El programa inicia mostrando un menú principal con las opciones de conversión disponibles y espera la entrada del usuario

2.- Submenús por Base: Dependiendo de la selección, el programa se dirige a rutinas específicas (menu_bin, menu_oct o menu_hex)
En este punto, se le pregunta al usuario la dirección de la conversión: de Decimal a la base seleccionada, o de la base seleccionada a Decimal

3.- Proceso de Conversión:
Se solicita al usuario el número a convertir

  1.- Se establece la "base de origen" en el registro rcx (por ejemplo, 10 para decimal) y se convierte el texto ingresado a un valor numérico interno en el procesador

  2.- Se cambia el registro rcx a la "base de destino" (por ejemplo, 2 para binario, 8 para octal o 16 para hexadecimal) y se transforma el valor interno nuevamente a texto

  3.-Se imprime el resultado en pantalla y el programa retorna al submenú

### Funciones Principales
El código no depende de bibliotecas externas de C, por lo que implementa sus propias funciones interactuando directamente con el sistema operativo (mediante llamadas al sistema o syscalls).

1.- print_str: Se encarga de imprimir texto en la consola. Su lógica incluye un bucle (.len_loop) que calcula automáticamente la longitud de la cadena buscando un terminador nulo (0), para luego realizar una llamada al sistema sys_write (código 1 en rax)

2.- read_input: Captura la entrada del usuario desde el teclado. Utiliza la llamada al sistema sys_read (código 0 en rax) para leer hasta 64 bytes y almacenarlos en un espacio de memoria llamado input_buf

3.- str_to_int: Convierte una cadena de caracteres a un número entero comprensible para la CPU
Resta el valor ASCII '0' a cada carácter para obtener su valor real, lo multiplica por la base definida en el registro rcx y va sumando el resultado

4.- int_to_str: Realiza la operación inversa, convirtiendo un número de la CPU a una cadena de texto para ser impresa
Divide el número sucesivamente por la base destino definida en rcx y convierte los residuos a caracteres
Nota: Contiene una lógica condicional especial para manejar la base hexadecimal, sumando 'A' - 10 a los residuos mayores a 9 para representarlos con letras de la 'A' a la 'F'

5.- exit: Cierra el programa de manera limpia devolviendo el control al sistema operativo mediante la llamada sys_exit (código 60 en rax) y estableciendo un código de salida 0 (sin errores)

### Sección de Datos
En la sección segment readable writeable, el programa almacena estáticamente todas las cadenas de texto utilizadas para la interfaz
Los textos utilizan el valor 10 para representar los saltos de línea y finalizan con un 0 (byte nulo), el cual es crucial para que la función print_str sepa dónde termina cada mensaje
