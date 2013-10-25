// Thumb2 Newlib Toolchain example project
// Written by Elias Önal <EliasOenal@gmail.com>, released as public domain.

#include <stdio.h>
#include <stdint.h>

#ifdef ST_LIB
#ifdef STM32F4
#include "stm32f4xx_gpio.h"
#include "stm32f4xx_rcc.h"
#elif STM32F1
#include "stm32f10x_gpio.h"
#include "stm32f10x_rcc.h"
#endif
#endif //ST_LIB

void delay(volatile unsigned int count);

//void SystemInit()
//{
//}

int main(void)
{
	// Testing some syscalls
	//_write("hello world"); // Can output only strings, most memory conserving.
	//iprintf("hello world"); // Format strings without floats, memory conserving.
	//printf("hello world"); // Everything, huge waste of memory.

	//void* ptr = malloc(0x400); // One kilobyte of heap please!
	//free(ptr); // Actually I didn't really need it.

#ifdef ST_LIB
	{
#ifdef STM32F1
		RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOD, ENABLE);
#elif STM32F4
  		RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);
#endif
		// Configure pins
		GPIO_InitTypeDef GPIO_InitStructure;
		GPIO_InitStructure.GPIO_Pin =  GPIO_Pin_12 | GPIO_Pin_13 | GPIO_Pin_14 | GPIO_Pin_15;
#ifdef STM32F1
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
#elif STM32F4
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
  		GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz;
		GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
#endif
		GPIO_Init(GPIOD, &GPIO_InitStructure);
	}
#endif //ST_LIB

	while (1)
	{
#ifdef ST_LIB
		GPIO_SetBits(GPIOD, GPIO_Pin_12);
		delay(0x3FFFFF);
		GPIO_SetBits(GPIOD, GPIO_Pin_13);
		delay(0x3FFFFF);
		GPIO_SetBits(GPIOD, GPIO_Pin_14);
		delay(0x3FFFFF);
		GPIO_SetBits(GPIOD, GPIO_Pin_15);
		delay(0x7FFFFF);
		GPIO_ResetBits(GPIOD, GPIO_Pin_12|GPIO_Pin_13|GPIO_Pin_14|GPIO_Pin_15);
		delay(0xFFFFFF);
#else
		delay(0xDEADBEEF);
#endif //ST_LIB
	}
}

// Do nothing, for a while (what a pun!)
void delay(volatile unsigned int count)
{
  while(count--)
  {
  }
}
