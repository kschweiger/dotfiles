return {
  s(
    "script-init",
    fmt(
      [[
  def {f}(): 
      pass

  
  if __name__ == "__main__":
      {f}()
  ]],
      {
        -- i(1) is at nodes[1], i(2) at nodes[2].
        f = i(1, "main"),
      },
      {
        repeat_duplicates = true,
      }
    )
  ),
}
