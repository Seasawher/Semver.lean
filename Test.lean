def main : IO UInt32 := do
  let actual ← IO.FS.readFile ⟨s!"Test/output/case1.txt"⟩
  let expected ← IO.FS.readFile ⟨s!"Test/expected/case1.txt"⟩
  if actual != expected then
    IO.println s!"error: test fails. expected: {expected}, actual: {actual}"
    return 1
  return 0
