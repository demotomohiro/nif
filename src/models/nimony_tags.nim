# Generated by tools/gen_tags.nim from doc/tags.md. DO NOT EDIT!

import tags

type
  NimonyExpr* = enum
    NoExpr
    ErrX = (ord(ErrTagId), "err")  ## indicates an error
    SufX = (ord(SufTagId), "suf")  ## literal with suffix annotation
    AtX = (ord(AtTagId), "at")  ## array indexing operation
    DerefX = (ord(DerefTagId), "deref")  ## pointer deref operation
    DotX = (ord(DotTagId), "dot")  ## object field selection
    PatX = (ord(PatTagId), "pat")  ## pointer indexing operation
    ParX = (ord(ParTagId), "par")  ## syntactic parenthesis
    AddrX = (ord(AddrTagId), "addr")  ## address of operation
    NilX = (ord(NilTagId), "nil")  ## nil pointer value
    InfX = (ord(InfTagId), "inf")  ## positive infinity floating point value
    NeginfX = (ord(NeginfTagId), "neginf")  ## negative infinity floating point value
    NanX = (ord(NanTagId), "nan")  ## NaN floating point value
    FalseX = (ord(FalseTagId), "false")  ## boolean `false` value
    TrueX = (ord(TrueTagId), "true")  ## boolean `true` value
    AndX = (ord(AndTagId), "and")  ## boolean `and` operation
    OrX = (ord(OrTagId), "or")  ## boolean `or` operation
    XorX = (ord(XorTagId), "xor")  ## boolean `xor` operation
    NotX = (ord(NotTagId), "not")  ## boolean `not` operation
    NegX = (ord(NegTagId), "neg")  ## negation operation
    SizeofX = (ord(SizeofTagId), "sizeof")  ## `sizeof` operation
    AlignofX = (ord(AlignofTagId), "alignof")  ## `alignof` operation
    OffsetofX = (ord(OffsetofTagId), "offsetof")  ## `offsetof` operation
    OconstrX = (ord(OconstrTagId), "oconstr")  ## object constructor
    AconstrX = (ord(AconstrTagId), "aconstr")  ## array constructor
    BracketX = (ord(BracketTagId), "bracket")  ## untyped array constructor
    CurlyX = (ord(CurlyTagId), "curly")  ## untyped set constructor
    CurlyatX = (ord(CurlyatTagId), "curlyat")  ## curly expression `a{i}`
    OvfX = (ord(OvfTagId), "ovf")  ## access overflow flag
    AddX = (ord(AddTagId), "add")
    SubX = (ord(SubTagId), "sub")
    MulX = (ord(MulTagId), "mul")
    DivX = (ord(DivTagId), "div")
    ModX = (ord(ModTagId), "mod")
    ShrX = (ord(ShrTagId), "shr")
    ShlX = (ord(ShlTagId), "shl")
    BitandX = (ord(BitandTagId), "bitand")
    BitorX = (ord(BitorTagId), "bitor")
    BitxorX = (ord(BitxorTagId), "bitxor")
    BitnotX = (ord(BitnotTagId), "bitnot")
    EqX = (ord(EqTagId), "eq")
    NeqX = (ord(NeqTagId), "neq")
    LeX = (ord(LeTagId), "le")
    LtX = (ord(LtTagId), "lt")
    CastX = (ord(CastTagId), "cast")  ## `cast` operation
    ConvX = (ord(ConvTagId), "conv")  ## type conversion
    CallX = (ord(CallTagId), "call")  ## call operation
    CmdX = (ord(CmdTagId), "cmd")  ## command operation
    CchoiceX = (ord(CchoiceTagId), "cchoice")  ## closed choice
    OchoiceX = (ord(OchoiceTagId), "ochoice")  ## open choice
    PragmaxX = (ord(PragmaxTagId), "pragmax")  ## pragma expressions
    QuotedX = (ord(QuotedTagId), "quoted")  ## name in backticks
    HderefX = (ord(HderefTagId), "hderef")  ## hidden pointer deref operation
    DdotX = (ord(DdotTagId), "ddot")  ## deref dot
    HaddrX = (ord(HaddrTagId), "haddr")  ## hidden address of operation
    NewrefX = (ord(NewrefTagId), "newref")  ## Nim's `new` magic proc that allocates a `ref T`
    NewobjX = (ord(NewobjTagId), "newobj")  ## new object constructor
    TupX = (ord(TupTagId), "tup")  ## untyped tuple constructor
    TupconstrX = (ord(TupconstrTagId), "tupconstr")  ## tuple constructor
    SetconstrX = (ord(SetconstrTagId), "setconstr")  ## set constructor
    TabconstrX = (ord(TabconstrTagId), "tabconstr")  ## table constructor
    AshrX = (ord(AshrTagId), "ashr")
    BaseobjX = (ord(BaseobjTagId), "baseobj")  ## object conversion to base type
    HconvX = (ord(HconvTagId), "hconv")  ## hidden basic type conversion
    DconvX = (ord(DconvTagId), "dconv")  ## conversion between `distinct` types
    CallstrlitX = (ord(CallstrlitTagId), "callstrlit")
    InfixX = (ord(InfixTagId), "infix")
    PrefixX = (ord(PrefixTagId), "prefix")
    HcallX = (ord(HcallTagId), "hcall")  ## hidden converter call
    CompilesX = (ord(CompilesTagId), "compiles")
    DeclaredX = (ord(DeclaredTagId), "declared")
    DefinedX = (ord(DefinedTagId), "defined")
    InstanceofX = (ord(InstanceofTagId), "instanceof")  ## only-fans operator for object privilege checking
    ProccallX = (ord(ProccallTagId), "proccall")  ## turns method call into a proc call aka a "static" call
    HighX = (ord(HighTagId), "high")
    LowX = (ord(LowTagId), "low")
    TypeofX = (ord(TypeofTagId), "typeof")
    UnpackX = (ord(UnpackTagId), "unpack")
    FieldsX = (ord(FieldsTagId), "fields")  ## fields iterator
    FieldpairsX = (ord(FieldpairsTagId), "fieldpairs")  ## fieldPairs iterator
    EnumtostrX = (ord(EnumtostrTagId), "enumtostr")
    IsmainmoduleX = (ord(IsmainmoduleTagId), "ismainmodule")
    DefaultobjX = (ord(DefaultobjTagId), "defaultobj")
    DefaulttupX = (ord(DefaulttupTagId), "defaulttup")
    ExprX = (ord(ExprTagId), "expr")
    DoX = (ord(DoTagId), "do")  ## `do` expression
    ArratX = (ord(ArratTagId), "arrat")  ## two optional exprs: `high` boundary and the `low` boundary (if != 0)
    TupatX = (ord(TupatTagId), "tupat")
    PlussetX = (ord(PlussetTagId), "plusset")
    MinussetX = (ord(MinussetTagId), "minusset")
    MulsetX = (ord(MulsetTagId), "mulset")
    XorsetX = (ord(XorsetTagId), "xorset")
    EqsetX = (ord(EqsetTagId), "eqset")
    LesetX = (ord(LesetTagId), "leset")
    LtsetX = (ord(LtsetTagId), "ltset")
    InsetX = (ord(InsetTagId), "inset")
    CardX = (ord(CardTagId), "card")
    EmoveX = (ord(EmoveTagId), "emove")
    DestroyX = (ord(DestroyTagId), "destroy")
    DupX = (ord(DupTagId), "dup")
    CopyX = (ord(CopyTagId), "copy")
    WasmovedX = (ord(WasmovedTagId), "wasmoved")
    SinkhX = (ord(SinkhTagId), "sinkh")
    TraceX = (ord(TraceTagId), "trace")
    InternalTypeNameX = (ord(InternalTypeNameTagId), "internalTypeName")  ## returns compiler's internal type name
    InternalFieldPairsX = (ord(InternalFieldPairsTagId), "internalFieldPairs")  ## variant of fieldPairs iterator returns compiler's internal field name

