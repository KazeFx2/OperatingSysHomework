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
    uintptr_t comparable;
} rbtnode_t, *rbtree_t;

rbtree_t initTree();

bool addNode(rbtree_t head, uintptr_t comparable_value, void *data, size_t data_size);

bool addExistNode(rbtree_t head, uintptr_t comparable_value, rbtnode_t *node);

bool deleteNode(rbtree_t head, rbtnode_t *target);

rbtnode_t *getNode(rbtree_t head, uintptr_t key);

bool RBTreeIsCorrect(rbtree_t head, uint depth_now, bool forceBlack);

#endif //QT_TEST_CRBTREE_H
