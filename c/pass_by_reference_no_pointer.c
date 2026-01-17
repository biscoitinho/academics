#include <stdio.h>

void swap(int x, int y)
{
    int temp = x;
    x = y;
    y = temp;
    printf("%d %d\n", x, y);
}

int main()
{
    int x = 10, y = 20;
    swap(x, y);
    printf("%d %d\n", x, y);
    return 0;
}