proc rawTagIsNimonyExpr*(raw: TagEnum): bool {.inline.} =
  raw in {ErrTagId, SufTagId, AtTagId, DerefTagId, DotTagId, PatTagId, ParTagId, AddrTagId, NilTagId, InfTagId, NeginfTagId, NanTagId, FalseTagId, TrueTagId, AndTagId, OrTagId, XorTagId, NotTagId, NegTagId, SizeofTagId, AlignofTagId, OffsetofTagId, OconstrTagId, AconstrTagId, BracketTagId, CurlyTagId, CurlyatTagId, OvfTagId, AddTagId, SubTagId, MulTagId, DivTagId, ModTagId, ShrTagId, ShlTagId, BitandTagId, BitorTagId, BitxorTagId, BitnotTagId, EqTagId, NeqTagId, LeTagId, LtTagId, CastTagId, ConvTagId, CallTagId, CmdTagId, CchoiceTagId, OchoiceTagId, PragmaxTagId, QuotedTagId, HderefTagId, DdotTagId, HaddrTagId, NewrefTagId, NewobjTagId, TupTagId, TupconstrTagId, SetconstrTagId, TabconstrTagId, AshrTagId, BaseobjTagId, HconvTagId, DconvTagId, CallstrlitTagId, InfixTagId, PrefixTagId, HcallTagId, CompilesTagId, DeclaredTagId, DefinedTagId, InstanceofTagId, ProccallTagId, HighTagId, LowTagId, TypeofTagId, UnpackTagId, FieldsTagId, FieldpairsTagId, EnumtostrTagId, IsmainmoduleTagId, DefaultobjTagId, DefaulttupTagId, ExprTagId, DoTagId, ArratTagId, TupatTagId, PlussetTagId, MinussetTagId, MulsetTagId, XorsetTagId, EqsetTagId, LesetTagId, LtsetTagId, InsetTagId, CardTagId, EmoveTagId, DestroyTagId, DupTagId, CopyTagId, WasmovedTagId, SinkhTagId, TraceTagId, InternalTypeNameTagId, InternalFieldPairsTagId}

