    .data
prompt_number:   .asciiz "Ingrese la cantidad de numeros de la serie Fibonacci a generar: "
result_msg:      .asciiz "Serie Fibonacci: "
sum_msg:         .asciiz "\nLa suma de los numeros de la serie es: "
newline:         .asciiz "\n"

    .text
    .globl main

main:
    # Solicitar al usuario cuántos números de la serie Fibonacci desea generar
    li $v0, 4                    # Llamar a syscall para imprimir string
    la $a0, prompt_number         # Cargar el mensaje "Ingrese la cantidad de números..."
    syscall

    li $v0, 5                    # Llamar a syscall para leer un entero
    syscall
    move $t0, $v0                # Guardar el número ingresado en $t0 (cantidad de números a generar)

    # Inicializar los primeros dos números de la serie Fibonacci
    li $t1, 0                    # F0 = 0
    li $t2, 1                    # F1 = 1
    li $t3, 2                    # Contador para controlar la cantidad de números generados
    move $t4, $t1                # Inicializar suma en $t4 (F0)
    add $t4, $t4, $t2            # Suma F0 + F1

    # Mostrar el mensaje "Serie Fibonacci:"
    li $v0, 4                    # Llamar a syscall para imprimir string
    la $a0, result_msg            # Cargar el mensaje "Serie Fibonacci: "
    syscall

    # Imprimir el primer número (F0 = 0)
    move $a0, $t1                # Cargar F0 en $a0 para imprimir
    li $v0, 1                    # Syscall para imprimir un entero
    syscall

    # Imprimir un salto de línea
    li $v0, 4
    la $a0, newline
    syscall

    # Imprimir el segundo número (F1 = 1)
    move $a0, $t2                # Cargar F1 en $a0 para imprimir
    li $v0, 1                    # Syscall para imprimir un entero
    syscall

    # Imprimir un salto de línea
    li $v0, 4
    la $a0, newline
    syscall

fib_loop:
    # Calcular el siguiente número en la serie: F(n) = F(n-1) + F(n-2)
    add $t5, $t1, $t2            # F(n) = F(n-1) + F(n-2)

    # Imprimir el número calculado
    move $a0, $t5                # Cargar el número calculado en $a0
    li $v0, 1                    # Syscall para imprimir un entero
    syscall

    # Imprimir un salto de línea
    li $v0, 4
    la $a0, newline
    syscall

    # Sumar el número calculado a la suma total
    add $t4, $t4, $t5            # Suma total += F(n)

    # Actualizar los valores para la siguiente iteración
    move $t1, $t2                # F(n-2) = F(n-1)
    move $t2, $t5                # F(n-1) = F(n)

    # Incrementar el contador y verificar si se generaron suficientes números
    addi $t3, $t3, 1
    bge $t3, $t0, end_loop       # Si hemos generado suficientes números, salir del bucle

    # Repetir el ciclo para el siguiente número
    j fib_loop

end_loop:
    # Mostrar la suma de todos los números generados
    li $v0, 4                    # Llamar a syscall para imprimir string
    la $a0, sum_msg               # Cargar el mensaje "La suma de los numeros..."
    syscall

    move $a0, $t4                # Cargar la suma total en $a0 para imprimir
    li $v0, 1                    # Syscall para imprimir un entero
    syscall

    # Terminar el programa
    li $v0, 10                   # Syscall para terminar el programa
    syscall
