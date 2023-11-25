//
// Created by Kaze Fx on 2023/11/24.
//

#include "bootmem.h"
#include "malloc.h"
#include "stdio.h"

void testMax() {
    void *start = malloc(1);
    int i = 0;
    while (1) {
        printf("i: %d, acc: %c\n", i, *((char *) ((uintptr_t) start + i)));
        i++;
    }
}

int main() {
    initPage(0, 0);
    // testMax();
    return 0;
}