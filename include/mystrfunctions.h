// include/mystrfunctions.h
#ifndef MYSTRFUNCTIONS_H
#define MYSTRFUNCTIONS_H

/* Basic safe string utilities. Return -1 on invalid input. */
int mystrlen(const char* s);
int mystrcpy(char* dest, const char* src);
int mystrncpy(char* dest, const char* src, int n);
int mystrcat(char* dest, const char* src);

#endif /* MYSTRFUNCTIONS_H */

