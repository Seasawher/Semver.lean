/-! lib for String operation -/

namespace String

/-- determines whether the string contains the given string and returns its index -/
def findWhere (line : String) (tgt : String) : Option Nat := Id.run do
  let mut rest := line
  for i in [0 : line.length - tgt.length + 1] do
    if rest.startsWith tgt then
      return some i
    rest := rest.drop 1
  return none

#guard findWhere "hello" "ell" = some 1
#guard findWhere "hello" "ele" = none

/-- count how many times a given Charcter appears in a String -/
def countChar (haystack : String) (needle : Char) : Nat :=
  haystack.foldl (fun count c => if c == needle then count + 1 else count) 0

#guard countChar "hello" 'l' = 2
#guard countChar "hello" 'a' = 0

end String
