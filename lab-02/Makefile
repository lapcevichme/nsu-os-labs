CC = gcc
CFLAGS = -Wall -Wextra -O2 -Iinclude -MMD -MP

TARGET = build/prog
GENMUL = build/genmul

SRCS = $(sort $(shell find src -type f -name '*.c' 2>/dev/null) src/mul.c)

OBJS = $(SRCS:src/%.c=build/%.o)

DEPS = $(OBJS:.o=.d) build/genmul.d

OBJ_DIRS = $(sort $(dir $(OBJS) $(TARGET) $(GENMUL)))

.PHONY: all clean test

ifneq ($(filter clean,$(MAKECMDGOALS)),)
  $(filter-out clean,$(MAKECMDGOALS)): | clean
endif

all: $(TARGET)

$(TARGET): $(OBJS) | $(OBJ_DIRS)
	$(CC) $(CFLAGS) $^ -o $@
	@ln -sf prog build/calc

$(GENMUL): tools/genmul.c | $(OBJ_DIRS)
	$(CC) $(CFLAGS) $< -o $@

src/mul.c include/mul.h &: $(GENMUL)
	./$(GENMUL)

$(OBJS): | include/mul.h $(OBJ_DIRS)

build/mul.o: src/mul.c include/mul.h

build/%.o: src/%.c | $(OBJ_DIRS)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIRS):
	@mkdir -p $@

clean:
	rm -rf build src/mul.c include/mul.h

test: $(TARGET)
	@tests/test.sh

-include $(DEPS)
