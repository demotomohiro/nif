#
#
#           Hexer Compiler
#        (c) Copyright 2024 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

import std / [hashes, os, tables, sets, assertions]

include nifprelude
import typekeys
import ".." / nimony / [nimony_model, programs, typenav, expreval, xints, decls]
import basics, pipeline


proc setOwner(e: var EContext; newOwner: SymId): SymId =
  result = e.currentOwner
  e.currentOwner = newOwner

proc demand(e: var EContext; s: SymId) =
  if not e.declared.contains(s):
    e.requires.add s

proc offer(e: var EContext; s: SymId) =
  e.declared.incl s


proc skipExportMarker(e: var EContext; c: var Cursor) =
  if c.kind == DotToken:
    inc c
  elif c.kind == Ident and pool.strings[c.litId] == "x":
    inc c
  elif c.kind == ParLe:
    # can now also be `(tag)` or `(tag <bits>)`:
    skip c
  else:
    error e, "expected '.' or 'x' for an export marker: ", c

proc expectSymdef(e: var EContext; c: var Cursor) =
  if c.kind != SymbolDef:
    error e, "expected symbol definition, but got: ", c

proc getSymDef(e: var EContext; c: var Cursor): (SymId, PackedLineInfo) =
  expectSymdef(e, c)
  result = (c.symId, c.info)
  inc c

proc expectSym(e: var EContext; c: var Cursor) =
  if c.kind != Symbol:
    error e, "expected symbol, but got: ", c

proc getSym(e: var EContext; c: var Cursor): (SymId, PackedLineInfo) =
  expectSym(e, c)
  result = (c.symId, c.info)
  inc c

proc expectStrLit(e: var EContext; c: var Cursor) =
  if c.kind != StringLit:
    error e, "expected string literal, but got: ", c

proc expectIntLit(e: var EContext; c: var Cursor) =
  if c.kind != IntLit:
    error e, "expected int literal, but got: ", c



proc add(e: var EContext; tag: string; info: PackedLineInfo) =
  e.dest.add tagToken(tag, info)

type
  TraverseMode = enum
    TraverseAll, TraverseSig, TraverseTopLevel

proc traverseExpr(e: var EContext; c: var Cursor)
proc traverseStmt(e: var EContext; c: var Cursor; mode = TraverseAll)
proc traverseLocal(e: var EContext; c: var Cursor; tag: string; mode: TraverseMode)

type
  TypeFlag = enum
    IsTypeBody
    IsPointerOf

proc traverseType(e: var EContext; c: var Cursor; flags: set[TypeFlag] = {})

proc traverseField(e: var EContext; c: var Cursor; flags: set[TypeFlag] = {}) =
  e.dest.add c # fld
  inc c

  expectSymdef(e, c)
  let (s, sinfo) = getSymDef(e, c)
  e.dest.add symdefToken(s, sinfo)
  e.offer s

  skipExportMarker e, c

  skip c # pragmas
  e.dest.addDotToken()

  traverseType e, c, flags

  skip c # skips value
  wantParRi e, c

proc ithTupleField(counter: int): SymId {.inline.} =
  pool.syms.getOrIncl("fld." & $counter)

proc genTupleField(e: var EContext; typ: var Cursor; counter: int) =
  e.dest.add tagToken("fld", typ.info)
  let name = ithTupleField(counter)
  e.dest.add symdefToken(name, typ.info)
  e.offer name
  e.dest.addDotToken() # pragmas
  e.traverseType(typ, {})
  e.dest.addParRi() # "fld"

proc traverseEnumField(e: var EContext; c: var Cursor; flags: set[TypeFlag] = {}) =
  e.dest.add c # efld
  inc c

  expectSymdef(e, c)
  let (s, sinfo) = getSymDef(e, c)
  e.dest.add symdefToken(s, sinfo)
  e.offer s

  skipExportMarker e, c

  skip c # pragmas: must be empty

  skip c # type: must be the enum itself

  inc c # skips TupleConstr
  traverseExpr e, c
  skip c
  skipParRi e, c

  wantParRi e, c

const
  NimStringName = "NimStr.0.sys"
  StringField = "s.0.sys"
  LengthField = "len.0.sys"

