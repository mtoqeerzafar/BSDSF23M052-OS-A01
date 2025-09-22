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
