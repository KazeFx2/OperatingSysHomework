//
// Created by Kaze Fx on 2023/11/23.
//

#ifndef QT_TEST_CLIST_H
#define QT_TEST_CLIST_H

#include <malloc.h>
#include "setmem.h"
#include "types.h"

#define GetFirst(list, type) ((type *)((list)->next))

#define ASC true
#define DESC false

typedef struct list_s {
    struct list_s *prev;
    struct list_s *next;
} node_t, *list_t;

typedef int (*compare_func)(node_t *, node_t *);

list_t initList();

node_t **findNodeByIndex(list_t *head, size_t index);

node_t *findPNodeByIndex(list_t head, size_t index);

bool pushEnd(list_t head, const void *data, size_t data_size);

bool pushExistEnd(list_t head, node_t *node);

bool addNodeBefore(list_t _head, void *target, const void *data, size_t data_size);

bool addExistNodeBefore(list_t _head, void *target, node_t *node);

bool addExistComparedBefore(list_t _head, node_t *node, compare_func func, bool asc);

bool addComparedBefore(list_t _head, const void *data, size_t data_size, compare_func func, bool asc);

bool removeNode(node_t *node);

bool removeByIndex(list_t head, size_t index);

bool swapNodes(node_t *a, node_t *b);

bool swapNodesByIndex(list_t head, size_t a, size_t b);

bool moveFromTo(list_t head, size_t from, size_t to);

node_t *removeEnd(list_t head);

bool clearList(list_t head);

bool destroyList(list_t head);

size_t listSize(list_t head);

list_t sortBy(list_t old, compare_func func, size_t data_size, bool asc);

#endif //QT_TEST_CLIST_H
