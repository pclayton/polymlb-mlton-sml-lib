(* remove infix status of & and && *)
nonfix & &&

(* remove constructor status of & and && *)
fun & () = ()
fun && () = ()
