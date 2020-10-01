;nasm -fwin64 fizzbuzz.asm && gcc -m64 -mconsole fizzbuzz.obj -o fizzbuzz.exe && fizzbuzz.exe
            extern	    printf

            SECTION .data
none:       db      0
fizz:       db      "fizz", 0
buzz:       db      "buzz", 0
wordfmt:    db      "%s%s", 10, 0   ; The printf format, "\n",'0'
numfmt:     db      "%d", 10, 0
count:      db      100

            global  main
            SECTION .text
main:       push    rbp         ; frame
            mov     rbp, rsp
            push    rbx         ; save state
            push    rcx
            push    rdx
            push    r8
            push    r9
            xor     rcx, rcx    ; clear counter
loop:       inc     rcx
            lea     r8, none    ; starts out loop with fizz and buzz set to ""
            lea     r9, none
            mov     rdx, 3      ; load value to mod by          FIRST MOD
            call    mod         ; rax = rcx%3                     
            lea     rbx, fizz   ; load fizz for cmov
            cmp     eax, 0      ; if rax == 0
            cmovz   r8,  rbx    ; add fizz to formatting
            mov     rdx, 5      ; loading value to mod by       SECOND MOD
            call    mod         ; rax = rcx%5                     
            lea     rbx, buzz   ; load buzz for cmov
            cmp     eax, 0      ; if rax == 0
            cmovz   r9,  rbx    ; add buzz to formatting
            cmp     r8,  r9     ; if r8 != r9                   CHECK IF PRINT WORD
            jnz     doword      ; print word
            call    printnum    ; else print num                ELSE PRINT NUM
            jmp     endloop
doword:     push    rcx
            mov     rcx, r8     ; set argument registers        PRINT WORD
            mov     rdx, r9     ;
            call    printword   ; print line
            pop     rcx
endloop:    cmp     rcx, [count]; while rcx != 100
            jnz     loop        ; continue
            mov     rax, 0      ; return 0                      EXIT
            pop     r9          ; restore state
            pop     r8
            pop     rdx
            pop     rcx
            pop     rbx
            pop     rbp         ; restore frame
            ret

;mods value in rcx by rdx   
mod:        push    rbp             ; frame
            mov     rbp, rsp        
            push    rcx             ; save state
            push    rdx
            mov     rax, rcx        ; sets the number to be modded
            mov     rcx, rdx        ; seys value to mod by
            xor     rdx, rdx        ; clear output reg
            div     rcx             ; does mod
            mov     rax, rdx        ; return result of mod
            pop     rdx             ; restores state
            pop     rcx
            pop     rbp             ; restore frame
            ret

;rcx = fizz and rdx = buzz
printword:  push    rbp             ; frame
            mov     rbp, rsp        
            push    rcx             ; save state
            push    rdx
            push    r8
            push    r9
            push    r11
            mov     r8, rdx         ; arg3
            mov     rdx, rcx        ; arg2
            mov     rcx, wordfmt    ; arg1
            sub     rsp, 32         ; clear room on stack for printed return values
            call    printf	        ; Call C function
            add     rsp, 32         ; restore stack
            mov     rcx, rdx        ; restore rcx
            mov     rdx, r8         ; restore rdx
	        mov	    rax, 0	        ; ret 0
            pop     r11             ; restore state
            pop     r9
            pop     r8
            pop     rdx
            pop     rcx
	        pop	    rbp             ; restore frame
	        ret

;prints the number in rcx
printnum:   push    rbp         ; frame
            mov     rbp, rsp
            push    rcx         ; save state
            push    rdx
            push    r8
            push    r9
            push    r11
            mov     rdx, rcx    ; put num as arg2
            mov     rcx, numfmt ; put formatter as arg1
            sub     rsp, 32     ; allocate shadow
            call    printf      ; call
            add     rsp, 32     ; deallocate shadow
            mov     rax, 0      ; ret 0
            pop     r11         ; restore state
            pop     r9
            pop     r8
            pop     rdx         
            pop     rcx
            pop     rbp         ; restore frame
            ret