type
  NimonyStmt* = enum
    NoStmt
    CallS = (ord(CallTagId), "call")  ## call operation
    CmdS = (ord(CmdTagId), "cmd")  ## command operation
    GvarS = (ord(GvarTagId), "gvar")  ## global variable declaration
    TvarS = (ord(TvarTagId), "tvar")  ## thread local variable declaration
    VarS = (ord(VarTagId), "var")  ## variable declaration
    ConstS = (ord(ConstTagId), "const")  ## const variable declaration
    ResultS = (ord(ResultTagId), "result")  ## result variable declaration
    GletS = (ord(GletTagId), "glet")  ## global let variable declaration
    TletS = (ord(TletTagId), "tlet")  ## thread local let variable declaration
    LetS = (ord(LetTagId), "let")  ## let variable declaration
    CursorS = (ord(CursorTagId), "cursor")  ## cursor variable declaration
    ProcS = (ord(ProcTagId), "proc")  ## proc declaration
    FuncS = (ord(FuncTagId), "func")  ## function declaration
    IteratorS = (ord(IteratorTagId), "iterator")  ## iterator declaration
    ConverterS = (ord(ConverterTagId), "converter")  ## converter declaration
    MethodS = (ord(MethodTagId), "method")  ## method declaration
    MacroS = (ord(MacroTagId), "macro")  ## macro declaration
    TemplateS = (ord(TemplateTagId), "template")  ## template declaration
    TypeS = (ord(TypeTagId), "type")  ## type declaration
    BlockS = (ord(BlockTagId), "block")  ## block declaration
    EmitS = (ord(EmitTagId), "emit")  ## emit statement
    AsgnS = (ord(AsgnTagId), "asgn")  ## assignment statement
    ScopeS = (ord(ScopeTagId), "scope")  ## explicit scope annotation, like `stmts`
    IfS = (ord(IfTagId), "if")  ## if statement header
    WhenS = (ord(WhenTagId), "when")  ## when statement header
    BreakS = (ord(BreakTagId), "break")  ## `break` statement
    ContinueS = (ord(ContinueTagId), "continue")  ## `continue` statement
    ForS = (ord(ForTagId), "for")  ## for statement
    WhileS = (ord(WhileTagId), "while")  ## `while` statement
    CaseS = (ord(CaseTagId), "case")  ## `case` statement
    RetS = (ord(RetTagId), "ret")  ## `return` instruction
    YldS = (ord(YldTagId), "yld")  ## yield statement
    StmtsS = (ord(StmtsTagId), "stmts")  ## list of statements
    PragmasS = (ord(PragmasTagId), "pragmas")  ## begin of pragma section
    InclS = (ord(InclTagId), "incl")  ## `#include` statement or `incl` set operation
    ExclS = (ord(ExclTagId), "excl")  ## `excl` set operation
    IncludeS = (ord(IncludeTagId), "include")  ## `include` statement
    ImportS = (ord(ImportTagId), "import")  ## `import` statement
    ImportasS = (ord(ImportasTagId), "importas")  ## `import as` statement
    FromimportS = (ord(FromimportTagId), "fromimport")  ## `from import` statement
    ImportexceptS = (ord(ImportexceptTagId), "importexcept")  ## `importexcept` statement
    ExportS = (ord(ExportTagId), "export")  ## `export` statement
    ExportexceptS = (ord(ExportexceptTagId), "exportexcept")  ## `exportexcept` statement
    CommentS = (ord(CommentTagId), "comment")  ## `comment` statement
    DiscardS = (ord(DiscardTagId), "discard")  ## `discard` statement
    TryS = (ord(TryTagId), "try")  ## `try` statement
    RaiseS = (ord(RaiseTagId), "raise")  ## `raise` statement
    UnpackdeclS = (ord(UnpackdeclTagId), "unpackdecl")  ## unpack var/let/const declaration
    AssumeS = (ord(AssumeTagId), "assume")  ## `assume` pragma
    AssertS = (ord(AssertTagId), "assert")  ## `assert` pragma
    StaticstmtS = (ord(StaticstmtTagId), "staticstmt")  ## `static` statement
    BindS = (ord(BindTagId), "bind")  ## `bind` statement
    MixinS = (ord(MixinTagId), "mixin")  ## `mixin` statement
    UsingS = (ord(UsingTagId), "using")  ## `using` statement
    AsmS = (ord(AsmTagId), "asm")  ## `asm` statement
    DeferS = (ord(DeferTagId), "defer")  ## `defer` statement

