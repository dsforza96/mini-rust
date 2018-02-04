structure D = DataTypes

structure Rust :
	sig val compile : string -> DataTypes.Rust
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
end;
