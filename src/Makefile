APP_NAME ?= kernel
DIR_NAME = kernel

PROJ_FILES = ../../
BIN_NAME = $(APP_NAME).bin
HEX_NAME = $(APP_NAME).hex
ELF_NAME = $(APP_NAME).elf


IMAGE_TYPE = IMAGE_TYPE0
VERSION = 1
#############################

-include $(PROJ_FILES)/m_config.mk
-include $(PROJ_FILES)/m_generic.mk

-include $(PROJ_FILES)/kernel/src/arch/socs/$(SOC)/Makefile.objs
-include $(PROJ_FILES)/kernel/src/arch/cores/$(ARCH)/Makefile.objs
-include $(PROJ_FILES)/kernel/src/arch/boards/Makefile.objs

# use an app-specific build dir
APP_BUILD_DIR = $(BUILD_DIR)/$(DIR_NAME)
ADA_BUILD_DIR = $(APP_BUILD_DIR)/Ada

#CFLAGS := $(KERN_CFLAGS)
#CFLAGS += $(EXTRA_CFLAGS)
#CFLAGS += -I. -IC -IC/syscalls -IC/generated -I$(CORE_DIR) -Iarch
#CFLAGS += -MMD -MP
#CFLAGS += -fstack-protector-strong
#CFLAGS += -I$(PROJ_FILES)/kernel/src/arch
#CFLAGS += -I$(CORE_DIR) -Iarch -Iarch/cores/$(CONFIG_ARCH)/C -Iarch/socs/$(CONFIG_SOCNAME)/C -Iarch/boards/$(CONFIG_BOARDNAME) -Iarch/boards
#CFLAGS += -I$(PROJ_FILES)/include/generated
#
#
#CLANG_CFLAGS := -I../../include/generated -I. -Isyscalls -I../src/generated  -I$(CORE_DIR) -Iarch -Iarch/cores/$(ARCH)/C -Iarch/socs/$(SOC)/C -Iarch/boards/$(BOARD) -Iarch/boards
#
## if no specific ldscript is specified, using default one, if the SDK want to relink successively with
## varous ldscripts, this variable has to be passed to the Makefile commandline
#EXTRA_LDFLAGS ?= -Tkernel.ld
#
#LDFLAGS += $(EXTRA_LDFLAGS) -L$(APP_BUILD_DIR) $(AFLAGS_GCC) -fno-builtin -nostdlib -nostartfiles -Xlinker
#
#
#LD_LIBS = -lkernel -L$(APP_BUILD_DIR)/Ada/lib
#LD_LIBS += -lgnat -L$(BUILD_DIR)/kernel/libgnat

BUILD_DIR ?= $(PROJ_FILE)build

OUT_DIRS = $(dir $(KERNEL_OBJ)) $(dir $(AALI)) $(dir $(ROBJ)) $(dir $(ALIB))

LDSCRIPT_NAME = $(APP_BUILD_DIR)/$(APP_NAME).ld

# file to (dist)clean
# objects and compilation related
TODEL_CLEAN +=  $(LDSCRIPT_NAME)
# targets
TODEL_DISTCLEAN += $(APP_BUILD_DIR)

.PHONY: __clean __distclean

default: all

ifeq (,$(CONFIG_PROJ_FILES))
# let's detect if the kernel is trying to be compiled out of any SDK...
all:
	@echo "The Ewok kernel is not made to be compiled out of any SDK"
	@echo "please use the following command:"
	@echo "  repo init -u https://github.com/wookey-project/manifest.git -m default.xml"
	@echo "  repo sync"
	@echo
	@echo "This will create a wookey directory in which the whole SDK (including kernel)"
	@echo "is downloaded and can be compiled"
else

all: $(APP_BUILD_DIR) $(ADA_BUILD_DIR) kernel

endif

show:
	@echo
	@echo "\t\tAPP_BUILD_DIR\t=> " $(APP_BUILD_DIR)
	@echo
	@echo "C sources files:"
	@echo "\t\tKERNEL_ASRC\t=> $(ASRC)"
	@echo "\t\tKERNEL_SRC\t=> " $(SRC)
	@echo "\t\tKERNEL_OBJ\t=> " $(OBJ)
	@echo "\t\tKERNEL_DEP\t=> " $(DEP)
	@echo
	@echo "\t\tBUILD_DIR\t=> " $(BUILD_DIR)
	@echo "\t\tAPP_BUILD_DIR\t=> " $(APP_BUILD_DIR)
	@echo