proc genStringType(e: var EContext; info: PackedLineInfo) =
  let s = pool.syms.getOrIncl(NimStringName)
  e.dest.add tagToken("type", info)
  e.dest.add symdefToken(s, info)
  e.offer s

  e.dest.addDotToken()
  e.dest.add tagToken("object", info)
  e.dest.addDotToken()

  e.dest.add tagToken("fld", info)
  let strField = pool.syms.getOrIncl(StringField)
  e.dest.add symdefToken(strField, info)
  e.offer strField
  e.dest.addDotToken()
  e.dest.add tagToken("ptr", info)
  e.dest.add tagToken("c", info)
  e.dest.addIntLit(8, info)
  e.dest.addParRi() # "c"
  e.dest.addParRi() # "ptr"
  e.dest.addParRi() # "fld"

  e.dest.add tagToken("fld", info)
  let lenField = pool.syms.getOrIncl(LengthField)
  e.dest.add symdefToken(lenField, info)
  e.offer lenField
  e.dest.addDotToken()
  e.dest.add tagToken("i", info)
  e.dest.addIntLit(-1, info)
  e.dest.addParRi() # "i"
  e.dest.addParRi() # "fld"

  e.dest.addParRi() # "object"
  e.dest.addParRi() # "type"

proc useStringType(e: var EContext; info: PackedLineInfo) =
  let s = pool.syms.getOrIncl(NimStringName)
  e.dest.add symToken(s, info)

proc traverseTupleBody(e: var EContext; c: var Cursor) =
  let info = c.info
  inc c
  e.dest.add tagToken("object", info)
  e.dest.addDotToken()
  var counter = 0
  while c.kind != ParRi:
    if c.substructureKind == FldS:
      inc c # skip fld
      e.offer c.symId
      skip c # skip name
      skip c # skip export marker
      skip c # skip pragmas
      genTupleField(e, c, counter)
      skip c # skip value
      skipParRi e, c
    else:
      if c.kind == SymbolDef:
        e.offer c.symId
      genTupleField(e, c, counter)
    inc counter
  wantParRi e, c

proc traverseOpenArrayBody(e: var EContext; c: var Cursor) =
  e.dest.add tagToken("object", c.info)
  e.dest.addDotToken()
  inc c
  let typ = c
  e.dest.add tagToken("fld", typ.info)
  let name = ithTupleField(0)
  e.dest.add symdefToken(name, typ.info)
  e.offer name
  e.dest.addDotToken() # pragmas
  e.dest.add tagToken("ptr", typ.info)
  e.traverseType(c, {})
  e.dest.addParRi() # "ptr"
  e.dest.addParRi() # "fld"

  var intType = e.typeCache.builtins.intType
  genTupleField(e, intType, 1)

  traverseType e, c
  skipParRi e, c

proc traverseArrayBody(e: var EContext; c: var Cursor) =
  e.dest.add c
  inc c
  traverseType e, c
  if c.typeKind == RangeT:
    inc c
    skip c
    expectIntLit e, c
    let first = pool.integers[c.intId]
    inc c
    expectIntLit e, c
    let last = pool.integers[c.intId]
    inc c
    skipParRi e, c
    e.dest.addIntLit(last - first + 1, c.info)
  else:
    # should not be possible, but assume length anyway
    traverseExpr e, c
  wantParRi e, c

proc traverseAsNamedType(e: var EContext; c: var Cursor) =
  let info = c.info
  var body = c
  let key = takeMangle c

  var val = e.newTypes.getOrDefault(key)
  if val == SymId(0):
    val = pool.syms.getOrIncl(key & ".0.t")
    e.newTypes[key] = val

    var buf = createTokenBuf(30)
    swap e.dest, buf

    e.dest.add tagToken("type", info)
    e.dest.add symdefToken(val, info)
    e.offer val

    e.dest.addDotToken()
    case body.typeKind
    of TupleT:
      traverseTupleBody e, body
    of ArrayT:
      traverseArrayBody e, body
    of OpenArrayT:
      traverseOpenArrayBody e, body
    else:
      error e, "expected tuple or array, but got: ", body
    e.dest.addParRi() # "type"

    swap e.dest, buf
    e.pending.add buf
  # regardless of what we had to do, we still need to add the typename:
  e.dest.add symToken(val, info)

