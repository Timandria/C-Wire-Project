# Makefile pour le projet C-Wire

CC = gcc
CFLAGS = -Wall -Wextra -g

SRC = cwire.c avl_tree.c
OBJ = $(SRC:.c=.o)
EXEC = cwire

all: $(EXEC)

$(EXEC): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(EXEC)

.PHONY: all clean
