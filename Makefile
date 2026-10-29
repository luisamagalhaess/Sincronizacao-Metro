sync_car:
	gcc -Wall -Wextra -Wpedantic -std=c11 -pthread -c sync_car.c
run:
	./sync_car

clean:
	rm -f sync_car

.PHONY: sync_car run clean