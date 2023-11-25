//
// Created by Kaze Fx on 2023/11/25.
//

#ifndef QT_TEST_TYPES_H
#define QT_TEST_TYPES_H

#include "stddef.h"

typedef unsigned char bool;
typedef unsigned int uint;
typedef unsigned int pid_t;

#define true 1
#define false 0

#define op_ptr(ptr, op) ((void *)(((uintptr_t)ptr) op))
#define offset_of(type, field) ((uintptr_t)&(((type *)NULL)->field))

#endif //QT_TEST_TYPES_H
