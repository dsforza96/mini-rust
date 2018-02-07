structure D = DataTypes

structure Rust :
	sig val compile : string -> D.Rust
		val run : D.Rust -> int
end =

struct
	exception RustError;

	local

		datatype LocClos = Loc of int
						 | Closure of  D.ArgList * D.Ltime list * D.Ltime * D.Rust
						 								* (D.VarDT * LocClos) list

		val undef = ~1
		val return = ref 0
		val returnVar = ref (D.V "dummy")
		fun LocToInt (Loc lox) = lox
		  	| LocToInt (Closure (a, ltl, lt, r, l)) = undef

		fun LocToClose (Loc lox) = (D.EmptyAL (), [], D.EmptyLT (), D.Empty (), [])
		  	| LocToClose (Closure (a, ltl, lt, r, l)) = (a, ltl, lt, r, l)

		val lox = ref undef
		val newLoc = fn () => let val _ = lox := (!lox) - 1 in Loc (!lox)  end

		fun evalVar (D.V v) = v
		fun evalLt (D.EmptyLT ()) = ""
		  | evalLt (D.L lt) = lt

		fun saveReturn (x: D.VarDT * int * (LocClos * int) list) =
						let val _ = returnVar := #1 x
							val _ = return := #2 x
							in #3 x
						end

		fun findInEnv (env, id) = #2 (valOf (List.find
								(fn x : (D.VarDT * LocClos)	=> #1 x = id) env))
								handle Option => let val _ = TextIO.output(TextIO.stdErr,
									"error: cannot find value `" ^ evalVar id ^ "` in this scope")
									in raise RustError end

		fun findInEnvLt (env , id) = #2 (getOpt ((List.find
								(fn x : (D.VarDT * (D.VarDT list)) => #1 x = id) (!env)),
								(D.V " ", [])))

		fun findInStore (store, loc) = #2 (valOf (List.find
								(fn x : (LocClos * int) => #1 x = loc) store))

		fun rederArgs (D.EmptyAL (), D.EmptyAL (), ltList, lt) = []
			| rederArgs (D.EmptyAL (), parL, ltList, lt) = []
			| rederArgs (ArgL, D.EmptyAL (), ltList, lt) = []
			| rederArgs (D.ArgConcat (ltimeA, varA, alA),
				 		 D.ArgConcat (ltimeP, varP, alP), ltList, lt) =
						 let val _ = List.find (fn x : D.Ltime => x = ltimeP) ltList
							 in if ltimeP = lt then varP::rederArgs(alA, alP, ltList, lt)
								  else rederArgs(alA, alP, ltList, lt)
						 end

		fun checkInEnv (env, id, v) = #1 (valOf (List.find
								(fn x : (D.VarDT * LocClos)	=> #2 x = id) env))
									handle Option => let val _ = TextIO.output(TextIO.stdErr,
										"error: `" ^ evalVar v ^ "` does not live long enough")
										in raise RustError end

		fun findLtInEnv (env, id) = #2 (valOf (List.find
								(fn x : (D.VarDT * LocClos)	=> #1 x = id) env))
								handle Option => let val _ = TextIO.output(TextIO.stdErr,
									"error:  `" ^ evalVar id ^ "` does not live long enough")
									in raise RustError end

		fun followRef (v, valueV, env, store) =
					let val var = ref v
							val value = ref valueV
							val _ = while !value < undef do let val _ = var := checkInEnv(env, Loc (!value), !var)
																									in value := findInStore (store, Loc (!value))
																							end
							in if !value = undef
								then let val _ = TextIO.output(TextIO.stdErr,
																"error:  use of possibly uninitialized variable `" ^ evalVar (!var) ^ "`")
													in raise RustError
											end else (!var, !value)
							end

		in
		fun compile (fileName) =
			let val inStream = TextIO.openIn fileName;
				val grab : int -> string = fn n => if TextIO.endOfStream inStream
												then ""
												else TextIO.inputN (inStream,n);
				val printError : string * int * int -> unit =
						fn (msg, ln, _) => let val _ = print ("error[" ^
						Int.toString ln ^ "]: " ^ msg) in raise RustError end;
				val (tree,rem) = RustParser.parse(15, (RustParser.makeLexer grab),
				 									printError, ())
				handle RustParser.ParseError => raise RustError;
				val _ = TextIO.closeIn inStream;

				val ltEnv = ref [(D.V "dummy", [])]

				fun EnqueueArgs (D.EmptyAL (), D.EmptyAL (), funEnv, env, store) = (funEnv, store)

					| EnqueueArgs (D.EmptyAL (), al, funEnv, env, store) = let val _ =
							TextIO.output(TextIO.stdErr, "error: this function requires less parameters") in raise RustError end

					| EnqueueArgs (al, D.EmptyAL (), funEnv, env, store) = let val _ =
							TextIO.output(TextIO.stdErr, "error: this function requires more parameters") in raise RustError end

					| EnqueueArgs (D.ArgConcat (ltimeP, varP, alP), D.ArgConcat (ltimeA, varA, alA), funEnv, env, store) =
						let val value = followRef(varA, (#1 (checkExp(env, D.Var varA, store))), env, store)
								val loc = newLoc ()
								in EnqueueArgs (alP, alA, (varP, loc)::funEnv, env, (loc, #2 value)::store)
						end

				and findLtime (D.EmptyAL (), D.EmptyAL (), ltList, lt, env, store) = []

					| findLtime (D.EmptyAL (), parL, ltList, lt, env, store) = let val _ =
							TextIO.output(TextIO.stdErr, "error: this function requires less parameters") in raise RustError end

					| findLtime (ArgL, D.EmptyAL (), ltList, lt, env, store) = let val _ =
							TextIO.output(TextIO.stdErr, "error: this function requires more parameters") in raise RustError end

					| findLtime (D.ArgConcat (ltimeA, varA, alA),
								 D.ArgConcat (ltimeP, varP, alP), ltList, lt, env, store) =
								let val _ = valOf (List.find (fn x : D.Ltime => x = ltimeP) ltList)
										handle Option => let val _ = TextIO.output(TextIO.stdErr,
											"error:  use of undeclared lifetime name `" ^ evalLt ltimeP ^ "`")
												in raise RustError end
										val var = followRef(varA, (#1 (checkExp(env, D.Var varA, store))), env, store)
										in if ltimeP = lt then (#1 var)::findLtime(alA, alP, ltList, lt, env, store)
										 		else findLtime(alA, alP, ltList, lt, env, store)
								end

				and checkExp (env, D.Undef (), store) = (undef, store)

				 	| checkExp (env, D.Const k, store) = (k, store)

					| checkExp (env, D.Var v, store) =
								let val valueV = #1 (findInStore (store,
													 findInEnv (env, v)), store)
									val varLtList  = findInEnvLt(ltEnv, v)
									val _ = List.map (fn x => findLtInEnv(env, x)) varLtList
									in if valueV >= 0 then (valueV, store)
											else if valueV = undef
														then let val _ = TextIO.output(TextIO.stdErr,
																	"error:  use of possibly uninitialized variable `" ^ evalVar v ^ "`")
																	in raise RustError end
														else let val _ = checkInEnv(env, Loc (valueV), v)
																		in (valueV, store)
																	end
								end

					| checkExp (env, D.Ref r, store) =
								let val var = r
										val value = #1 (checkExp(env, D.Var r, store))
										val _ = if value = undef
											then let val _ = TextIO.output(TextIO.stdErr,
																"error:  use of possibly uninitialized variable `" ^ evalVar var ^ "`")
															 in raise RustError
													 end else ()
										in (LocToInt (findInEnv (env, r)), store)
								end

					| checkExp (env, D.Plus (x, y), store) =
									let val p1 = checkExp (env, x, store)
										val p2 = checkExp (env, y, #2 p1)
										in (#1 p1 + #1 p2, #2 p2)
									end

					| checkExp (env, D.Call(f, al), store) =
						let val closure = LocToClose (findInEnv (env, f))
							val newEnvStore = EnqueueArgs ((#1 closure), al,
														   (#5 closure), env, store)
							val newLtList = if (#2 closure) = [] andalso (#3 closure) = D.EmptyLT ()
															then []
															else findLtime (al,	#1 closure, #2 closure, #3 closure, env, store)
							val _ = if (#2 closure) = [] andalso (#3 closure) = D.EmptyLT ()
											then D.EmptyLT ()
											else valOf (List.find (fn x : D.Ltime => x = (#3 closure)) (#2 closure))
									handle Option => let val _ = TextIO.output(TextIO.stdErr,
										"error:  use of undeclared lifetime name `" ^ evalLt (#3 closure) ^ "`")
									in raise RustError end
							val newStore = check (#1 newEnvStore, #4 closure, #2 newEnvStore)
							val _ = ltEnv :=  (D.V "$", newLtList)::(!ltEnv)
							val _ = valOf (List.find (fn x => (!returnVar) = x)
									(rederArgs (al, #1 closure,
											  #2 closure, #3 closure)))
								handle Option => let val _ = TextIO.output(TextIO.stdErr,
									"error: lifetime mismatch")
									in raise RustError end
							in ((!return), newStore)
						end

				and check (env, D.Empty r, store) = store

					| check (env, D.Skip r, store) = store

				 	| check (env, D.Comp (r, s), store) = check (env, s,
														  check (env, r, store))

					| check (env, D.Exp e, store) =
						let val exp = (checkExp (env, e, store))
							in #2 (checkExp (env, e, store))
						end

					| check (env, D.Block (r, s), store) = check (env, s,
														   check (env, r, store))

					| check (env, D.Let (v, e, r), store) =
						let val llox = newLoc ()
							val newEnv = (v, llox)::env
							val exp = checkExp (env, e, store)
							val lastLtime: (D.VarDT * (D.VarDT list)) =
											List.nth(!ltEnv, 0)
							val _ = if (#1 lastLtime) = (D.V "$") then
										ltEnv := (v, #2 lastLtime)::(!ltEnv)
									else ()
							in check (newEnv, r, (llox, #1 exp)::(#2 exp))
						end

					| check (env, D.Ass (v, e), store) =
						let val exp = checkExp (env, e, store)
							val lastLtime: (D.VarDT * (D.VarDT list)) =
											List.nth(!ltEnv, 0)
							val _ = if (#1 lastLtime) = (D.V "$") then
												ltEnv := (v, #2 lastLtime)::(!ltEnv)
											else ()
							val _ = if findInStore(store, findInEnv(env, v)) <> undef then
												let val _ = TextIO.output(TextIO.stdErr,
															"error:  cannot assign twice to immutable variable `" ^ evalVar v ^ "`")
														in raise RustError
												end
											else ()
							in ((findInEnv (env, v)), #1 (exp))::(#2 (exp))
						end

					| check (env, D.Fun (f, ll, al, ltime, body, rust), store) =
						let val newEnv = (f, Closure (al, ll, ltime, body, env))::env
							in check (newEnv, rust, store)
						end

					| check (env, D.BlockFun (r, v), store) =
						let val newStore = check (env, r, store)
							val resVal = checkExp (env, D.Var v, newStore)
							in saveReturn (v, #1 resVal, #2 resVal)
						end

					| check (env, D.Print e, store) =
						let val exp = checkExp (env, e, store)
								val _ = followRef((D.V ""), #1 exp, env, store)
							in #2 exp
						end

				val _ = check ([], tree, [])
				in tree
			end

		fun run(prog) =
			let val _ = lox := undef

			fun EnqueueArgs (D.EmptyAL (), D.EmptyAL (), funEnv, env, store) = (funEnv, store)

					| EnqueueArgs (D.EmptyAL (), al, funEnv, env, store) = (funEnv, store)

					| EnqueueArgs (al, D.EmptyAL (), funEnv, env, store) = (funEnv, store)

					| EnqueueArgs (D.ArgConcat (ltimeP, varP, alP), D.ArgConcat (ltimeA, varA, alA), funEnv, env, store) =
						let val value = followRef(varA, #1 (evalExp(env, D.Var varA, store)), env, store)
							val loc = newLoc ()
							in EnqueueArgs (alP, alA, (varP, loc)::funEnv, env, (loc, #2 value)::store)
						end

				and evalExp (env, D.Undef (), store) = (undef, store)

					| evalExp (env, D.Const k, store) = (k, store)

					| evalExp (env, D.Var v, store) =
						(findInStore (store, findInEnv (env, v)), store)

					| evalExp (env, D.Ref r, store) =
						(LocToInt (findInEnv (env, r)),store)

					| evalExp (env, D.Plus (x, y), store) =
						let val p1 = evalExp (env, x, store)
							val p2 = evalExp (env, y, #2 p1)
							in (#1 p1 + #1 p2, #2 p2)
						end

				 	| evalExp (env, D.Call(f, al), store) =
						let val closure = LocToClose (findInEnv (env, f))
							val newEnvStore = EnqueueArgs ((#1 closure), al,
														   (#5 closure), env, store)
							val newStore = eval (#1 newEnvStore, #4 closure, #2 newEnvStore)
				 			in (!return, newStore)
				 		end

				and eval (env, D.Empty r, store) = store

						| eval (env, D.Skip r, store) = store

					 	| eval (env, D.Comp (r, s), store) =
							eval (env, s, eval (env, r, store))

						| eval (env, D.Exp e, store) =
							let val exp = (evalExp (env, e, store))
								in #2 (exp)
							end

						| eval (env, D.Block (r, s), store) =
							eval (env, s, eval (env, r, store))

						| eval (env, D.Let (v, e, r), store) =
						 	let val llox = newLoc ()
								val newEnv = (v, llox)::env
								val exp = evalExp (env, e, store)
								in eval (newEnv, r,
										(llox, #1 exp)::(#2 exp))
							end

						| eval (env, D.Ass (v, e), store) =
							let val exp = evalExp (env, e, store)
								in ((findInEnv(env, v)), #1 (exp))::(#2 (exp))
							end

						| eval (env, D.Fun (f, ll, al, ltime, body, rust), store) =
							let val newEnv = (f, Closure (al, [], D.EmptyLT (), body, env))::env
								in eval (newEnv, rust, store)
							end

						| eval (env, D.BlockFun (r, v), store) =
							let val newStore = eval (env, r, store)
								val resVal = evalExp (env, D.Var v, newStore)
								in saveReturn (v, #1 resVal, #2 resVal)
							end

						| eval (env, D.Print e, store) =
							let val exp = evalExp (env, e, store)
									val value = followRef((D.V ""), #1 exp, env, store)
								val _ = TextIO.output(TextIO.stdOut,
										Int.toString (#2 value) ^ "\n")
								in #2 exp
							end

			val _ = eval ([], prog, []);	(* Env, prog, store *)
			in 0
		end
	end
end;
