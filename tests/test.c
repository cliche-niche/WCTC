#include <stdio.h>
#include <stdlib.h>

int main() {
    // printf("Hello world!");
    int A[20];
    A[5] = 10;

    A[2] = A[8] * A[5];

    int* p = (int*) malloc(20 * sizeof(int));

    A[3] = p[4];

    int* q = (int*) malloc(13 * sizeof(int));

    p[2] = q[0];

    free(p);

    return 0;
}