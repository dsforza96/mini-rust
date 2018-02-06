signature DATATYPES =
sig datatype VarDT = V of string

      and ExpDT = Undef of unit
                 | Const of int
                 | Var of VarDT
                 | Ref of VarDT
                 | Plus of ExpDT * ExpDT
                 | Call of VarDT * ArgList

      and Ltime = EmptyLT of unit
                 | L of string

      and ArgList = EmptyAL of unit
                 | ArgConcat of Ltime * VarDT * ArgList

      and Rust = Empty of unit
                 | Skip of unit
                 | Comp of Rust * Rust
                 | Exp of ExpDT
                 | Block of Rust * Rust
                 | Let of VarDT * ExpDT * Rust
                 | Ass of VarDT * ExpDT
                 | Fun of VarDT * Ltime list * ArgList * Ltime * Rust * Rust
                 | BlockFun of Rust * VarDT
                 | Print of ExpDT
end;

structure DataTypes : DATATYPES =
struct
    datatype VarDT = V of string

      and ExpDT = Undef of unit
                 | Const of int
                 | Var of VarDT
                 | Ref of VarDT
                 | Plus of ExpDT * ExpDT
                 | Call of VarDT * ArgList

      and Ltime = EmptyLT of unit
                 | L of string

      and ArgList = EmptyAL of unit
                 | ArgConcat of Ltime * VarDT * ArgList

      and Rust = Empty of unit
                 | Skip of unit
                 | Comp of Rust * Rust
                 | Exp of ExpDT
                 | Block of Rust * Rust
                 | Let of VarDT * ExpDT * Rust
                 | Ass of VarDT * ExpDT
                 | Fun of VarDT * Ltime list * ArgList * Ltime * Rust * Rust
                 | BlockFun of Rust * VarDT
                 | Print of ExpDT
end;
