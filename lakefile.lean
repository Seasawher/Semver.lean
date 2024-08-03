import Lake
open Lake DSL

package "Semver" where
  -- add package configuration options here
  leanOptions := #[
    ⟨`autoImplicit, false⟩,
    ⟨`relaxedAutoImplicit, false⟩,
    ⟨`linter.missingDocs, true⟩
  ]

lean_lib «Semver» where
  -- add library configuration options here

@[default_target]
lean_exe "semver" where
  root := `Main

def runCmd (cmd : String) (args : Array String) : ScriptM Bool := do
  let out ← IO.Process.output {
    cmd := cmd
    args := args
  }
  let hasError := out.exitCode != 0
  if hasError then
    IO.eprint out.stderr
  return hasError

@[test_driver] script tst do
  if ← runCmd "lake" #["exe", "semver", "test/input/case1.txt", "test/output/case1.txt"] then return 1
  if ← runCmd "lean" #["--run", "Test.lean"] then return 1
  return 0