proc rawTagIsNimonyStmt*(raw: TagEnum): bool {.inline.} =
  raw in {CallTagId, CmdTagId, GvarTagId, TvarTagId, VarTagId, ConstTagId, ResultTagId, GletTagId, TletTagId, LetTagId, CursorTagId, ProcTagId, FuncTagId, IteratorTagId, ConverterTagId, MethodTagId, MacroTagId, TemplateTagId, TypeTagId, BlockTagId, EmitTagId, AsgnTagId, ScopeTagId, IfTagId, WhenTagId, BreakTagId, ContinueTagId, ForTagId, WhileTagId, CaseTagId, RetTagId, YldTagId, StmtsTagId, PragmasTagId, InclTagId, ExclTagId, IncludeTagId, ImportTagId, ImportasTagId, FromimportTagId, ImportexceptTagId, ExportTagId, ExportexceptTagId, CommentTagId, DiscardTagId, TryTagId, RaiseTagId, UnpackdeclTagId, AssumeTagId, AssertTagId, StaticstmtTagId, BindTagId, MixinTagId, UsingTagId, AsmTagId, DeferTagId}

type
  NimonyType* = enum
    NoType
    ErrT = (ord(ErrTagId), "err")  ## indicates an error
    AtT = (ord(AtTagId), "at")  ## array indexing operation
    AndT = (ord(AndTagId), "and")  ## boolean `and` operation
    OrT = (ord(OrTagId), "or")  ## boolean `or` operation
    NotT = (ord(NotTagId), "not")  ## boolean `not` operation
    IteratorT = (ord(IteratorTagId), "iterator")  ## iterator declaration
    ParamsT = (ord(ParamsTagId), "params")  ## list of proc parameters, also used as a "proc type"
    ObjectT = (ord(ObjectTagId), "object")  ## object type declaration
    EnumT = (ord(EnumTagId), "enum")  ## enum type declaration
    ProctypeT = (ord(ProctypeTagId), "proctype")  ## proc type declaration (soon obsolete, use params instead)
    IT = (ord(ITagId), "i")  ## `int` builtin type
    UT = (ord(UTagId), "u")  ## `uint` builtin type
    FT = (ord(FTagId), "f")  ## `float` builtin type
    CT = (ord(CTagId), "c")  ## `char` builtin type
    BoolT = (ord(BoolTagId), "bool")  ## `bool` builtin type
    VoidT = (ord(VoidTagId), "void")  ## `void` return type
    PtrT = (ord(PtrTagId), "ptr")  ## `ptr` type contructor
    ArrayT = (ord(ArrayTagId), "array")  ## `array` type constructor
    VarargsT = (ord(VarargsTagId), "varargs")  ## `varargs` proc annotation
    StaticT = (ord(StaticTagId), "static")  ## `static` type or annotation
    TupleT = (ord(TupleTagId), "tuple")  ## `tuple` type
    OnumT = (ord(OnumTagId), "onum")  ## enum with holes type
    RefT = (ord(RefTagId), "ref")  ## `ref` type
    MutT = (ord(MutTagId), "mut")  ## `mut` type
    OutT = (ord(OutTagId), "out")  ## `out` type
    LentT = (ord(LentTagId), "lent")  ## `lent` type
    SinkT = (ord(SinkTagId), "sink")  ## `sink` type
    NiltT = (ord(NiltTagId), "nilt")  ## `nilt` type
    ConceptT = (ord(ConceptTagId), "concept")  ## `concept` type
    DistinctT = (ord(DistinctTagId), "distinct")  ## `distinct` type
    ItertypeT = (ord(ItertypeTagId), "itertype")  ## `itertype` type
    RangetypeT = (ord(RangetypeTagId), "rangetype")  ## `rangetype` type
    UarrayT = (ord(UarrayTagId), "uarray")  ## `uarray` type
    SetT = (ord(SetTagId), "set")  ## `set` type
    AutoT = (ord(AutoTagId), "auto")  ## `auto` type
    SymkindT = (ord(SymkindTagId), "symkind")  ## `symkind` type
    TypekindT = (ord(TypekindTagId), "typekind")  ## `typekind` type
    TypedescT = (ord(TypedescTagId), "typedesc")  ## `typedesc` type
    UntypedT = (ord(UntypedTagId), "untyped")  ## `untyped` type
    TypedT = (ord(TypedTagId), "typed")  ## `typed` type
    CstringT = (ord(CstringTagId), "cstring")  ## `cstring` type
    PointerT = (ord(PointerTagId), "pointer")  ## `pointer` type
    OrdinalT = (ord(OrdinalTagId), "ordinal")  ## `ordinal` type

