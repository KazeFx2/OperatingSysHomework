//
// Created by Kaze Fx on 2023/11/25.
//

#ifndef QT_TEST_SETMEM_H
#define QT_TEST_SETMEM_H

extern void *(*__malloc)(size_t);

extern void (*__free)(void *);

void setMalloc(void *(*_malloc)(size_t));

void setFree(void (*_free)(void *));

void *(*getMalloc())

(size_t);

void (*getFree())(void *);

#endif //QT_TEST_SETMEM_H
