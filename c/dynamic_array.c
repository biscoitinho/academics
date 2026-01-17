#include <stdio.h>
#include <stdlib.h>

int main()
{

    int* ptr;
    int n, i;

    printf("Enter number of elements:");
    scanf("%d",&n);
    printf("Entered number of elements: %d\n", n);

    // Dynamically allocate memory using malloc()
    ptr = (int*)malloc(n * sizeof(int));
    //or just like this:
    //ptr = malloc(n);

    // Check if the memory has been successfully
    // allocated by malloc or not
    if (ptr == NULL) {
        printf("Memory not allocated.\n");
        exit(0);
    }
    else {

        // Memory has been successfully allocated
        printf("Memory successfully allocated using malloc.\n");

        // Get the elements of the array
        for (i = 0; i < n; ++i) {
            ptr[i] = i + 1;
        }

        // Print the elements of the array
        printf("The elements of the array are: ");
        for (i = 0; i < n; ++i) {
            printf("%d, ", ptr[i]);
        }

        printf("\n");
        //free allocated memory
        free(ptr);
    }

    return 0;
}

//calloc
//ptr = (int*)calloc(n, sizeof(int));
//each element initalized with 0 value
//takie 3 arguments number of elements and size of element

//realloc
//ptr = realloc(ptr, n * sizeof(int));