proc rawTagIsNimonyType*(raw: TagEnum): bool {.inline.} =
  raw in {ErrTagId, AtTagId, AndTagId, OrTagId, NotTagId, IteratorTagId, ParamsTagId, ObjectTagId, EnumTagId, ProctypeTagId, ITagId, UTagId, FTagId, CTagId, BoolTagId, VoidTagId, PtrTagId, ArrayTagId, VarargsTagId, StaticTagId, TupleTagId, OnumTagId, RefTagId, MutTagId, OutTagId, LentTagId, SinkTagId, NiltTagId, ConceptTagId, DistinctTagId, ItertypeTagId, RangetypeTagId, UarrayTagId, SetTagId, AutoTagId, SymkindTagId, TypekindTagId, TypedescTagId, UntypedTagId, TypedTagId, CstringTagId, PointerTagId, OrdinalTagId}

type
  NimonyOther* = enum
    NoSub
    KvU = (ord(KvTagId), "kv")  ## key-value pair
    VvU = (ord(VvTagId), "vv")  ## value-value pair (used for explicitly named arguments in function calls)
    RangeU = (ord(RangeTagId), "range")  ## `(range a b)` construct
    RangesU = (ord(RangesTagId), "ranges")
    ParamU = (ord(ParamTagId), "param")  ## parameter declaration
    TypevarU = (ord(TypevarTagId), "typevar")  ## type variable declaration
    EfldU = (ord(EfldTagId), "efld")  ## enum field declaration
    FldU = (ord(FldTagId), "fld")  ## field declaration
    ElifU = (ord(ElifTagId), "elif")  ## pair of (condition, action)
    ElseU = (ord(ElseTagId), "else")  ## `else` action
    TypevarsU = (ord(TypevarsTagId), "typevars")  ## type variable/generic parameters
    OfU = (ord(OfTagId), "of")  ## `of` branch within a `case` statement
    ParamsU = (ord(ParamsTagId), "params")  ## list of proc parameters, also used as a "proc type"
    PragmasU = (ord(PragmasTagId), "pragmas")  ## begin of pragma section
    UnpackflatU = (ord(UnpackflatTagId), "unpackflat")  ## unpack into flat variable list
    UnpacktupU = (ord(UnpacktupTagId), "unpacktup")  ## unpack tuple
    ExceptU = (ord(ExceptTagId), "except")  ## except subsection
    FinU = (ord(FinTagId), "fin")  ## finally subsection

