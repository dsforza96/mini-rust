structure Rust : sig
	           val parse : unit -> unit
                 end = 
struct

    fun invoke lexstream =
      let fun print_error (s,i:int,_) =
	      TextIO.output(TextIO.stdOut,
			    "Error, line " ^ (Int.toString i) ^ ", " ^ s ^ "\n")
       in RustParser.parse(0,lexstream,print_error,())
      end

  fun parse () = 
      let val lexer = RustParser.makeLexer (fn _ =>
                                               (case TextIO.inputLine TextIO.stdIn
                                                of SOME s => s
                                                 | _ => ""))
	  val dummyEOF = RustLrVals.Tokens.EOF(0,0)
	  val dummySEMI = RustLrVals.Tokens.SEMI(0,0)
	  fun loop lexer =
	      let val (result,lexer) = invoke lexer
		  val (nextToken,lexer) = RustParser.Stream.get lexer
		  val _ = case result
			    of SOME r =>
				TextIO.output(TextIO.stdOut,
				       "result = " ^ (Int.toString r) ^ "\n")
			     | NONE => ()
	       in if RustParser.sameToken(nextToken,dummyEOF) then ()
		  else loop lexer
	      end
       in loop lexer
      end

end
