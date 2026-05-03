format ELF64 executable

segment readable executable
entry _start

;Menu inicial
_start:
menu_loop:
    mov rsi, msg_menu
    call print_str
    call read_input
    
    mov al, byte [input_buf]
    cmp al, '1'
    je menu_bin
    cmp al, '2'
    je menu_oct
    cmp al, '3'
    je menu_hex
    cmp al, '4'
    je exit
    jmp menu_loop

;Menu de Binario
menu_bin:
    mov rsi, msg_sub
    call print_str
    call read_input
    mov al, byte [input_buf]
    cmp al, '1'
    je dec_to_bin
    cmp al, '2'
    je bin_to_dec
    cmp al, '3'
    je menu_loop
    jmp menu_bin

;Decimal a Binario
dec_to_bin:
    mov rsi, msg_dec
    call print_str
    call read_input
    mov rcx, 10
    mov rsi, input_buf
    call str_to_int
    mov rcx, 2
    call int_to_str
    mov rsi, msg_res
    call print_str
    mov rsi, rdi
    call print_str
    jmp menu_bin

;Binario a Decimal
bin_to_dec:
    mov rsi, msg_bin
    call print_str
    call read_input
    mov rcx, 2
    mov rsi, input_buf
    call str_to_int
    mov rcx, 10
    call int_to_str
    mov rsi, msg_res
    call print_str
    mov rsi, rdi
    call print_str
    jmp menu_bin

;Menu Octal
menu_oct:
    mov rsi, msg_sub
    call print_str
    call read_input
    mov al, byte [input_buf]
    cmp al, '1'
    je dec_to_oct
    cmp al, '2'
    je oct_to_dec
    cmp al, '3'
    je menu_loop
    jmp menu_oct
    
;Decimal a octal
dec_to_oct:
    mov rsi, msg_dec
    call print_str
    call read_input
    mov rcx, 10
    mov rsi, input_buf
    call str_to_int
    mov rcx, 8
    call int_to_str
    mov rsi, msg_res
    call print_str
    mov rsi, rdi
    call print_str
    jmp menu_oct

;Octal a Decimal
oct_to_dec:
    mov rsi, msg_oct
    call print_str
    call read_input
    mov rcx, 8
    mov rsi, input_buf
    call str_to_int
    mov rcx, 10
    call int_to_str
    mov rsi, msg_res
    call print_str
    mov rsi, rdi
    call print_str
    jmp menu_oct

;Menú hexadecimal
menu_hex:
    mov rsi, msg_sub
    call print_str
    call read_input
    mov al, byte [input_buf]
    cmp al, '1'
    je dec_to_hex
    cmp al, '2'
    je hex_to_dec
    cmp al, '3'
    je menu_loop
    jmp menu_hex

;Decimal a hexadecimal
dec_to_hex:
    mov rsi, msg_dec
    call print_str
    call read_input
    mov rcx, 10
    mov rsi, input_buf
    call str_to_int
    mov rcx, 16
    call int_to_str
    mov rsi, msg_res
    call print_str
    mov rsi, rdi
    call print_str
    jmp menu_hex

;Hexadecimal a decimal
hex_to_dec:
    mov rsi, msg_hex
    call print_str
    call read_input
    mov rcx, 16
    mov rsi, input_buf
    call str_to_int
    mov rcx, 10
    call int_to_str
    mov rsi, msg_res
    call print_str
    mov rsi, rdi
    call print_str
    jmp menu_hex

;Salida del progama
exit:
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; código 0
    syscall

;Funcionalidades del programa

;Imprimir string
print_str:
    push rdi
    push rsi
    push rax
    push rdx
    mov rdx, 0
.len_loop:
    cmp byte [rsi + rdx], 0
    je .len_done
    inc rdx
    jmp .len_loop
.len_done:
    mov rax, 1          ; escribir
    mov rdi, 1          ; mostrar
    syscall
    pop rdx
    pop rax
    pop rsi
    pop rdi
    ret

read_input:
    push rax
    push rdi
    push rsi
    push rdx
    mov rax, 0          ; leer
    mov rdi, 0          ; input
    mov rsi, input_buf
    mov rdx, 64
    syscall
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

;De string a integer. 
str_to_int:
    xor rax, rax
    xor rbx, rbx
.loop:
    mov bl, byte [rsi]
    cmp bl, 10
    je .done
    cmp bl, 13
    je .skip
    cmp bl, 0
    je .done
    
    cmp bl, '0'
    jb .done
    cmp bl, '9'
    jbe .is_digit
    
    and bl, 0xDF        ; Convertir a Mayuscula // (Usado para HEXA)
    cmp bl, 'A'
    jb .done
    cmp bl, 'F'
    ja .done
    sub bl, 'A' - 10
    jmp .add
.is_digit:
    sub bl, '0'
.add:
    mul rcx
    add rax, rbx
.skip:
    inc rsi
    jmp .loop
.done:
    ret

int_to_str:
    mov rdi, out_buf + 63
    mov byte [rdi], 0
    dec rdi
    mov byte [rdi], 10  ; Salto de línea final
    test rax, rax
    jnz .loop
    dec rdi
    mov byte [rdi], '0'
    ret
.loop:
    xor rdx, rdx
    div rcx
    cmp dl, 10
    jl .is_digit
    add dl, 'A' - 10
    jmp .store
.is_digit:
    add dl, '0'
.store:
    dec rdi
    mov byte [rdi], dl
    test rax, rax
    jnz .loop
    ret

;Texto
segment readable writeable
    msg_menu db 10, '--- MENU PRINCIPAL ---', 10, '1. Decimal <-> Binario', 10, '2. Decimal <-> Octal', 10, '3. Decimal <-> Hexadecimal', 10, '4. Salir', 10, 'Elige una opcion: ', 0
    msg_sub  db 10, '--- SUBMENU ---', 10, '1. De Decimal a Base', 10, '2. De Base a Decimal', 10, '3. Volver al menu principal', 10, 'Opcion: ', 0
    msg_dec  db 'Introduce un numero decimal: ', 0
    msg_bin  db 'Introduce un numero binario: ', 0
    msg_oct  db 'Introduce un numero octal: ', 0
    msg_hex  db 'Introduce un numero hexadecimal: ', 0
    msg_res  db 'Resultado: ', 0

    input_buf rb 64
    out_buf   rb 64
