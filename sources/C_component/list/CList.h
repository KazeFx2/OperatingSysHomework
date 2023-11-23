//
// Created by Kaze Fx on 2023/11/23.
//

#ifndef QT_TEST_CLIST_H
#define QT_TEST_CLIST_H

#include <malloc.h>

//#ifdef __cplusplus
//extern "C" {
//#endif

typedef struct list {
    struct list *prev;
    struct list *next;
} Node, *List;

#define op_ptr(ptr, op) ((void *)(((uintptr_t)ptr) op))
#define offset_of(type, field) ((uintptr_t)&(((type *)NULL)->field))

List initList();

int pushEnd(List *_head, const void *data, size_t data_size);

//#ifdef __cplusplus
//};
//#endif

#endif //QT_TEST_CLIST_H
