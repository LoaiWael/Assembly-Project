.MODEL SMALL
.STACK 100H
.DATA
    PROMPT_D  DB 10,13, 'Enter Birth Day (DD): $'
    PROMPT_M  DB 10,13, 'Enter Birth Month (MM): $'
    PROMPT_Y  DB 10,13, 'Enter Birth Year (YYYY): $'
    MSG_GREG  DB 10,13, 10,13, '--- AGE ---$'
    MSG_HIJRI DB 10,13, 10,13, '--- HIJRI DATE ---$'
    MSG_STATS DB 10,13, 10,13, '--- AGE IN FORMATS ---$'
    MSG_ZOD   DB 10,13, 10,13, '--- ZODIAC SIGN ---$'
    TXT_BDAY  DB 10,13, 'Birth Date: $'
    TXT_AGE   DB 10,13, 'Your Age: $'
    TXT_NEXT  DB 10,13, 'Next Birthday in: $'
    TXT_Y     DB ' Years, $'
    TXT_M     DB ' Months, $'
    TXT_D     DB ' Days.$'
    TXT_SUF_M DB ' Months$'
    TXT_SUF_W DB ' Weeks$'
    TXT_SUF_D DB ' Days$'
    LBL_TOT_M DB 10,13, 'In Months: $'
    LBL_TOT_W DB 10,13, 'In Weeks:  $'
    LBL_TOT_D DB 10,13, 'In Days:   $'
    Z_ARIES   DB 'Aries$'
    Z_TAURUS  DB 'Taurus$'
    Z_GEMINI  DB 'Gemini$'
    Z_CANCER  DB 'Cancer$'
    Z_LEO     DB 'Leo$'
    Z_VIRGO   DB 'Virgo$'
    Z_LIBRA   DB 'Libra$'
    Z_SCORPIO DB 'Scorpio$'
    Z_SAGIT   DB 'Sagittarius$'
    Z_CAPRI   DB 'Capricorn$'
    Z_AQUA    DB 'Aquarius$'
    Z_PISCES  DB 'Pisces$'
    BDAY      DW ?
    BMONTH    DW ?
    BYEAR     DW ?
    CDAY      DW ?
    CMONTH    DW ?
    CYEAR     DW ?
    AGE_D     DW ?
    AGE_M     DW ?
    AGE_Y     DW ?
    H_DAY     DW ?
    H_MONTH   DW ?
    H_YEAR    DW ?
    TOTAL_DAYS DW ? 

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    LEA DX, PROMPT_D
    MOV AH, 9
    INT 21H
    CALL READ_NUM
    MOV BDAY, AX
    LEA DX, PROMPT_M
    MOV AH, 9
    INT 21H
    CALL READ_NUM
    MOV BMONTH, AX
    LEA DX, PROMPT_Y
    MOV AH, 9
    INT 21H
    CALL READ_NUM
    MOV BYEAR, AX
    MOV AH, 2AH
    INT 21H
    MOV CYEAR, CX
    MOV BL, DH
    XOR BH, BH
    MOV CMONTH, BX
    MOV BL, DL
    XOR BH, BH
    MOV CDAY, BX
    MOV AX, CDAY
    MOV BX, CMONTH
    MOV CX, CYEAR
    CMP AX, BDAY
    JAE DAY_OK
    ADD AX, 30
    DEC BX
DAY_OK:
    SUB AX, BDAY
    MOV AGE_D, AX
    CMP BX, BMONTH
    JAE MONTH_OK
    ADD BX, 12
    DEC CX
MONTH_OK:
    SUB BX, BMONTH
    MOV AGE_M, BX
    SUB CX, BYEAR
    MOV AGE_Y, CX
    LEA DX, MSG_GREG
    MOV AH, 9
    INT 21H
    LEA DX, TXT_AGE
    MOV AH, 9
    INT 21H
    MOV AX, AGE_Y
    CALL PRINT_NUM
    LEA DX, TXT_Y
    MOV AH, 9
    INT 21H
    MOV AX, AGE_M
    CALL PRINT_NUM
    LEA DX, TXT_M
    MOV AH, 9
    INT 21H
    MOV AX, AGE_D
    CALL PRINT_NUM
    LEA DX, TXT_D
    MOV AH, 9
    INT 21H
    LEA DX, TXT_NEXT
    MOV AH, 9
    INT 21H
    MOV AX, 11
    SUB AX, AGE_M
    CMP AGE_D, 0
    JE  EXACT_MONTH
    JMP CALC_REM_DAYS
