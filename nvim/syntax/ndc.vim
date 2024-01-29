if exists('b:current_syntax')
  finish
endif

syntax case match

syntax keyword Keyword print if else fn while
syn match Number "[0-9]\+"
syn match Operator "(:=)\|[:+-/^%!*=]\+"
syn region String start='"' end ='"' 
syn region Comment  start='//' end='$'
let b:current_syntax = 'andy-cpp'
