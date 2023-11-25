//
// Created by Kaze Fx on 2023/11/25.
//

#include "CRbtree.h"
#include <string.h>

#define set_red(node) ((node)->color = RB_Red)
#define set_black(node) ((node)->color = RB_Black)
#define node_is_red(node) ((node)->color == RB_Red)
#define node_is_black(node) ((node)->color == RB_Black)
#define root(tree) ((tree)->right)
#define REPLACE_LEFT_MAX true

void leftRotation(rbtnode_t *node) {
    rbtnode_t *parent = node->parent,
            *right = node->right,
            *left = node,
            *mid = node->right->left;
    bool isLeft = (parent->left == node);
    left->parent = right;
    right->left = left;
    right->parent = parent;
    isLeft ? (parent->left = right) : (parent->right = right);
    left->right = mid;
    mid->parent = left;
}

void rightRotation(rbtnode_t *node) {
    rbtnode_t *parent = node->parent,
            *left = node->left,
            *right = node,
            *mid = node->left->right;
    bool isLeft = (parent->left == node);
    right->parent = left;
    left->right = right;
    left->parent = parent;
    isLeft ? (parent->left = left) : (parent->right = left);
    right->left = mid;
    mid->parent = right;
}

rbtree_t initTree() {
    rbtree_t head = __malloc(sizeof(rbtnode_t));
    if (!head)
        return NULL;
    head->color = RB_Head;
    head->comparable = 0;
    head->left = head->right = head->parent = NULL;
    return head;
}

rbtnode_t **getInsertValuePosition(rbtree_t head, uint value, __out bool *left) {
    rbtnode_t **start = &root(head);
    bool l = 2;
    while (*start) {
        if (value < (*start)->comparable) {
            l = true;
            start = &((*start)->left);
        } else if (value > (*start)->comparable) {
            l = false;
            start = &((*start)->right);
        } else
            return NULL;
    }
    if (left)
        *left = l;
    return start;
}

void adjustTree(rbtnode_t *node, rbtnode_t *root) {
    rbtnode_t *tmp;
    while (node != root && node_is_red(node->parent)) {
        if (node->parent == node->parent->parent->left) {
            tmp = node->parent->parent->right;
            if (node_is_red(tmp)) {
                set_black(tmp);
                set_black(node->parent);
                set_red(tmp->parent);
                node = tmp->parent;
            } else {
                if (node == node->parent->right) {
                    leftRotation(node->parent);
                    node = node->left;
                }
                set_red(node->parent->parent);
                set_black(node->parent);
                rightRotation(node->parent->parent);
            }
        } else {
            tmp = node->parent->parent->left;
            if (node_is_red(tmp)) {
                set_black(tmp);
                set_black(node->parent);
                set_red(tmp->parent);
                node = tmp->parent;
            } else {
                if (node == node->parent->left) {
                    rightRotation(node->parent);
                    node = node->right;
                }
                set_red(node->parent->parent);
                set_black(node->parent);
                leftRotation(node->parent->parent);
            }
        }
    }
    set_black(root);
}

bool addNode(rbtree_t head, uint comparable_value, void *data, size_t data_size) {
    bool left;
    rbtnode_t **now = getInsertValuePosition(head, comparable_value, &left);
    if (!now)
        return false;
    *now = __malloc(sizeof(rbtnode_t) + data_size);
    if (!*now) {
        *now = NULL;
        return false;
    }
    (*now)->left = (*now)->right = NULL;
    if (left == 2)
        // is root
        (*now)->parent = head;
    else if (left)
        (*now)->parent = op_ptr(now, -offset_of(rbtnode_t, left));
    else
        (*now)->parent = op_ptr(now, -offset_of(rbtnode_t, right));
    (*now)->comparable = comparable_value;
    // (*now)->color = !(*now)->parent->color;
    set_red(*now);
    memcpy((*now) + 1, data, data_size);
    adjustTree(*now, root(head));
    return true;
}

rbtnode_t *getNode(rbtree_t head, uint key) {
    rbtnode_t *node = root(head);
    while (node) {
        if (node->comparable == key)
            return node;
        if (key < node->comparable)
            node = node->left;
        else
            node = node->right;
    }
    return NULL;
}

void swapForDelete(rbtnode_t *target) {
    rbtnode_t *replace, *tmp_l = target->left, *tmp_r = target->right, *tmp_p = target->parent;
#if(REPLACE_LEFT_MAX == true)
    replace = tmp_l;
    while (replace->right)
        replace = replace->right;
#else
    replace = tmp_r;
    while (replace->left)
        replace = replace->left;
#endif
    bool isLeft = target->parent->left == target;
    target->left = replace->left, target->right = replace->right;
    target->parent = replace->parent;
#if(REPLACE_LEFT_MAX == true)
    target->parent->right = target;
#else
    target->parent->left = target;
#endif
    replace->left = tmp_l, replace->right = tmp_r;
    replace->parent = tmp_p;
    isLeft ? (replace->parent->left = replace) : (replace->parent->right = replace);
    target->color ^= replace->color;
    replace->color ^= target->color;
    target->color ^= replace->color;
}

bool deleteNode(rbtree_t head, rbtnode_t *target) {
    if (!target)
        return false;
    if (target->left && target->right) {
        swapForDelete(target);
    }
    return true;
}