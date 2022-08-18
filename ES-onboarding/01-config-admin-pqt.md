# Configuración del administrador de paquetes

Los administradores de paquetes son útiles para instalar y actualizar las herramientas de la línea de comandos. En vez de tener que pasar por varios pasos complicados, puedes ejecutar un solo comando. Por ejemplo:

Sin un administrador de paquetes:
```
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
tar xzf nvim-macos.tar.gz
./nvim-osx64/bin/nvim
```

Con un administrador de paquetes:
```
brew install neovim
```

## MacOS: Instalación de homebrew

Homebrew es el administrador de paquetes más popular para macOS. Para instalarlo, copia y pega la síguiente línea en el terminal y presiona Enter.

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

## Linux: TODO

## Windows: TODO

<!-- give up, maybe -->