proc rawTagIsNimonyOther*(raw: TagEnum): bool {.inline.} =
  raw in {KvTagId, VvTagId, RangeTagId, RangesTagId, ParamTagId, TypevarTagId, EfldTagId, FldTagId, ElifTagId, ElseTagId, TypevarsTagId, OfTagId, ParamsTagId, PragmasTagId, UnpackflatTagId, UnpacktupTagId, ExceptTagId, FinTagId}

type
  NimonyPragma* = enum
    NoPragma
    EmitP = (ord(EmitTagId), "emit")  ## emit statement
    InlineP = (ord(InlineTagId), "inline")  ## `inline` proc annotation
    NoinlineP = (ord(NoinlineTagId), "noinline")  ## `noinline` proc annotation
    VarargsP = (ord(VarargsTagId), "varargs")  ## `varargs` proc annotation
    SelectanyP = (ord(SelectanyTagId), "selectany")
    AlignP = (ord(AlignTagId), "align")
    BitsP = (ord(BitsTagId), "bits")
    NodeclP = (ord(NodeclTagId), "nodecl")  ## `nodecl` annotation
    RaisesP = (ord(RaisesTagId), "raises")  ## proc annotation
    UntypedP = (ord(UntypedTagId), "untyped")  ## `untyped` type
    MagicP = (ord(MagicTagId), "magic")  ## `magic` pragma
    ImportcP = (ord(ImportcTagId), "importc")  ## `importc` pragma
    ImportcppP = (ord(ImportcppTagId), "importcpp")  ## `importcpp` pragma
    ExportcP = (ord(ExportcTagId), "exportc")  ## `exportc` pragma
    HeaderP = (ord(HeaderTagId), "header")  ## `header` pragma
    ThreadvarP = (ord(ThreadvarTagId), "threadvar")  ## `threadvar` pragma
    GlobalP = (ord(GlobalTagId), "global")  ## `global` pragma
    DiscardableP = (ord(DiscardableTagId), "discardable")  ## `discardable` pragma
    NoreturnP = (ord(NoreturnTagId), "noreturn")  ## `noreturn` pragma
    BorrowP = (ord(BorrowTagId), "borrow")  ## `borrow` pragma
    NoSideEffectP = (ord(NoSideEffectTagId), "noSideEffect")  ## `noSideEffect` pragma
    NodestroyP = (ord(NodestroyTagId), "nodestroy")  ## `nodestroy` pragma
    PluginP = (ord(PluginTagId), "plugin")  ## `plugin` pragma
    BycopyP = (ord(BycopyTagId), "bycopy")  ## `bycopy` pragma
    ByrefP = (ord(ByrefTagId), "byref")  ## `byref` pragma
    NoinitP = (ord(NoinitTagId), "noinit")  ## `noinit` pragma
    RequiresP = (ord(RequiresTagId), "requires")  ## `requires` pragma
    EnsuresP = (ord(EnsuresTagId), "ensures")  ## `ensures` pragma
    AssumeP = (ord(AssumeTagId), "assume")  ## `assume` pragma
    AssertP = (ord(AssertTagId), "assert")  ## `assert` pragma
    BuildP = (ord(BuildTagId), "build")  ## `build` pragma
    StringP = (ord(StringTagId), "string")  ## `string` pragma
    ViewP = (ord(ViewTagId), "view")  ## `view` pragma
    InjectP = (ord(InjectTagId), "inject")  ## `inject` pragma
    GensymP = (ord(GensymTagId), "gensym")  ## `gensym` pragma
    ErrorP = (ord(ErrorTagId), "error")  ## `error` pragma
    ReportP = (ord(ReportTagId), "report")  ## `report` pragma
    TagsP = (ord(TagsTagId), "tags")  ## `tags` effect annotation
    DeprecatedP = (ord(DeprecatedTagId), "deprecated")  ## `deprecated` pragma
    SideEffectP = (ord(SideEffectTagId), "sideEffect")  ## explicit `sideEffect` pragma
    KeepOverflowFlagP = (ord(KeepOverflowFlagTagId), "keepOverflowFlag")  ## keep overflow flag
    SemanticsP = (ord(SemanticsTagId), "semantics")  ## proc with builtin behavior for expreval
    InheritableP = (ord(InheritableTagId), "inheritable")  ## `inheritable` pragma
    BaseP = (ord(BaseTagId), "base")  ## `base` pragma (currently ignored)
    PureP = (ord(PureTagId), "pure")  ## `pure` pragma (currently ignored)
    FinalP = (ord(FinalTagId), "final")  ## `final` pragma

