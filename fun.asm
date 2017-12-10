%macro writeline 1        ; escreve mensagem na tela
  push %1                 ; carrega valor parâmetro na pilha
  call printf             ; chama a função printf do C
  add esp, 4              ; limpa a pilha
%endmacro

%macro readline 2         ; lê entrada do terminal
  push %1                 ; carrega parâmetro 1 (formato de entrada) na pilha
  push %2                 ; carrega parâmetro 2 (variável de armazenamento) na pilha
  call scanf              ; chama a função scanf do C
  add esp, 8              ; limpa a pilha
%endmacro

print_result:
  push dword[res+4]       ; carrega bits menos significativos na pilha
  push dword[res]         ; carrega bits mais significativos na pilha
  push resf
  call printf
  add esp, 12
  ret

exit:                     ; realiza rotina do kernel sys_exit()
    mov eax, 1            ; põe código de operação de saída em eax
    mov ebx, 0            ; sinalização de nenhum erro ocorrido
    int 0x80              ; chamada do kernel

fadd:
    faddp st1, st0        ; soma os elementos na pilha FPU
    fst qword[res]        ; armazena o resultado da operação na variável res
    jmp main.done         ; salta para o local indicado pela label

fsub:
    fsubp st1, st0        ; subtrai os elementos na pilha FPU
    fst qword[res]
    jmp main.done

fmul:
    fmulp st1, st0        ; multiplica os elementos na pilha FPU
    fst qword[res]
    jmp main.done

fdiv:
    cmp dword[n2], 0      ; compara o 2º operando com zero para evitar erro
    je div0               ; salta para subrotina de tratamento caso o operando seja igual a zero
    fdivp st1, st0        ; divide os elementos na pilha FPU
    fst qword[res]
    jmp main.done

read_first_number:
  writeline msg1          ; pede o primeiro número
  readline n1, floatf     ; lê a entrada
  fld dword[n1]           ; coloca o número lido na pilha da FPU

read_operator:
  writeline msg3          ; pede o operador
  call getchar            ; limpa o buffer
  readline op, char       ; lê a entrada
  call verifn             ; verifica se o número digitado é o código de saída

read_second_number:
  writeline msg2          ; pede o segundo número
  readline n2, floatf     ; lê a entrada
  fld dword[n2]           ; coloca o número lido na pilha da FPU
  jmp main.continue       ; salta para o local indicado pela label


compares_operator:        ; compara o operador lido para definir a operação a ser realizada.
  xor eax, eax            ; limpa todo o registrador eax
  mov al, byte[op]        ; move o operador para al

  cmp al, 43              ; compara com o caractere '+'
  je fadd                 ; salta para subrotina de soma

  cmp al, 45              ; compara com o caractere '-'
  je fsub                 ; salta para subrotina de subtração

  cmp al, 42              ; compara com o caractere '*'
  je fmul                 ; salta para subrotina de multiplicação

  cmp al, 47              ; compara com o caractere '/'
  je fdiv                 ; salta para subrotina de divisão

  writeline msg6          ; escreve mensagem de operador invalido
  jmp read_first_number   ; volta para pedir os operandos

div0:                     ; tratamento do caso de divisão por zero
  writeline msg5          ; exibe mensagem de divisão impossível
  jmp read_first_number  ; volta pra pedir o primeiro operando novamente

verifn:                   ; verifica se o operador é vazio (código de saída)
  cmp byte[op], 10        ; compara com código ASCII de LF (\n)
  je main.finish          ; salta para o fim do programa
  ret                     ; retorna para o local onde foi chamado
