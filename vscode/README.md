# VS-Code files

## Global Settings

Link or place in the correct directory. To find it, use the `Preferences: Open Settings (JSON)` command. 

## Examples

Collection of settings and launch file used in a vscode workspace. 


## VS-Code Notes:

### Moduels are not found in quick fix

* First you have to make sure that the correct venv is selected. If that is the case,
* you want to take a look at the **Python > Analysis: Package Index Depths** setting and add something like this
  ```json
  {
      "name": "package_name",
      "depth": 2,
      "includeAllSymbols" : true
  },
  ```
