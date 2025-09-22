// src/mystrfunctions.c
#include "../include/mystrfunctions.h"
#include <stddef.h>

int mystrlen(const char* s) {
    if (!s) return -1;
    int len = 0;
    while (s[len] != '\0') ++len;
    return len;
}

int mystrcpy(char* dest, const char* src) {
    if (!dest || !src) return -1;
    int i = 0;
    while (src[i] != '\0') {
        dest[i] = src[i];
        ++i;
    }
    dest[i] = '\0';
    return i; /* number of chars copied (excluding null) */
}

/* Safe strncpy variant that ensures null-termination.
   Copies up to n-1 chars and places a terminating NUL. */
int mystrncpy(char* dest, const char* src, int n) {
    if (!dest || !src || n <= 0) return -1;
    int i = 0;
    for (; i < n - 1 && src[i] != '\0'; ++i) {
        dest[i] = src[i];
    }
    dest[i] = '\0';
    return i; /* number of bytes copied (excluding NUL) */
}

int mystrcat(char* dest, const char* src) {
    if (!dest || !src) return -1;
    int dest_len = 0;
    while (dest[dest_len] != '\0') ++dest_len;
    int i = 0;
    while (src[i] != '\0') {
        dest[dest_len + i] = src[i];
        ++i;
    }
    dest[dest_len + i] = '\0';
    return dest_len + i; /* length of resulting string */
}

