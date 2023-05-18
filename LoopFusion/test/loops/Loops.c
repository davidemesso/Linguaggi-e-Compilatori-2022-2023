#define N 10
#include <stdlib.h>
#include <stdio.h>

void populate(int a[N], int b[N], int c[N]) {
    int i;
    for(i=0; i<N; i++)
        a[i] = 5*c[i];
    
    for(i=0; i<N; i++)
        b[i] = a[i] + c[i];
}
int main () {
    int a[N], b[N], c[N];

    printf("Valori iniziali di c[i]\n");
    for(int i = 0; i < N; i++) {
        c[i] = 1;
        printf("%d\n",c[i]);
    }

    populate(a,b,c);

    printf("\nHo finito\n");

    printf("Vettore A\n");
    for(int i = 0; i < N; i++)
        printf("%d\n", a[i]);
    
    printf("\nVettore B\n");
    for(int i = 0; i < N; i++)
        printf("%d\n", b[i]);

    printf("\nVettore C\n");
    for(int i = 0; i < N; i++)
        printf("%d\n", c[i]);
    return 0;
}