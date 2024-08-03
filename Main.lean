import Semver

set_option autoImplicit false

open IO FS System

def main (args : List String) : IO UInt32 := do
  if args.length != 2 then
    eprintln "usage: semver <input file> <output file>"
    return 1

  let input := args[0]!
  let output := args[1]!

  let contents := (← lines input).map (fun line => line.replace "\r" "")
  let semvers := contents.filterMap Semver.parse
  let latest := semvers.getMax? (· ≤ ·)

  if let some latest := latest then
    createFile output latest.toString
    return 0
  else
    eprintln "no valid semver found"
    return 1
