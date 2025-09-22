// include/myfilefunctions.h
#ifndef MYFILEFUNCTIONS_H
#define MYFILEFUNCTIONS_H

#include <stdio.h>

/*
 Count the number of lines, words and characters in the passed file pointer.
 On success: populates *lines,*words,*chars and returns 0.
 On failure: returns -1.
*/
int wordCount(FILE* file, int* lines, int* words, int* chars);

/*
 Search lines containing search_str in a file and fills the matches array.
 On success: returns count of matches and sets *matches to a malloc'ed array
            of char* each pointing to a malloc'ed duplicated line.
            Caller must free individual strings and then free(*matches).
 On failure: returns -1 and leaves *matches undefined.
*/
int mygrep(FILE* fp, const char* search_str, char*** matches);

#endif /* MYFILEFUNCTIONS_H */

