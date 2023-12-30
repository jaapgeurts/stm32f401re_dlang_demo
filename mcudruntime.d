module mcudruntime;

size_t strlen(const(char)* s) {
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
        ++n;
    }
    return n;
}

extern(C) noreturn __assert(const(char)* msg, const(char)* file, int line) {
    string smsg = cast(string)msg[0..strlen(msg)];
    string sfile = cast(string)file[0..strlen(file)];
    writeln("FATAL ERROR: ", sfile,"(",line,"): ", smsg);
    // hang
    while(true)
        continue;
}

extern(C) void* memcpy(byte* a, byte* b, size_t n) {
    byte* t = a;
    for(int i=0;i<n;i++)
        *a++ = *b++;
    return t;
}

