global computeMode
extern time, strlen

extern lastcheck, name, beam, energy, actual, prescribed, cloc, mode, actualbeam

section .text 
computeMode:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    lea rdi, [rsp]
    call time

    mov rdi, [lastcheck]
    test rdi, rdi       ; Is lastcheck > 0?
    jle .eval_mode      ; skip delay eval if not

    mov rsi, rax        ; rsi = current time 
    sub rsi, rdi        ; rsi = t - lastcheck
    cmp rsi, 8          ; did 8 seconds pass or no?
    jl .exit

.eval_mode:
    ; Compute condition: strlen(name) > 0
    lea rdi, [name]
    call strlen
    test rax, rax       ; Check first character slot of name array
    setg al
    movzx ecx, al       ; accumulate boolean "mode"

    ; beam > 0

    mov edx, [beam]
    cmp eax, 0
    setg al
    movzx eax, al
    and ecx, eax

    ; energy > 0
    
    mov edx, [energy]
    cmp edx, 0
    setg al
    movzx eax, al
    and ecx, eax


    mov rdx, 3

.loop_start:
    cmp rdx, 9
    jge .check_cur

    movsd xmm0, [actual + rdx*8]
    movsd xmm1, [prescribed + rdx*8]
    ucomisd xmm0, xmm1
    jp .mismatch
    jne .mismatch

    inc rdx
    jmp .loop_start

.mismatch:
    xor ecx, ecx

.check_cur:
    mov edx, [cloc]
    cmp edx, 12
    sete al
    movzx eax, al
    and ecx, eax

    test ecx, ecx
    jz .set_mode_zero

    mov DWORD [mode], 1
    lea rdi, [rsp]
    mov rsi, [rdi]
    mov [lastcheck], rsi
    jmp .sync_beam

.set_mode_zero:
    mov DWORD [mode], 0
    mov qword [lastcheck], 0

.sync_beam:
    mov eax, [actualbeam]
    mov [beam], eax

.exit:
    leave
    ret