(* mlrep.sml
 * 2023 Phil Clayton (phil.clayton@veonix.com)
 *  Adapted for Poly/ML.
 * Poly/ML 5.9.1 does not have structures Int8, Int16 nor Int64.
 *)

(* mlrep.sml
 * 2007 Matthew Fluet (mfluet@acm.org)
 *  Adapted for MLton.  Make use of $(SML_LIB)/basis/c-types.mlb
 * 2005 Matthew Fluet (mfluet@acm.org)
 *  Adapted for MLton.
 *)

(* mlrep-i32f64.sml
 *
 *   User-visible ML-side representation of certain primitive C types.
 *   x86/Sparc/PPC version (all ints: 32 bit, all floats: 64 bit)
 *
 * Copyright (c) 2004 by The Fellowship of SML/NJ
 *
 * Author: Matthias Blume (blume@tti-c.org)
 *)
structure MLRep = struct
    structure Char =
       struct
          structure Signed = Int
          structure Unsigned = Word8
          (* word-style bit-operations on integers... *)
          structure SignedBitops = IntBitOps(structure I = Signed
                                             structure W = Unsigned)
       end
    structure Short =
       struct
          structure Signed = Int
          structure Unsigned = Word16
          (* word-style bit-operations on integers... *)
          structure SignedBitops = IntBitOps(structure I = Signed
                                             structure W = Unsigned)
       end
    structure Int =
       struct
          structure Signed = Int32
          structure Unsigned = Word32
          (* word-style bit-operations on integers... *)
          structure SignedBitops = IntBitOps(structure I = Signed
                                             structure W = Unsigned)
       end  
    structure Long =
       struct
          structure Signed = Int32
          structure Unsigned = Word32
          (* word-style bit-operations on integers... *)
          structure SignedBitops = IntBitOps(structure I = Signed
                                             structure W = Unsigned)
       end
    structure LongLong =
       struct
          structure Signed = Int64
          structure Unsigned = Word64
          (* word-style bit-operations on integers... *)
          structure SignedBitops = IntBitOps(structure I = Signed
                                             structure W = Unsigned)
       end
    structure Float = Real32
    structure Double = Real64
end
