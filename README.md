# nvim config with autocomplete for python

This nvim config has been setup to allow autocomplete with python.

## Install

1. Run `setup.sh` to install depdendencies and copy init.vim to `~/.config/nvim/`
    - This will also backup your current `init.vim` file
2. Install Adobe Source Code Pro Fonts
    - https://github.com/adobe-fonts/source-code-pro
## Configuring Projects

- Each python project requires a `pyrightconfig.json` with the vaues you want.
- Best practices dictate that your source code lives in `src` and your venv is in `.venv`.
- The following `pyrightconfig.json` is an example configuration for a standard Python3 repository.
```
{    
    "include": [    
        ".venv"    
        "src"    
    ],    
    "executionEvnironments": [    
        {"root": "src"},    
    ],    
    "venvPath": ".",    
    "venv": ".venv",    
    "analysis": {    
        "useLibraryCodeForTypes": true    
    }    
}    
```

### Creating Type Stubs

Pyright depends on type stubs. Thankfully these can be created with the `pyright --createstub $IMPORT_NAME`. 
This can include modules that are in the include path in the `pyrightconfig.json` file as well as modules that are installed via `pip`.

> **NOTE:** If you have a large number of modules the parent module can be used to generate stubs for all submodules.
