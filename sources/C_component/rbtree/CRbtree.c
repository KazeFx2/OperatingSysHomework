//
// Created by Kaze Fx on 2023/11/25.
//

#include "CRbtree.h"
#include <string.h>

#define set_red(node) ((node)->color = RB_Red)
#define set_black(node) ((node)->color = RB_Black)
#define node_is_red(node) ((node) && (node)->color == RB_Red)
#define node_is_black(node) ((!(node)) || (node)->color == RB_Black)
#define root(tree) ((tree)->right)
#define REPLACE_LEFT_MAX true

void leftRotation(rbtnode_t *node) {
    rbtnode_t *parent = node->parent,
            *right = node->right,
            *left = node,
            *mid = right ? right->left : NULL;
    bool isLeft = (parent->left == node);
    left->parent = right;
    if (right)
        right->left = left,
                right->parent = parent;
    isLeft ? (parent->left = right) : (parent->right = right);
    left->right = mid;
    if (mid)
        mid->parent = left;
}

void rightRotation(rbtnode_t *node) {
    rbtnode_t *parent = node->parent,
            *left = node->left,
            *right = node,
            *mid = left ? left->right : NULL;
    bool isLeft = (parent->left == node);
    right->parent = left;
    if (left)
        left->right = right,
                left->parent = parent;
    isLeft ? (parent->left = left) : (parent->right = left);
    right->left = mid;
    if (mid)
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

void adjustTree(rbtnode_t *node, rbtree_t head) {
    rbtnode_t *tmp;
    while (node != root(head) && node_is_red(node->parent)) {
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
    set_black(root(head));
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
    if (data && data_size)
        memcpy((*now) + 1, data, data_size);
    adjustTree(*now, head);
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
    if (!tmp_l)
        return;
    while (replace->right)
        replace = replace->right;
    if (replace == tmp_l)
        tmp_l = target, replace->parent = replace;
#else
    replace = tmp_r;
    if (!tmp_r)
        return;
    while (replace->left)
        replace = replace->left;
    if (replace == tmp_r)
        tmp_r = target, replace->parent = replace;
#endif
    bool isLeft = target->parent->left == target;
    target->left = replace->left, target->right = replace->right;
    target->parent = replace->parent;
    replace->left = tmp_l, replace->right = tmp_r;
    replace->parent = tmp_p;
    isLeft ? (replace->parent->left = replace) : (replace->parent->right = replace);
    if (target->left)
        target->left->parent = target;
    if (target->right)
        target->right->parent = target;
    if (replace->left)
        replace->left->parent = replace;
    if (replace->right)
        replace->right->parent = replace;
    target->color ^= replace->color;
    replace->color ^= target->color;
    target->color ^= replace->color;
}

bool deleteNode(rbtree_t head, rbtnode_t *target) {
    bool isRed, isLeft;
    rbtnode_t *tmp, *sub, *sibling;
    // replace
    swapForDelete(target);
    if (target->left == NULL) {
        tmp = target->right;
        sub = target;
    } else {
        tmp = target->left;
        sub = target;
    }
    if (sub == root(head)) {
        root(head) = tmp;
        if (tmp)
            set_black(tmp);
        return true;
    }
    isRed = node_is_red(sub);
    isLeft = sub->parent->left == sub;
    if (isLeft) {
        sub->parent->left = tmp;
    } else {
        sub->parent->right = tmp;
    }
    if (tmp)
        tmp->parent = sub->parent;
    if (isRed)
        return true;
    // fixup
    while (tmp != root(head) && node_is_black(tmp)) {
        if ((tmp && tmp == tmp->parent->left) || (!tmp && isLeft)) {
            sibling = tmp ? tmp->parent->right : sub->parent->right;
            if (node_is_red(sibling)) {
                set_black(sibling);
                set_red(tmp ? tmp->parent : sub->parent);
                leftRotation(tmp ? tmp->parent : sub->parent);
                sibling = tmp ? tmp->parent->right : sub->parent->right;
            }
            if (sibling && node_is_black(sibling->left) && node_is_black(sibling->right)) {
                set_red(sibling);
                tmp = tmp ? tmp->parent : sub->parent;
            } else {
                if (sibling && node_is_black(sibling->right)) {
                    set_black(sibling->left);
                    set_red(sibling);
                    rightRotation(sibling);
                    sibling = tmp ? tmp->parent->right : sub->parent->right;
                }
                if (sibling)
                    sibling->color = tmp ? tmp->parent->color : sub->parent->color;
                set_black(tmp ? tmp->parent : sub->parent);
                if (sibling && sibling->right)
                    set_black(sibling->right);
                leftRotation(tmp ? tmp->parent : sub->parent);
                tmp = root(head);
            }
        } else {
            sibling = tmp ? tmp->parent->left : sub->parent->left;
            if (node_is_red(sibling)) {
                set_black(sibling);
                set_red(tmp ? tmp->parent : sub->parent);
                rightRotation(tmp ? tmp->parent : sub->parent);
                sibling = tmp ? tmp->parent->left : sub->parent->left;
            }
            if (sibling && node_is_black(sibling->left) && node_is_black(sibling->right)) {
                set_red(sibling);
                tmp = tmp ? tmp->parent : sub->parent;
            } else {
                if (sibling && node_is_black(sibling->left)) {
                    set_black(sibling->right);
                    set_red(sibling);
                    leftRotation(sibling);
                    sibling = tmp ? tmp->parent->left : sub->parent->left;
                }
                if (sibling)
                    sibling->color = tmp ? tmp->parent->color : sub->parent->color;
                set_black(tmp ? tmp->parent : sub->parent);
                if (sibling && sibling->left)
                    set_black(sibling->left);
                rightRotation(tmp ? tmp->parent : sub->parent);
                tmp = root(head);
            }
        }
    }
    if (tmp)
        set_black(tmp);
    return true;
}

bool RBTreeIsCorrect(rbtree_t head, uint depth_now, bool forceBlack) {
    static uint depth;
    static bool firstEnd;
    if (!head)
        return true;
    if (head->color == RB_Head) {
        firstEnd = false;
        return RBTreeIsCorrect(root(head), 1, 1);
    }
    bool black = node_is_black(head);
    if (forceBlack && !black)
        return false;
    bool st = true;
    depth_now += black ? 1 : 0;
    if (head->left) {
        st = RBTreeIsCorrect(head->left, depth_now, !black);
    } else {
        if (!firstEnd)
            firstEnd = true, depth = depth_now;
        else if (depth_now != depth)
            return false;
    }
    if (!st)
        return false;
    if (head->right) {
        st = RBTreeIsCorrect(head->right, depth_now, !black);
    } else if (head->left) {
        if (!firstEnd)
            firstEnd = true, depth = depth_now;
        else if (depth_now != depth)
            return false;
        return true;
    }
    if (!st)
        return false;
    return true;
}