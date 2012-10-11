# Thumb2 Newlib Toolchain example project
# Written by Elias Önal <EliasOenal@gmail.com>, released as public domain.

#Path to toolchain - Uncomment as you need
#TOOLCHAIN = $HOME/toolchain/bin
#export PATH = $TOOLCHAIN:$PATH

#STM32F1 = 1
STM32F4 = 1
BUILD_ST_LIB = 1
CFLAGS += -D "HSE_VALUE=((uint32_t)8000000)" # 8mhz clock source

ifdef STM32F1
# You probably want to change the startup code as well if you change the model here.
#MODEL = -DSTM32F10X_LD
#MODEL = -DSTM32F10X_LD_VL
MODEL = -DSTM32F10X_MD
#MODEL = -DSTM32F10X_MD_VL
#MODEL = -DSTM32F10X_HD
#MODEL = -DSTM32F10X_HD_VL
#MODEL = -DSTM32F10X_XL
#MODEL = -DSTM32F10X_CL
endif

TARGET = arm-none-eabi // Toolchain prefix
ifdef STM32F4
ARCH_FLAGS = -mthumb -march=armv7e-m -mfloat-abi=hard -mfpu=fpv4-sp-d16 # Cortex-M4 with FPU
else
ifdef STM32F1
ARCH_FLAGS = -mthumb -march=armv7-m -mfloat-abi=soft # Cortex-M3
else
$(error "Uncomment either STM32F1 or STM32F4")
endif
endif

#ARCH_FLAGS = -mthumb -march=armv7e-m -mfloat-abi=soft # Cortex-M4
#ARCH_FLAGS = -mthumb -march=armv6s-m -mfloat-abi=soft # Cortex-M0

CC = $(TARGET)-gcc
CXX = $(TARGET)-g++
OBJCOPY = $(TARGET)-objcopy
OBJDUMP = $(TARGET)-objdump
SIZE = $(TARGET)-size
NM = $(TARGET)-nm

OPT = s
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
LDFLAGS += -nostartfiles -static
LDFLAGS += -lm -lc -lgcc 
LDFLAGS += -lnosys #newlib specific - stub syscalls
LDFLAGS += -Wl,-Map=$(EXECUTABLE).map


OPTIMIZE += -O$(OPT)
#OPTIMIZE += -flto -flto-partition=none -fno-use-linker-plugin
CFLAGS += -ffunction-sections
CFLAGS += -fdata-sections
LDFLAGS += -Wl,--gc-sections

CFLAGS += $(OPTIMIZE)
LDFLAGS += $(OPTIMIZE)

ST_LIB_PATH = STM32_USB-Host-Device_Lib_V2.1.0
ST_CMSIS_CORE = $(ST_LIB_PATH)/Libraries/CMSIS

ifdef STM32F4
CFLAGS += -DSTM32F4
ST_CMSIS_DEVICE = $(ST_LIB_PATH)/Libraries/CMSIS/Device/ST/STM32F4xx
CSRC += $(ST_CMSIS_DEVICE)/Source/Templates/system_stm32f4xx.c
ASRC += $(ST_CMSIS_DEVICE)/Source/Templates/gcc_ride7/startup_stm32f4xx.s
else
ifdef STM32F1
CFLAGS += -DSTM32F1
ST_CMSIS_DEVICE = $(ST_LIB_PATH)/Libraries/CMSIS/Device/ST/STM32F10x
CSRC += $(ST_CMSIS_DEVICE)/Source/Templates/system_stm32f10x.c
ASRC += $(ST_CMSIS_DEVICE)/Source/Templates/gcc_ride7/startup_stm32f10x_md.s
endif
endif