proc traverseType(e: var EContext; c: var Cursor; flags: set[TypeFlag] = {}) =
  case c.kind
  of DotToken:
    e.dest.add c
    inc c
  of Symbol:
    let s = c.symId
    let ext = maybeMangle(e, s)
    if ext.len != 0:
      e.dest.addSymUse pool.syms.getOrIncl(ext), c.info
      inc c
      return
    let res = tryLoadSym(s)
    if res.status == LacksNothing:
      var body = asTypeDecl(res.decl).body
      if body.typeKind == DistinctT: # skips DistinctT
        inc body
        traverseType(e, body, flags)
        inc c
      else:
        e.demand s
        e.dest.add c
        inc c
    else:
      error e, "could not find symbol: " & pool.syms[s]
  of ParLe:
    case c.typeKind
    of NoType, OrT, AndT, NotT, TypedescT, UntypedT, TypedT, TypeKindT, OrdinalT:
      error e, "type expected but got: ", c
    of IntT, UIntT, FloatT, CharT, BoolT, AutoT, SymKindT:
      e.loop c:
        e.dest.add c
        inc c
    of PtrT, RefT, MutT, OutT, LentT:
      e.dest.add tagToken("ptr", c.info)
      inc c
      e.loop c:
        traverseType e, c, {IsPointerOf}
    of ProcT:
      e.dest.add c
      inc c
      e.loop c:
        traverseType e, c
    of ArrayT, OpenArrayT:
      traverseAsNamedType e, c
    of RangeT:
      # skip to base type
      inc c
      traverseType e, c
      skip c
      skip c
      wantParRi e, c
    of UncheckedArrayT:
      if IsPointerOf in flags:
        inc c
        traverseType e, c
        skipParRi e, c
      else:
        e.dest.add tagToken("flexarray", c.info)
        inc c
        traverseType e, c
        wantParRi e, c
    of PointerT:
      e.dest.add tagToken("ptr", c.info)
      e.dest.add tagToken("void", c.info)
      e.dest.addParRi()
      inc c
      wantParRi e, c
    of CstringT:
      e.dest.add tagToken("ptr", c.info)
      e.dest.add tagToken($CharT, c.info)
      e.dest.addIntLit(8, c.info)
      e.dest.addParRi()
      inc c
      wantParRi e, c
    of StaticT, SinkT, DistinctT:
      inc c
      traverseType e, c, flags
      skipParRi e, c
    of TupleT:
      traverseAsNamedType e, c
    of ObjectT:
      e.dest.add c
      inc c
      if c.kind == DotToken:
        e.dest.add c
        inc c
      else:
        # inherited symbol
        let (s, sinfo) = getSym(e, c)
        e.dest.add symToken(s, sinfo)
        e.demand s

      if c.kind == DotToken:
        e.dest.add c
        inc c
      else:
        while c.substructureKind == FldS:
          traverseField(e, c, flags)

      wantParRi e, c
    of EnumT, HoleyEnumT:
      e.dest.add tagToken("enum", c.info)
      inc c
      traverseType e, c, flags # base type

      while c.substructureKind == EfldS:
        traverseEnumField(e, c, flags)

      wantParRi e, c
    of StringT:
      useStringType e, c.info
      inc c
      skipParRi e, c
    of SetT:
      let info = c.info
      inc c
      let sizeOrig = bitsetSizeInBytes(c)
      var err = false
      let size = asSigned(sizeOrig, err)
      if err:
        error e, "invalid set element type: ", c
      else:
        var arrBuf = createTokenBuf(16)
        arrBuf.add tagToken("array", info)
        arrBuf.add tagToken("u", info)
        arrBuf.addIntLit(8, info)
        arrBuf.addParRi()
        arrBuf.addIntLit(size, info)
        arrBuf.addParRi()
        var arrCursor = cursorAt(arrBuf, 0)
        traverseAsNamedType(e, arrCursor)
      skip c
      skipParRi e, c
    of VoidT, VarargsT, NilT, ConceptT,
       IterT, InvokeT, RefObjectT, PtrObjectT:
      error e, "unimplemented type: ", c
  else:
    error e, "type expected but got: ", c

proc traverseParams(e: var EContext; c: var Cursor) =
  if c.kind == DotToken:
    e.dest.add c
    inc c
  elif c.kind == ParLe and pool.tags[c.tag] == $ParamsS:
    e.dest.add c
    inc c
    loop e, c:
      if c.substructureKind != ParamS:
        error e, "expected (param) but got: ", c
      traverseLocal(e, c, "param", TraverseSig)
  # the result type
  traverseType e, c

type
  CollectedPragmas = object
    externName: string
    flags: set[PragmaKind]
    align, bits: IntId
    header: StrId
    callConv: CallConv

proc parsePragmas(e: var EContext; c: var Cursor): CollectedPragmas =
  result = default(CollectedPragmas)
  if c.kind == DotToken:
    inc c
  elif c.kind == ParLe and pool.tags[c.tag] == $PragmasS:
    inc c
    while true:
      case c.kind
      of ParRi:
        inc c
        break
      of EofToken:
        error e, "expected ')', but EOF reached"
      else: discard
      if c.kind == ParLe:
        let pk = c.pragmaKind
        case pk
        of NoPragma:
          let cc = c.callConvKind
          if cc == NoCallConv:
            error e, "unknown pragma: ", c
          else:
            result.callConv = cc
          inc c
        of Magic:
          inc c
          if c.kind notin {StringLit, Ident}:
            error e, "expected string literal or ident, but got: ", c
          result.flags.incl Nodecl
          inc c
        of ImportC, ImportCpp:
          inc c
          expectStrLit e, c
          result.externName = pool.strings[c.litId]
          result.flags.incl pk
          inc c
        of ExportC, Plugin:
          inc c
          expectStrLit e, c
          result.externName = pool.strings[c.litId]
          inc c
        of Nodecl, Selectany, Threadvar, Globalvar, Discardable, NoReturn,
           Varargs, Borrow, NoSideEffect, NoDestroy, ByCopy, ByRef, Inline, NoInit:
          result.flags.incl pk
          inc c
        of Header:
          inc c
          expectStrLit e, c
          result.header = c.litId
          result.flags.incl Nodecl
          inc c
        of Align:
          inc c
          expectIntLit e, c
          result.align = c.intId
          inc c
        of Bits:
          inc c
          expectIntLit e, c
          result.bits = c.intId
          inc c
        of Requires, Ensures:
          skip c
        skipParRi e, c
      else:
        error e, "unknown pragma: ", c
  else:
    error e, "(pragmas) or '.' expected, but got: ", c

