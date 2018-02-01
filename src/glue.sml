structure RustLrVals = RustLrValsFun(structure Token = RustParser.Token);
structure RustLex = RustLexFun(structure Tokens = RustLrVals.Tokens);
structure RustParser = Join(
    structure ParserData = RustLrVals.ParserData
    structure Lex = RustLex
    structure LrParser = LrParser);
