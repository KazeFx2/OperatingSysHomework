//
// Created by Kaze Fx on 2023/11/24.
//
#include "bootmem.h"

#include "malloc.h"

#ifdef _DEBUG

#include "stdio.h"

///
/// * TO BE CONTINUED
///

#endif

#define ALIGNMENT 8

// sizeof_mem_zone != 0
#define ADD_MEM_ZONE(total_used, page_max, sizeof_link_node) (((uintptr_t)(page_max) - (uintptr_t)(sizeof_link_node) > 0) && (uintptr_t)(total_used) % ((uintptr_t)page_max - (uintptr_t)sizeof_link_node))
#define ADD_MEM_ZONE_INIT(total_used) ADD_MEM_ZONE(total_used, page_byte_size, sizeof(page_link_node_t) + sizeof(addr_mem_tree_node_t))
#define PAGE_USED (op_ptr(op_ptr(mem_now, - (uintptr_t)mem_start), % page_byte_size))
#define N_PAGES (PAGE_USED ? ((uintptr_t)op_ptr(op_ptr(mem_now, - (uintptr_t)mem_start), / page_byte_size + 1)) : ((uintptr_t)op_ptr(op_ptr(mem_now, - (uintptr_t)mem_start), % page_byte_size)))
#define TOTAL_USED (op_ptr(mem_now, - (uintptr_t)mem_start))

#define true 1
#define false 0

uint Page_size, Max_pages;

size_t page_byte_size;

void *mem_start, *mem_end, *mem_now;

mem_zone_node_t *mz_reserve;

uint pid;

strategy_t strategy;

mem_management_t *manger;

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

void *kmalloc(size_t Size) {
    if (Size % ALIGNMENT)
        Size += (ALIGNMENT - (Size % ALIGNMENT));
    // step 1: search in malloced_pages
    // if failed, calcu pages that size need
    // step 2: then search continuous pages in empty pages
    bool found = false;
    uint pages = 1;
    if (Size <= page_byte_size) {
        pid_page_tree_node_t *node = (pid_page_tree_node_t *) getNode(manger->pid_page_tree, 0);
        FOREACH(page_link_node_t, i, node->page_list) {
            page_t *p = i->p_page;
            if (p->first_page != p && !p->end)
                continue;
            FOREACH(mem_zone_node_t, j, p->mem_zone) {
                if (j->mem_zone.used)
                    continue;
                if (j->mem_zone.size >= Size) {
                    // mem_zone is enough
                    found = true;
                    break;
                }
            }
        }
    }
    // if not found
    if (!found) {
        pages = Size % page_byte_size ? Size / page_byte_size + 1 : Size / page_byte_size;
        for (uint i = 0; i < Max_pages; i++)
            if (!manger->bitmap[i]) {
                uint j = 1;
                for (; i + j < Max_pages && j < pages; j++) {
                    if (manger->bitmap[i + j])
                        break;
                }
                if (j == pages) {
                    // find pages
                    found = true;
                    break;
                } else {
                    i += j;
                }
            }
    }
    if (!found)
        return NULL;
    return NULL;
}

void kfree(void *Block) {

}

void *my_malloc(size_t Size) {
    return NULL;
}

void my_free(void *Block) {

}

inline bool initMemZone(list_t *list, void *start, size_t size) {
    *list = initList();
    if (!*list)
        return false;
    mem_zone_t tmp = {
            start,
            size,
            false
    };
    if (!pushEnd(*list, &tmp, sizeof(mem_zone_t)))
        return false;
    return true;
}

bool initMM(mem_management_t **mm) {
    *mm = tmp_malloc(sizeof(mem_management_t));
    if (!*mm)
        return false;
    uint i;
    page_t *t_page;
    bool *t_bit;
    (*mm)->page_array = tmp_malloc(Max_pages * sizeof(page_t));
    if (!(*mm)->page_array)
        return false;
    (*mm)->bitmap = tmp_malloc(Max_pages);
    if (!(*mm)->bitmap)
        return false;
    (*mm)->pid_page_tree = initTree();
    if (!(*mm)->pid_page_tree)
        return false;
    // init pages & bitmap
    t_page = (*mm)->page_array;
    t_bit = (*mm)->bitmap;
    void *now_start = mem_start;
    void *now_end = now_start;
    for (i = 0; i < Max_pages; i++) {
        // printf("%d\n", i);
        now_end = op_ptr(now_end, +page_byte_size);
        t_page->page_byte_size = page_byte_size;
        if (!initMemZone(&t_page->mem_zone, now_start, page_byte_size))
            return false;
        t_page->addr_mem = initTree();
        if (!t_page->addr_mem)
            return false;
        t_page->pages = NULL;
        t_page->page_start = now_start;
        t_page->page_end = now_end;
        t_page->first_page = t_page;
        t_page->pfn = i;
        t_page->pid = 0;
        t_page->used = false;
        t_page->end = false;
        *t_bit = false;
        t_page++, t_bit++;
        now_start = now_end;
    }
    return true;
}

