# nvim config with autocomplete for python

This nvim config has been setup to allow autocomplete with python.

## Install

1. Run `setup.sh` to install depdendencies and copy init.vim to `~/.config/nvim/`
    - This will also backup your current `init.vim` file

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
