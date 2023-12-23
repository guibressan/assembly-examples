.PHONY: all clean

all: bin bin/main

bin:
	@mkdir -p bin

bin/main: main.s
	@cc -w -O0 -nostdlib -no-pie -o bin/main main.s

clean:
	@rm -rf bin
