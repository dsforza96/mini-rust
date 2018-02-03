signature DATATYPES =
sig datatype VarDT = V of string

      and ExpDT =  Const of Int
                 | Var of VarDT
                 | Plus of ExpDT * ExpDT

      and Ltime = Empty of unit
                 | L of String

      and LtimeList = Empty of unit
                 | LtimeConcat of Ltime * LtimeList

      and ArgList = Empty of unit
                 | ArgConcat of Ltime * VarDT * ArgList

      and Rust = Empty of unit
                 | Skip of unit
                 | Comp of Rust * Rust
                 | Exp of ExpDT
                 | Block of Rust
                 | Let of VarDT * Rust
                 | Fun of VarDT * LtimeList * ArgList * Ltime * Rust
                 | Call of VarDT * ArgList
                 | Print of Rust
end;

structure DataTypes : DATATYPES =
struct
    datatype VarDT = V of string

      and ExpDT =  Const of Int
                 | Var of VarDT
                 | Plus of ExpDT * ExpDT

      and Ltime = Empty of unit
                 | L of String

      and LtimeList = Empty of unit
                 | LtimeConcat of Ltime * LtimeList

      and ArgList = Empty of unit
                 | ArgConcat of Ltime * VarDT * ArgList

      and Rust = Empty of unit
                 | Skip of unit
                 | Comp of Rust * Rust
                 | Exp of ExpDT
                 | Block of Rust
                 | Let of VarDT * Rust
                 | Fun of VarDT * LtimeList * ArgList * Ltime * Rust
                 | Call of VarDT * ArgList
                 | Print of Rust
end;
