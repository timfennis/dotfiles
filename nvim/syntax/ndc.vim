if exists('b:current_syntax')
  finish
endif

syntax case match

syntax keyword Keyword if else fn while for return in
syn keyword Function read_file print
syn match Number "\<[0-9]\+\>\|\<[0-9][0-9_]\+\>"
syn match Operator ":=\|[:+-/^%!*=]\+"
syn region String start='"' end ='"' 
syn region Comment  start='//' end='$'
let b:current_syntax = 'andy-cpp'
