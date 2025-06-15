import std/assertions

const a = {'a', 'b'}
const b = {'0', '1'} + {'8', '9'}
assert b == {'0', '1', '8', '9'}

const c = a + {'x'}
assert c == {'a', 'b', 'x'}
