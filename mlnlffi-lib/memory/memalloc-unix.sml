(* c-int.sml
 * 2023 Phil Clayton (phil.clayton@veonix.com)
 *  Adapted for Poly/ML.
 *)

(* memalloc.sml
 *
 *   Memory allocation (via malloc) for platform Poly/ML is built on.
 *   Size of address determined by platform Poly/ML is built on.
 *
 * Copyright (c) 2004 by The Fellowship of SML/NJ
 *
 * Author: Matthias Blume (blume@tti-c.org)
 *)
structure CMemAlloc : CMEMALLOC = struct

    exception OutOfMemory = PolyMLFFI.Memory.Memory

    type addr' = PolyMLFFI.Memory.Pointer.t

    val alloc = PolyMLFFI.Memory.malloc
    val free = PolyMLFFI.Memory.free
end
