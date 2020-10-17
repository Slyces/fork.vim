" Vim syntax file
" Language:     Zephyr
" Maintainer:   Simon Lassourreuille <slyces.coding@gmail.com>
" Last Change:  Oct 13, 2020

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
syn keyword   zephyrExport export
" 'else' not yet implemented
syn keyword   zephyrConditional if
syn keyword   zephyrRepeat while
" syn keyword   zephyrTypedef type nextgroup=zephyrIdentifier skipwhite skipempty
" syn keyword   zephyrStructure struct enum nextgroup=zephyrIdentifier skipwhite skipempty
" syn keyword   zephyrUnion union nextgroup=zephyrIdentifier skipwhite skipempty contained
" syn match zephyrUnionContextual /\<union\_s\+\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*/ transparent contains=zephyrUnion
" syn keyword   zephyrOperator    as

" syn match     zephyrAssert      "\<assert\(\w\)*!" contained
" syn match     zephyrPanic       "\<panic\(\w\)*!" contained
" syn keyword   zephyrKeyword     break
" syn keyword   zephyrKeyword     box nextgroup=zephyrBoxPlacement skipwhite skipempty
" syn keyword   zephyrKeyword     continue
" syn keyword   zephyrKeyword     extern nextgroup=zephyrExternCrate,zephyrObsoleteExternMod skipwhite skipempty
syn keyword   zephyrKeyword     fun nextgroup=zephyrFuncName skipwhite skipempty
syn keyword   zephyrKeyword     let
syn keyword   zephyrKeyword     pub nextgroup=zephyrPubScope skipwhite skipempty
syn keyword   zephyrKeyword     return
syn keyword   zephyrKeyword     expose package
syn keyword   zephyrKeyword     as
" syn keyword   zephyrSuper       super
" syn keyword   zephyrKeyword     unsafe where
syn keyword   zephyrKeyword     use nextgroup=zephyrModPath skipwhite skipempty

" FIXME: Scoped impl's name is also fallen in this category
" syn keyword   zephyrKeyword     mod trait nextgroup=zephyrIdentifier skipwhite skipempty
" syn keyword   zephyrStorage     move mut ref static const
" syn match zephyrDefault /\<default\ze\_s\+\(impl\|fun\|type\|const\)\>/

" syn keyword   zephyrInvalidBareKeyword crate

" syn keyword zephyrPubScopeCrate crate contained
syn match zephyrPubScopeDelim /[()]/ contained
syn match zephyrPubScope /([^()]*)/ contained contains=zephyrPubScopeDelim, transparent

" syn keyword   zephyrExternCrate crate contained nextgroup=zephyrIdentifier,zephyrExternCrateString skipwhite skipempty
" This is to get the `bar` part of `extern crate "foo" as bar;` highlighting.
syn match   zephyrExternCrateString /".*"\_s*as/ contained nextgroup=zephyrIdentifier skipwhite transparent skipempty contains=zephyrString,zephyrOperator

syn match     zephyrIdentifier  contains=zephyrIdentifierPrime "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained
syn match     zephyrFuncName    "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained

syn region    zephyrBoxPlacement matchgroup=zephyrBoxPlacementParens start="(" end=")" contains=TOP contained
" Ideally we'd have syntax rules set up to match arbitrary expressions. Since
" we don't, we'll just define temporary contained rules to handle balancing
" delimiters.
syn region    zephyrBoxPlacementBalance start="(" end=")" containedin=zephyrBoxPlacement transparent
syn region    zephyrBoxPlacementBalance start="\[" end="\]" containedin=zephyrBoxPlacement transparent
" {} are handled by zephyrFoldBraces

" syn region zephyrMacroRepeat matchgroup=zephyrMacroRepeatDelimiters start="$(" end=")" contains=TOP nextgroup=zephyrMacroRepeatCount
" syn match zephyrMacroRepeatCount ".\?[*+]" contained
" syn match zephyrMacroVariable "$\w\+"

" Reserved (but not yet used) keywords {{{2
syn keyword   zephyrReservedKeyword as priv sizeof typeof yield abstract virtual final override macro

" Built-in types {{{2
syn keyword   zephyrType        f32 f64 i32 i64 bool

" Things from the libstd v1 prelude (src/libstd/prelude/v1.rs) {{{2
" This section is just straight transformation of the contents of the prelude,
" to make it easy to update.

