return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        arduino_language_server = {
          cmd = {
            "arduino-language-server",
            "-cli-config",
            "/home/serendipity/.arduino15/arduino-cli.yaml",
            "-cli",
            "/usr/bin/arduino-cli",
            "-clangd",
            "/usr/bin/clangd",
          },
          filetypes = { "arduino", "cpp" },
          root_dir = require("lspconfig.util").root_pattern("*.ino", "*.cpp", "*.h"),
        },
      },
    },
  },
}
