" Vim syntax file
" Language:     Fork
" Maintainer:   Simon Lassourreuille <slyces.coding@gmail.com>
" Last Change:  May 30, 2020

" DISCLAIMER:
" This syntax file is inspired by rust's syntax file
" > https://github.com/rust-lang/rust.vim

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

" Syntax definitions {{{1
" Basic keywords {{{2
syn keyword   forkExport export
syn keyword   forkConditional match if else
syn keyword   forkRepeat for loop while
syn keyword   forkTypedef type nextgroup=forkIdentifier skipwhite skipempty
syn keyword   forkStructure struct enum nextgroup=forkIdentifier skipwhite skipempty
syn keyword   forkUnion union nextgroup=forkIdentifier skipwhite skipempty contained
syn match forkUnionContextual /\<union\_s\+\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*/ transparent contains=forkUnion
syn keyword   forkOperator    as

syn match     forkAssert      "\<assert\(\w\)*!" contained
syn match     forkPanic       "\<panic\(\w\)*!" contained
syn keyword   forkKeyword     break
syn keyword   forkKeyword     box nextgroup=forkBoxPlacement skipwhite skipempty
syn keyword   forkKeyword     continue
syn keyword   forkKeyword     extern nextgroup=forkExternCrate,forkObsoleteExternMod skipwhite skipempty
syn keyword   forkKeyword     fun nextgroup=forkFuncName skipwhite skipempty
syn keyword   forkKeyword     in impl let
syn keyword   forkKeyword     pub nextgroup=forkPubScope skipwhite skipempty
syn keyword   forkKeyword     return
syn keyword   forkKeyword     expose package
syn keyword   forkSuper       super
syn keyword   forkKeyword     unsafe where
syn keyword   forkKeyword     use nextgroup=forkModPath skipwhite skipempty

" FIXME: Scoped impl's name is also fallen in this category
syn keyword   forkKeyword     mod trait nextgroup=forkIdentifier skipwhite skipempty
syn keyword   forkStorage     move mut ref static const
syn match forkDefault /\<default\ze\_s\+\(impl\|fun\|type\|const\)\>/

syn keyword   forkInvalidBareKeyword crate

syn keyword forkPubScopeCrate crate contained
syn match forkPubScopeDelim /[()]/ contained
syn match forkPubScope /([^()]*)/ contained contains=forkPubScopeDelim,forkPubScopeCrate,forkSuper,forkModPath,forkModPathSep,forkSelf transparent

syn keyword   forkExternCrate crate contained nextgroup=forkIdentifier,forkExternCrateString skipwhite skipempty
" This is to get the `bar` part of `extern crate "foo" as bar;` highlighting.
syn match   forkExternCrateString /".*"\_s*as/ contained nextgroup=forkIdentifier skipwhite transparent skipempty contains=forkString,forkOperator
syn keyword   forkObsoleteExternMod mod contained nextgroup=forkIdentifier skipwhite skipempty

syn match     forkIdentifier  contains=forkIdentifierPrime "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained
syn match     forkFuncName    "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained

syn region    forkBoxPlacement matchgroup=forkBoxPlacementParens start="(" end=")" contains=TOP contained
" Ideally we'd have syntax rules set up to match arbitrary expressions. Since
" we don't, we'll just define temporary contained rules to handle balancing
" delimiters.
syn region    forkBoxPlacementBalance start="(" end=")" containedin=forkBoxPlacement transparent
syn region    forkBoxPlacementBalance start="\[" end="\]" containedin=forkBoxPlacement transparent
" {} are handled by forkFoldBraces

syn region forkMacroRepeat matchgroup=forkMacroRepeatDelimiters start="$(" end=")" contains=TOP nextgroup=forkMacroRepeatCount
syn match forkMacroRepeatCount ".\?[*+]" contained
syn match forkMacroVariable "$\w\+"

" Reserved (but not yet used) keywords {{{2
syn keyword   forkReservedKeyword alignof become do offsetof priv pure sizeof typeof unsized yield abstract virtual final override macro

" Built-in types {{{2
syn keyword   forkType        isize usize char bool u8 u16 u32 u64 u128 f32
syn keyword   forkType        f64 i8 i16 i32 i64 i128 str Self

