; Define la clave correcta
CORRECT_PASSWORD: DB '1234'
; Declarar un maximo de 3 intentos 
MAX_ATTEMPTS: DB 3

; Inicio del programa
.ORG 0000H
START:
    LD A, 0          ; contador de intentos
    LD (ATTEMPTS), A

REQUEST_PASSWORD:
    LD HL, MESSAGE_REQUEST
    CALL PrintString

    ; Llamar a la rutina para leer la clave
    CALL ReadPassword

    ; Comprobar si la clave es correcta
    LD HL, INPUT_BUFFER
    LD DE, CORRECT_PASSWORD
    CALL CompareStrings
    JR Z, PASSWORD_CORRECT

    ; Si es incorrecta, incrementar el contador de intentos
    INC, (ATTEMPTS)
    LD A, (ATTEMPTS)
    CP MAX_ATTEMPTS
    JR NZ, ATTEMPT_FAILED

    ; Mostrar mensaje de bloqueo si supera el número de intentos
    LD HL, MESSAGE_LOCKED
    CALL PrintString
    JR START

ATTEMPT_FAILED:
    LD HL, MESSAGE_INCORRECT
    CALL PrintString
    JR REQUEST_PASSWORD

PASSWORD_CORRECT:
    LD HL, MESSAGE_CORRECT
    CALL PrintString
    JR START

; Subrutina para leer la clave, mostrando '*' para cada dígito
ReadPassword:
    LD HL, INPUT_BUFFER
    LD B, 4
READ_DIGIT:
    CALL ReadChar
    CP '0'
    JR C, INVALID_CHARACTER
    CP '9'+1
    JR NC, INVALID_CHARACTER
    LD (HL), A
    INC HL

    ; Mostrar '*'
    LD A, '*'
    CALL OutputChar
    DJNZ READ_DIGIT
    RET

INVALID_CHARACTER:
    LD HL, MESSAGE_ERROR
    CALL PrintString
    JP REQUEST_PASSWORD

OutputChar:
    ; Implementación específica para mostrar un carácter en la pantalla
    RET

ReadChar:
    ; Implementación específica para leer un carácter del teclado
    RET

PrintString:
    ; Implementación específica para mostrar una cadena de texto a partir de HL
    RET

CompareStrings:
    ; Comparar HL y DE. Si son iguales, Z se pone a 1
    RET

; Definiciones de cadenas de texto
MESSAGE_REQUEST:    DB 'Ingrese clave de 4 dígitos: ', 0
MESSAGE_CORRECT:    DB 'Clave correcta', 0
MESSAGE_INCORRECT:  DB 'Clave incorrecta', 0
MESSAGE_LOCKED:     DB 'Acceso bloqueado', 0
MESSAGE_ERROR:      DB 'Caracter no valido', 0
ATTEMPTS:           DB 0
INPUT_BUFFER:       DB '0000'

