global doBeam
extern newwin, box, mvwprintw, wrefresh, cbreak, getch, delwin, touchwin, refresh, rand
extern curscr
extern mode, actualbeam, beam, name
extern fmt_mal_13, fmt_mal_26, fmt_mal_54, fmt_success

section .text
doBeam:
    push rbp
    mov rbp, rsp

    ; make window
    mov rdi, 3
    mov rsi, 50
    mov rdx, 12
    mov rcx, 15
    call newwin
    mov rbx, rax

    ; draw border box
    mov rdi, rbx
    xor rsi, rsi
    xor rdx, rdx
    call box

    ; check mode state
    mov eax, [mode]
    test eax, eax
    jnz .mode_active

    mov rdi, rbx
    mov rsi, 1
    mov rdx, 2
    lea rcx, [fmt_mal_13]
    xor rax, rax
    call mvwprintw
    jmp .refresh

.mode_active:
    mov edx, [actualbeam]
    mov esi, [beam]
    cmp edx, esi
    jne .overdose_chk

    mov rdi, rbx
    mov rsi, 1
    mov rdx, 2
    lea rcx, [fmt_success]
    lea r8, [name]
    xor rax, rax
    call mvwprintw
    jmp .refresh

.overdose_chk:
    cmp edx, 2
    jne .mal_26

    call rand
    xor rdx, rdx
    mov ecx, 10000
    div ecx
    add edx, 10000

    mov rdi, rbx
    mov rsi, 1
    mov rdx, 2
    lea rcx, [fmt_mal_54]
    mov r8, rdx
    xor rax, rax
    call mvwprintw
    jmp .refresh

.mal_26:
    call rand
    xor rdx, rdx
    mov ecx, 10
    div ecx
    add edx, 10

    mov rdi, rbx
    mov rsi, 1
    mov rdx, 2
    lea rcx, [fmt_mal_26]
    mov r8, rdx
    xor rax, rax
    call mvwprintw

.refresh:
    mov rdi, rbx
    call wrefresh
    call cbreak
    call getch

    mov rdi, rbx
    call delwin
    mov rdi, [curscr]
    call touchwin
    call refresh

    pop rbp
    ret