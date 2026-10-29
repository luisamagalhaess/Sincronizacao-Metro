#include <pthread.h>
#include "sync_car.h"

void station_init(struct station *station){
    pthread_mutex_init(&station->lock, NULL);
    pthread_cond_init(&station->car_arrived, NULL);
    pthread_cond_init(&station->car_can_leave, NULL);
    station->free_seats = 0;
    station->waiting = 0;
}