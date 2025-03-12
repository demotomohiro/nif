# Generated by tools/gen_tags.nim from doc/tags.md. DO NOT EDIT!


type
  NiflerKind* = enum
    None
    ErrL = (1, "err")  ## indicates an error
    SufL = (2, "suf")  ## literal with suffix annotation
    AtL = (3, "at")  ## array indexing operation
    DerefL = (4, "deref")  ## pointer deref operation
    DotL = (5, "dot")  ## object field selection
    ParL = (7, "par")  ## syntactic parenthesis
    AddrL = (8, "addr")  ## address of operation
    NilL = (9, "nil")  ## nil pointer value
    OconstrL = (23, "oconstr")  ## object constructor
    BracketL = (25, "bracket")  ## untyped array constructor
    CurlyL = (26, "curly")  ## untyped set constructor
    CurlyatL = (27, "curlyat")  ## curly expression `a{i}`
    KvL = (28, "kv")  ## key-value pair
    VvL = (29, "vv")  ## value-value pair (used for explicitly named arguments in function calls)
    CastL = (45, "cast")  ## `cast` operation
    CallL = (47, "call")  ## call operation
    CmdL = (48, "cmd")  ## command operation
    RangesL = (50, "ranges")
    VarL = (53, "var")  ## variable declaration
    ParamL = (54, "param")  ## parameter declaration
    ConstL = (55, "const")  ## const variable declaration
    LetL = (59, "let")  ## let variable declaration
    TypevarL = (61, "typevar")  ## type variable declaration
    EfldL = (62, "efld")  ## enum field declaration
    FldL = (63, "fld")  ## field declaration
    ProcL = (64, "proc")  ## proc declaration
    FuncL = (65, "func")  ## function declaration
    IteratorL = (66, "iterator")  ## iterator declaration
    ConverterL = (67, "converter")  ## converter declaration
    MethodL = (68, "method")  ## method declaration
    MacroL = (69, "macro")  ## macro declaration
    TemplateL = (70, "template")  ## template declaration
    TypeL = (71, "type")  ## type declaration
    BlockL = (72, "block")  ## block declaration
    AsgnL = (77, "asgn")  ## assignment statement
    IfL = (79, "if")  ## if statement header
    WhenL = (80, "when")  ## when statement header
    ElifL = (81, "elif")  ## pair of (condition, action)
    ElseL = (82, "else")  ## `else` action
    TypevarsL = (83, "typevars")  ## type variable/generic parameters
    BreakL = (84, "break")  ## `break` statement
    ContinueL = (85, "continue")  ## `continue` statement
    ForL = (86, "for")  ## for statement
    WhileL = (87, "while")  ## `while` statement
    CaseL = (88, "case")  ## `case` statement
    OfL = (89, "of")  ## `of` branch within a `case` statement
    RetL = (92, "ret")  ## `return` instruction
    YldL = (93, "yld")  ## yield statement
    StmtsL = (94, "stmts")  ## list of statements
    ParamsL = (95, "params")  ## list of proc parameters, also used as a "proc type"
    ObjectL = (97, "object")  ## object type declaration
    EnumL = (98, "enum")  ## enum type declaration
    ProctypeL = (99, "proctype")  ## proc type declaration (soon obsolete, use params instead)
    PtrL = (110, "ptr")  ## `ptr` type contructor
    PragmasL = (129, "pragmas")  ## begin of pragma section
    PragmaxL = (130, "pragmax")  ## pragma expressions
    IncludeL = (138, "include")  ## `include` statement
    ImportL = (139, "import")  ## `import` statement
    ImportasL = (140, "importas")  ## `import as` statement
    FromL = (141, "from")  ## `from` statement
    ImportexceptL = (142, "importexcept")  ## `importexcept` statement
    ExportL = (143, "export")  ## `export` statement
    ExportexceptL = (144, "exportexcept")  ## `exportexcept` statement
    CommentL = (145, "comment")  ## `comment` statement
    DiscardL = (146, "discard")  ## `discard` statement
    TryL = (147, "try")  ## `try` statement
    RaiseL = (148, "raise")  ## `raise` statement
    StaticL = (152, "static")  ## `static` type or annotation
    UnpackflatL = (157, "unpackflat")  ## unpack into flat variable list
    UnpacktupL = (158, "unpacktup")  ## unpack tuple
    UnpackdeclL = (159, "unpackdecl")  ## unpack var/let/const declaration
    ExceptL = (160, "except")  ## except subsection
    FinL = (161, "fin")  ## finally subsection
    TupleL = (162, "tuple")  ## `tuple` type
    RefL = (164, "ref")  ## `ref` type
    MutL = (165, "mut")  ## `mut` type
    OutL = (166, "out")  ## `out` type
    ConceptL = (170, "concept")  ## `concept` type
    DistinctL = (171, "distinct")  ## `distinct` type
    ItertypeL = (172, "itertype")  ## `itertype` type
    QuotedL = (206, "quoted")  ## name in backticks
    TupL = (212, "tup")  ## untyped tuple constructor
    TabconstrL = (215, "tabconstr")  ## table constructor
    CallstrlitL = (220, "callstrlit")
    InfixL = (221, "infix")
    PrefixL = (222, "prefix")
    TypeofL = (229, "typeof")
    ExprL = (235, "expr")
    DoL = (236, "do")  ## `do` expression
    StaticstmtL = (256, "staticstmt")  ## `static` statement
    BindL = (257, "bind")  ## `bind` statement
    MixinL = (258, "mixin")  ## `mixin` statement
    UsingL = (259, "using")  ## `using` statement
    AsmL = (260, "asm")  ## `asm` statement
    DeferL = (261, "defer")  ## `defer` statement
