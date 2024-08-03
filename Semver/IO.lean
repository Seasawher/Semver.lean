open IO System FS

/-- create a file with given path and content. -/
def createFile (path : FilePath) (content : String) : IO Unit := do
  match path.parent with
  | none => writeFile path content
  | some parent =>
    createDirAll parent
    writeFile path content
