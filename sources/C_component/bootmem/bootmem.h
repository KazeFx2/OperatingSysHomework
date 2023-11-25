//
// Created by Kaze Fx on 2023/11/24.
//

#ifndef QT_TEST_BOOTMEM_H
#define QT_TEST_BOOTMEM_H

#include "list/CList.h"
#include "types.h"

// page size, 4K in default
# define PAGE_SIZE 4
# define MAX_PAGES 1024
# define MINIMUM_SIZE 1

typedef struct page_s {
    // start of page
    void *page_start;
    // end of page
    void *page_end;
    // page_size Byte
    size_t page_byte_size;
    // page frame number
    uint pfn;
    // page is used
    bool used: 1;
    // used by
    pid_t pid;
} page_t;

typedef struct page_node_s {
    list_t list;
    page_t page;
} page_node_t;

bool initPage(uint page_size, uint max_pages);

#endif //QT_TEST_BOOTMEM_H
