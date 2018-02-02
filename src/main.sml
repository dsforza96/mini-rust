structure Rust : sig
	           val compile : unit -> unit
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
	  val dummyEOF = RustLrVals.Tokens.EOF(0,0)
	  fun loop lexer =
	      let val (result,lexer) = invoke lexer
		  val (nextToken,lexer) = RustParser.Stream.get lexer
            val _ = result
	       in if RustParser.sameToken(nextToken,dummyEOF) then ()
		  else loop lexer
	      end
       in loop lexer
      end

end
