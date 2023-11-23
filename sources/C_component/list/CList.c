//
// Created by Kaze Fx on 2023/11/23.
//

#include "CList.h"

#include <string.h>

#ifdef _DEBUG

#include "stdio.h"

#endif

#define true 1
#define false 0

List initList() {
    List head;
    head = malloc(sizeof(Node));
    if (!head)
        return NULL;
    head->prev = head->next = NULL;
    return head;
}

Node **findNode(List *head, const void *target) {
    if (!*head)
        return NULL;
    head = &((*(Node **) head)->next);
    while (*head != target && *head)
        head = &((*head)->next);
    if (*head == target)
        return head;
    return NULL;
}

Node **findNodeByIndex(List *head, size_t index) {
    if (!head || !*head)
        return NULL;
    head = &((*(Node **) head)->next);
    if (index == 0)
        return head;
    while (*head && index != 0)
        head = &((*head)->next), index--;
    if (index == 0)
        return head;
    return NULL;
}

int addNodeBefore(List *head, void *target, const void *data, size_t data_size) {
    head = findNode(head, target);
    if (!head)
        return false;
    *head = malloc(data_size + sizeof(Node));
    if (!*head) {
        *head = target;
        return false;
    }
    (*head)->next = target;
    (*head)->prev = op_ptr(head, -offset_of(Node, next));
    if (target)
        ((Node *) target)->prev = *head;
    if (!data)
        return false;
    memcpy((*head) + 1, data, data_size);
    return true;
}

int pushEnd(List *head, const void *data, size_t data_size) {
    return addNodeBefore(head, NULL, data, data_size);
}

int insertBegin(List *head, const void *data, size_t data_size) {
    if (!head || !*head)
        return false;
    return addNodeBefore(head, (*head)->next, data, data_size);
}