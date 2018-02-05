structure D = DataTypes

structure Rust :
	sig val compile : string -> D.Rust
		val execute : D.Rust -> unit
end =

struct
	exception RustError;

	local

		datatype LocClos = Loc of int
						 | Closure of  D.ArgList * D.Rust *
						 			   (D.VarDT * LocClos) list

		val undef = ~1
		val return = ref 0
		fun LocToInt (Loc lox) = lox
		  	| LocToInt (Closure (a, r, l)) = undef

		fun LocToClose (Loc lox) = (D.EmptyAL (), D.Empty (), [])
		  	| LocToClose (Closure (a, r, l)) = (a, r, l)

		val lox = ref undef
		val newLoc = fn () => let val _ = lox := (!lox) - 1 in !lox  end

		fun saveReturn (x: int * (LocClos * int) list) =
										let	val _ = return := #1 (x) in x end

		fun findInEnv (env, id) = #2 (valOf (List.find
								(fn x : (D.VarDT * LocClos)	=> #1 x = id) env))

		fun findInStore (store, loc) = #2 (valOf (List.find
								(fn x : (LocClos * int) => #1 x = loc) store))

		fun EnqueueArgs (D.EmptyAL (), env, store) = (env, store)
			| EnqueueArgs (D.ArgConcat (ltime, var, al), env, store) =
				let val loc = findInEnv (env, var) val lloc = newLoc ()
					in EnqueueArgs (al, (var, Loc lloc)::env, (loc, lloc)::store)
					end

		fun checkInEnv (env, id) = #1 (valOf (List.find
								(fn x : (D.VarDT * LocClos)	=> #2 x = id) env))

		in
		fun compile (fileName) =
			let val inStream = TextIO.openIn fileName;
				val grab : int -> string = fn n => if TextIO.endOfStream inStream
												then ""
												else TextIO.inputN (inStream,n);
				val printError : string * int * int -> unit =
						fn (msg,line,col) => print (fileName ^ "[" ^
						Int.toString line ^ ":" ^ Int.toString
						col ^ "] " ^ msg ^ "\n");
				val (tree,rem) = RustParser.parse(15, (RustParser.makeLexer grab),
				 									printError, ())
				handle RustParser.ParseError => raise RustError;
				val _ = TextIO.closeIn inStream;

				fun checkExp (env, D.Undef (), store) = (undef, store)
				 	| checkExp (env, D.Const k, store) = (k, store)
					| checkExp (env, D.Var v, store) =
							let val valueV = #1 (findInStore (store,
												 findInEnv (env, v)), store)
									in if valueV > 0 then (valueV, store)
									else let val _ = checkInEnv(env, Loc (valueV))
									in (valueV, store) end
							end
					| checkExp (env, D.Ref r, store) = (LocToInt
												(findInEnv (env, r)), store)
					| checkExp (env, D.Plus (x, y), store) =
									let val p1 = checkExp (env, x, store)
										val p2 = checkExp (env, y, #2 p1)
										in (#1 p1 + #1 p2, #2 p2)
									end
					(*	| checkExp (env, D.Call(f, al), store) = (100, store) *)

				fun check (env, D.Empty r, store) = store
					| check (env, D.Skip r, store) = store
				 	| check (env, D.Comp (r, s), store) = check (env, s,
														  check (env, r, store))
					| check (env, D.Exp e, store) = #2 (checkExp (env, e, store))
					| check (env, D.Block (r, s), store) = check (env, s,
														   check (env, r, store))
					| check (env, D.Print e, store) = #2 (checkExp (env, e, store))
					| check (env, D.Let (v, e, r), store) =
						let val newEnv = (v, Loc (newLoc ()))::env
							val exp = checkExp (env, e, store)
							in check (newEnv, r, (Loc (!lox), #1 exp)::(#2 exp))
						end
					| check (env, D.Ass (v, e), store) =
						let val exp = checkExp (env, e, store)
							in ((findInEnv (env, v)), #1 (exp))::(#2 (exp))
						end


				val _ = check ([], tree, [])
				in tree
			end

		fun execute(prog) =
			let val _ = lox := undef
				fun evalExp (env, D.Undef (), store) = saveReturn (undef, store)
					| evalExp (env, D.Const k, store) = saveReturn (k, store)
					| evalExp (env, D.Var v, store) =
						saveReturn (findInStore (store,
												findInEnv (env, v)), store)
					| evalExp (env, D.Ref r, store) =
						saveReturn (LocToInt (findInEnv (env, r)),store)
					| evalExp (env, D.Plus (x, y), store) =
						let val p1 = evalExp (env, x, store)
							val p2 = evalExp (env, y, #2 p1)
							in saveReturn (#1 p1 + #1 p2, #2 p2)
						end
				 	| evalExp (env, D.Call(f, al), store) =
						let val closure = LocToClose (findInEnv (env, f))
							val newEnvStore = EnqueueArgs ((#1 closure),
														   (#3 closure), store)
				 			in saveReturn ((!return),
							 eval (#1 newEnvStore, #2 closure, #2 newEnvStore))
				 		end
				and eval (env, D.Empty r, store) = store
						| eval (env, D.Skip r, store) = store
					 	| eval (env, D.Comp (r, s), store) =
							eval (env, s, eval (env, r, store))
						| eval (env, D.Exp e, store) =
							#2 (evalExp (env, e, store))
						| eval (env, D.Block (r, s), store) =
							eval (env, s, eval (env, r, store))
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
						| eval (env, D.Ass (v, e), store) =
							let val exp = evalExp (env, e, store)
								in ((findInEnv(env, v)), #1 (exp))::(#2 (exp))
							end

			val _ = eval ([], prog, []);	(* Env, prog, store *)
			in ()
		end
	end
end;
