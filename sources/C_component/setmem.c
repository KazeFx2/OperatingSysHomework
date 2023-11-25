//
// Created by Kaze Fx on 2023/11/25.
//

#include "setmem.h"
#include <malloc.h>

void *(*__malloc)(size_t) = malloc;

void (*__free)(void *) = free;

void setMalloc(void *(*_malloc)(size_t)) {
    __malloc = _malloc;
}

void setFree(void (*_free)(void *)) {
    __free = _free;
}

void *(*getMalloc())(size_t) {
    return __malloc;
}

void (*getFree())(void *) {
    return __free;
}
