%include 'fun.asm'

section .data
  msg0: db ":::::::::: CALCULADORA ASSEMBLY v1.0 ::::::::::", 10, 0
  msg1: db "N1: ", 0
  msg2: db "N2: ", 0
  msg3: db "OP: ", 0
  msg4: db "Finalizado.", 10, 0
  msg5: db "Não é possível dividir por zero.", 10, 0
  msg6: db "Operador inválido.", 10, 0
  floatf: db "%f", 0
  char: db "%c", 0
  resf: db "RES: %.2f", 10, 0
  n1: dd 0
  n2: dd 0
  op: db 0
  res: dq 0

section .text
	global main
	extern printf
	extern scanf
	extern getchar

main:

  writeline msg0            ; exibe nome do programa

  call read_first_number    ; chama rotina de leitura do primeiro operando

  .repeat:                  ; ponto de repetição
  call read_operator        ; chama rotina de leitura do operador

  call read_second_number   ; chama rotina de leitura do segundo operando

  .continue:                ; ponto de continuidade do programa para algumas rotinas
  call compares_operator    ; chama rotina de cálculos

  .done:                    ; ponto de exibição do resultado
  call print_result         ; chama rotina de exibição do resultado
  jmp .repeat               ; salto para ponto de repetição

  .finish:                  ; ponto de encerramento do programa
  writeline msg4            ; exibe mensagem de finalização
  call exit                 ; chama rotina de encerramento
