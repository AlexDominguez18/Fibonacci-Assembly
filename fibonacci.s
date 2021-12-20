section .data
;Definicion de constantes

LF              equ 10
NULL            equ 0
EXIT_SUCCESS    equ 0
SYS_exit        equ 60
MAX_N           equ 46
SYS_write       equ 1
STDOUT          equ 1

;Definicion de variables
printFormat     db "f(%d) = %d", LF, NULL
nesimoNumero    db 0
msjError        db "Error: el maximo n-esimo es 46", LF, NULL
longMsjError    equ $-msjError

;Reserva de memoria
section .bss
resultado   resq 1

;Codigo
section .text
;Incluimos el printf
extern printf

global main
main:
    ;El protocolo
    push rbp
    mov rbp, rsp
    ;Inicializar el nesimo numero
    mov byte[nesimoNumero], 46
    ;Checamos si no rebasa el limite
    cmp byte[nesimoNumero], MAX_N
    ja mostrarMensajeError
    ;Inicializar el contador
    mov rcx, 0

ciclo:
    mov rdi, rcx
    call fibonacci
    ;Resultado
    mov qword[resultado], rax
    ;Imprimir el resultado en consola
    push rcx

    mov rdi, printFormat
    mov rsi, rcx
    mov rdx, qword[resultado]
    xor rax, rax
    call printf

    pop rcx

    inc rcx
    cmp rcx, MAX_N
    jne ciclo

fin:
    ;Fin del protocolo
    mov rsp, rbp
    pop rbp
    mov rax, SYS_exit
    mov rdi, EXIT_SUCCESS
    syscall

fibonacci:
    ;El protocolo
    push rbp
    mov rbp, rsp
    push rdi
    ;Rerserva de memoria para los numeros a imprimir
    sub rsp, 16
    ;Checamos si n < 2
    mov qword[rbp-16], rdi
    cmp qword[rbp-16], 2
    jb casoBase

    ;F(n-1)
    dec qword[rbp-16]
    mov rdi, qword[rbp-16]
    call fibonacci
    mov qword[rbp-24], rax
    ;F(n-2)
    dec qword[rbp-16]
    mov rdi, qword[rbp-16]
    call fibonacci
    ;F(n-2) + F(n-1)
    add rax, qword[rbp-24]
    jmp finFibonacci

casoBase:
    mov rax, qword[rbp-16]

finFibonacci:
    ;Recuperamos la memoria reservada
    add rsp, 16
    ;Fin del protocolo
    pop rdi
    mov rsp, rbp
    pop rbp
    ret

mostrarMensajeError:
    ;Imprimir mensaje en consola
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, msjError
    mov rdx, longMsjError
    syscall
    jmp fin