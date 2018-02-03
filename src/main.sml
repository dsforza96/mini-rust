structure D = DataTypes

structure Rust :
	sig val compile : unit -> unit
end =

struct
  fun invoke lexstream =
    let fun print_error (s,i:int,_) =
      TextIO.output(TextIO.stdErr,
		    "Error, line " ^ (Int.toString i) ^ ", " ^ s ^ "\n")
    in RustParser.parse(0,lexstream,print_error,())
  	end

  fun compile () =
      let val lexer = RustParser.makeLexer (fn _ =>
                                               (case TextIO.inputLine TextIO.stdIn
                                                of SOME s => s
                                                 | _ => ""))

	(*	fun evalV (D.V x) = x
		fun eval (D.Empty ()) = ""
			| eval (D.Const x) = Int.toString x
			| eval (D.Var x) = evalV x
			| eval (D.Plus(x, y)) = eval x ^ " + " ^ eval y
			| eval (D.Let(x, y)) = "let " ^ eval x ^ " = " ^ eval y *)

	  val dummyEOF = RustLrVals.Tokens.EOF(0,0)
	  fun loop lexer =
	      let val (result,lexer) = invoke lexer
		  			val (nextToken,lexer) = RustParser.Stream.get lexer
            (* val _ = TextIO.output(TextIO.stdOut, eval result ^ "\n") *)
	       in if RustParser.sameToken(nextToken,dummyEOF) then ()
		  			else loop lexer
	      end
      in loop lexer
  end

end
