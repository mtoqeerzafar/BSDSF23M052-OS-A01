CC := gcc
AR := ar
RANLIB := ranlib

CFLAGS := -Wall -Wextra -Iinclude -g
OBJDIR := obj
SRCDIR := src
LIBDIR := lib
BINDIR := bin

LIBNAME := libmyutils.a
LIBPATH := $(LIBDIR)/$(LIBNAME)

LIB_SRCS := $(SRCDIR)/mystrfunctions.c $(SRCDIR)/myfilefunctions.c
LIB_OBJS := $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(LIB_SRCS))

MAIN_SRC := $(SRCDIR)/main.c
MAIN_OBJ := $(OBJDIR)/main.o
TARGET_STATIC := $(BINDIR)/client_static

.PHONY: all lib client_static clean dirs

all: $(TARGET_STATIC)

dirs:
	mkdir -p $(OBJDIR) $(LIBDIR) $(BINDIR)

$(OBJDIR)/%.o: $(SRCDIR)/%.c | dirs
	$(CC) $(CFLAGS) -c $< -o $@

$(LIBPATH): $(LIB_OBJS) | dirs
	$(AR) rcs $@ $(LIB_OBJS)
	$(RANLIB) $@ || true

$(TARGET_STATIC): $(MAIN_OBJ) $(LIBPATH) | dirs
	$(CC) $(CFLAGS) $(MAIN_OBJ) $(LIBPATH) -o $@

lib: $(LIBPATH)

client_static: $(TARGET_STATIC)

clean:
	rm -rf $(OBJDIR)/*.o $(LIBDIR)/* $(BINDIR)/*
