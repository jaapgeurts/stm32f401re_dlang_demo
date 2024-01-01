module mcudruntime;

import io;

// pragma(LDC_intrinsic, "ldc.bitop.vld") ubyte volatileLoad(ubyte* ptr);
// pragma(LDC_intrinsic, "ldc.bitop.vld") ushort volatileLoad(ushort* ptr);
// pragma(LDC_intrinsic, "ldc.bitop.vld") uint volatileLoad(uint* ptr);
// pragma(LDC_intrinsic, "ldc.bitop.vld") ulong volatileLoad(ulong* ptr);
// pragma(LDC_intrinsic, "ldc.bitop.vst") void volatileStore(ubyte* ptr, ubyte value);
// pragma(LDC_intrinsic, "ldc.bitop.vst") void volatileStore(ushort* ptr, ushort value);
// pragma(LDC_intrinsic, "ldc.bitop.vst") void volatileStore(uint* ptr, uint value);
// pragma(LDC_intrinsic, "ldc.bitop.vst") void volatileStore(ulong* ptr, ulong value);


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

// extern (C) void* __aeabi_read_tp() {
// }

