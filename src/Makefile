# Compiler and flags
CC = gcc
CFLAGS = -Wall -I../include

# Directories
OBJDIR = ../obj
BINDIR = ../bin

# Files
OBJS = $(OBJDIR)/main.o $(OBJDIR)/mystrfunctions.o $(OBJDIR)/myfilefunctions.o
TARGET = $(BINDIR)/client

# Default target
all: $(TARGET)

# Linking rule
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Compile each source into object file
$(OBJDIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean
clean:
	rm -f $(OBJDIR)/*.o $(TARGET)

