#include <stdio.h>
#include <stdlib.h>

int number = 0;
float *prices = NULL;
int newNumber = 0;

float sumPrices(void) {
    float sum = 0;
    for(int i = 0; i < newNumber; i++){
        sum += prices[i];
    }

    return sum;
}

int main(){

    printf("Enter the number of prices: ");
    scanf("%d", &number);

    prices = malloc(number * sizeof(float));
    if (prices == NULL) {
        printf("Memory allocation failed!\n");
        return 1;
    }

    for(int i = 0; i < number; i++){
        printf("Enter price #%d: ", i + 1);
        scanf("%f", &prices[i]);
    }

    printf("Enter a new number of prices: ");
    scanf("%d", &newNumber);

    float *temp = realloc(prices, newNumber * sizeof(float));


    if(temp == NULL){
        printf("Could not reallocate memory!\n");
    }
    else{
        prices = temp;
        temp = NULL;


        for(int i = number; i < newNumber; i++){
            printf("Enter price #%d: ", i + 1);
            scanf("%f", &prices[i]);
        }


        for(int i = 0; i < newNumber; i++){
            printf("$%.2f \n", prices[i]);
        }
    }

    char response;
    float sum = 0;

    printf("Would you like to sum the prices?\n");
    printf("Y or N\n");
    scanf(" %c", &response);

    if(response == 'Y') {
        float result = sumPrices();
        printf("Sum of prices is: %.2f\n", result);
    }

    free(prices);
    prices = NULL;


    return 0;

}
