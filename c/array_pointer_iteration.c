#include <stdio.h>
#include <string.h>

int main() {
        char arr[] = "Some random string to iterate";
        int length = strlen(arr);
        char *ptr = &arr[0];

        for (int i = 0; i < length; i++) {
                *ptr = '#';
                ptr++;
        }

        printf("%s\n", arr);
}