// only for manager progress, pid 0
bool initProc(mem_management_t *mm) {
    // step 1: add tree node, init page list
    rbtree_t pid_tree = mm->pid_page_tree;
    // init list
    list_t page_list = initList();
    if (!page_list)
        return false;
    // tree node add
    addNode(pid_tree, 0, &page_list, sizeof(list_t));
    // mem calc
    bool reserve = true;
    uint n_pages, i;
    page_link_node_t *p_start = NULL;
    addr_mem_tree_node_t *a_start = NULL;
    mem_zone_node_t *mem_z = NULL;
    if (ADD_MEM_ZONE_INIT(TOTAL_USED)) {
        mem_z = tmp_malloc(sizeof(mem_zone_node_t));
        if (!mem_z)
            return false;
        if (!ADD_MEM_ZONE_INIT(TOTAL_USED))
            mz_reserve = mem_z;
        else
            reserve = false;
        n_pages = N_PAGES;
    } else {
        n_pages = N_PAGES;
    }
    p_start = tmp_malloc(n_pages * sizeof(page_link_node_t));
    if (!p_start)
        return false;
    a_start = tmp_malloc(n_pages * sizeof(addr_mem_tree_node_t));
    if (!a_start)
        return false;
    for (i = 0; i < n_pages; i++) {
        p_start[i].p_page = &mm->page_array[i];
        pushExistEnd(page_list, (node_t *) &p_start[i]);
        mm->bitmap[i] = true;
        mm->page_array[i].first_page = &mm->page_array[0];
        mm->page_array[i].used = true;
        mm->page_array[i].pid = 0;
        mm->page_array[i].pages = page_list;
        GetFirst(mm->page_array[i].mem_zone, mem_zone_node_t)->mem_zone.start = mm->page_array[i].page_start;
        GetFirst(mm->page_array[i].mem_zone, mem_zone_node_t)->mem_zone.used = true;
        addExistNode(mm->page_array[i].addr_mem, (uintptr_t) mm->page_array[i].page_start,
                     GetFirst(mm->page_array[i].mem_zone, rbtnode_t));
        if (i == n_pages - 1) {
            if (!reserve) {
                GetFirst(mm->page_array[i].mem_zone, mem_zone_node_t)->mem_zone.size = (uintptr_t) op_ptr(mem_now,
                                                                                                          -(uintptr_t) mm->page_array[i].page_start);
                mem_z->mem_zone.start = mem_now;
                mem_z->mem_zone.size =
                        mm->page_array[i].page_byte_size -
                        GetFirst(mm->page_array[i].mem_zone, mem_zone_node_t)->mem_zone.size;
                mem_z->mem_zone.used = false;
                pushExistEnd(mm->page_array[i].mem_zone, (node_t *) mem_z);
            } else
                GetFirst(mm->page_array[i].mem_zone, mem_zone_node_t)->mem_zone.size = mm->page_array[i].page_byte_size;
            mm->page_array[i].end = true;
        } else
            GetFirst(mm->page_array[i].mem_zone, mem_zone_node_t)->mem_zone.size = mm->page_array[i].page_byte_size;
    }
    for (; i < Max_pages; i++)
        mm->bitmap[i] = false;
    return true;
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
    mz_reserve = NULL;
    pid = 0;
    page_byte_size = Page_size * 1024;
    mem_now = mem_start = malloc(Max_pages * page_byte_size);
    if (!mem_start)
        return false;
    mem_end = op_ptr(mem_start, +Max_pages * page_byte_size);
    // set temporary malloc
    setMalloc(tmp_malloc);
    // set temporary free
    setFree(tmp_free);
    // start here
    mem_management_t *mm;
    if (!initMM(&mm))
        return false;
    if (!initProc(mm))
        return false;
    setMalloc(my_malloc);
    setFree(my_free);
    setStrategy(FF);
    manger = mm;
    return true;
}

void setPID(uint _pid) {
    pid = _pid;
}

void setStrategy(strategy_t s) {
    strategy = s;
}
