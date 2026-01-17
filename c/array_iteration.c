#include <stdio.h>
#include <string.h>

int main() {
        char arr[] = "Text to be iterated";
        char length = strlen(arr);

        for(int i = 0; i < length; i++) {
                printf("%c\n", arr[i]);
        }
}