#libgnat:
#	$(Q)$(MAKE) -C libgnat all

kernel: $(APP_BUILD_DIR)/$(ELF_NAME) $(APP_BUILD_DIR)/$(HEX_NAME)

#############################################################
# build targets (driver, core, SoC, Board... and local)
# App C sources files
# kernel C sources files


ewok: ewok.gpr
	mkdir -p $(APP_BUILD_DIR)/obj
	LD_FILE=$(APP_NAME).ld KERN_BINARY=$(APP_NAME).elf ADA_ARCH=$(CONFIG_ADA_ARCH) ADA_RUNTIME=$(ADA_RUNTIME) ADA_PROFILE=$(CONFIG_ADA_PROFILE) BUILD_DIR=$(APP_BUILD_DIR) SOC=$(SOC) ARCH=$(CONFIG_ARCH) SOCNAME=$(CONFIG_SOCNAME) KERNEL_ADA_BUILDSIZE=$(CONFIG_KERNEL_ADA_BUILDSIZE) gprbuild -vm -P$< -XLDSCRIPT=$(APP_NAME).ld


sanitize: $(SRC)
	clang -target armv7-m -mfloat-abi=hard -mcpu=cortex-m4 $(CLANG_CFLAGS) --analyze $(SRC)

# LDSCRIPT. All are built in one time
$(LDSCRIPT_NAME): ../$(APP_NAME).ld.in
	$(call if_changed,k_ldscript)

# ELF
$(APP_BUILD_DIR)/$(ELF_NAME): $(LDSCRIPT_NAME) ewok

# HEX
$(APP_BUILD_DIR)/$(HEX_NAME): $(APP_BUILD_DIR)/$(ELF_NAME)
	$(call if_changed,objcopy_ihex)

# BIN
$(APP_BUILD_DIR)/$(BIN_NAME): $(APP_BUILD_DIR)/$(ELF_NAME)
	$(call if_changed,objcopy_bin)

$(APP_BUILD_DIR):
	$(call cmd,mkdir)

$(ADA_BUILD_DIR):
	$(call cmd,mkdir)

__clean: ewok.gpr
	LD_FILE=$(APP_NAME).ld KERN_BINARY=$(APP_NAME).elf ADA_ARCH=$(CONFIG_ADA_ARCH) ADA_RUNTIME=$(ADA_RUNTIME) ADA_PROFILE=$(CONFIG_ADA_PROFILE) BUILD_DIR=$(APP_BUILD_DIR) ARCH=$(CONFIG_ARCH) SOCNAME=$(CONFIG_SOCNAME) KERNEL_ADA_BUILDSIZE=$(CONFIG_KERNEL_ADA_BUILDSIZE) gprclean -c -Pewok.gpr

__distclean: libkernel.gpr
	LD_FILE=$(APP_NAME).ld KERN_BINARY=$(APP_NAME).elf ADA_ARCH=$(CONFIG_ADA_ARCH) ADA_RUNTIME=$(ADA_RUNTIME) ADA_PROFILE=$(CONFIG_ADA_PROFILE) BUILD_DIR=$(APP_BUILD_DIR) ARCH=$(CONFIG_ARCH) SOCNAME=$(CONFIG_SOCNAME) KERNEL_ADA_BUILDSIZE=$(CONFIG_KERNEL_ADA_BUILDSIZE) gprclean -Pewok.gpr

#
# As any modification in the user apps permissions or configuration impact the kernel
# generated headers, the kernel headers and as a consequence the kernel binaries need
# to be built again. We decide to require a kernel rebuilt at each all target to be
# sure that the last potential configuration or userspace layout upgrade is taken into
# account in the kernel
#
clean_headers:
	-rm C/generated/*
	-rm Ada/generated/*
	-rm -rf $(APP_BUILD_DIR)/kernel.*.hex
	-rm -rf $(APP_BUILD_DIR)/*.elf

