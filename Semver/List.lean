/-! lib for List operations -/

namespace List

/-- if lists contains no `none`, then return its internal values. -/
def allSome {α : Type} (xs : List (Option α)) : Option (List α) :=
  xs.foldr (fun x xs => match x, xs with
    | some x, some xs => some (x :: xs)
    | _, _ => none
  ) (some [])

#guard [some 1, some 2, some 3].allSome = some [1, 2, 3]
#guard [none, some 1, some 2].allSome = none

end List
