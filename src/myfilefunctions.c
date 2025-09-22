// src/myfilefunctions.c
#define _GNU_SOURCE
#include "../include/myfilefunctions.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* wordCount implementation */
int wordCount(FILE* file, int* lines, int* words, int* chars) {
    if (!file || !lines || !words || !chars) return -1;

    /* Attempt to preserve current position (best-effort) */
    long initial_pos = -1;
    if ( (initial_pos = ftell(file)) != -1 ) {
        /* try to rewind to start */
        if (fseek(file, 0, SEEK_SET) != 0) {
            /* cannot seek - still try to read from current position */
        }
    } else {
        /* non-seekable stream - will read from current position */
    }

    int c;
    int in_word = 0;
    int l = 0, w = 0, ch = 0;
    while ((c = fgetc(file)) != EOF) {
        ch++;
        if (c == '\n') l++;
        if (isspace((unsigned char)c)) {
            if (in_word) in_word = 0;
        } else {
            if (!in_word) { w++; in_word = 1; }
        }
    }

    *lines = l;
    *words = w;
    *chars = ch;

    /* restore file position if possible */
    if (initial_pos != -1) {
        fseek(file, initial_pos, SEEK_SET);
    } else {
        /* cannot restore - caller should be aware */
    }

    return 0;
}

/* mygrep implementation:
   - uses getline (POSIX / glibc). If not available on some platform, implement fallback.
*/
int mygrep(FILE* fp, const char* search_str, char*** matches) {
    if (!fp || !search_str || !matches) return -1;

    /* attempt to rewind() to start */
    if (fseek(fp, 0, SEEK_SET) != 0) {
        /* non-seekable may still work from current pos */
    }

    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    size_t capacity = 8;
    size_t count = 0;
    char **results = malloc(capacity * sizeof(char*));
    if (!results) return -1;

    while ((read = getline(&line, &len, fp)) != -1) {
        if (strstr(line, search_str) != NULL) {
            if (count >= capacity) {
                capacity *= 2;
                char **tmp = realloc(results, capacity * sizeof(char*));
                if (!tmp) {
                    /* free allocated matches on error */
                    for (size_t i = 0; i < count; ++i) free(results[i]);
                    free(results);
                    free(line);
                    return -1;
                }
                results = tmp;
            }
            /* duplicate the line */
            results[count] = strdup(line);
            if (!results[count]) {
                for (size_t i = 0; i < count; ++i) free(results[i]);
                free(results);
                free(line);
                return -1;
            }
            count++;
        }
    }

    free(line);

    if (count == 0) {
        free(results);
        *matches = NULL;
        return 0;
    }
    /* shrink to fit */
    char **shrink = realloc(results, count * sizeof(char*));
    if (shrink) results = shrink;
    *matches = results;
    return (int)count;
}

