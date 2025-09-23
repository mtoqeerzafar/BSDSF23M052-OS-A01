Q1: Explain the linking rule $(TARGET): $(OBJECTS). How does it differ from linking against a library?

Answer:
$(TARGET): $(OBJECTS) is a Make rule where $(TARGET) depends on a list of object files. The recipe for this rule links those object files together into a final executable. Each object contains machine code for translation units; the linker resolves symbol references among them and produces a single binary.

Linking against a library (static .a or shared .so) differs in that you provide the linker with a library file (-lname and -L/path) instead of individual object files. For static libraries, the linker pulls only the object files from the archive that satisfy unresolved references; for shared libraries, the final executable contains references to the shared library resolved at runtime. Order of libraries on the command line matters for static linking; unresolved symbols can remain if the library is specified before the object that needs it.

Q2: What is a git tag and why is it useful? Difference between simple tag and annotated tag?

Answer:
A git tag points to a specific commit and is used to mark important points (releases) in history. A lightweight (simple) tag is just a name for a commit (like a branch that doesn’t move), whereas an annotated tag is a full object that stores metadata (tagger, date, message) and can be cryptographically signed. Annotated tags are preferred for releases because they record more information and are visible in git log and git show.

Q3: Purpose of creating a "Release" on GitHub and attaching binaries?

Answer:
A GitHub Release is a user-friendly packaging of a tagged commit that allows maintainers to publish release notes and attach pre-built binaries. Attaching binaries (like bin/client) is significant because it lets users download ready-to-run artifacts without building from source — important for graders or end-users who don’t want to compile. It also documents the exact executable associated with a release tag.


Feature 3 Questions:

1) Compare Makefile from Part 2 (multifile) and Part 3 (static)

Part 2: directly compiles all .c and links them in one step — no archive step. Rule was like $(TARGET): $(OBJECTS) and then $(CC) $(OBJECTS) -o $(TARGET).

Part 3: adds rules to compile .c → .o, an explicit lib rule that archives the .o files into lib/libmyutils.a using ar, and the final link uses main.o plus lib/libmyutils.a. The difference: you separate creation of reusable archived binary unit, and change the link line so it uses the .a.

2)What is ar and why ranlib?

ar creates and manipulates static archive files (.a). It bundles multiple .o files into a single file.

ranlib generates an index (symbol table) inside the archive so linkers can quickly locate which object in the archive defines a required symbol. On modern GNU ar rcs often creates a table automatically, but ranlib is historically required on some systems.

3)When you run nm on client_static, are mystrlen symbols present? What does that tell you?

If mystrlen is used by the program, nm bin/client_static will show mystrlen as a defined symbol (e.g., T mystrlen). This demonstrates that static linking copied the library's object code into the executable at link time — there is no runtime dependency on libmyutils.a.

Include small outputs (e.g., ar -t and nm snippets) and a short paragraph interpreting them.
