#include <stdio.h>
#include <stdlib.h>
#include "utils.h"

int read_int(const char *prompt, int *out) {
    char buf[64];
    printf("%s", prompt);
    if (!fgets(buf, sizeof buf, stdin)) return -1;
    if (sscanf(buf, "%d", out) != 1) return -1;
    return 0;
}

int read_float(const char *prompt, float *out) {
    char buf[64];
    printf("%s", prompt);
    if (!fgets(buf, sizeof buf, stdin)) return -1;
    if (sscanf(buf, "%f", out) != 1) return -1;
    return 0;
}

float sum_prices(const float *prices, int n) {
    float sum = 0;
    for (int i = 0; i < n; i++) {
        sum += prices[i];
    }
    return sum;
}

