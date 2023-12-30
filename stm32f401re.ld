EXTERN(vector_table)

/* Entry Point */
ENTRY(reset_handler)

/* Memories definition */
MEMORY
{
 ram (rwx) : ORIGIN = 0x20000000, LENGTH = 96K
 rom (rx)  : ORIGIN = 0x08000000, LENGTH = 512K
}

/* Section definitions */
SECTIONS
{
  /* We don't need exceptions, and discarding these sections
     prevents linker errors with LDC */
  /DISCARD/ :
  {
    *(.ARM.extab*)
    *(.ARM.exidx*)
  }

  /* program code placed in rom */
 .text : {
    *(.vectors)  /* Startup vector table */
    *(.text)    /* text sections */
    *(.text*)    /* text sections */
    . = ALIGN(4);
    *(.rodata)  /* Read only data */
    *(.rodata*)  /* Read only data */
    . = ALIGN(4);
 } >rom

  /* array initialization code placed in rom */
 .preinit_array : {
    . = ALIGN(4);
    __preinit_array_start = .;
    KEEP (*(.preinit_array))
    __preinit_array_end = .;
 } >rom

  /* array initialization code placed in rom */
 .init_array : {
    . = ALIGN(4);
    __init_array_start = .;
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array))
    __init_array_end = .;
 } >rom

  /* array initialization code placed in rom */
 .fini_array : {
    . = ALIGN(4);
    __fini_array_start = .;
    KEEP (*(.fini_array))
    KEEP (*(SORT(.fini_array.*)))
    __fini_array_end = .;
 } >rom

 /* ARM exception table
 .ARM.extab : {
    *(.ARM.extab*)
 } >rom

 /* ARM start address table
 .ARM.exidx : {
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
 } >rom
*/
 /* _etext = The first address following the program text. */
 . = ALIGN(4);
 _etext = .;

 /* ram not initialized at startup */
 .noinit (NOLOAD) : {
    *(.noinit*)
 } >ram

 . = ALIGN(4);

 /* initialized global variables */
 .data : {
    _data = .;
    *(.data*)
    *(.ramtext*)
    . = ALIGN(4);
    _edata = .; /* The first address following the initialized vars region. */
 } >ram AT >rom

 _data_loadaddr = LOADADDR(.data);

 /* Block starting symbol = uninitialized global variables */
 .bss : {
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .; /* The first address following the uninitialized vars region. */
 } >ram

 /* throw away exception frames */
 /DISCARD/ : { *(.eh_frame) }
 . = ALIGN(4);
 end = .;
}

/* Setup stack to the top of ram */
PROVIDE(_stack = ORIGIN(ram) + LENGTH(ram));
