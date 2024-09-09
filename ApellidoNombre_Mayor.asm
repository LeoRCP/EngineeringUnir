    .data
prompt_numbers: .asciiz "Ingrese la cantidad de numeros a comparar (minimo 3, maximo 5): "
prompt_input:   .asciiz "Ingrese un numero: "
result_msg:     .asciiz "El mayor numero es: "
invalid_input:  .asciiz "Entrada invalida, por favor ingrese entre 3 y 5 numeros.\n"

    .text
    .globl main

main:
    # Solicitar la cantidad de números a comparar
    li $v0, 4                  # Llamar a syscall para imprimir string
    la $a0, prompt_numbers      # Cargar mensaje a imprimir
    syscall

    li $v0, 5                  # Llamar a syscall para leer un entero
    syscall
    move $t0, $v0              # Guardar el número ingresado en $t0

    # Verificar que la entrada esté entre 3 y 5
    li $t1, 3                  # Establecer valor mínimo (3)
    li $t2, 5                  # Establecer valor máximo (5)
    blt $t0, $t1, error_input  # Si la entrada es menor que 3, ir a error
    bgt $t0, $t2, error_input  # Si la entrada es mayor que 5, ir a error

    # Inicializar el mayor número
    li $t3, -2147483648        # Inicializar a valor mínimo posible en 32 bits

    # Leer los números a comparar
    move $t4, $t0              # $t4 será nuestro contador de números a ingresar

input_loop:
    li $v0, 4                  # Llamar a syscall para imprimir string
    la $a0, prompt_input        # Cargar mensaje "Ingrese un numero: "
    syscall

    li $v0, 5                  # Llamar a syscall para leer un entero
    syscall
    move $t5, $v0              # Guardar el número ingresado en $t5

    # Comparar si el número actual es mayor que el mayor hasta ahora
    ble $t5, $t3, skip_update  # Si el número ingresado es menor o igual al mayor actual, saltar
    move $t3, $t5              # Actualizar el mayor número

skip_update:
    sub $t4, $t4, 1            # Decrementar contador
    bgtz $t4, input_loop       # Si aún quedan números por ingresar, repetir

    # Mostrar el mayor número
    li $v0, 4                  # Llamar a syscall para imprimir string
    la $a0, result_msg          # Cargar mensaje "El mayor numero es: "
    syscall

    move $a0, $t3              # Cargar el mayor número en $a0 para mostrarlo
    li $v0, 1                  # Llamar a syscall para imprimir entero
    syscall

    # Salir del programa
    li $v0, 10                 # Llamar a syscall para salir
    syscall

error_input:
    li $v0, 4                  # Llamar a syscall para imprimir string
    la $a0, invalid_input       # Cargar mensaje de error
    syscall

    # Salir del programa con error
    li $v0, 10                 # Llamar a syscall para salir
    syscall
