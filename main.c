// Thumb2 Newlib Toolchain example project
// Written by Elias Önal <EliasOenal@gmail.com>, released as public domain.

#include <stdio.h>
#include <stdint.h>

#ifdef ST_LIB
#ifdef STM32F4
#include "stm32f4xx_hal.h"
#endif
#endif //ST_LIB

void delay(volatile unsigned int count);

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
		HAL_Init();
#ifdef STM32F4
  		__GPIOG_CLK_ENABLE();
#endif
		// Configure pins
		GPIO_InitTypeDef GPIO_InitStructure;
		GPIO_InitStructure.Pin =  GPIO_PIN_13 | GPIO_PIN_14;
#ifdef STM32F4
		GPIO_InitStructure.Mode = GPIO_MODE_OUTPUT_PP;
        GPIO_InitStructure.Pull = GPIO_PULLUP;
        GPIO_InitStructure.Speed = GPIO_SPEED_LOW;
#endif
		HAL_GPIO_Init(GPIOG, &GPIO_InitStructure);
	}
#endif //ST_LIB

	while (1)
	{
#ifdef ST_LIB
		HAL_GPIO_WritePin(GPIOG, GPIO_PIN_13, GPIO_PIN_SET);
		HAL_Delay(500);
		HAL_GPIO_WritePin(GPIOG, GPIO_PIN_14, GPIO_PIN_SET);
		HAL_Delay(500);
		HAL_GPIO_WritePin(GPIOG, GPIO_PIN_13 | GPIO_PIN_14, GPIO_PIN_RESET);
		HAL_Delay(1000);
#else
		// Do nothing
#endif //ST_LIB
	}
}
