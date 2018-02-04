structure D = DataTypes

structure Rust :
	sig val compile : string -> D.Rust
			val execute : D.Rust -> unit
end =
struct
	exception RustError;

	fun compile (fileName) =
		let val inStream = TextIO.openIn fileName;
				val grab : int -> string = fn n => if TextIO.endOfStream inStream
																							then ""
																							else TextIO.inputN (inStream,n);
				val printError : string * int * int -> unit =
						fn (msg,line,col) => print (fileName ^ "[" ^ Int.toString line ^ ":"
																					^ Int.toString col ^ "] " ^ msg ^ "\n");
				val (tree,rem) = RustParser.parse(15, (RustParser.makeLexer grab),
																						printError, ())
				handle RustParser.ParseError => raise RustError;
				val _ = TextIO.closeIn inStream;
				in tree
		end

	fun execute(prog) =
		let val lox = ref 0
				val newLoc = fn () => let val _ = lox := (!lox) + 1 in !lox - 1 end
				fun findVar (env, id, store) = (fn loc =>  #2 (valOf (List.find
																		(fn x : (int * int) => #1 x = loc) store)))
																(#2 (valOf (List.find (fn x : (string * int) =>
																														#1 x = id) env)))

				fun evalVar (D.V s) = s

				fun evalExp (env, D.Const k, store) = (k, store)
					| evalExp (env, D.Var v, store) = (findVar (env, evalVar v, store),
																									store)
					| evalExp (env, D.Plus(x, y), store) =
																				let val p1 = evalExp (env, x, store)
																				 		val p2 = (evalExp (env, y,
																								#2 (evalExp (env, x, store))))
																						in (#1 p1 + #1 p2, #2 p2)
																				end
			 		| evalExp (env, D.Call(f, al), store) = (0, store)

				fun eval (env, D.Empty r, store) = store
					| eval (env, D.Skip r, store) = store
				 	| eval (env, D.Comp (r, s), store) = eval (env, s, eval (env, r, store))
					| eval (env, D.Exp e, store) = #2 (evalExp (env, e, store))
					| eval (env, D.Print e, store) =
																			let val p = evalExp (env, e, store)
																					val _ = TextIO.output(TextIO.stdOut,
																											Int.toString (#1 p) ^ "\n")
																					in #2 p
																			end
					| eval (env, D.Let (v, e, r), store) = eval ((evalVar v, newLoc ())::env, r,
																					(!lox, (#2 (evalExp (env, e, store)))::store))

				val _ = eval ([], prog, []);	(* Env, prog, store *)
				in ()
		end
end;
