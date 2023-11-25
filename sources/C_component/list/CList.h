//
// Created by Kaze Fx on 2023/11/23.
//

#ifndef QT_TEST_CLIST_H
#define QT_TEST_CLIST_H

#include <malloc.h>
#include "setmem.h"
#include "types.h"

//#ifdef __cplusplus
//extern "C" {
//#endif

typedef struct list_s {
    struct list_s *prev;
    struct list_s *next;
} node_t, *list_t;

list_t initList();

bool pushEnd(list_t head, const void *data, size_t data_size);

//#ifdef __cplusplus
//};
//#endif

#endif //QT_TEST_CLIST_H
