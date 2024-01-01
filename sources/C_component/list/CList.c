//
// Created by Kaze Fx on 2023/11/23.666
//

#include "CList.h"

#include <string.h>

#ifdef _DEBUG

#include "stdio.h"

#endif

#define SWAP(type, a, b) {type tmp = a; a = b; b = tmp;}

#define SET_NODE(node) {if ((node)->prev) (node)->prev->next = (node); if((node)->next) (node)->next->prev = (node);}

#define true 1
#define false 0

inline bool check_node(list_t head, node_t **node) {
    if (!node)
        return false;
    if (!*node || *node == head)
        return false;
    return true;
}

list_t initList() {
    list_t head;
    head = __malloc(sizeof(node_t));
    if (!head)
        return NULL;
    head->prev = head->next = NULL;
    return head;
}

node_t **findNode(list_t _head, const void *target) {
    if (!_head)
        return NULL;
    node_t **head = &_head;
    head = &((*head)->next);
    while (*head != target && *head)
        head = &((*head)->next);
    if (*head == target)
        return head;
    return NULL;
}

node_t **findNodeByIndex(list_t *head, size_t index) {
    if (!head || !*head)
        return NULL;
    head = &((*head)->next);
    if (index == 0)
        return head;
    while (*head && index != 0)
        head = &((*head)->next), index--;
    if (index == 0)
        return head;
    return NULL;
}

node_t *findPNodeByIndex(list_t head, size_t index) {
    node_t **ret = findNodeByIndex(&head, index);
    if (!check_node(head, ret))
        return NULL;
    return *ret;
}

bool addNodeBefore(list_t _head, void *target, const void *data, size_t data_size) {
    node_t **head = findNode(_head, target);
    if (!head)
        return false;
    *head = __malloc(data_size + sizeof(node_t));
    if (!*head) {
        *head = target;
        return false;
    }
    (*head)->next = target;
    (*head)->prev = op_ptr(head, -offset_of(node_t, next));
    if (target)
        ((node_t *) target)->prev = *head;
    if (!data)
        return false;
    memcpy((*head) + 1, data, data_size);
    return true;
}

bool addExistNodeBefore(list_t _head, void *target, node_t *node) {
    if (!node)
        return false;
    node_t **head = findNode(_head, target);
    if (!head)
        return false;
    *head = node;
    if (!*head) {
        *head = target;
        return false;
    }
    (*head)->next = target;
    (*head)->prev = op_ptr(head, -offset_of(node_t, next));
    if (target)
        ((node_t *) target)->prev = *head;
    return true;
}

bool addExistComparedBefore(list_t _head, node_t *node, compare_func func, bool asc) {
    FOREACH(node_t, i, _head) {
        if (asc) {
            if (func(node, i) < 0) {
                return addExistNodeBefore(_head, i, node);
            }
        } else if (func(node, i) > 0) {
            return addExistNodeBefore(_head, i, node);
        }
    }
    return addExistNodeBefore(_head, NULL, node);
}

bool addComparedBefore(list_t _head, const void *data, size_t data_size, compare_func func, bool asc) {
    node_t *new = (node_t *) __malloc(sizeof(node_t) + data_size);
    if (!new)
        return false;
    memcpy(new + 1, data, data_size);
    if (!addExistComparedBefore(_head, new, func, asc)) {
        __free(new);
        return false;
    }
    return true;
}

bool pushEnd(list_t head, const void *data, size_t data_size) {
    return addNodeBefore(head, NULL, data, data_size);
}

bool pushExistEnd(list_t head, node_t *node) {
    return addExistNodeBefore(head, NULL, node);
}

bool insertBegin(list_t head, const void *data, size_t data_size) {
    if (!head)
        return false;
    return addNodeBefore(head, head->next, data, data_size);
}

bool removeNode(node_t *node) {
    if (!node->prev)
        return false;
    if (node->next)
        node->next->prev = node->prev;
    node->prev->next = node->next;
    return true;
}

bool removeByIndex(list_t head, size_t index) {
    node_t **ret = findNodeByIndex(&head, index);
    if (!ret || ret == &head)
        return false;
    node_t *node = *ret;
    if (!node)
        return false;
    return removeNode(node);
}

bool swapNodes(node_t *a, node_t *b) {
    if (!a || !b || !a->prev || !b->prev)
        return false;
    SWAP(node_t *, a->next, b->next)
    SWAP(node_t *, a->prev, b->prev)
    SET_NODE(a)
    SET_NODE(b)
    return true;
}

bool swapNodesByIndex(list_t head, size_t a, size_t b) {
    node_t *na = findPNodeByIndex(head, a), *nb = findPNodeByIndex(head, b);
    if (!na || !nb)
        return false;
    return swapNodes(na, nb);
}

bool moveFromTo(list_t head, size_t from, size_t to) {
    if (from == to)
        return true;
    node_t *a = findPNodeByIndex(head, from);
    node_t *b = findPNodeByIndex(head, to < from ? to : to + 1);
    if (!a)
        return false;
    a->prev->next = a->next;
    if (a->next)
        a->next->prev = a->prev;
    return addExistNodeBefore(head, b, a);
}

node_t *removeEnd(list_t head) {
    node_t *del = op_ptr(findNode(head, NULL), -offset_of(node_t, next));
    removeNode(del);
    return del;
}

bool clearList(list_t head) {
    if (!head)
        return false;
    while (head->next) {
        void *n = head->next;
        removeNode(head->next);
        __free(n);
    }
    return true;
}

bool destroyList(list_t head) {
    if (!clearList(head))
        return false;
    __free(head);
    return true;
}

size_t listSize(list_t head) {
    size_t len = 0;
    while (head->next)
        head = head->next, len++;
    return len;
}

list_t sortBy(list_t old, compare_func func, size_t data_size, bool asc) {
    list_t new = initList();
    if (!new)
        return NULL;
    FOREACH(node_t, i, old) {
        if (!addComparedBefore(new, i + 1, data_size, func, asc))
            goto err;
    }
    return new;
    err:
    destroyList(new);
    return NULL;
}