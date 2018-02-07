structure T = Tokens

exception RustError

type pos = int
type svalue = T.svalue
type ('a, 'b) token = ('a, 'b) T.token
type lexresult = (svalue, pos) token

val lineNum = ref 0;
val eof = fn () => T.EOF(!lineNum, !lineNum);

val perror = fn ln => fn ch =>  TextIO.output(TextIO.stdErr, "error[" ^ Int.toString ln ^
                                          "]: found `" ^ ch ^ "`");

val trim = fn s => List.nth((String.tokens(fn c => c = #" " orelse c = #"\t"
                                     orelse c = #"\n" orelse c = #"\r"
                                     orelse c = #"}") s), 0)

%%

%full
%count
%header (functor RustLexFun(structure Tokens: Rust_TOKENS));

alpha = [A-Za-z_-];
digit = [0-9];
ws = [\ \t];
eol = ("\r\n"|"\n"|"\r");

%%

{eol}	                            => (lex());
{ws}+	                            => (lex());

"+"                                 => (T.PLUS(!yylineno, !yylineno));
"let"                               => (T.LET(!yylineno, !yylineno));
"fn"                                => (T.FUN(!yylineno, !yylineno));
"i32"                               => (T.INT(!yylineno, !yylineno));
"="                                 => (T.ASS(!yylineno, !yylineno));
":"                                 => (T.COLON(!yylineno, !yylineno));
";"                                 => (T.SEMI(!yylineno, !yylineno));
","                                 => (T.COMMA(!yylineno, !yylineno));
"->"                                => (T.ARROW(!yylineno, !yylineno));
"("                                 => (T.LPAR(!yylineno, !yylineno));
")"                                 => (T.RPAR(!yylineno, !yylineno));
"{"                                 => (T.LBRA(!yylineno, !yylineno));
"}"                                 => (T.RBRA(!yylineno, !yylineno));
"<"                                 => (T.LCHE(!yylineno, !yylineno));
">"                                 => (T.RCHE(!yylineno, !yylineno));
"&"                                 => (T.AMP(!yylineno, !yylineno));
"println!"                          => (T.PRINT(!yylineno, !yylineno));
"fn"({ws}|{eol})+"main"             => (T.MAIN(!yylineno, !yylineno));

"'"{alpha}({alpha}|{digit})*        => (T.LTIME(yytext, !yylineno, !yylineno));
{alpha}({alpha}|{digit})*({ws}|{eol})*"}"
                                    => (T.IDRET(trim yytext, !yylineno, !yylineno));
{alpha}({alpha}|{digit})*           => (T.ID(yytext, !yylineno, !yylineno));
{digit}+                            => (T.CONST(valOf(Int.fromString yytext), !yylineno, !yylineno));

.                                   => (perror (!yylineno)  yytext; raise RustError);
