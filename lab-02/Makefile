CC = gcc
CFLAGS = -Wall -Wextra -O2 -Iinclude -MMD -MP

TARGET = build/prog

SRCS = $(shell find src -type f -name '*.c')

OBJS = $(SRCS:src/%.c=build/%.o)

DEPS = $(OBJS:.o=.d)

OBJ_DIRS = $(sort $(dir $(OBJS)))

.PHONY: all clean test

ifneq ($(filter clean,$(MAKECMDGOALS)),)
  $(filter-out clean,$(MAKECMDGOALS)): | clean
endif

all: $(TARGET)

$(TARGET): $(OBJS) | $(OBJ_DIRS)
	$(CC) $(CFLAGS) $^ -o $@

build/%.o: src/%.c | $(OBJ_DIRS)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIRS):
	@mkdir -p $@

clean:
	rm -rf build

test: $(TARGET)
	@tests/test.sh

-include $(DEPS)
