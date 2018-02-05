structure D = DataTypes

structure Rust :
	sig val compile : string -> D.Rust
			val execute : D.Rust -> unit
end =
struct
	exception RustError;

	local
		datatype LocClos = Loc of int
										 | Closure of  D.ArgList * D.Rust * LocClos

		val undef = ~1
		(*
		and Env = EmptyEnv of unit
						| AddVar of D.VarDT * Closure * Env

		and Store = EmptyStore of unit
		          | AddLoc int * int * Store

		fun findVar (var, EmptyEnv ()) = raise RustError
				| findVar (var, AddVar (v, l, e)) = if var = v then l else findVar(var, e)
				| findVar (var, AddFun (v, l, e))		*)
		in

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
			let val lox = ref undef
					val newLoc = fn () => let val _ = lox := (!lox) + 1 in !lox  end
					fun findInEnv (env, id) = #2 (valOf (List.find (fn x : (D.VarDT * LocClos)
																			=> #1 x = id) env))

					fun findInStore (store, loc) = #2 (valOf (List.find (fn x : (LocClos * int)
																			=> #1 x = loc) store))

					fun evalExp (env, D.Undef (), store) = (undef, store)
					 	| evalExp (env, D.Const k, store) = (k, store)
						| evalExp (env, D.Var v, store) = (findInStore(store,
																								findInEnv(env, v)), store)
						| evalExp (env, D.Plus(x, y), store) =
																					let val p1 = evalExp (env, x, store)
																					 		val p2 = (evalExp (env, y, #2 p1))
																							in (#1 p1 + #1 p2, #2 p2)
																					end
				 	(*	| evalExp (env, D.Call(f, al), store) = (100, store) *)

					fun eval (env, D.Empty r, store) = store
						| eval (env, D.Skip r, store) = store
					 	| eval (env, D.Comp (r, s), store) = eval (env, s, eval (env, r, store))
						| eval (env, D.Exp e, store) = #2 (evalExp (env, e, store))
						| eval (env, D.Print e, store) =
																				let val exp = evalExp (env, e, store)
																						val _ = TextIO.output(TextIO.stdOut,
																												Int.toString (#1 exp) ^ "\n")
																						in #2 exp
																				end
						| eval (env, D.Let (v, e, r), store) =
						 														let val newEnv = (v, Loc (newLoc ()))::env
																						val exp = evalExp (env, e, store)
																						in eval (newEnv, r,
																									(Loc (!lox), #1 exp)::(#2 exp))
																				end

					val _ = eval ([], prog, []);	(* Env, prog, store *)
					in ()
				end
		end
end;
