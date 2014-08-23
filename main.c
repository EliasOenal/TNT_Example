// Thumb2 Newlib Toolchain example project
// Written by Elias Önal <EliasOenal@gmail.com>, released as public domain.

#include <stdio.h>
#include <stdint.h>

#ifdef ST_LIB
#ifdef STM32F4
#include "stm32f4xx_hal_gpio.h"
#include "stm32f4xx_hal_rcc.h"
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
#ifdef STM32F4
  		__GPIOD_CLK_ENABLE();
#endif
		// Configure pins
		GPIO_InitTypeDef GPIO_InitStructure;
		GPIO_InitStructure.Pin =  GPIO_PIN_12 | GPIO_PIN_13 | GPIO_PIN_14 | GPIO_PIN_15;
#ifdef STM32F4
		GPIO_InitStructure.Mode = GPIO_MODE_OUTPUT_PP;
        GPIO_InitStructure.Pull = GPIO_PULLUP;
        GPIO_InitStructure.Speed = GPIO_SPEED_FAST;
#endif
		HAL_GPIO_Init(GPIOD, &GPIO_InitStructure);
	}
#endif //ST_LIB

	while (1)
	{
#ifdef ST_LIB
		HAL_GPIO_WritePin(GPIOD, GPIO_PIN_12, GPIO_PIN_SET);
		delay(0x3FFFFF);
		HAL_GPIO_WritePin(GPIOD, GPIO_PIN_13, GPIO_PIN_SET);
		delay(0x3FFFFF);
		HAL_GPIO_WritePin(GPIOD, GPIO_PIN_14, GPIO_PIN_SET);
		delay(0x3FFFFF);
		HAL_GPIO_WritePin(GPIOD, GPIO_PIN_15, GPIO_PIN_SET);
		delay(0x7FFFFF);
		HAL_GPIO_WritePin(GPIOD, GPIO_PIN_12|GPIO_PIN_13|GPIO_PIN_14|GPIO_PIN_15, GPIO_PIN_RESET);
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
