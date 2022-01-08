# Lib version 0.7.4

BIN_NAME = arm7_default.elf

SRC_DIR = source
BUILD_DIR = build

LIBS = -ldswifi7 -lmm7 -lnds7 \
       -lm -lg -lsysbase -lc -lgcc \
	   -nodefaultlibs

ARCH = -march=armv4t \
	   -mthumb \
	   -mthumb-interwork

CFLAGS = -DARM7 \
		 -mcpu=arm7tdmi \
		 -mtune=arm7tdmi \
		 -fomit-frame-pointer \
		 -ffunction-sections \
		 -fdata-sections \
		 -ffast-math \
		 $(ARCH)

LDFLAGS	= -specs=arm7.specs \
		  $(ARCH) 

CC = arm-none-eabi-gcc
LD = arm-none-eabi-gcc

SRC_FILES = main.c

SRC_OBJ_FILES = $(patsubst %,$(BUILD_DIR)/%,$(addsuffix .o,$(basename $(notdir $(SRC_FILES)))))

$(BUILD_DIR)/$(BIN_NAME): $(SRC_OBJ_FILES)
	$(LD) $(LDFLAGS) $^ $(LIBS) -o $@
	
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: all clean build rebuild path_builder install

all: path_builder build
rebuild: clean all
build: $(BUILD_DIR)/$(BIN_NAME)

clean:
	rm -rf $(BUILD_DIR)

path_builder:
	mkdir -p $(BUILD_DIR)

install: $(BUILD_DIR)/$(BIN_NAME)
	install -d $(DESTDIR)/opt/nds
	install -m 644 $(BUILD_DIR)/$(BIN_NAME) $(DESTDIR)/opt/nds