# Makefile - builds static (.a) and dynamic (.so) libs and executables

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

.PHONY: all static dynamic clean dirs

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
# set soname to libmyutils.so for clarity (simple case). For real versioning use libmyutils.so.1
$(DYNAMIC_LIB): $(PIC_OBJS) | dirs
	$(CC) -shared -Wl,-soname,$(LIBNAME).so -o $@ $(PIC_OBJS)

# Static-linked client
$(TARGET_STATIC): $(MAIN_OBJ) $(STATIC_LIB) | dirs
	$(CC) $(CFLAGS) $(MAIN_OBJ) $(STATIC_LIB) -o $@

# Dynamic-linked client
# Link by name; at runtime you must set LD_LIBRARY_PATH to find the .so in ./lib
$(TARGET_DYNAMIC): $(MAIN_OBJ) $(DYNAMIC_LIB) | dirs
	$(CC) $(CFLAGS) $(MAIN_OBJ) -L$(LIBDIR) -lmyutils -o $@

static: $(TARGET_STATIC)

dynamic: $(TARGET_DYNAMIC)

clean:
	rm -rf $(OBJDIR) $(LIBDIR) $(BINDIR)