" Things from the libstd v1 prelude (src/libstd/prelude/v1.rs) {{{2
" This section is just straight transformation of the contents of the prelude,
" to make it easy to update.

" Reexported core operators {{{3
syn keyword   forkTrait       Copy Send Sized Sync
syn keyword   forkTrait       Drop Fn FnMut FnOnce

" Reexported functions {{{3
" There’s no point in highlighting these; when one writes drop( or drop::< it
" gets the same highlighting anyway, and if someone writes `let drop = …;` we
" don’t really want *that* drop to be highlighted.
"syn keyword forkFunction drop

" Reexported types and traits {{{3
syn keyword forkTrait Box
syn keyword forkTrait ToOwned
syn keyword forkTrait Clone
syn keyword forkTrait PartialEq PartialOrd Eq Ord
syn keyword forkTrait AsRef AsMut Into From
syn keyword forkTrait Default
syn keyword forkTrait Iterator Extend IntoIterator
syn keyword forkTrait DoubleEndedIterator ExactSizeIterator
syn keyword forkEnum Option
syn keyword forkEnumVariant Some None
syn keyword forkEnum Result
syn keyword forkEnumVariant Ok Err
syn keyword forkTrait SliceConcatExt
syn keyword forkTrait String ToString
syn keyword forkTrait Vec

" Other syntax {{{2
syn keyword   forkSelf        self
syn keyword   forkBoolean     true false

" If foo::bar changes to foo.bar, change this ("::" to "\.").
" If foo::bar changes to Foo::bar, change this (first "\w" to "\u").
syn match     forkModPath     "\w\(\w\)*::[^<]"he=e-3,me=e-3
syn match     forkModPathSep  "::"

syn match     forkFuncCall    "\w\(\w\)*("he=e-1,me=e-1
syn match     forkFuncCall    "\w\(\w\)*::<"he=e-3,me=e-3 " foo::<T>();

" This is merely a convention; note also the use of [A-Z], restricting it to
" latin identifiers rather than the full Unicode uppercase. I have not used
" [:upper:] as it depends upon 'noignorecase'
"syn match     forkCapsIdent    display "[A-Z]\w\(\w\)*"

syn match     forkOperator     display "\%(+\|-\|/\|*\|=\|\^\|&\||\|!\|>\|<\|%\)=\?"
" This one isn't *quite* right, as we could have binary-& with a reference
syn match     forkSigil        display /&\s\+[&~@*][^)= \t\r\n]/he=e-1,me=e-1
syn match     forkSigil        display /[&~@*][^)= \t\r\n]/he=e-1,me=e-1
" This isn't actually correct; a closure with no arguments can be `|| { }`.
" Last, because the & in && isn't a sigil
syn match     forkOperator     display "&&\|||"
" This is forkArrowCharacter rather than forkArrow for the sake of matchparen,
" so it skips the ->; see http://stackoverflow.com/a/30309949 for details.
syn match     forkArrowCharacter display "->"
syn match     forkQuestionMark display "?\([a-zA-Z]\+\)\@!"

syn match     forkMacro       '\w\(\w\)*!' contains=forkAssert,forkPanic
syn match     forkMacro       '#\w\(\w\)*' contains=forkAssert,forkPanic

syn match     forkEscapeError   display contained /\\./
syn match     forkEscape        display contained /\\\([nrt0\\'"]\|x\x\{2}\)/
syn match     forkEscapeUnicode display contained /\\u{\x\{1,6}}/
syn match     forkStringContinuation display contained /\\\n\s*/
syn region    forkString      start=+b"+ skip=+\\\\\|\\"+ end=+"+ contains=forkEscape,forkEscapeError,forkStringContinuation
syn region    forkString      start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=forkEscape,forkEscapeUnicode,forkEscapeError,forkStringContinuation,@Spell
syn region    forkString      start='b\?r\z(#*\)"' end='"\z1' contains=@Spell

syn region    forkAttribute   start="#!\?\[" end="\]" contains=forkString,forkDerive,forkCommentLine,forkCommentBlock,forkCommentLineDocError,forkCommentBlockDocError
syn region    forkDerive      start="derive(" end=")" contained contains=forkDeriveTrait
" This list comes from src/libsyntax/ext/deriving/mod.rs
" Some are deprecated (Encodable, Decodable) or to be removed after a new snapshot (Show).
syn keyword   forkDeriveTrait contained Clone Hash RustcEncodable RustcDecodable Encodable Decodable PartialEq Eq PartialOrd Ord Rand Show Debug Default FromPrimitive Send Sync Copy

" Number literals
syn match     forkDecNumber   display "\<[0-9][0-9_]*\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
syn match     forkHexNumber   display "\<0x[a-fA-F0-9_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
syn match     forkOctNumber   display "\<0o[0-7_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
syn match     forkBinNumber   display "\<0b[01_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="

" Special case for numbers of the form "1." which are float literals, unless followed by
" an identifier, which makes them integer literals with a method call or field access,
" or by another ".", which makes them integer literals followed by the ".." token.
" (This must go first so the others take precedence.)
syn match     forkFloat       display "\<[0-9][0-9_]*\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\|\.\)\@!"
" To mark a number as a normal float, it must have at least one of the three things integral values don't have:
" a decimal point and more numbers; an exponent; and a type suffix.
syn match     forkFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)\="
syn match     forkFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\(f32\|f64\)\="
syn match     forkFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)"

