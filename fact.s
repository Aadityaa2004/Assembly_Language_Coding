	.globl fact
	add X0, XZR, XZR
	add X0, X0, #6
	BL		fact
	nop
fact:
	SUBS	XZR, X0, #1
	B.GT	else
	BR		X30
else:
	SUB 	SP, SP, #16
	STUR 	X30, [SP, #8]
	STUR 	X0, [SP, #0]
	SUB 	X0, X0, #1
	BL		fact
	LDUR 	X9, [SP, #0]
	LDUR 	X30, [SP, #8]
	ADD 	SP, SP, #16
	MUL 	X0, X9, X0
	BR		X30
