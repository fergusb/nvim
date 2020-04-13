# Fergus' nvim setup

## Installation
Use the project install file.  The installer will backup the old nvim directory 
(if present) with a date stamp 

```
git clone https://github.com/fergusb/nvim.git ~/.config/nvim
cd ~/.comfig/nvim/
./install
```

### Init plugins (not needed with installer)
```
cd ~/.config/nvim/
git submodule init
git submodule update
```

Note: for pyflakes or jedi to work correctly, use:
```
git submodule update --init --recursive
```

### Add plugins
```
cd ~/.config/nvim/
mkdir bundle
git submodule add https://github.com/fergusb/nvim-foo.git bundle/foo
```

### Update plugins
```
git submodule foreach git pull origin master
git submodule update
```

" vim:ft=mkd
