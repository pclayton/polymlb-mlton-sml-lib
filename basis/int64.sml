structure Int64 :> INTEGER =
  struct

    type int = IntInf.int

    val n = 64
    val minVal = IntInf.~ (IntInf.pow (2, n - 1))
    val maxVal = IntInf.- (IntInf.pow (2, n - 1), 1)
    fun check n = if minVal <= n andalso n <= maxVal then n else raise Overflow

    val toLarge = IntInf.toLarge
    val fromLarge = check o IntInf.fromLarge
    val toInt = IntInf.toInt
    val fromInt = check o IntInf.fromInt  (* check not necessary if `Int.int` has precision no greater than 64 *)

    val precision = SOME n
    val minInt = SOME minVal
    val maxInt = SOME maxVal

    val op + = check o IntInf.+
    val op - = check o IntInf.-
    val op * = check o IntInf.*
    val op div = check o IntInf.div
    val op mod = check o IntInf.mod
    val quot = check o IntInf.quot
    val rem = check o IntInf.rem

    val compare = IntInf.compare
    val op <  = IntInf.<
    val op <= = IntInf.<=
    val op >  = IntInf.>
    val op >= = IntInf.>=

    fun ~ n = if n <> minVal then IntInf.~ n else raise Overflow
    fun abs n = if n <> minVal then IntInf.abs n else raise Overflow
    val min = IntInf.min
    val max = IntInf.max
    val sign = IntInf.sign
    val sameSign = IntInf.sameSign

    val fmt      = IntInf.fmt
    val toString = IntInf.toString
    fun scan r read src =
      case IntInf.scan r read src of
        SOME (n, src') => SOME (check n, src')
      | NONE           => NONE
    val fromString = Option.map check o IntInf.fromString

  end
;

local
  fun convInt s =
    case Int64.fromString s of
      NONE => raise RunCall.Conversion "Invalid integer constant"
    | SOME res => res
in
  val () = RunCall.addOverload convInt "convInt"
end
;

val () = RunCall.addOverload Int64.~ "~";
val () = RunCall.addOverload Int64.+ "+";
val () = RunCall.addOverload Int64.- "-";
val () = RunCall.addOverload Int64.* "*";
val () = RunCall.addOverload Int64.div "div";
val () = RunCall.addOverload Int64.mod "mod";
val () = RunCall.addOverload Int64.< "<";
val () = RunCall.addOverload Int64.> ">";
val () = RunCall.addOverload Int64.<= "<=";
val () = RunCall.addOverload Int64.>= ">=";
