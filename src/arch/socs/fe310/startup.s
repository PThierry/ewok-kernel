/**
  ***************************************************************************
  * @file      startup_fe310.s
  * @version   V1.0.0
  * @date      02-Jully-2019
  * @brief     RISCV FE310 SoC startup table
  * @Licence:  Apache2
  ***************************************************************************
  */

.syntax unified
.cpu riscv
.fpu softvfp

.global g_BaseAddress
.global g_StackAddress

.extern Default_SubHandler

/* start address for the initialization values of the .data section. defined in linker script */
.word   _sidata
/* start address for the .data section. defined in linker script */
.word   _sdata
/* end address for the .data section. defined in linker script */
.word   _edata
/* start address for the .bss section. defined in linker script */
.word   _sbss
/* end address for the .bss section. defined in linker script */
.word   _ebss
.word   _sigot
.word   _sgot
.word   _egot



.section .data
g_BaseAddress:
    .word 0
g_StackAddress:
    .word 0


.section .text.Reset_Handler
    .weak  Reset_Handler
    .type  Reset_Handler, %function
Reset_Handler:

  /* set 0 in mtvec (base for IVT) */
  csrrw x0, mtvec, x0

  /* set all registers to zero */
  mv  x1, x0
  mv  x2, x1
  mv  x3, x1
  mv  x4, x1
  mv  x5, x1
  mv  x6, x1
  mv  x7, x1
  mv  x8, x1
  mv  x9, x1
  mv x10, x1
  mv x11, x1
  mv x12, x1
  mv x13, x1
  mv x14, x1
  mv x15, x1
  mv x16, x1
  mv x17, x1
  mv x18, x1
  mv x19, x1
  mv x20, x1
  mv x21, x1
  mv x22, x1
  mv x23, x1
  mv x24, x1
  mv x25, x1
  mv x26, x1
  mv x27, x1
  mv x28, x1
  mv x29, x1
  mv x30, x1
  mv x31, x1

  /* stack initilization */
  la   x2, _stack_start

_start:
  .global _start

  /* clear BSS */
  la x26, _bss_start
  la x27, _bss_end

  bge x26, x27, zero_loop_end

zero_loop:
  sw x0, 0(x26)
  addi x26, x26, 4
  ble x26, x27, zero_loop
zero_loop_end:

main_entry:
  /* jump to main program entry point (argc = argv = 0) */
  addi x10, x0, 0
  addi x11, x0, 0
  jal x1, main
  mv s0, a0
  jal  uart_wait_tx_done;
  mv a0, s0
  /* if program exits call exit routine from library */
  jal  x1, exit


/* next to be added..., including branch to kernel init */

.size  Reset_Handler, .-Reset_Handler


.section .text.Default_Handler
    .weak  Default_Handler
    .type  Default_Handler, %function
Default_Handler:
    /*clear interrupt (CSR clear sstatus SR_SIE field) */


    /*
     * 2) Save registers on the previously used stack.
     *    x0->x31 to the saved registers
     */

    /* 3) Adjusting the previously used stack pointer */

    /*
     * x10 is passed as a parameter. It still points to the saved registers.
     */

    jal     Default_SubHandler

    /* Registers restore */

    fence iorw,iorw
    /* enable interrrupt */
    iret
.size Default_Handler, .-Default_Handler


