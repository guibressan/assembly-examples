#include<stdio.h>

extern int add(int a, int b);

int main(void) {
	int a = 3;
	int b = 5;
	int r = add(a,b);
	printf("%d + %d == %d\n", a, b, r); 
	return 0;
}