type
  GenPragmas = object
    opened: bool

proc openGenPragmas(): GenPragmas = GenPragmas(opened: false)

proc maybeOpen(e: var EContext; g: var GenPragmas; info: PackedLineInfo) {.inline.} =
  if not g.opened:
    g.opened = true
    e.dest.add tagToken("pragmas", info)

proc addKey(e: var EContext; g: var GenPragmas; key: string; info: PackedLineInfo) =
  maybeOpen e, g, info
  e.dest.add tagToken(key, info)
  e.dest.addParRi()

proc addKeyVal(e: var EContext; g: var GenPragmas; key: string; val: PackedToken; info: PackedLineInfo) =
  maybeOpen e, g, info
  e.dest.add tagToken(key, info)
  e.dest.add val
  e.dest.addParRi()

proc closeGenPragmas(e: var EContext; g: GenPragmas) =
  if g.opened:
    e.dest.addParRi()
  else:
    e.dest.addDotToken()

proc traverseProc(e: var EContext; c: var Cursor; mode: TraverseMode) =
  e.openMangleScope()
  var dst = createTokenBuf(50)
  swap e.dest, dst
  #let toPatch = e.dest.len
  let vinfo = c.info
  e.add "proc", vinfo
  inc c
  let (s, sinfo) = getSymDef(e, c)

  # namePos
  e.dest.add symdefToken(s, sinfo)
  e.offer s

  var isGeneric = false
  if c.kind == ParLe:
    isGeneric = true
  skipExportMarker e, c

  skip c # patterns

  if c.substructureKind == TypevarsS:
    isGeneric = true
    # count each typevar as used:
    inc c
    while c.kind != ParRi:
      assert c.symKind == TypevarY
      inc c
      let (typevar, _) = getSymDef(e, c)
      e.offer typevar
      skipToEnd c
    inc c
  else:
    skip c # generic parameters

  if isGeneric:
    # count each param as used:
    inc c
    while c.kind != ParRi:
      assert c.symKind == ParamY
      inc c
      let (param, _) = getSymDef(e, c)
      e.offer param
      skipToEnd c
    inc c
    skip c # skip return type
  else:
    traverseParams e, c

  let pinfo = c.info
  let prag = parsePragmas(e, c)

  let oldOwner = setOwner(e, s)

  var genPragmas = openGenPragmas()
  if prag.externName.len > 0:
    e.registerMangleInParent(s, prag.externName & ".c")
    e.addKeyVal genPragmas, "was", symToken(s, pinfo), pinfo
  if Selectany in prag.flags:
    e.addKey genPragmas, "selectany", pinfo

  if Borrow in prag.flags:
    e.addKey genPragmas, $Inline, pinfo
  closeGenPragmas e, genPragmas

  skip c # miscPos

  # body:
  if isGeneric:
    skip c
  elif mode != TraverseSig or Inline in prag.flags:
    traverseStmt e, c, TraverseAll
  else:
    e.dest.addDotToken()
    skip c
  wantParRi e, c
  swap dst, e.dest
  if Nodecl in prag.flags or isGeneric:
    discard "do not add to e.dest"
  elif prag.flags * {ImportC, ImportCpp} != {}:
    e.dest.add tagToken("imp", c.info)
    e.dest.add dst
    e.dest.addParRi()
  else:
    e.dest.add dst
  if prag.header != StrId(0):
    e.headers.incl prag.header
  discard setOwner(e, oldOwner)
  e.closeMangleScope()

