# Thumb2 Newlib Toolchain example project
# Written by Elias Önal <EliasOenal@gmail.com>, released as public domain.

#Path to toolchain - Uncomment as you need
#TOOLCHAIN = $HOME/toolchain/bin
#export PATH = $TOOLCHAIN:$PATH

# comment the next line if LTO isn't supported
#OPTIMIZE += -flto -flto-partition=none #-fno-use-linker-plugin
OPT = s
DEBUG = -g -gdwarf-2

STM32F4 = 1
BUILD_ST_LIB = 1
CFLAGS += -D "HSE_VALUE=((uint32_t)8000000)" # 8mhz clock source


# Toolchain prefix
TARGET = arm-none-eabi

ifdef STM32F4
ARCH_FLAGS = -mthumb -march=armv7e-m -mfloat-abi=hard -mfpu=fpv4-sp-d16 # Cortex-M4 with FPU
else
$(error " Uncomment STM32F4")
endif

CC = $(TARGET)-gcc -fdiagnostics-color=auto
CXX = $(TARGET)-g++ -fdiagnostics-color=auto
OBJCOPY = $(TARGET)-objcopy
OBJDUMP = $(TARGET)-objdump
SIZE = $(TARGET)-size
NM = $(TARGET)-nm

BUILDDIR = build
EXECUTABLE = $(BUILDDIR)/firmware

CFLAGS += -c
CFLAGS += $(MODEL)
CFLAGS += -std=gnu99
CFLAGS += $(ARCH_FLAGS)

ASFLAGS += -c
ASFLAGS += $(ARCH_FLAGS)

LDFLAGS += $(ARCH_FLAGS)
LDFLAGS += -Tlinker_script/simple.ld
LDFLAGS += -static
#LDFLAGS += -nostartfiles
#CFLAGS += -fno-builtin
#LDFLAGS += -nostdlib
#LDFLAGS += -nodefaultlibs
LDFLAGS += -lc
LDFLAGS += -lm
LDFLAGS += -lgcc
#LDFLAGS += -lnosys #newlib specific - stub syscalls
LDFLAGS += -Wl,-Map=$(EXECUTABLE).map


OPTIMIZE += -O$(OPT)
CFLAGS += -ffunction-sections
CFLAGS += -fdata-sections
LDFLAGS += -Wl,--gc-sections

CFLAGS += $(OPTIMIZE) $(DEBUG)
LDFLAGS += $(OPTIMIZE) $(DEBUG)

ST_LIB_PATH = STM32Cube_FW_F4_V1.3.0

ifdef STM32F4
CFLAGS += -DSTM32F4
CFLAGS += -DSTM32F407xx
ST_CMSIS_CORE = $(ST_LIB_PATH)/Drivers/CMSIS
ST_CMSIS_DEVICE = $(ST_LIB_PATH)/Drivers/CMSIS/Device/ST/STM32F4xx
CSRC += $(ST_CMSIS_DEVICE)/Source/Templates/system_stm32f4xx.c
ASRC += $(ST_CMSIS_DEVICE)/Source/Templates/gcc/startup_stm32f407xx.s
endif

