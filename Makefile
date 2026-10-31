sync_car:
	gcc -Wall -Wextra -Wpedantic -Wno-unused-parameter -std=c11 -D_DEFAULT_SOURCE -pthread sync_car-runner.c sync_car.c -o sync_car

run:
	./sync_car

clean:
	rm -f sync_car sync_car.o

.PHONY: sync_car run clean