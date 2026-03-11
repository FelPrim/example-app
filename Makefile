DIR := .
TARGET := hello_world
# possible modes: default, debug, release, fun
MODE ?= default

SRC := $(DIR)/src
TMP := $(DIR)/build
OUT := $(DIR)/bin

.PHONY: all clean distclean run

all: $(OUT)/$(TARGET)

clean:
	rm -rf $(TMP)

distclean: clean
	rm -rf $(OUT)

CC ?= gcc
default_CFLAGS := -std=c23 -Wall -Wextra -Wpedantic \
				-Wconversion -Wshadow -Wstrict-prototypes -Wfloat-equal -fno-common \
				-pipe 
# if pipe causes errors you can remove it

ifeq ($(MODE), default)
    CFLAGS ?= $(default_CFLAGS)
else ifeq ($(MODE), debug)
    CFLAGS ?= $(default_CFLAGS) -g3 -Og \
              -fsanitize=address,undefined -fsanitize-address-use-after-scope -fno-omit-frame-pointer -fstack-protector-all
else ifeq ($(MODE), release)
    CFLAGS ?= $(default_CFLAGS) -O2 -march=native 
else ifeq ($(MODE), fun)
    CFLAGS ?= $(default_CFLAGS) -Ofast -march=native -flto -fipa-pta
endif 
# interesting flags: 
# -floop-nest-optimize (needs isl support) (learn llvm Polly if interested)
# -fprofile-generate + -fprofile-use (should consider manual profiling instead)

$(OUT)/$(TARGET): $(SRC)/main.c
	mkdir $(OUT)
	$(CC) $(CFLAGS) $< -o $@

run: $(OUT)/$(TARGET)
	$(OUT)/$(TARGET) $(ARGS)