" For the benefit of delimitMate
syn region forkLifetimeCandidate display start=/&'\%(\([^'\\]\|\\\(['nrt0\\\"]\|x\x\{2}\|u{\x\{1,6}}\)\)'\)\@!/ end=/[[:cntrl:][:space:][:punct:]]\@=\|$/ contains=forkSigil,forkLifetime
syn region forkGenericRegion display start=/<\%('\|[^[cntrl:][:space:][:punct:]]\)\@=')\S\@=/ end=/>/ contains=forkGenericLifetimeCandidate
syn region forkGenericLifetimeCandidate display start=/\%(<\|,\s*\)\@<='/ end=/[[:cntrl:][:space:][:punct:]]\@=\|$/ contains=forkSigil,forkLifetime

"forkLifetime must appear before forkCharacter, or chars will get the lifetime highlighting
syn match     forkLifetime    display "\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*"
syn match     forkLabel       display "\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*:"
syn match   forkCharacterInvalid   display contained /b\?'\zs[\n\r\t']\ze'/
" The groups negated here add up to 0-255 but nothing else (they do not seem to go beyond ASCII).
syn match   forkCharacterInvalidUnicode   display contained /b'\zs[^[:cntrl:][:graph:][:alnum:][:space:]]\ze'/
syn match   forkCharacter   /b'\([^\\]\|\\\(.\|x\x\{2}\)\)'/ contains=forkEscape,forkEscapeError,forkCharacterInvalid,forkCharacterInvalidUnicode
syn match   forkCharacter   /'\([^\\]\|\\\(.\|x\x\{2}\|u{\x\{1,6}}\)\)'/ contains=forkEscape,forkEscapeUnicode,forkEscapeError,forkCharacterInvalid

syn match forkShebang /\%^#![^[].*/
syn region forkCommentLine                                                  start="//"                      end="$"   contains=forkTodo,@Spell
syn region forkCommentLineDoc                                               start="//\%(//\@!\|!\)"         end="$"   contains=forkTodo,@Spell
syn region forkCommentLineDocError                                          start="//\%(//\@!\|!\)"         end="$"   contains=forkTodo,@Spell contained
syn region forkCommentBlock             matchgroup=forkCommentBlock         start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/" contains=forkTodo,forkCommentBlockNest,@Spell
syn region forkCommentBlockDoc          matchgroup=forkCommentBlockDoc      start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=forkTodo,forkCommentBlockDocNest,@Spell
syn region forkCommentBlockDocError     matchgroup=forkCommentBlockDocError start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=forkTodo,forkCommentBlockDocNestError,@Spell contained
syn region forkCommentBlockNest         matchgroup=forkCommentBlock         start="/\*"                     end="\*/" contains=forkTodo,forkCommentBlockNest,@Spell contained transparent
syn region forkCommentBlockDocNest      matchgroup=forkCommentBlockDoc      start="/\*"                     end="\*/" contains=forkTodo,forkCommentBlockDocNest,@Spell contained transparent
syn region forkCommentBlockDocNestError matchgroup=forkCommentBlockDocError start="/\*"                     end="\*/" contains=forkTodo,forkCommentBlockDocNestError,@Spell contained transparent
" FIXME: this is a really ugly and not fully correct implementation. Most
" importantly, a case like ``/* */*`` should have the final ``*`` not being in
" a comment, but in practice at present it leaves comments open two levels
" deep. But as long as you stay away from that particular case, I *believe*
" the highlighting is correct. Due to the way Vim's syntax engine works
" (greedy for start matches, unlike Rust's tokeniser which is searching for
" the earliest-starting match, start or end), I believe this cannot be solved.
" Oh you who would fix it, don't bother with things like duplicating the Block
" rules and putting ``\*\@<!`` at the start of them; it makes it worse, as
" then you must deal with cases like ``/*/**/*/``. And don't try making it
" worse with ``\%(/\@<!\*\)\@<!``, either...

