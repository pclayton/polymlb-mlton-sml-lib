(* memaccess-a4s2i4l4f4d8.sml
 *
 *   Primitives for "raw" memory access.
 *
 *   x86/Sparc/PPC version:
 *       addr char short  int  long float double
 *       4    1    2      4    4    4     8       (bytes)
 *
 *   (C) 2004 The Fellowship of SML/NJ
 *
 * author: Matthias Blume (blume@tti-c.org)
 *)
structure CMemAccess : CMEMACCESS = struct

    open PolyMLFFI

    type addr = Memory.Pointer.t
    val null = Memory.Pointer.null
    fun isNull a = a = null
    infix ++ --
    (* rely on 2's-complement for the following... *)
    fun (a: addr) ++ i = Memory.Pointer.add (a, Word.fromInt i)
    fun compare (a1, a2) =
        SysWord.compare (
            Memory.Pointer.toSysWord a1,
            Memory.Pointer.toSysWord a2
        )
    fun a1 -- a2 =
        SysWord.toIntX (
            Memory.Pointer.toSysWord a1
             - Memory.Pointer.toSysWord a2
        )

    val addr_size     = #size (#ctype (breakConversion cPointer))
    val char_size     = #size (#ctype (breakConversion cChar))
    val short_size    = #size (#ctype (breakConversion cShort))
    val int_size      = #size (#ctype (breakConversion cIntLarge))
    val long_size     = #size (#ctype (breakConversion cLongLarge))
    val longlong_size = #size (#ctype (breakConversion cLonglongLarge))
    val float_size    = #size (#ctype (breakConversion cFloat))
    val double_size   = #size (#ctype (breakConversion cDouble))

    val load_addr      =                       #load (breakConversion cPointer)
    val load_uchar     =                       #load (breakConversion cUchar)
    val load_schar     = Char.ord            o #load (breakConversion cChar)
    val load_ushort    = Word16.fromInt      o #load (breakConversion cUshort)
    val load_sshort    =                       #load (breakConversion cShort)
    val load_uint      = Word32.fromLargeInt o #load (breakConversion cUintLarge)
    val load_sint      = Int32.fromLarge     o #load (breakConversion cIntLarge)
    val load_ulong     = Word32.fromLargeInt o #load (breakConversion cUlongLarge)
    val load_slong     = Int32.fromLarge     o #load (breakConversion cLongLarge)
    val load_ulonglong = Word64.fromLargeInt o #load (breakConversion cUlonglongLarge)
    val load_slonglong = Int64.fromLarge     o #load (breakConversion cLonglongLarge)
    val load_float     = Real32.fromLarge IEEEReal.TO_NEAREST
                                             o #load (breakConversion cFloat)
    val load_double    =                       #load (breakConversion cDouble)

    fun store_addr (a, x)      = #store (breakConversion cPointer) x a ()
    fun store_uchar (a, x)     = #store (breakConversion cUchar) x a ()
    fun store_schar (a, x)     = #store (breakConversion cChar) (Char.chr (x mod 256)) a ()
    fun store_ushort (a, x)    = #store (breakConversion cUshort) (Word16.toIntX x) a ()
    fun store_sshort (a, x)    = #store (breakConversion cShort) x a ()
    fun store_uint (a, x)      = #store (breakConversion cUintLarge) (Word32.toLargeInt x) a ()
    fun store_sint (a, x)      = #store (breakConversion cIntLarge) (Int32.toLarge x) a ()
    fun store_ulong (a, x)     = #store (breakConversion cUlongLarge) (Word32.toLargeInt x) a ()
    fun store_slong (a, x)     = #store (breakConversion cLongLarge) (Int32.toLarge x) a ()
    fun store_ulonglong (a, x) = #store (breakConversion cUlonglongLarge) (Word64.toLargeInt x) a ()
    fun store_slonglong (a, x) = #store (breakConversion cLonglongLarge) (Int64.toLarge x) a ()
    fun store_float (a, x)     = #store (breakConversion cFloat) (Real32.toLarge x) a ()
    fun store_double (a, x)    = #store (breakConversion cDouble) x a ()

    val int_bits = Word.fromInt Word32.wordSize

    (* this needs to be severely optimized... *)
    fun bcopy { from: addr, to: addr, bytes: word } =
	if bytes > 0w0 then
	    (store_uchar (to, load_uchar from);
	     bcopy { from = from ++ 1, to = to ++ 1, bytes = bytes - 0w1 })
	else ()

    (* types used in C calling convention *)
    (* for Poly/ML these match the types used in conversions *)
    type cc_addr      = Memory.Pointer.t
    type cc_schar     = Char.char
    type cc_uchar     = Word8.word
    type cc_sshort    = Int.int
    type cc_ushort    = Int.int
    type cc_sint      = LargeInt.int
    type cc_uint      = LargeInt.int
    type cc_slong     = LargeInt.int
    type cc_ulong     = LargeInt.int
    type cc_slonglong = LargeInt.int
    type cc_ulonglong = LargeInt.int
    type cc_float     = Real.real
    type cc_double    = Real.real

    (* wrapping and unwrapping for cc types *)
    fun wrap_addr (x : addr) = x : cc_addr
    fun wrap_schar (x : MLRep.Char.Signed.int) = Char.chr (x mod 256) : cc_schar
    fun wrap_uchar (x : MLRep.Char.Unsigned.word) = x : cc_uchar
    fun wrap_sshort (x : MLRep.Short.Signed.int) = x : cc_sshort
    fun wrap_ushort (x : MLRep.Short.Unsigned.word) = MLRep.Short.Unsigned.toIntX x : cc_ushort
    fun wrap_sint (x : MLRep.Int.Signed.int) = MLRep.Int.Signed.toLarge x : cc_sint
    fun wrap_uint (x : MLRep.Int.Unsigned.word) = MLRep.Int.Unsigned.toLargeInt x : cc_uint
    fun wrap_slong (x : MLRep.Long.Signed.int) = MLRep.Long.Signed.toLarge x : cc_slong
    fun wrap_ulong (x : MLRep.Long.Unsigned.word) = MLRep.Long.Unsigned.toLargeInt x : cc_ulong
    fun wrap_slonglong (x : MLRep.LongLong.Signed.int) = MLRep.LongLong.Signed.toLarge x : cc_slonglong
    fun wrap_ulonglong (x : MLRep.LongLong.Unsigned.word) = MLRep.LongLong.Unsigned.toLargeInt x : cc_ulonglong
    fun wrap_float (x : MLRep.Float.real) = MLRep.Float.toLarge x : cc_float
    fun wrap_double (x : MLRep.Double.real) = x : cc_double

    fun unwrap_addr (x : cc_addr) = x : addr
    fun unwrap_schar (x : cc_schar) = Char.ord x : MLRep.Char.Signed.int
    fun unwrap_uchar (x : cc_uchar) = x : MLRep.Char.Unsigned.word
    fun unwrap_sshort (x : cc_sshort) = x : MLRep.Short.Signed.int
    fun unwrap_ushort (x : cc_ushort) = MLRep.Short.Unsigned.fromInt x : MLRep.Short.Unsigned.word
    fun unwrap_sint (x : cc_sint) = MLRep.Int.Signed.fromLarge x : MLRep.Int.Signed.int
    fun unwrap_uint (x : cc_uint) = MLRep.Int.Unsigned.fromLargeInt x : MLRep.Int.Unsigned.word
    fun unwrap_slong (x : cc_slong) = MLRep.Long.Signed.fromLarge x : MLRep.Long.Signed.int
    fun unwrap_ulong (x : cc_ulong) = MLRep.Long.Unsigned.fromLargeInt x : MLRep.Long.Unsigned.word
    fun unwrap_slonglong (x : cc_slonglong) = MLRep.LongLong.Signed.fromLarge x : MLRep.LongLong.Signed.int
    fun unwrap_ulonglong (x : cc_ulonglong) = MLRep.LongLong.Unsigned.fromLargeInt x : MLRep.LongLong.Unsigned.word
    fun unwrap_float (x : cc_float) = MLRep.Float.fromLarge IEEEReal.TO_NEAREST x : MLRep.Float.real
    fun unwrap_double (x : cc_double) = x : MLRep.Double.real

    fun p2i (x : addr) =
        MLRep.Long.Unsigned.fromLarge (SysWord.toLarge (Memory.Pointer.toSysWord x)) : MLRep.Long.Unsigned.word
    fun i2p (x : MLRep.Long.Unsigned.word) =
        Memory.Pointer.fromSysWord (SysWord.fromLarge (MLRep.Long.Unsigned.toLarge x)) : addr
end
