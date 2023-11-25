//
// Created by Kaze Fx on 2023/11/25.
//

#ifndef QT_TEST_CRBTREE_H
#define QT_TEST_CRBTREE_H

#include "setmem.h"
#include "types.h"

typedef enum {
    RB_Red = 0,
    RB_Black,
    RB_Head
} tree_color_t;

typedef struct rbtnode_s {
    tree_color_t color;
    struct rbtnode_s *left, *right, *parent;
    uint comparable;
} rbtnode_t, *rbtree_t;

rbtree_t initTree();

bool addNode(rbtree_t head, uint comparable_value, void *data, size_t data_size);

rbtnode_t *getNode(rbtree_t head, uint key);

#endif //QT_TEST_CRBTREE_H
