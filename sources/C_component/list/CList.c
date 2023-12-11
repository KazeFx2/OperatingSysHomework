//
// Created by Kaze Fx on 2023/11/23.666
//

#include "CList.h"

#include <string.h>

#ifdef _DEBUG

#include "stdio.h"

#endif

#define true 1
#define false 0

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