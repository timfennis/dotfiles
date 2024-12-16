if exists('b:current_syntax')
  finish
endif

syntax case match

syntax keyword Keyword if else fn while for return in not and or break let continue pure
syn keyword Function read_file print
syn match Number "\<[0-9]\+\>\|\<[0-9][0-9_]\+\|true\|false\>"
syn match Operator ":=\|[:+-/^%!*=<>]\+"
syn match ndcEmbedded /\\[\\"'ntbrf]/ contained
syn match ndcEmbedded /\\'/ contained
hi def link noulithEmbedded Identifier
syn region String start='"' end ='"' contains=ndcEmbedded
syn region Comment  start='//' end='$'

let b:current_syntax = 'andy-cpp'