" Reexported core operators {{{3
" syn keyword   zephyrTrait       Copy Send Sized Sync
" syn keyword   zephyrTrait       Drop Fn FnMut FnOnce

" Reexported functions {{{3
" There’s no point in highlighting these; when one writes drop( or drop::< it
" gets the same highlighting anyway, and if someone writes `let drop = …;` we
" don’t really want *that* drop to be highlighted.
" syn keyword zephyrFunction drop

" Reexported types and traits {{{3
" syn keyword zephyrTrait Box
" syn keyword zephyrTrait ToOwned
" syn keyword zephyrTrait Clone
" syn keyword zephyrTrait PartialEq PartialOrd Eq Ord
" syn keyword zephyrTrait AsRef AsMut Into From
" syn keyword zephyrTrait Default
" syn keyword zephyrTrait Iterator Extend IntoIterator
" syn keyword zephyrTrait DoubleEndedIterator ExactSizeIterator
" syn keyword zephyrEnum Option
" syn keyword zephyrEnumVariant Some None
" syn keyword zephyrEnum Result
" syn keyword zephyrEnumVariant Ok Err
" syn keyword zephyrTrait SliceConcatExt
" syn keyword zephyrTrait String ToString
" syn keyword zephyrTrait Vec

" Other syntax {{{2
" syn keyword   zephyrSelf        self
syn keyword   zephyrBoolean     true false

" If foo::bar changes to foo.bar, change this ("::" to "\.").
" If foo::bar changes to Foo::bar, change this (first "\w" to "\u").
" syn match     zephyrModPath     "\w\(\w\)*::[^<]"he=e-3,me=e-3
" syn match     zephyrModPathSep  "::"

syn match     zephyrFuncCall    "\w\(\w\)*("he=e-1,me=e-1
syn match     zephyrFuncCall    "\w\(\w\)*::<"he=e-3,me=e-3 " foo::<T>();

" This is merely a convention; note also the use of [A-Z], restricting it to
" latin identifiers rather than the full Unicode uppercase. I have not used
" [:upper:] as it depends upon 'noignorecase'
"syn match     zephyrCapsIdent    display "[A-Z]\w\(\w\)*"

syn match     zephyrOperator     display "\%(+\|-\|/\|*\|=\|\^\|&\||\|!\|>\|<\|%\)=\?"
" This one isn't *quite* right, as we could have binary-& with a reference
syn match     zephyrSigil        display /&\s\+[&~@*][^)= \t\r\n]/he=e-1,me=e-1
syn match     zephyrSigil        display /[&~@*][^)= \t\r\n]/he=e-1,me=e-1
" This isn't actually correct; a closure with no arguments can be `|| { }`.
" Last, because the & in && isn't a sigil
syn match     zephyrOperator     display "&&\|||"
" This is zephyrArrowCharacter rather than zephyrArrow for the sake of matchparen,
" so it skips the ->; see http://stackoverflow.com/a/30309949 for details.
" syn match     zephyrArrowCharacter display "->"
" syn match     zephyrQuestionMark display "?\([a-zA-Z]\+\)\@!"

" syn match     zephyrMacro       '\w\(\w\)*!' contains=zephyrAssert,zephyrPanic
" syn match     zephyrMacro       '#\w\(\w\)*' contains=zephyrAssert,zephyrPanic

