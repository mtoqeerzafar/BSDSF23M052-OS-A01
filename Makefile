# Makefile - builds static (.a) and dynamic (.so) libs, executables, and supports install/uninstall

CC := gcc
AR := ar
RANLIB := ranlib

SRCDIR := src
INCDIR := include
OBJDIR := obj
PICOBJDIR := $(OBJDIR)/pic
LIBDIR := lib
BINDIR := bin

CFLAGS := -Wall -Wextra -I$(INCDIR) -g
PICFLAGS := -fPIC

LIBNAME := libmyutils
STATIC_LIB := $(LIBDIR)/$(LIBNAME).a
DYNAMIC_LIB := $(LIBDIR)/$(LIBNAME).so

# Sources for the library modules
LIB_SRCS := $(SRCDIR)/mystrfunctions.c $(SRCDIR)/myfilefunctions.c

# Object files for static lib (obj/*.o)
LIB_OBJS := $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(LIB_SRCS))

# PIC object files for shared lib (obj/pic/*.o)
PIC_OBJS := $(patsubst $(SRCDIR)/%.c,$(PICOBJDIR)/%.o,$(LIB_SRCS))

# main program object
MAIN_SRC := $(SRCDIR)/main.c
MAIN_OBJ := $(OBJDIR)/main.o

TARGET_STATIC := $(BINDIR)/client_static
TARGET_DYNAMIC := $(BINDIR)/client_dynamic

# Installation directories
PREFIX  := /usr/local
BINDIR_SYS := $(PREFIX)/bin
MANDIR_SYS := $(PREFIX)/share/man/man1

MANPAGE := man/man1/client.1

.PHONY: all static dynamic clean dirs install uninstall

all: static dynamic

# Ensure directories exist
dirs:
	mkdir -p $(OBJDIR) $(PICOBJDIR) $(LIBDIR) $(BINDIR)

# Generic compile for normal objects
$(OBJDIR)/%.o: $(SRCDIR)/%.c | dirs
	$(CC) $(CFLAGS) -c $< -o $@

# Compile PIC objects for shared library
$(PICOBJDIR)/%.o: $(SRCDIR)/%.c | dirs
	$(CC) $(CFLAGS) $(PICFLAGS) -c $< -o $@

# Main object
$(MAIN_OBJ): $(MAIN_SRC) | dirs
	$(CC) $(CFLAGS) -c $< -o $@

# Static library (archive)
$(STATIC_LIB): $(LIB_OBJS) | dirs
	$(AR) rcs $@ $(LIB_OBJS)
	$(RANLIB) $@ || true

# Shared library (.so)
$(DYNAMIC_LIB): $(PIC_OBJS) | dirs
	$(CC) -shared -Wl,-soname,$(LIBNAME).so -o $@ $(PIC_OBJS)

# Static-linked client
$(TARGET_STATIC): $(MAIN_OBJ) $(STATIC_LIB) | dirs
	$(CC) $(CFLAGS) $(MAIN_OBJ) $(STATIC_LIB) -o $@

# Dynamic-linked client
$(TARGET_DYNAMIC): $(MAIN_OBJ) $(DYNAMIC_LIB) | dirs
	$(CC) $(CFLAGS) $(MAIN_OBJ) -L$(LIBDIR) -lmyutils -o $@

static: $(TARGET_STATIC)
dynamic: $(TARGET_DYNAMIC)

# Install target: installs client_dynamic and man page
install: $(TARGET_DYNAMIC) $(MANPAGE)
	@echo "Installing executable to $(BINDIR_SYS)..."
	install -d $(BINDIR_SYS)
	install -m 755 $(TARGET_DYNAMIC) $(BINDIR_SYS)/client
	@echo "Installing man page to $(MANDIR_SYS)..."
	install -d $(MANDIR_SYS)
	install -m 644 $(MANPAGE) $(MANDIR_SYS)

# Uninstall target: removes installed files
uninstall:
	@echo "Removing installed files..."
	rm -f $(BINDIR_SYS)/client
	rm -f $(MANDIR_SYS)/client.1

clean:
	rm -rf $(OBJDIR) $(LIBDIR) $(BINDIR)

