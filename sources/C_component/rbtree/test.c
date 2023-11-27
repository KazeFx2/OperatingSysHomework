#include "CRbtree.h"
#include "stdio.h"

#define print(a) printf("%d\n", a);
#define corr(head) print(RBTreeIsCorrect(head, 0, 0))

int main() {
    int array[] = {1, 2, 4, 6, 3, 5};
    rbtree_t tree = initTree();
    corr(tree);
    for (int i = 0; i < 6; i++) {
        addNode(tree, array[i], NULL, 0);
        corr(tree);
    }
    for (int i = 5; i > -1; i--) {
        rbtnode_t *tmp = getNode(tree, array[i]);
        printf("0x%p\n", tmp);
        deleteNode(tree, tmp);
        corr(tree);
    }
    return 0;
}