proc traverseTypeDecl(e: var EContext; c: var Cursor) =
  var dst = createTokenBuf(50)
  swap e.dest, dst
  #let toPatch = e.dest.len
  let vinfo = c.info
  e.add "type", vinfo
  inc c
  let (s, sinfo) = getSymDef(e, c)
  let oldOwner = setOwner(e, s)

  e.dest.add symdefToken(s, sinfo)
  e.offer s

  var isGeneric = c.kind == ParLe
  skipExportMarker e, c
  if c.substructureKind == TypevarsS:
    isGeneric = true
    # count each typevar as used:
    inc c
    while c.kind != ParRi:
      assert c.symKind == TypevarY
      inc c
      let (typevar, _) = getSymDef(e, c)
      e.offer typevar
      skipToEnd c
    inc c
  else:
    skip c # generic parameters

  let prag = parsePragmas(e, c)

  e.dest.addDotToken() # adds pragmas

  if isGeneric:
    skip c
  else:
    traverseType e, c, {IsTypeBody}
  wantParRi e, c
  swap dst, e.dest
  if Nodecl in prag.flags or isGeneric:
    discard "do not add to e.dest"
  else:
    e.dest.add dst
  if prag.header != StrId(0):
    e.headers.incl prag.header
  discard setOwner(e, oldOwner)

proc genCstringLit(e: var EContext; c: var Cursor): bool =
  var cb = c
  if cb.typeKind == CstringT:
    inc cb # skip "(cstring"
    skipParRi e, cb # skip ")"
    if cb.kind == StringLit:
      e.dest.addStrLit pool.strings[cb.litId]
      inc cb
      skipParRi e, cb # skip ")" from "(conv"
      c = cb
      return true
  return false

proc genStringLit(e: var EContext; c: Cursor) =
  assert c.kind == StringLit
  let info = c.info
  let s {.cursor.} = pool.strings[c.litId]
  let existing = e.strLits.getOrDefault(s)
  if existing != SymId(0):
    e.dest.add symToken(existing, info)
  else:
    let strName = pool.syms.getOrIncl("str`." & $e.strLits.len)
    e.strLits[s] = strName
    e.pending.add tagToken("const", info)
    e.pending.add symdefToken(strName, info)
    e.offer strName

    e.pending.add tagToken("pragmas", info)
    e.pending.add tagToken("static", info)
    e.pending.addParRi()
    e.pending.addParRi()

    # type:
    e.pending.add symToken(pool.syms.getOrIncl(NimStringName), info)
    # value:
    e.pending.add tagToken("oconstr", info)
    e.pending.add symToken(pool.syms.getOrIncl(NimStringName), info)

    e.pending.add parLeToken(KvX, info)
    let strField = pool.syms.getOrIncl(StringField)
    e.pending.add symToken(strField, info)
    e.pending.addStrLit(s)
    e.pending.addParRi() # "kv"

    e.pending.add parLeToken(KvX, info)
    let lenField = pool.syms.getOrIncl(LengthField)
    e.pending.add symToken(lenField, info)
    # length also contains the "isConst" flag:
    e.pending.addIntLit(s.len * 2 + 1, info)
    e.pending.addParRi() # "kv"

    e.pending.addParRi() # "oconstr"
    e.pending.addParRi() # "const"
    e.dest.add symToken(strName, info)

proc traverseStmtsExpr(e: var EContext; c: var Cursor) =
  let head = c.load()
  inc c
  if isLastSon(c):
    traverseExpr e, c
    skipParRi e, c
  else:
    e.dest.add head
    while c.kind != ParRi:
      if not isLastSon(c):
        traverseStmt e, c
      else:
        traverseExpr e, c
    wantParRi e, c

proc traverseTupleConstr(e: var EContext; c: var Cursor) =
  e.dest.add tagToken("oconstr", c.info)
  var tupleType = e.typeCache.getType(c)
  e.traverseType(tupleType, {})
  inc c
  var counter = 0
  while c.kind != ParRi:
    e.dest.add tagToken("kv", c.info)
    e.dest.add symToken(ithTupleField(counter), c.info)
    inc counter
    if c.exprKind == KvX:
      inc c # skip "kv"
      skip c # skip key
      traverseExpr e, c
      skipParRi e, c
    else:
      traverseExpr e, c
    e.dest.addParRi() # "kv"
  wantParRi e, c