syn keyword forkTodo contained TODO FIXME XXX NB NOTE

" Folding rules {{{2
" Trivial folding rules to begin with.
" FIXME: use the AST to make really good folding
syn region forkFoldBraces start="{" end="}" transparent fold

" Default highlighting {{{1
hi def link forkDecNumber       forkNumber
hi def link forkHexNumber       forkNumber
hi def link forkOctNumber       forkNumber
hi def link forkBinNumber       forkNumber
hi def link forkIdentifierPrime forkIdentifier
hi def link forkTrait           forkType
hi def link forkDeriveTrait     forkTrait

hi def link forkMacroRepeatCount   forkMacroRepeatDelimiters
hi def link forkMacroRepeatDelimiters   Macro
hi def link forkMacroVariable Define
hi def link forkSigil         StorageClass
hi def link forkEscape        Special
hi def link forkEscapeUnicode forkEscape
hi def link forkEscapeError   Error
hi def link forkStringContinuation Special
hi def link forkString        String
hi def link forkCharacterInvalid Error
hi def link forkCharacterInvalidUnicode forkCharacterInvalid
hi def link forkCharacter     Character
hi def link forkNumber        Number
hi def link forkBoolean       Boolean
hi def link forkEnum          forkType
hi def link forkEnumVariant   forkConstant
hi def link forkConstant      Constant
hi def link forkSelf          Constant
hi def link forkFloat         Float
hi def link forkArrowCharacter forkOperator
hi def link forkOperator      Operator
hi def link forkKeyword       Keyword
hi def link forkTypedef       Keyword " More precise is Typedef, but it doesn't feel right for Rust
hi def link forkStructure     Keyword " More precise is Structure
hi def link forkUnion         forkStructure
hi def link forkPubScopeDelim Delimiter
hi def link forkPubScopeCrate forkKeyword
hi def link forkSuper         forkKeyword
hi def link forkReservedKeyword Error
hi def link forkRepeat        Conditional
hi def link forkConditional   Conditional
hi def link forkExport        forkKeyword
hi def link forkIdentifier    Identifier
hi def link forkCapsIdent     forkIdentifier
hi def link forkModPath       Include
hi def link forkModPathSep    Delimiter
hi def link forkFunction      Function
hi def link forkFuncName      Function
hi def link forkFuncCall      Function
hi def link forkShebang       Comment
hi def link forkCommentLine   Comment
hi def link forkCommentLineDoc SpecialComment
hi def link forkCommentLineDocError Error
hi def link forkCommentBlock  forkCommentLine
hi def link forkCommentBlockDoc forkCommentLineDoc
hi def link forkCommentBlockDocError Error
hi def link forkAssert        PreCondit
hi def link forkPanic         PreCondit
hi def link forkMacro         Macro
hi def link forkType          Type
hi def link forkTodo          Todo
hi def link forkAttribute     PreProc
hi def link forkDerive        PreProc
hi def link forkDefault       StorageClass
hi def link forkStorage       StorageClass
hi def link forkObsoleteStorage Error
hi def link forkLifetime      Special
hi def link forkLabel         Label
hi def link forkInvalidBareKeyword Error
hi def link forkExternCrate   forkKeyword
hi def link forkObsoleteExternMod Error
hi def link forkBoxPlacementParens Delimiter
hi def link forkQuestionMark  Special

" Other Suggestions:
" hi forkAttribute ctermfg=cyan
" hi forkDerive ctermfg=cyan
" hi forkAssert ctermfg=yellow
" hi forkPanic ctermfg=red
" hi forkMacro ctermfg=magenta

syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = "fork"

