# Fork Information

### Optional: Required Dependencies to Run tex Formatter
To use the `tex formatter`, install the following Perl modules:
```bash
brew install cpanminus
sudo cpanm File::HomeDir File::Which YAML::Tiny
```

### Optional: Install lazygit
To install `lazygit`, use:
```bash
brew install lazygit
```
To launch, use `<leader>gg`.

### Mandatory: Reverse Search Configuration
1. Install the `neovim-remote` package:
   ```bash
   pip install neovim-remote
   ```
2. Start Neovide with the following command:
   ```bash
   neovide -- --listen /tmp/nvimsocket
   ```
   Use this command for future launches.
3. Configure Sync settings in `skim`:
   - Command:
     ```bash
     which nvr
     ```
     This will output a path like `/Users/yourname/.local/bin/nvr`. Use this as the command.
   - Parameters:
     ```bash
     --remote-silent +%line '%file'
--remote-silent +%line '%file'     ```
4. Create an alias for convenience:
   ```bash
   alias neovide="neovide -- --listen /tmp/nvimsocket"
   ```

### Optional: Install Stylua
Stylua is an optional code formatter you can install.

### Optional: Install fd
`fd` is a file search system. Install it using:
```bash
brew install fd
```

### Install coc.nvim
1. Navigate to `~/.local/share/nvim/lazy/coc.nvim`:
   ```bash
   cd ~/.local/share/nvim/lazy/coc.nvim
   ```
2. Run the following commands:
   ```bash
   yarn install
   yarn build