syn match     zephyrEscapeError   display contained /\\./
syn match     zephyrEscape        display contained /\\\([nrt0\\'"]\|x\x\{2}\)/
syn match     zephyrEscapeUnicode display contained /\\u{\x\{1,6}}/
syn match     zephyrStringContinuation display contained /\\\n\s*/
syn region    zephyrString      start=+b"+ skip=+\\\\\|\\"+ end=+"+ contains=zephyrEscape,zephyrEscapeError,zephyrStringContinuation
syn region    zephyrString      start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=zephyrEscape,zephyrEscapeUnicode,zephyrEscapeError,zephyrStringContinuation,@Spell
syn region    zephyrString      start='b\?r\z(#*\)"' end='"\z1' contains=@Spell

syn region    zephyrAttribute   start="#!\?\[" end="\]" contains=zephyrString,zephyrDerive,zephyrCommentLine,zephyrCommentBlock,zephyrCommentLineDocError,zephyrCommentBlockDocError
syn region    zephyrDerive      start="derive(" end=")" contained contains=zephyrDeriveTrait
" This list comes from src/libsyntax/ext/deriving/mod.rs
" Some are deprecated (Encodable, Decodable) or to be removed after a new snapshot (Show).
syn keyword   zephyrDeriveTrait contained Clone Hash RustcEncodable RustcDecodable Encodable Decodable PartialEq Eq PartialOrd Ord Rand Show Debug Default FromPrimitive Send Sync Copy

" Number literals
" syn match     zephyrDecNumber   display "\<[0-9][0-9_]*\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
" syn match     zephyrHexNumber   display "\<0x[a-fA-F0-9_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
" syn match     zephyrOctNumber   display "\<0o[0-7_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
" syn match     zephyrBinNumber   display "\<0b[01_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="

" Special case for numbers of the form "1." which are float literals, unless followed by
" an identifier, which makes them integer literals with a method call or field access,
" or by another ".", which makes them integer literals followed by the ".." token.
" (This must go first so the others take precedence.)
syn match     zephyrFloat       display "\<[0-9][0-9_]*\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\|\.\)\@!"
" To mark a number as a normal float, it must have at least one of the three things integral values don't have:
" a decimal point and more numbers; an exponent; and a type suffix.
syn match     zephyrFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)\="
syn match     zephyrFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\(f32\|f64\)\="
syn match     zephyrFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)"

" For the benefit of delimitMate
syn region zephyrLifetimeCandidate display start=/&'\%(\([^'\\]\|\\\(['nrt0\\\"]\|x\x\{2}\|u{\x\{1,6}}\)\)'\)\@!/ end=/[[:cntrl:][:space:][:punct:]]\@=\|$/ contains=zephyrSigil,zephyrLifetime
syn region zephyrGenericRegion display start=/<\%('\|[^[cntrl:][:space:][:punct:]]\)\@=')\S\@=/ end=/>/ contains=zephyrGenericLifetimeCandidate
syn region zephyrGenericLifetimeCandidate display start=/\%(<\|,\s*\)\@<='/ end=/[[:cntrl:][:space:][:punct:]]\@=\|$/ contains=zephyrSigil,zephyrLifetime

"zephyrLifetime must appear before zephyrCharacter, or chars will get the lifetime highlighting
" syn match     zephyrLifetime    display "\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*"
" syn match     zephyrLabel       display "\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*:"
syn match   zephyrCharacterInvalid   display contained /b\?'\zs[\n\r\t']\ze'/
" The groups negated here add up to 0-255 but nothing else (they do not seem to go beyond ASCII).
syn match   zephyrCharacterInvalidUnicode   display contained /b'\zs[^[:cntrl:][:graph:][:alnum:][:space:]]\ze'/
syn match   zephyrCharacter   /b'\([^\\]\|\\\(.\|x\x\{2}\)\)'/ contains=zephyrEscape,zephyrEscapeError,zephyrCharacterInvalid,zephyrCharacterInvalidUnicode
syn match   zephyrCharacter   /'\([^\\]\|\\\(.\|x\x\{2}\|u{\x\{1,6}}\)\)'/ contains=zephyrEscape,zephyrEscapeUnicode,zephyrEscapeError,zephyrCharacterInvalid

" syn match zephyrShebang /\%^#![^[].*/
syn region zephyrCommentLine                                                  start="//"                      end="$"   contains=zephyrTodo,@Spell
syn region zephyrCommentLineDoc                                               start="//\%(//\@!\|!\)"         end="$"   contains=zephyrTodo,@Spell
syn region zephyrCommentLineDocError                                          start="//\%(//\@!\|!\)"         end="$"   contains=zephyrTodo,@Spell contained
syn region zephyrCommentBlock             matchgroup=zephyrCommentBlock         start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/" contains=zephyrTodo,zephyrCommentBlockNest,@Spell
syn region zephyrCommentBlockDoc          matchgroup=zephyrCommentBlockDoc      start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=zephyrTodo,zephyrCommentBlockDocNest,@Spell
syn region zephyrCommentBlockDocError     matchgroup=zephyrCommentBlockDocError start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=zephyrTodo,zephyrCommentBlockDocNestError,@Spell contained
syn region zephyrCommentBlockNest         matchgroup=zephyrCommentBlock         start="/\*"                     end="\*/" contains=zephyrTodo,zephyrCommentBlockNest,@Spell contained transparent
syn region zephyrCommentBlockDocNest      matchgroup=zephyrCommentBlockDoc      start="/\*"                     end="\*/" contains=zephyrTodo,zephyrCommentBlockDocNest,@Spell contained transparent
syn region zephyrCommentBlockDocNestError matchgroup=zephyrCommentBlockDocError start="/\*"                     end="\*/" contains=zephyrTodo,zephyrCommentBlockDocNestError,@Spell contained transparent
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

syn keyword zephyrTodo contained TODO FIXME XXX NB NOTE

" Folding rules {{{2
" Trivial folding rules to begin with.
" FIXME: use the AST to make really good folding
syn region zephyrFoldBraces start="{" end="}" transparent fold

" Default highlighting {{{1
hi def link zephyrDecNumber       zephyrNumber
hi def link zephyrHexNumber       zephyrNumber
hi def link zephyrOctNumber       zephyrNumber
hi def link zephyrBinNumber       zephyrNumber
hi def link zephyrIdentifierPrime zephyrIdentifier
" hi def link zephyrTrait           zephyrType
" hi def link zephyrDeriveTrait     zephyrTrait

" hi def link zephyrMacroRepeatCount   zephyrMacroRepeatDelimiters
" hi def link zephyrMacroRepeatDelimiters   Macro
" hi def link zephyrMacroVariable Define
hi def link zephyrSigil         StorageClass
hi def link zephyrEscape        Special
hi def link zephyrEscapeUnicode zephyrEscape
hi def link zephyrEscapeError   Error
hi def link zephyrStringContinuation Special
hi def link zephyrString        String
hi def link zephyrCharacterInvalid Error
hi def link zephyrCharacterInvalidUnicode zephyrCharacterInvalid
hi def link zephyrCharacter     Character
hi def link zephyrNumber        Number
hi def link zephyrBoolean       Boolean
" hi def link zephyrEnum          zephyrType
" hi def link zephyrEnumVariant   zephyrConstant
" hi def link zephyrConstant      Constant
" hi def link zephyrSelf          Constant
hi def link zephyrFloat         Float
hi def link zephyrArrowCharacter zephyrOperator
hi def link zephyrOperator      Operator
hi def link zephyrKeyword       Keyword
hi def link zephyrTypedef       Keyword " More precise is Typedef, but it doesn't feel right for Rust
hi def link zephyrStructure     Keyword " More precise is Structure
" hi def link zephyrUnion         zephyrStructure
" hi def link zephyrPubScopeDelim Delimiter
" hi def link zephyrPubScopeCrate zephyrKeyword
" hi def link zephyrSuper         zephyrKeyword
" hi def link zephyrReservedKeyword Error
hi def link zephyrRepeat        Conditional
hi def link zephyrConditional   Conditional
hi def link zephyrExport        zephyrKeyword
hi def link zephyrIdentifier    Identifier
hi def link zephyrCapsIdent     zephyrIdentifier
" hi def link zephyrModPath       Include
" hi def link zephyrModPathSep    Delimiter
hi def link zephyrFunction      Function
hi def link zephyrFuncName      Function
hi def link zephyrFuncCall      Function
" hi def link zephyrShebang       Comment
hi def link zephyrCommentLine   Comment
hi def link zephyrCommentLineDoc SpecialComment
hi def link zephyrCommentLineDocError Error
hi def link zephyrCommentBlock  zephyrCommentLine
hi def link zephyrCommentBlockDoc zephyrCommentLineDoc
hi def link zephyrCommentBlockDocError Error
" hi def link zephyrAssert        PreCondit
" hi def link zephyrPanic         PreCondit
" hi def link zephyrMacro         Macro
hi def link zephyrType          Type
hi def link zephyrTodo          Todo
hi def link zephyrAttribute     PreProc
" hi def link zephyrDerive        PreProc
" hi def link zephyrDefault       StorageClass
" hi def link zephyrStorage       StorageClass
" hi def link zephyrObsoleteStorage Error
" hi def link zephyrLifetime      Special
" hi def link zephyrLabel         Label
" hi def link zephyrInvalidBareKeyword Error
" hi def link zephyrExternCrate   zephyrKeyword
" hi def link zephyrObsoleteExternMod Error
" hi def link zephyrBoxPlacementParens Delimiter
" hi def link zephyrQuestionMark  Special

" Other Suggestions:
" hi zephyrAttribute ctermfg=cyan
" hi zephyrDerive ctermfg=cyan
" hi zephyrAssert ctermfg=yellow
" hi zephyrPanic ctermfg=red
" hi zephyrMacro ctermfg=magenta

syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = "zephyr"