proc rawTagIsNimonyPragma*(raw: TagEnum): bool {.inline.} =
  raw in {EmitTagId, InlineTagId, NoinlineTagId, VarargsTagId, SelectanyTagId, AlignTagId, BitsTagId, NodeclTagId, RaisesTagId, UntypedTagId, MagicTagId, ImportcTagId, ImportcppTagId, ExportcTagId, HeaderTagId, ThreadvarTagId, GlobalTagId, DiscardableTagId, NoreturnTagId, BorrowTagId, NoSideEffectTagId, NodestroyTagId, PluginTagId, BycopyTagId, ByrefTagId, NoinitTagId, RequiresTagId, EnsuresTagId, AssumeTagId, AssertTagId, BuildTagId, StringTagId, ViewTagId, InjectTagId, GensymTagId, ErrorTagId, ReportTagId, TagsTagId, DeprecatedTagId, SideEffectTagId, KeepOverflowFlagTagId, SemanticsTagId, InheritableTagId, BaseTagId, PureTagId, FinalTagId}

type
  NimonySym* = enum
    NoSym
    GvarY = (ord(GvarTagId), "gvar")  ## global variable declaration
    TvarY = (ord(TvarTagId), "tvar")  ## thread local variable declaration
    VarY = (ord(VarTagId), "var")  ## variable declaration
    ParamY = (ord(ParamTagId), "param")  ## parameter declaration
    ConstY = (ord(ConstTagId), "const")  ## const variable declaration
    ResultY = (ord(ResultTagId), "result")  ## result variable declaration
    GletY = (ord(GletTagId), "glet")  ## global let variable declaration
    TletY = (ord(TletTagId), "tlet")  ## thread local let variable declaration
    LetY = (ord(LetTagId), "let")  ## let variable declaration
    CursorY = (ord(CursorTagId), "cursor")  ## cursor variable declaration
    TypevarY = (ord(TypevarTagId), "typevar")  ## type variable declaration
    EfldY = (ord(EfldTagId), "efld")  ## enum field declaration
    FldY = (ord(FldTagId), "fld")  ## field declaration
    ProcY = (ord(ProcTagId), "proc")  ## proc declaration
    FuncY = (ord(FuncTagId), "func")  ## function declaration
    IteratorY = (ord(IteratorTagId), "iterator")  ## iterator declaration
    ConverterY = (ord(ConverterTagId), "converter")  ## converter declaration
    MethodY = (ord(MethodTagId), "method")  ## method declaration
    MacroY = (ord(MacroTagId), "macro")  ## macro declaration
    TemplateY = (ord(TemplateTagId), "template")  ## template declaration
    TypeY = (ord(TypeTagId), "type")  ## type declaration
    BlockY = (ord(BlockTagId), "block")  ## block declaration
    ModuleY = (ord(ModuleTagId), "module")  ## module declaration
    CchoiceY = (ord(CchoiceTagId), "cchoice")  ## closed choice

proc rawTagIsNimonySym*(raw: TagEnum): bool {.inline.} =
  raw >= GvarTagId and raw <= CchoiceTagId

type
  HookKind* = enum
    NoHook
    DestroyH = (ord(DestroyTagId), "destroy")
    DupH = (ord(DupTagId), "dup")
    CopyH = (ord(CopyTagId), "copy")
    WasmovedH = (ord(WasmovedTagId), "wasmoved")
    SinkhH = (ord(SinkhTagId), "sinkh")
    TraceH = (ord(TraceTagId), "trace")

proc rawTagIsHookKind*(raw: TagEnum): bool {.inline.} =
  raw >= DestroyTagId and raw <= TraceTagId

type
  ControlFlowKind* = enum
    NoControlFlow
    IteF = (ord(IteTagId), "ite")  ## if-then-else
    GraphF = (ord(GraphTagId), "graph")  ## disjoint subgraph annotation
    ForbindF = (ord(ForbindTagId), "forbind")  ## bindings for a `for` loop but the loop itself is mapped to gotos
    KillF = (ord(KillTagId), "kill")  ## some.var is about to disappear (scope exit)

proc rawTagIsControlFlowKind*(raw: TagEnum): bool {.inline.} =
  raw >= IteTagId and raw <= KillTagId