proc traverseExpr(e: var EContext; c: var Cursor) =
  var nested = 0
  while true:
    case c.kind
    of EofToken: break
    of ParLe:
      case c.exprKind
      of EqX, NeqX, LeX, LtX:
        e.dest.add c
        inc c
        var skipped = createTokenBuf()
        swap skipped, e.dest
        traverseType(e, c)
        swap skipped, e.dest
        inc nested
      of CastX:
        e.dest.add c
        inc c
        traverseType(e, c)
        traverseExpr(e, c)
        inc nested
      of HconvX, ConvX:
        let info = c.info
        inc c
        if not genCstringLit(e, c):
          e.dest.add tagToken("conv", info)
          traverseType(e, c)
          traverseExpr(e, c)
          inc nested
      of DconvX:
        inc c
        let beforeType = e.dest.len
        traverseType(e, c)
        e.dest.shrink beforeType
        traverseExpr(e, c)
        skipParRi(e, c)
      of AconstrX:
        e.dest.add tagToken("aconstr", c.info)
        var arrayType = e.typeCache.getType(c)
        inc c
        e.traverseType(arrayType, {})
        inc nested
      of OconstrX:
        e.dest.add tagToken("oconstr", c.info)
        inc c
        traverseType(e, c)
        inc nested
      of TupleConstrX:
        traverseTupleConstr e, c
      of CmdX, CallStrLitX, InfixX, PrefixX:
        e.dest.add tagToken("call", c.info)
        inc c
        inc nested
      of ExprX:
        traverseStmtsExpr e, c
      of ArrAtX:
        # XXX does not handle index type with offset low(I), maybe should be done in sem
        e.dest.add tagToken("at", c.info)
        inc c
        inc nested
      of TupAtX:
        e.dest.add tagToken("dot", c.info)
        inc c # skip tag
        traverseExpr e, c # tuple
        expectIntLit e, c
        e.dest.add symToken(ithTupleField(pool.integers[c.intId]), c.info)
        inc c # skip index
        e.dest.addIntLit(0, c.info) # inheritance
        e.dest.add c # add right paren
        inc c # skip right paren
      of DerefDotX:
        e.dest.add tagToken("dot", c.info)
        e.dest.add tagToken("deref", c.info)
        inc c # skip tag
        traverseExpr e, c
        e.dest.addParRi()
        traverseExpr e, c
        traverseExpr e, c
        wantParRi e, c
      of HAddrX, AddrX:
        e.dest.add tagToken("addr", c.info)
        inc c
        inc nested
      of HderefX, DerefX:
        e.dest.add tagToken("deref", c.info)
        inc c
        inc nested
      of SufX:
        e.dest.add c
        inc c
        traverseExpr e, c
        assert c.kind == StringLit
        e.dest.add c
        inc c
        inc nested
      else:
        e.dest.add c
        inc c
        inc nested
    of ParRi:
      e.dest.add c
      dec nested
      if nested == 0:
        inc c
        break
      inc c
    of SymbolDef:
      e.dest.add c
      e.offer c.symId
      inc c
    of Symbol:
      let ext = maybeMangle(e, c.symId)
      if ext.len != 0:
        e.dest.addSymUse pool.syms.getOrIncl(ext), c.info
      else:
        e.dest.add c
      e.demand c.symId
      inc c
    of StringLit:
      genStringLit e, c
      inc c
    of UnknownToken, DotToken, Ident, CharLit, IntLit, UIntLit, FloatLit:
      e.dest.add c
      inc c

    if nested == 0:
      break

proc traverseLocal(e: var EContext; c: var Cursor; tag: string; mode: TraverseMode) =
  var localDecl = c
  let toPatch = e.dest.len
  let vinfo = c.info
  e.add tag, vinfo
  inc c
  let (s, sinfo) = getSymDef(e, c)
  skipExportMarker e, c
  let pinfo = c.info
  let prag = parsePragmas(e, c)

  e.dest.add symdefToken(s, sinfo)
  e.offer s

  var genPragmas = openGenPragmas()

  if prag.externName.len > 0:
    e.registerMangle(s, prag.externName & ".c")
    e.addKeyVal genPragmas, "was", symToken(s, pinfo), pinfo

  if Threadvar in prag.flags:
    e.dest[toPatch] = tagToken("tvar", vinfo)
  elif Globalvar in prag.flags:
    e.dest[toPatch] = tagToken("gvar", vinfo)

  if prag.align != IntId(0):
    e.addKeyVal genPragmas, "align", intToken(prag.align, pinfo), pinfo
  if prag.bits != IntId(0):
    e.addKeyVal genPragmas, "bits", intToken(prag.bits, pinfo), pinfo
  closeGenPragmas e, genPragmas

  var nodecl = prag.flags.contains(Nodecl)
  e.typeCache.registerLocal(s, c)
  if tag == "param" and typeKind(c) == VarargsT:
    skip c
    nodecl = true
  else:
    traverseType e, c

  if mode != TraverseSig:
    traverseExpr e, c
  else:
    e.dest.addDotToken()
    skip c
  wantParRi e, c
  if nodecl:
    e.dest.shrink toPatch
  if prag.header != StrId(0):
    e.headers.incl prag.header

  if mode != TraverseTopLevel and tag in ["var", "const", "param"] and
      prag.flags * {Threadvar, Globalvar} == {}: # register local variables
    var declBuf = createTokenBuf()
    takeTree(declBuf, localDecl)
    publish s, declBuf

