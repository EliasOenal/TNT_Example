/*
Thumb2 Newlib Toolchain example project
Written by Elias Önal <EliasOenal@gmail.com>, released as public domain.

This is a minimal linkerscript that should be easy to port to new microcontrollers.
At this point it supports only C and will lead to weird behavior when used for C++.
*/

ENTRY(Reset_Handler)

MEMORY
{
  RAM (xrw) : ORIGIN = 0x20000000, LENGTH = 16K
  FLASH (rx) : ORIGIN = 0x8000000, LENGTH = 64K
}

_estack = 0x20004000; /* Upper stack boundary */
_sstack = (_estack - 1024); /* Lower stack boundary */

SECTIONS {
	.isr_vector : /* interrupt vector */
	{
		. = ALIGN(4);
		_svector = .;
		KEEP(*(.isr_vector))
		. = ALIGN(4);
	} > FLASH

	.text : /* code goes here*/
	{
		. = ALIGN(4);
		*(.text)
		*(.text.*)
		*(.eh_frame) /* Exception handling frame for C++ */
		KEEP (*(.init))
		KEEP (*(.fini))
		. = ALIGN(4);
		_etext = .;
	} > FLASH

	.rodata : /* read only data */
	{
		. = ALIGN(4);
		*(.rodata)
		*(.rodata.*)
		. = ALIGN(4);
		_sidata = .;
	} > FLASH

	.ARM.extab : /* Exception table */
	{
		. = ALIGN(4);
		*(.ARM.extab*)
		*(.gnu.linkonce.armextab.*)
		. = ALIGN(4);
	} > FLASH

	.ARM : /* Exception Index table */
	{
		. = ALIGN(4);
		__exidx_start = .;
		*(.ARM.exidx*)
		__exidx_end = .;
		. = ALIGN(4);
	} > FLASH

	.preinit_array :
	{
		. = ALIGN(4);
		PROVIDE_HIDDEN (__preinit_array_start = .);
		KEEP (*(.preinit_array*))
		PROVIDE_HIDDEN (__preinit_array_end = .);
		. = ALIGN(4);
	} > FLASH

	.init_array :
	{
		. = ALIGN(4);
		PROVIDE_HIDDEN (__init_array_start = .);
		KEEP (*(SORT(.init_array.*)))
		KEEP (*(.init_array*))
		PROVIDE_HIDDEN (__init_array_end = .);
		. = ALIGN(4);
	} > FLASH

	.fini_array :
	{
		. = ALIGN(4);
		PROVIDE_HIDDEN (__fini_array_start = .);
		KEEP (*(SORT(.fini_array.*)))
		KEEP (*(.fini_array*))
		PROVIDE_HIDDEN (__fini_array_end = .);
		. = ALIGN(4);
	} > FLASH

	_sidata = LOADADDR(.data);
	.data : /* initial .data values go to _sidata */
	{
		. = ALIGN(4);
		_sdata = . ;
		_data = . ;
		*(.data)
		*(.data.*)
		. = ALIGN(4);
		_edata = . ;
	} > RAM AT > FLASH

	.bss : /* zero initialized memory */
	{
		. = ALIGN(4);
		_sbss = .;
		_bss = .;
		*(.bss)
		*(.bss.*)
		. = ALIGN(4);
		_ebss = . ;
	} > RAM

	/DISCARD/ : /* discarding sections */
	{

	}
}

. = ALIGN(4);
end = .;
_end = .;
