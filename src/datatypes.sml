signature DATATYPES =
sig datatype VarDT = V of string
      and Rust = Empty of unit
                 | Const of int
                 | Var of VarDT
                 | Plus of Rust * Rust
                 | Let of Rust * Rust
end;

structure DataTypes : DATATYPES =
struct
    datatype VarDT = V of string
      and Rust = Empty of unit
                | Const of int
                | Var of VarDT
                | Plus of Rust * Rust
                | Let of Rust * Rust
end;
