import Lake
open Lake DSL

package "Semver" where
  -- add package configuration options here
  leanOptions := #[
    ⟨`autoImplicit, false⟩,
    ⟨`relaxedAutoImplicit, false⟩
  ]

lean_lib «Semver» where
  -- add library configuration options here

@[default_target]
lean_exe "semver" where
  root := `Main
