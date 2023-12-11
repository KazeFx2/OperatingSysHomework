//
// Created by Kaze Fx on 2023/11/23.
//

#ifndef QT_TEST_CLIST_H
#define QT_TEST_CLIST_H

#include <malloc.h>
#include "setmem.h"
#include "types.h"

#define GetFirst(list, type) ((type *)((list)->next))

typedef struct list_s {
    struct list_s *prev;
    struct list_s *next;
} node_t, *list_t;

list_t initList();

node_t **findNodeByIndex(list_t *head, size_t index);

bool pushEnd(list_t head, const void *data, size_t data_size);

bool pushExistEnd(list_t head, node_t *node);

bool addNodeBefore(list_t _head, void *target, const void *data, size_t data_size);

bool addExistNodeBefore(list_t _head, void *target, node_t *node);

bool removeNode(node_t *node);

node_t *removeEnd(list_t head);

bool clearList(list_t head);

#endif //QT_TEST_CLIST_H