ifdef BUILD_ST_LIB
ifdef STM32F4
ST_STD_PERIPH_LIB = $(ST_LIB_PATH)/Libraries/STM32F4xx_StdPeriph_Driver
_ST_STD_PERIPH_LIB_SRC += 	misc.c                stm32f4xx_dac.c       stm32f4xx_hash.c      stm32f4xx_rtc.c \
				stm32f4xx_adc.c       stm32f4xx_dbgmcu.c    stm32f4xx_hash_md5.c  stm32f4xx_sdio.c \
				stm32f4xx_can.c       stm32f4xx_dcmi.c      stm32f4xx_hash_sha1.c stm32f4xx_spi.c \
				stm32f4xx_crc.c       stm32f4xx_dma.c       stm32f4xx_i2c.c       stm32f4xx_syscfg.c \
				stm32f4xx_cryp.c      stm32f4xx_exti.c      stm32f4xx_iwdg.c      stm32f4xx_tim.c \
				stm32f4xx_cryp_aes.c  stm32f4xx_flash.c     stm32f4xx_pwr.c       stm32f4xx_usart.c \
				stm32f4xx_cryp_des.c  stm32f4xx_fsmc.c      stm32f4xx_rcc.c       stm32f4xx_wwdg.c \
				stm32f4xx_cryp_tdes.c stm32f4xx_gpio.c      stm32f4xx_rng.c
else
ifdef STM32F1
ST_STD_PERIPH_LIB = $(ST_LIB_PATH)/Libraries/STM32F10x_StdPeriph_Driver
_ST_STD_PERIPH_LIB_SRC += 	misc.c             stm32f10x_crc.c    stm32f10x_flash.c  stm32f10x_pwr.c    stm32f10x_tim.c \
				stm32f10x_adc.c    stm32f10x_dac.c    stm32f10x_fsmc.c   stm32f10x_rcc.c    stm32f10x_usart.c \
				stm32f10x_bkp.c    stm32f10x_dbgmcu.c stm32f10x_gpio.c   stm32f10x_rtc.c    stm32f10x_wwdg.c \
				stm32f10x_can.c    stm32f10x_dma.c    stm32f10x_i2c.c    stm32f10x_sdio.c \
				stm32f10x_cec.c    stm32f10x_exti.c   stm32f10x_iwdg.c   stm32f10x_spi.c
endif
endif
#CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -DST_LIB
CFLAGS += -D"assert_param(expr)=((void)0)"
INCLUDE += $(ST_STD_PERIPH_LIB)/inc
CSRC += $(patsubst %, $(ST_STD_PERIPH_LIB)/src/%,$(_ST_STD_PERIPH_LIB_SRC))
endif

CSRC += main.c syscalls.c
COBJ += $(patsubst %, $(BUILDDIR)/%,$(CSRC:.c=.o))

#ASRC += (FILES GO HERE)
AOBJ += $(patsubst %, $(BUILDDIR)/%,$(ASRC:.s=.o))

INCLUDE += $(ST_CMSIS_CORE)/Include $(ST_CMSIS_DEVICE)/Include
CFLAGS += $(patsubst %,-I%,$(INCLUDE))

all: setup elf bin lss sym size

size:
	$(SIZE) $(EXECUTABLE).elf

setup:
	@mkdir -p $(BUILDDIR)
	@mkdir -p $(BUILDDIR)/$(ST_STD_PERIPH_LIB)/src
	@mkdir -p $(BUILDDIR)/$(ST_CMSIS_DEVICE)/Source/Templates
	@mkdir -p $(BUILDDIR)/$(ST_CMSIS_DEVICE)/Source/Templates/gcc_ride7/

clean:
	@echo CLEANING UP:
	rm -rf $(BUILDDIR)


$(COBJ): $(BUILDDIR)/%.o : %.c
	@echo COMPILING: $<
	$(CC) $(CFLAGS) $< -o $@

$(AOBJ): $(BUILDDIR)/%.o : %.s
	@echo ASSEMBLING:
	$(CC) $(ASFLAGS) $< -o $@

elf: $(EXECUTABLE).elf
bin: $(EXECUTABLE).bin
hex: $(EXECUTABLE).hex
lss: $(EXECUTABLE).lss 
sym: $(EXECUTABLE).sym

%.elf:  $(COBJ) $(AOBJ)
	@echo LINKING: $@
	$(CC) $(LDFLAGS) $(COBJ) $(AOBJ) -o $@

%.hex: %.elf
	$(OBJCOPY) -O binary $< $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.lss: %.elf
	@echo GENERATING EXTENDED LISTING: $@
	$(OBJDUMP) -h -S -D $< > $@

%.sym: %.elf
	@echo GENERATING SYMBOL TABLE: $@
	$(NM) -n $< > $@
