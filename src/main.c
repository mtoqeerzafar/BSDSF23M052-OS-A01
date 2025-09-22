// src/main.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../include/mystrfunctions.h"
#include "../include/myfilefunctions.h"

int main(void) {
    printf("--- Testing String Functions ---\n");

    char a[100];
    int n;

    n = mystrcpy(a, "Hello");
    printf("mystrcpy -> copied %d chars, a=\"%s\"\n", n, a);

    int len = mystrlen(a);
    printf("mystrlen -> %d\n", len);

    n = mystrncpy(a, "WorldLongString", 6);
    printf("mystrncpy(6) -> copied %d, a=\"%s\"\n", n, a);

    /* test mystrcat */
    mystrcpy(a, "Hello");
    n = mystrcat(a, "!");
    n = mystrcat(a, " World");
    printf("mystrcat -> result \"%s\" (len=%d)\n", a, mystrlen(a));

    printf("\n--- Testing File Functions ---\n");

    /* create a small test file if not present */
    const char *testfile = "test_input.txt";
    FILE *tf = fopen(testfile, "r");
    if (!tf) {
        tf = fopen(testfile, "w");
        if (tf) {
            fputs("Hello world\nThis is a test file\nsearch me line\nanother search me\n", tf);
            fclose(tf);
        }
    }

    tf = fopen(testfile, "r");
    if (!tf) {
        printf("Cannot open %s\n", testfile);
        return 1;
    }

    int lines, words, chars;
    if (wordCount(tf, &lines, &words, &chars) == 0) {
        printf("wordCount -> lines=%d words=%d chars=%d\n", lines, words, chars);
    } else {
        printf("wordCount failed\n");
    }

    /* test mygrep */
    char **matches = NULL;
    int cnt = mygrep(tf, "search", &matches);
    if (cnt < 0) {
        printf("mygrep failed\n");
    } else if (cnt == 0) {
        printf("mygrep -> no matches\n");
    } else {
        printf("mygrep -> %d matches:\n", cnt);
        for (int i = 0; i < cnt; ++i) {
            printf("  [%d] %s", i, matches[i]);
            free(matches[i]);
        }
        free(matches);
    }

    fclose(tf);
    return 0;
}