EXACT_MONTH:
    ADD AX, 1 
    MOV BX, 0 
    JMP PRINT_REM
CALC_REM_DAYS:
    MOV BX, 30
    SUB BX, AGE_D
PRINT_REM:
    PUSH BX 
    CALL PRINT_NUM 
    LEA DX, TXT_M
    MOV AH, 9
    INT 21H
    POP AX 
    CALL PRINT_NUM
    LEA DX, TXT_D
    MOV AH, 9
    INT 21H
    LEA DX, MSG_HIJRI
    MOV AH, 9
    INT 21H
    LEA DX, TXT_BDAY
    MOV AH, 9
    INT 21H
    MOV AX, BYEAR
    SUB AX, 622
    MOV BX, 33
    MUL BX
    MOV BX, 32
    DIV BX
    MOV H_YEAR, AX
    MOV AX, BDAY
    MOV BX, BMONTH
    MOV CX, H_YEAR
    SUB AX, 12
    CMP AX, 1
    JGE H_DAY_OK
    ADD AX, 30
    DEC BX
H_DAY_OK:
    MOV H_DAY, AX
    SUB BX, 1
    CMP BX, 1
    JGE H_MON_OK
    ADD BX, 12
    DEC CX
H_MON_OK:
    MOV H_MONTH, BX
    MOV H_YEAR, CX
    MOV AX, H_YEAR
    CALL PRINT_NUM
    MOV AH, 2
    MOV DL, '-'
    INT 21H
    MOV AX, H_MONTH
    CALL PRINT_NUM
    MOV AH, 2
    MOV DL, '-'
    INT 21H
    MOV AX, H_DAY
    CALL PRINT_NUM
    LEA DX, MSG_STATS
    MOV AH, 9
    INT 21H
    MOV AX, AGE_Y
    MOV BX, 365
    MUL BX          
    MOV TOTAL_DAYS, AX 
    MOV AX, AGE_M
    MOV BX, 30
    MUL BX
    ADD TOTAL_DAYS, AX
    MOV AX, AGE_D
    ADD TOTAL_DAYS, AX 
    LEA DX, LBL_TOT_M
    MOV AH, 9
    INT 21H
    MOV AX, AGE_Y
    MOV BX, 12
    MUL BX
    ADD AX, AGE_M
    CALL PRINT_NUM
    LEA DX, TXT_SUF_M
    MOV AH, 9
    INT 21H
    LEA DX, LBL_TOT_W
    MOV AH, 9
    INT 21H
    MOV AX, TOTAL_DAYS
    MOV BX, 7
    MOV DX, 0
    DIV BX
    CALL PRINT_NUM
    LEA DX, TXT_SUF_W
    MOV AH, 9
    INT 21H
    LEA DX, LBL_TOT_D
    MOV AH, 9
    INT 21H
    MOV AX, TOTAL_DAYS
    CALL PRINT_NUM
    LEA DX, TXT_SUF_D
    MOV AH, 9
    INT 21H
    LEA DX, MSG_ZOD
    MOV AH, 9
    INT 21H
    MOV AH, 2
    MOV DL, 10
    INT 21H
    MOV DL, 13
    INT 21H
    CALL GET_ZODIAC
    MOV AH, 4CH
    INT 21H
MAIN ENDP

READ_NUM PROC
    PUSH BX
    PUSH CX
    PUSH DX
    XOR BX, BX
    XOR CX, CX
