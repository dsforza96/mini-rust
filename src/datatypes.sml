signature DATATYPES =
sig datatype VarDT = V of string

      and ExpDT = Undef of unit
                 | Const of int
                 | Var of VarDT
                 | Plus of ExpDT * ExpDT
                 | Call of VarDT * ArgList

      and Ltime = EmptyLT of unit
                 | L of string

      and LtimeList = EmptyLL of unit
                 | LtimeConcat of Ltime * LtimeList

      and ArgList = EmptyAL of unit
                 | ArgConcat of Ltime * VarDT * ArgList

      and Rust = Empty of unit
                 | Skip of unit
                 | Comp of Rust * Rust
                 | Exp of ExpDT
                 | Block of Rust * Rust
                 | Let of VarDT * ExpDT * Rust
                 | Ass of VarDT * ExpDT
                 | Fun of VarDT * LtimeList * ArgList * Ltime * Rust
                 | Print of ExpDT
end;

structure DataTypes : DATATYPES =
struct
    datatype VarDT = V of string

      and ExpDT = Undef of unit
                 | Const of int
                 | Var of VarDT
                 | Plus of ExpDT * ExpDT
                 | Call of VarDT * ArgList

      and Ltime = EmptyLT of unit
                 | L of string

      and LtimeList = EmptyLL of unit
                 | LtimeConcat of Ltime * LtimeList

      and ArgList = EmptyAL of unit
                 | ArgConcat of Ltime * VarDT * ArgList

      and Rust = Empty of unit
                 | Skip of unit
                 | Comp of Rust * Rust
                 | Exp of ExpDT
                 | Block of Rust * Rust
                 | Let of VarDT * ExpDT * Rust
                 | Ass of VarDT * ExpDT
                 | Fun of VarDT * LtimeList * ArgList * Ltime * Rust
                 | Print of ExpDT
end;
