" Vim syntax file
" Language:     QML
" Maintainer:   Peter Hoeg <peter@hoeg.com>
" Updaters:     Refer to CONTRIBUTORS.md
" URL:          https://github.com/peterhoeg/vim-qml
" Changes:      `git log` is your friend
" Last Change:  2021-03-17
"
" This file is bassed on the original work done by Warwick Allison
" <warwick.allison@nokia.com> whose did about 99% of the work here.

" Based on javascript syntax (as is QML)

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'qml'
endif

" Drop fold if it set but vim doesn't support it.
if version < 600 && exists("qml_fold")
  unlet qml_fold
endif

syn case match

syn cluster qmlExpr              contains=qmlStringD,qmlStringS,qmlStringT,SqmlCharacter,qmlNumber,qmlBoolean,qmlBasicType,qmlJsType,qmlAliasType,qmlNull,qmlGlobal,qmlFunction,qmlArrowFunction
syn keyword qmlCommentTodo       TODO FIXME XXX TBD contained
syn match   qmlLineComment       "\/\/.*" contains=@Spell,qmlCommentTodo
syn match   qmlCommentSkip       "^[ \t]*\*\($\|[ \t]\+\)"
syn region  qmlComment           start="/\*"  end="\*/" contains=@Spell,qmlCommentTodo fold
syn match   qmlSpecial           "\\\d\d\d\|\\."
syn region  qmlStringD           start=+"+  skip=+\\\\\|\\"\|\\$+  end=+"+  keepend  contains=qmlSpecial,@htmlPreproc,@Spell
syn region  qmlStringS           start=+'+  skip=+\\\\\|\\'\|\\$+  end=+'+  keepend  contains=qmlSpecial,@htmlPreproc,@Spell
syn region  qmlStringT           start=+`+  skip=+\\\\\|\\`\|\\$+  end=+`+  keepend  contains=qmlTemplateExpr,qmlSpecial,@htmlPreproc,@Spell

syntax region  qmlTemplateExpr contained  matchgroup=qmlBraces start=+${+ end=+}+  keepend  contains=@qmlExpr

syn match   qmlCharacter         "'\\.'"
syn match   qmlNumber            "-\=\<\d\+L\=\>\|0[xX][0-9a-fA-F]\+\>"
syn region  qmlRegexpString      start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gi]\{0,2\}\s*$+ end=+/[gi]\{0,2\}\s*[;.,)\]}]+me=e-1 contains=@htmlPreproc oneline
syn match   qmlObjectDefinition  "\<\(\u\i*\.\)*\u\i*\(\s*{\|\s\+on\s\+\)\@=" nextgroup=qmlPropModifierOn
syn match   qmlPropModifierOn    "\s\+on\s\+" contained nextgroup=qmlPropModifierTarget
syn match   qmlPropModifierTarget "\<\(\u\i*\.\)*[_a-z]\i*\s*\({\)\@=" contained
syn region  qmlTernaryColon   start="?" end=":" contains=@qmlExpr,qmlBraces,qmlParens
syn keyword qmlProperty          property nextgroup=qmlPropertyType
syn match   qmlPropertyType      "\s\+\(list<\I\(\i\|\.\)*>\|\I\(\i\|\.\)*\)" contained contains=qmlBasicType,qmlAliasType,qmlPropertyBracket nextgroup=qmlPropertyName
syn match   qmlPropertyBracket   "[<>]" contained
syn match   qmlPropertyName      "\s\+[_a-z]\i*:\=" contained
syn match   qmlBindingProperty   "\<\(\I\i*\.\)*[_a-z]\i*\s*:"
syn match   qmlSlotDefinition    "\<\(\I\i*\.\)*on\i*\s*:"
syn match   qmlObjectId          "\<\(id\|name\)\s*:"
syn match   qmlGroupProperty     "\<\(\u\i*\.\)*[_a-z]\i*\s*\({\)\@="

syn keyword qmlConditional       if else switch
syn keyword qmlRepeat            while for do in
syn keyword qmlBranch            break continue
syn keyword qmlOperator          new delete instanceof typeof
syn keyword qmlAliasType         alias
syn keyword qmlStatement         return with
syn keyword qmlBoolean           true false
syn keyword qmlNull              null undefined
syn keyword qmlIdentifier        arguments this var let const
syn keyword qmlLabel             case default
syn keyword qmlException         try catch finally throw
syn keyword qmlMessage           alert confirm prompt status
syn keyword qmlDeclaration       signal component readonly required enum
syn keyword qmlDirective         import pragma

" List extracted in alphabatical order from: https://doc.qt.io/qt-5/qmlbasictypes.html
" Qt v5.15.1

" Basic Types {{{

let basicTypes = [ "bool",
                 \ "color",
                 \ "coordinate",
                 \ "date",
                 \ "double",
                 \ "enumeration",
                 \ "font",
                 \ "geocircle",
                 \ "geopath",
                 \ "geopolygon",
                 \ "georectangle",
                 \ "geoshape",
                 \ "int",
                 \ "list",
                 \ "matrix4x4",
                 \ "palette",
                 \ "point",
                 \ "quaternion",
                 \ "real",
                 \ "rect",
                 \ "size",
                 \ "string",
                 \ "url",
                 \ "var",
                 \ "variant",
                 \ "vector2d",
                 \ "vector3d",
                 \ "vector4d" ]

exec "syntax match qmlBasicType \"\\.\\@<!\\<\\(".join(basicTypes, "\\|")."\\)\\>[:.]\\@!\""

" }}}

" List extracted in alphabatical order from: https://doc.qt.io/qt-5/qtqml-javascript-functionlist.html
" Qt v5.15.1

" JavaScript Types {{{

syn keyword qmlJsType Array
syn keyword qmlJsType ArrayBuffer
syn keyword qmlJsType Boolean
syn keyword qmlJsType DataView
syn keyword qmlJsType Date
syn keyword qmlJsType Error
syn keyword qmlJsType EvalError
syn keyword qmlJsType Function
syn keyword qmlJsType Map
syn keyword qmlJsType Number
syn keyword qmlJsType Object
syn keyword qmlJsType Promise
syn keyword qmlJsType RangeError
syn keyword qmlJsType ReferenceError
syn keyword qmlJsType RegExp
syn keyword qmlJsType Set
syn keyword qmlJsType SharedArrayBuffer
syn keyword qmlJsType String
syn keyword qmlJsType Symbol
syn keyword qmlJsType SyntaxError
syn keyword qmlJsType TypeError
syn keyword qmlJsType URIError
syn keyword qmlJsType WeakMap
syn keyword qmlJsType WeakSet

" }}}

if get(g:, 'qml_fold', 0)
  syn match   qmlFunction      "\<function\>"
  syn region  qmlFunctionFold  start="\<function\>.*[^};]$" end="^\z1}.*$" transparent fold keepend

  syn sync match qmlSync  grouphere qmlFunctionFold "\<function\>"
  syn sync match qmlSync  grouphere NONE "^}"

  setlocal foldmethod=syntax
  setlocal foldtext=getline(v:foldstart)
else
  syn keyword qmlFunction         function
  syn match   qmlArrowFunction    "=>"
  syn match   qmlBraces           "[{}\[\]]"
  syn match   qmlParens           "[()]"
endif

syn sync fromstart
syn sync maxlines=100

if main_syntax == "qml"
  syn sync ccomment qmlComment
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_qml_syn_inits")
  if version < 508
    let did_qml_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink qmlComment           Comment
  HiLink qmlLineComment       Comment
  HiLink qmlCommentTodo       Todo
  HiLink qmlSpecial           Special
  HiLink qmlStringS           String
  HiLink qmlStringD           String
  HiLink qmlStringT           String
  HiLink qmlCharacter         Character
  HiLink qmlNumber            Number
  HiLink qmlConditional       Conditional
  HiLink qmlRepeat            Repeat
  HiLink qmlBranch            Conditional
  HiLink qmlOperator          Operator
  HiLink qmlBasicType         Type
  HiLink qmlJsType            Type
  HiLink qmlAliasType         Type
  HiLink qmlObjectDefinition  Type
  HiLink qmlPropModifierOn    Function
  HiLink qmlPropModifierTarget Label
  HiLink qmlStatement         Statement
  HiLink qmlFunction          Function
  HiLink qmlArrowFunction     Function
  HiLink qmlBraces            Function
  HiLink qmlError             Error
  HiLink qmlNull              Keyword
  HiLink qmlBoolean           Boolean
  HiLink qmlRegexpString      String

  HiLink qmlIdentifier        Identifier
  HiLink qmlLabel             Label
  HiLink qmlException         Exception
  HiLink qmlMessage           Keyword
  HiLink qmlDirective         Statement
  HiLink qmlDebug             Debug
  HiLink qmlConstant          Label
  HiLink qmlProperty          Function
  HiLink qmlPropertyBracket   Function
  HiLink qmlPropertyName      Label
  HiLink qmlBindingProperty   Label
  HiLink qmlSlotDefinition    Special
  HiLink qmlObjectId          Identifier
  HiLink qmlGroupProperty     Label
  HiLink qmlDeclaration       Function

  delcommand HiLink
endif

let b:current_syntax = "qml"
if main_syntax == 'qml'
  unlet main_syntax
endif
