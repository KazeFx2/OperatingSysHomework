//
// Created by Kaze Fx on 2023/11/24.
//

#include "bootmem.h"
#include "malloc.h"
#include "stdio.h"

void testMax() {
    int i = 0, ct = 100;
    uintptr_t max = 0, start = 0, tmp;
    while (ct--) {
        tmp = (uintptr_t) malloc(1);
        if (tmp - start > 4096)
            printf("cg\n"),
                    start = tmp;
        if (tmp - start > max)
            max = tmp - start;
        printf("max: %llu, i: %d, acc: 0x%p\n", max, i, (void *)tmp);
        i++;
    }
}

int main() {
    initPage(0, 0);
    // testMax();
    return 0;
}