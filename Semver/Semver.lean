import Semver.List
import Semver.String

/-- semantic versioning number -/
structure Semver where
  /-- major version number -/
  major : Nat
  /-- minor version number -/
  minor : Nat
  /-- patch version number -/
  patch : Nat
  /-- release candidate number. `none` for stable release -/
  prerelease : Option Nat
deriving DecidableEq, Inhabited

namespace Semver

/-- get Semver from List -/
def ofList (xs : List Nat) : Option Semver :=
  match xs with
  | [major, minor, patch] => some ⟨major, minor, patch, none⟩
  | [major, minor, patch, prerelease] => some ⟨major, minor, patch, some prerelease⟩
  | _ => none

/-- convert Semver to String -/
def toString (v : Semver) : String :=
  let prereleaseStr := match v.prerelease with
    | none => ""
    | some n => s!"-rc{n}"
  s!"leanprover/lean4:{v.major}.{v.minor}.{v.patch}{prereleaseStr}"

#guard toString ⟨4, 8, 0, none⟩ = "leanprover/lean4:4.8.0"
#guard toString ⟨4, 10, 0, some 2⟩ = "leanprover/lean4:4.10.0-rc2"

instance : ToString Semver := ⟨toString⟩

/-- read String and get Semver object -/
def parse (s : String) : Option Semver := Id.run do
  let s := if s.startsWith "leanprover/lean4:"
    then s.drop "leanprover/lean4:".length
    else s
  if s.countChar '.' != 2 then
    return none
  let withoutRc := if let some _ := s.findWhere "-rc"
    then s.replace "-rc" "."
    else s
  let dotted := if withoutRc.startsWith "v"
    then withoutRc.drop 1
    else withoutRc
  let parts := dotted.splitOn "."
    |>.map String.toNat?
    |>.allSome
  if let some versions := parts then
    return Semver.ofList versions
  else
    none

#guard parse "v4.8.0" = some ⟨4, 8, 0, none⟩
#guard parse "v4.10.0-rc2" = some ⟨4, 10, 0, some 2⟩
#guard parse "4.8.0" = some ⟨4, 8, 0, none⟩
#guard parse "leanprover/lean4:4.10.0-rc2" = some ⟨4, 10, 0, some 2⟩
#guard parse "v4.8" = none
#guard parse "v4" = none

/-- `leq x y` means `x ≤ y`, `y` is the newer one. -/
def decidableLeq (x y : Semver) : Bool := Id.run do
  -- handle major
  if x.major > y.major then
    return false
  if x.major < y.major then
    return true

  -- handle minor
  if x.minor < y.minor then
    return true
  if x.minor > y.minor then
    return false

  -- handle patch
  if x.patch < y.patch then
    return true
  if x.patch > y.patch then
    return false

  -- handle prerelease
  match x.prerelease, y.prerelease with
    | none, none => true
    | none, some _ => false
    | some _, none => true
    | some x, some y => decide (x ≤ y)

instance : LE Semver where
  le x y := decidableLeq x y

instance : @DecidableRel Semver (· ≤ ·) := fun x y => (decidableLeq x y).decEq true

-- stable release ≥ prerelease
#guard (⟨3, 2, 1, none⟩ : Semver) ≥ ⟨3, 2, 1, some 1⟩

-- minor version is important than patch version
#guard (⟨4, 9, 1, none⟩ : Semver) ≤ ⟨4, 10, 0, some 2⟩

-- rc number matters
#guard (⟨4, 10, 0, some 2⟩ : Semver) ≥ ⟨4, 10, 0, some 1⟩

-- reflectivity
#guard (⟨4, 10, 0, none⟩ : Semver) ≤ ⟨4, 10, 0, none⟩

end Semver
