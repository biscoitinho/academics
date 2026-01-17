#include <stdio.h>
#include <stdlib.h>
#include "utils.h"

int main(void) {
    int number = 0;
    if (read_int("Enter the number of prices: ", &number) != 0 || number <= 0) {
        printf("Invalid number.\n");
        return 1;
    }

    float *prices = malloc(number * sizeof(float));
    if (!prices) {
        perror("malloc");
        return 1;
    }

    for (int i = 0; i < number; i++) {
        char prompt[64];
        snprintf(prompt, sizeof prompt, "Enter price #%d: ", i + 1);
        if (read_float(prompt, &prices[i]) != 0) {
            printf("Invalid input.\n");
            free(prices);
            return 1;
        }
    }

    int newNumber = 0;
    if (read_int("Enter a new number of prices: ", &newNumber) != 0 || newNumber <= 0) {
        printf("Invalid number.\n");
        free(prices);
        return 1;
    }

    float *temp = realloc(prices, newNumber * sizeof(float));
    if (!temp) {
        perror("realloc");
        free(prices);
        return 1;
    }
    prices = temp;

    // jeśli tablica się powiększyła, dopytujemy o brakujące elementy
    for (int i = number; i < newNumber; i++) {
        char prompt[64];
        snprintf(prompt, sizeof prompt, "Enter price #%d: ", i + 1);
        if (read_float(prompt, &prices[i]) != 0) {
            printf("Invalid input.\n");
            free(prices);
            return 1;
        }
    }
    number = newNumber;

    printf("\nFinal list of prices:\n");
    for (int i = 0; i < number; i++) {
        printf("  $%.2f\n", prices[i]);
    }

    char response;
    printf("\nWould you like to sum the prices? (Y/N): ");
    if (scanf(" %c", &response) == 1 && response == 'Y') {
        float total = sum_prices(prices, number);
        printf("Sum of prices: %.2f\n", total);
    }

    free(prices);
    return 0;
}