proc traverseWhile(e: var EContext; c: var Cursor) =
  let info = c.info
  e.nestedIn.add (WhileS, SymId(0))
  e.dest.add c
  inc c
  traverseExpr e, c
  traverseStmt e, c
  wantParRi e, c
  let lab = e.nestedIn[^1][1]
  if lab != SymId(0):
    e.dest.add tagToken("lab", info)
    e.dest.add symdefToken(lab, info)
    e.offer lab
    e.dest.addParRi()
  discard e.nestedIn.pop()

proc traverseBlock(e: var EContext; c: var Cursor) =
  let info = c.info
  inc c
  if c.kind == DotToken:
    e.nestedIn.add (BlockS, SymId(0))
    inc c
  else:
    let (s, _) = getSymDef(e, c)
    e.nestedIn.add (BlockS, s)
  e.dest.add tagToken("scope", info)
  traverseStmt e, c
  wantParRi e, c
  let lab = e.nestedIn[^1][1]
  if lab != SymId(0):
    e.dest.add tagToken("lab", info)
    e.dest.add symdefToken(lab, info)
    e.offer lab
    e.dest.addParRi()
  discard e.nestedIn.pop()

proc traverseBreak(e: var EContext; c: var Cursor) =
  let info = c.info
  inc c
  if c.kind == DotToken:
    inc c
    e.dest.add tagToken("break", info)
  else:
    expectSym e, c
    let lab = c.symId
    inc c
    e.dest.add tagToken("jmp", info)
    e.dest.add symToken(lab, info)
  wantParRi e, c

proc traverseIf(e: var EContext; c: var Cursor) =
  # (if cond (.. then ..) (.. else ..))
  e.dest.add c
  inc c
  while c.kind == ParLe and pool.tags[c.tag] == $ElifS:
    e.dest.add c
    inc c # skips '(elif'
    traverseExpr e, c
    traverseStmt e, c
    wantParRi e, c
  if c.kind == ParLe and pool.tags[c.tag] == $ElseS:
    e.dest.add c
    inc c
    traverseStmt e, c
    wantParRi e, c
  wantParRi e, c

proc traverseCase(e: var EContext; c: var Cursor) =
  e.dest.add c
  inc c
  traverseExpr e, c
  while c.kind != ParRi:
    case c.substructureKind
    of OfS:
      e.dest.add c
      inc c
      if c.kind == ParLe and pool.tags[c.tag] == $SetX:
        inc c
        e.add "ranges", c.info
        while c.kind != ParRi:
          traverseExpr e, c
        wantParRi e, c
      else:
        traverseExpr e, c
      traverseStmt e, c
      wantParRi e, c
    of ElseS:
      e.dest.add c
      inc c
      traverseStmt e, c
      wantParRi e, c
    else:
      error e, "expected (of) or (else) but got: ", c
  wantParRi e, c

proc traverseStmt(e: var EContext; c: var Cursor; mode = TraverseAll) =
  case c.kind
  of DotToken:
    e.dest.add c
    inc c
  of ParLe:
    case c.stmtKind
    of NoStmt:
      error e, "unknown statement: ", c
    of StmtsS:
      if mode == TraverseTopLevel:
        inc c
        while c.kind notin {EofToken, ParRi}:
          traverseStmt e, c, mode
        skipParRi e, c
      else:
        e.dest.add c
        inc c
        e.loop c:
          traverseStmt e, c, mode
    of ScopeS:
      e.openMangleScope()
      if mode == TraverseTopLevel:
        inc c
        while c.kind notin {EofToken, ParRi}:
          traverseStmt e, c, mode
        skipParRi e, c
      else:
        e.dest.add c
        inc c
        e.loop c:
          traverseStmt e, c, mode
      e.closeMangleScope()
    of VarS, LetS, CursorS, ResultS:
      traverseLocal e, c, (if e.nestedIn[^1][0] == StmtsS and mode in {TraverseTopLevel, TraverseSig}: "gvar" else: "var"), mode
    of ConstS:
      traverseLocal e, c, "const", mode
    of CmdS, CallS:
      e.dest.add tagToken("call", c.info)
      inc c
      e.loop c:
        traverseExpr e, c
    of EmitS, AsgnS, RetS:
      e.dest.add c
      inc c
      e.loop c:
        traverseExpr e, c
    of DiscardS:
      let discardToken = c
      inc c
      if c.kind == DotToken:
        # eliminates discard without side effects
        inc c
        skipParRi e, c
      else:
        e.dest.add discardToken
        traverseExpr e, c
        wantParRi e, c
    of BreakS: traverseBreak e, c
    of WhileS: traverseWhile e, c
    of BlockS: traverseBlock e, c
    of IfS: traverseIf e, c
    of CaseS: traverseCase e, c
    of YieldS, ForS:
      error e, "BUG: not eliminated: ", c
    of TryS, RaiseS:
      error e, "BUG: not implemented: ", c
    of FuncS, ProcS, ConverterS, MethodS:
      traverseProc e, c, mode
    of MacroS, TemplateS, IncludeS, ImportS, FromImportS, ImportExceptS, ExportS, CommentS, IterS:
      # pure compile-time construct, ignore:
      skip c
    of TypeS:
      traverseTypeDecl e, c
    of ContinueS, WhenS, ClonerS, TracerS, DisarmerS, MoverS, DtorS:
      error e, "unreachable: ", c
    of PragmasLineS:
      skip c
  else:
    error e, "statement expected, but got: ", c

