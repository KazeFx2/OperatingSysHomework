//
// Created by Kaze Fx on 2023/11/24.
//
#include "bootmem.h"

#include "malloc.h"

#ifdef _DEBUG

#include "stdio.h"

#endif

#define ALIGNMENT 8

#define true 1
#define false 0

uint Page_size, Max_pages;

uint now_page;
size_t page_offset;
size_t page_byte_size;

void *mem_start, *mem_end, *mem_now;

void *tmp_malloc(size_t Size) {
    if (Size % ALIGNMENT)
        Size += (ALIGNMENT - (Size % ALIGNMENT));
    if (op_ptr(mem_start, +Size) > mem_end)
        return NULL;
    void *tmp = mem_now;
    mem_now = op_ptr(mem_now, +Size);
    return tmp;
}

void tmp_free(void *Block) {
    // do nothing
}

bool initPage(uint page_size, uint max_pages) {
    uint i;
    if (page_size == 0)
        Page_size = PAGE_SIZE;
    else
        Page_size = page_size;
    if (max_pages == 0)
        Max_pages = MAX_PAGES;
    else
        Max_pages = max_pages;
    now_page = page_offset = 0;
    page_byte_size = Page_size * 1024;
    mem_now = mem_start = malloc(Max_pages * page_byte_size);
    if (!mem_start)
        return false;
    mem_end = op_ptr(mem_start, +Max_pages * page_byte_size);
    // set temporary malloc
    setMalloc(tmp_malloc);
    // set temporary free
    setFree(tmp_free);
    list_t pages = initList();
    void *now_start = mem_start;
    void *now_end = now_start;
    for (i = 0; i < Max_pages; i++) {
#ifdef _DEBUG
        // printf("%d\n", i);
#endif
        now_end = op_ptr(now_end, +page_byte_size);
        page_t tmp_page = {
                now_start,
                now_end,
                page_byte_size,
                i,
                false,
                0
        };
        if (!pushEnd(pages, &tmp_page, sizeof(page_t)))
            return false;
        now_start = now_end;
    }
    return true;
}
