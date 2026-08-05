global fmt_mal_13, fmt_mal_54, fmt_mal_26, fmt_success 
global BEAM_TYPES, MODE_TYPES
global actualbeam, beam, energy, cloc, mode, done, lastcheck
global name, actual, prescribed

section .data 

    actual          dq 0.0, 200.0, 0.27, 0.0, 359.2, 14.2, 27.2, 1.0, 0.0

    fmt_mal_13      db "MALFUNCTION 13 (Data Entry incomplete)", 0
    fmt_mal_54      db "MALFUNCTION 54 (%d rads delivered)", 0
    fmt_mal_26      db "MALFUNCTION 26 (%d rads delivered)", 0
    fmt_success     db "TREATED %s SUCCESSFULLY!", 0

    str_empty           db 0
    str_mode_x          db "X", 0
    str_mode_e          db "E", 0

    str_case_entry      db "DATA ENTRY", 0
    str_case_ready      db "BEAM READY", 0

    align 8
    BEAM_TYPES:
        dq str_empty
        dq str_mode_x
        dq str_mode_e

    MODE_TYPES:
        dq str_case_entry
        dq str_case_ready

    section .bss

    actualbeam      resd 1
    beam            resd 1
    energy          resd 1
    cloc            resd 1
    mode            resd 1
    done            resd 1
    lastcheck       resq 1      ; time_t is a 64 bit integer on x86-64
    prescribed      resq 9      ; double prescribed[9]
    name            resb 50     ; char name[50]