proc importSymbol(e: var EContext; s: SymId) =
  let res = tryLoadSym(s)
  if res.status == LacksNothing:
    var c = res.decl
    e.dest.add tagToken("imp", c.info)
    traverseStmt e, c, TraverseSig
    e.dest.addDotToken()
    e.dest.addParRi()
  else:
    error e, "could not find symbol: " & pool.syms[s]

proc writeOutput(e: var EContext) =
  var b = nifbuilder.open(e.dir / e.main & ".c.nif")
  b.addHeader "hexer", "nifc"
  b.addTree "stmts"
  for h in e.headers:
    b.withTree "incl":
      b.addStrLit pool.strings[h]

  var c = beginRead(e.dest)
  var ownerStack = @[(SymId(0), -1)]

  var stack: seq[PackedLineInfo] = @[]
  var nested = 0
  var nextIsOwner = -1
  for n in 0 ..< e.dest.len:
    let info = c.info
    if info.isValid:
      var (file, line, col) = unpack(pool.man, info)
      var fileAsStr = ""
      if stack.len > 0:
        let (pfile, pline, pcol) = unpack(pool.man, stack[^1])
        line = line - pline
        col = col - pcol
        if file != pfile: fileAsStr = pool.files[file]
      b.addLineInfo(col, line, fileAsStr)

    case c.kind
    of DotToken:
      b.addEmpty()
    of Ident:
      b.addIdent(pool.strings[c.litId])
    of Symbol:
      let owner = ownerStack[^1][0]
      let val = e.maybeMangle(c.symId)
      if val.len > 0:
        b.addSymbol(val)
      else:
        b.addSymbol(pool.syms[c.symId])
    of SymbolDef:
      let owner = ownerStack[^1][0]
      let val = e.maybeMangle(c.symId)
      if val.len > 0:
        b.addSymbolDef(val)
      else:
        b.addSymbolDef(pool.syms[c.symId])
      if nextIsOwner >= 0:
        ownerStack.add (c.symId, nextIsOwner)
        nextIsOwner = -1
    of IntLit:
      b.addIntLit(pool.integers[c.intId])
    of UIntLit:
      b.addUIntLit(pool.uintegers[c.uintId])
    of FloatLit:
      b.addFloatLit(pool.floats[c.floatId])
    of CharLit:
      b.addCharLit char(c.uoperand)
    of StringLit:
      b.addStrLit(pool.strings[c.litId])
    of UnknownToken:
      b.addIdent "<unknown token>"
    of EofToken:
      b.addIntLit c.soperand
    of ParRi:
      discard stack.pop()
      b.endTree()
      if nested > 0: dec nested
      if ownerStack[^1][1] == nested:
        discard ownerStack.pop()
    of ParLe:
      let tag = pool.tags[c.tagId]
      if tag == "proc" or tag == "type":
        nextIsOwner = nested
      b.addTree(tag)
      stack.add info
      inc nested
    inc c

  b.endTree()
  b.close()


proc expand*(infile: string) =
  let (dir, file, ext) = splitModulePath(infile)
  var e = EContext(dir: (if dir.len == 0: getCurrentDir() else: dir), ext: ext, main: file,
    dest: createTokenBuf(),
    nestedIn: @[(StmtsS, SymId(0))],
    typeCache: createTypeCache())
  e.openMangleScope()

  var c0 = setupProgram(infile, infile.changeFileExt ".c.nif", true)
  var dest = transform(e, c0, file)

  var c = beginRead(dest)

  if stmtKind(c) == StmtsS:
    inc c
    genStringType e, c.info
    while c.kind != ParRi:
      traverseStmt e, c, TraverseTopLevel
    e.dest.add e.pending
  else:
    error e, "expected (stmts) but got: ", c

  # fix point expansion:
  var i = 0
  while i < e.requires.len:
    let imp = e.requires[i]
    if not e.declared.contains(imp):
      importSymbol(e, imp)
    inc i
  skipParRi e, c
  writeOutput e
  e.closeMangleScope()

when isMainModule:
  echo splitModulePath("/abc/def/name.4.nif")