READ_LOOP:
    MOV AH, 1
    INT 21H
    CMP AL, 13 
    JE END_READ
    SUB AL, 30H 
    XOR AH, AH
    MOV CX, AX
    MOV AX, BX
    MOV DX, 10
    MUL DX
    ADD AX, CX
    MOV BX, AX
    JMP READ_LOOP
END_READ:
    MOV AX, BX
    POP DX
    POP CX
    POP BX
    RET
READ_NUM ENDP

PRINT_NUM PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV CX, 0
    MOV BX, 10
PRINT_LOOP:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE PRINT_LOOP
PRINT_OUT:
    POP DX
    ADD DL, 30H
    MOV AH, 2
    INT 21H
    LOOP PRINT_OUT
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUM ENDP

GET_ZODIAC PROC
    MOV AX, BMONTH
    MOV BX, BDAY
    CMP AX, 1
    JNE C1
    JMP Z_JAN
C1: CMP AX, 2
    JNE C2
    JMP Z_FEB
C2: CMP AX, 3
    JNE C3
    JMP Z_MAR
C3: CMP AX, 4
    JNE C4
    JMP Z_APR
C4: CMP AX, 5
    JNE C5
    JMP Z_MAY
C5: CMP AX, 6
    JNE C6
    JMP Z_JUN
C6: CMP AX, 7
    JNE C7
    JMP Z_JUL
C7: CMP AX, 8
    JNE C8
    JMP Z_AUG
C8: CMP AX, 9
    JNE C9
    JMP Z_SEP
C9: CMP AX, 10
    JNE C10
    JMP Z_OCT
C10: CMP AX, 11
    JNE C11
    JMP Z_NOV
C11: JMP Z_DEC
Z_JAN: 
    CMP BX, 20
    JAE J1
    LEA DX, Z_CAPRI
    JMP P_Z
J1: LEA DX, Z_AQUA
    JMP P_Z
Z_FEB: 
    CMP BX, 19
    JAE J2
    LEA DX, Z_AQUA
    JMP P_Z
J2: LEA DX, Z_PISCES
    JMP P_Z
Z_MAR: 
    CMP BX, 21
    JAE J3
    LEA DX, Z_PISCES
    JMP P_Z
J3: LEA DX, Z_ARIES
    JMP P_Z
Z_APR: 
    CMP BX, 20
    JAE J4
    LEA DX, Z_ARIES
    JMP P_Z
J4: LEA DX, Z_TAURUS
    JMP P_Z
Z_MAY: 
    CMP BX, 21
    JAE J5
    LEA DX, Z_TAURUS
    JMP P_Z
J5: LEA DX, Z_GEMINI
    JMP P_Z
Z_JUN: 
    CMP BX, 21
    JAE J6
    LEA DX, Z_GEMINI
    JMP P_Z
J6: LEA DX, Z_CANCER
    JMP P_Z
Z_JUL: 
    CMP BX, 23
    JAE J7
    LEA DX, Z_CANCER
    JMP P_Z
J7: LEA DX, Z_LEO
    JMP P_Z
Z_AUG: 
    CMP BX, 23
    JAE J8
    LEA DX, Z_LEO
    JMP P_Z
J8: LEA DX, Z_VIRGO
    JMP P_Z
Z_SEP: 
    CMP BX, 23
    JAE J9
    LEA DX, Z_VIRGO
    JMP P_Z
J9: LEA DX, Z_LIBRA
    JMP P_Z
Z_OCT: 
    CMP BX, 24
    JAE J10
    LEA DX, Z_LIBRA
    JMP P_Z
J10: LEA DX, Z_SCORPIO
    JMP P_Z
Z_NOV: 
    CMP BX, 22
    JAE J11
    LEA DX, Z_SCORPIO
    JMP P_Z
J11: LEA DX, Z_SAGIT
    JMP P_Z
Z_DEC: 
    CMP BX, 22
    JAE J12
    LEA DX, Z_SAGIT
    JMP P_Z
J12: LEA DX, Z_CAPRI
P_Z:
    MOV AH, 9
    INT 21H
    RET
GET_ZODIAC ENDP

END MAIN