ifdef BUILD_ST_LIB
ifdef STM32F4
ST_STD_PERIPH_LIB = $(ST_LIB_PATH)/Drivers/STM32F4xx_HAL_Driver
_ST_STD_PERIPH_LIB_SRC += 	stm32f4xx_hal.c               stm32f4xx_hal_hash.c          stm32f4xx_hal_rcc_ex.c \
				stm32f4xx_hal_adc.c           stm32f4xx_hal_hash_ex.c       stm32f4xx_hal_rng.c \
				stm32f4xx_hal_adc_ex.c        stm32f4xx_hal_hcd.c           stm32f4xx_hal_rtc.c \
				stm32f4xx_hal_can.c           stm32f4xx_hal_i2c.c           stm32f4xx_hal_rtc_ex.c \
				stm32f4xx_hal_cortex.c        stm32f4xx_hal_i2c_ex.c        stm32f4xx_hal_sai.c \
				stm32f4xx_hal_crc.c           stm32f4xx_hal_i2s.c           stm32f4xx_hal_sd.c \
				stm32f4xx_hal_cryp.c          stm32f4xx_hal_i2s_ex.c        stm32f4xx_hal_sdram.c \
				stm32f4xx_hal_cryp_ex.c       stm32f4xx_hal_irda.c          stm32f4xx_hal_smartcard.c \
				stm32f4xx_hal_dac.c           stm32f4xx_hal_iwdg.c          stm32f4xx_hal_spi.c \
				stm32f4xx_hal_dac_ex.c        stm32f4xx_hal_ltdc.c          stm32f4xx_hal_sram.c \
				stm32f4xx_hal_dcmi.c          stm32f4xx_hal_msp_template.c  stm32f4xx_hal_tim.c \
				stm32f4xx_hal_dma.c           stm32f4xx_hal_nand.c          stm32f4xx_hal_tim_ex.c \
				stm32f4xx_hal_dma2d.c         stm32f4xx_hal_nor.c           stm32f4xx_hal_uart.c \
				stm32f4xx_hal_dma_ex.c        stm32f4xx_hal_pccard.c        stm32f4xx_hal_usart.c \
				stm32f4xx_hal_eth.c           stm32f4xx_hal_pcd.c           stm32f4xx_hal_wwdg.c \
				stm32f4xx_hal_flash.c         stm32f4xx_hal_pcd_ex.c        stm32f4xx_ll_fmc.c \
				stm32f4xx_hal_flash_ex.c      stm32f4xx_hal_pwr.c           stm32f4xx_ll_fsmc.c \
				stm32f4xx_hal_flash_ramfunc.c stm32f4xx_hal_pwr_ex.c        stm32f4xx_ll_sdmmc.c \
				stm32f4xx_hal_gpio.c          stm32f4xx_hal_rcc.c           stm32f4xx_ll_usb.c

#CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -DST_LIB
CFLAGS += -D"assert_param(expr)=((void)0)"
INCLUDE += $(ST_STD_PERIPH_LIB)/Inc
CSRC += $(patsubst %, $(ST_STD_PERIPH_LIB)/Src/%,$(_ST_STD_PERIPH_LIB_SRC))
endif
endif

CSRC += main.c syscalls.c
COBJ += $(patsubst %, $(BUILDDIR)/%,$(CSRC:.c=.o))

#ASRC += (FILES GO HERE)
AOBJ += $(patsubst %, $(BUILDDIR)/%,$(ASRC:.s=.o))

INCLUDE += $(ST_CMSIS_DEVICE)/Include $(ST_CMSIS_CORE)/Include
INCLUDE += $(ST_LIB_PATH)/Projects/STM32F4-Discovery/Templates/Inc

CFLAGS += $(patsubst %,-I%,$(INCLUDE))


all: setup $(EXECUTABLE).elf $(EXECUTABLE).bin $(EXECUTABLE).lss $(EXECUTABLE).sym size

size: $(EXECUTABLE).elf $(EXECUTABLE).bin $(EXECUTABLE).lss $(EXECUTABLE).sym
	$(SIZE) -A $(EXECUTABLE).elf

setup:
	@mkdir -p $(BUILDDIR)
	@mkdir -p $(BUILDDIR)/$(ST_STD_PERIPH_LIB)/Src
	@mkdir -p $(BUILDDIR)/$(ST_CMSIS_DEVICE)/Source/Templates/gcc/

clean:
	@echo CLEANING UP:
	rm -rf $(BUILDDIR)


$(COBJ): $(BUILDDIR)/%.o : %.c setup
	@echo COMPILING: $<
	$(CC) $(CFLAGS) $< -o $@

$(AOBJ): $(BUILDDIR)/%.o : %.s setup
	@echo ASSEMBLING:
	$(CC) $(ASFLAGS) $< -o $@

$(EXECUTABLE).elf:  $(COBJ) $(AOBJ)
	@echo LINKING: $@
	$(CC) $(LDFLAGS) $(COBJ) $(AOBJ) -o $@

$(EXECUTABLE).hex: $(EXECUTABLE).elf
	$(OBJCOPY) -O binary $< $@

$(EXECUTABLE).bin: $(EXECUTABLE).elf
	$(OBJCOPY) -O binary $< $@

$(EXECUTABLE).lss: $(EXECUTABLE).elf
	@echo GENERATING EXTENDED LISTING: $@
	$(OBJDUMP) -h -S -D $< > $@

$(EXECUTABLE).sym: $(EXECUTABLE).elf
	@echo GENERATING SYMBOL TABLE: $@
	$(NM) -n $< > $@
