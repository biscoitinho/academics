#include <stdio.h>

void swap(int *x, int *y) {

   int temp;

   temp = *x; /* save the value of x */
   *x = *y;    /* put y into x */
   *y = temp; /* put temp into y */

   return;
}

void add_by_value(int x, int y) {
   int c;
   int d;

   c = x + 1;
   d = y + 1;

   printf("After add, value of x (inside function): %d\n", c );
   printf("After add, value of y (inside function): %d\n", d );

   return;
}


int main () {

   /* local variable definition */
   int a = 100;
   int b = 200;

   printf("Before swap, value of a : %d\n", a );
   printf("Before swap, value of b : %d\n", b );

   /* calling a function to swap the values */
   swap(&a, &b);

   printf("After swap, value of a : %d\n", a );
   printf("After swap, value of b : %d\n", b );

   add_by_value(a, b);

   printf("After add, value of a : %d\n", a );
   printf("After add, value of b : %d\n", b );

   return 0;
}

// The change has reflected outside the function as well,
// unlike call by value where the changes do not reflect outside the function.
