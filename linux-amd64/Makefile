CC = cc
CFLAGS = -Wall -Werror -O0
ASMFLAGS = -w -O0 -nostdlib -no-pie

.PHONY: all clean

all: bin bin/main bin/main1

bin:
	@mkdir -p bin

bin/main: main.s
	@$(CC) $(ASMFLAGS) -o bin/main main.s

bin/main1: main.o add.o
	@$(CC) -o bin/main1 main.o add.o

main.o: main.c
	@$(CC) $(CFLAGS) -c -o $@ $<

add.o: add.s
	@$(CC) $(ASMFLAGS) -c -o $@ $<

clean:
	@rm -rf bin *.o
