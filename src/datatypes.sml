signature DATATYPES = 
sig datatype V = V of string
      and Rust = Const of int
                 | Var of V
                 | Plus of Rust * Rust
                 | Let of Rust * Rust
end;

structure DataTypes : DATATYPES =
struct
    datatype V = V of string
      and Rust = Const of int
                 | Var of V
                 | Plus of Rust * Rust
                 | Let of Rust * Rust
end;
