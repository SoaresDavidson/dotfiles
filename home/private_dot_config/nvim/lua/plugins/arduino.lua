-- Arduino (.ino) support: arduino-language-server for LSP and arduino-cli for
-- compile/upload. Board and port come from the sketch's sketch.yaml
-- (default_fqbn / default_port), created with <leader>Ab.

-- Directory holding the sketch of the current buffer (where sketch.yaml lives).
local function sketch_dir()
  return vim.fs.root(0, function(name)
    return name:match("%.ino$") ~= nil
  end) or vim.fn.expand("%:p:h")
end

local function arduino(args, interactive)
  vim.cmd("silent! wall")
  Snacks.terminal(vim.list_extend({ "arduino-cli" }, args), {
    cwd = sketch_dir(),
    interactive = interactive or false,
    auto_close = false,
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "arduino" } },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        arduino_language_server = {
          -- Not available in Mason; installed with pacman.
          mason = false,
          cmd = {
            "arduino-language-server",
            "-cli-config",
            vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
            "-clangd",
            vim.fn.exepath("clangd") ~= "" and vim.fn.exepath("clangd") or "clangd",
          },
        },
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts = { spec = { { "<leader>A", group = "arduino", icon = "" } } },
  },

  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>Ac", function() arduino({ "compile" }) end, desc = "Compile sketch", ft = "arduino" },
      { "<leader>Au", function() arduino({ "compile", "--upload" }) end, desc = "Compile + upload", ft = "arduino" },
      { "<leader>Am", function() arduino({ "monitor", "--config", "115200" }, true) end, desc = "Serial monitor", ft = "arduino" },
      { "<leader>Al", function() arduino({ "board", "list" }) end, desc = "List boards", ft = "arduino" },
      {
        "<leader>Ab",
        function()
          vim.ui.input({ prompt = "Port: ", default = "/dev/ttyUSB0" }, function(port)
            if not port then return end
            vim.ui.input({ prompt = "FQBN: ", default = "esp32:esp32:esp32" }, function(fqbn)
              if not fqbn then return end
              arduino({ "board", "attach", "-p", port, "-b", fqbn })
            end)
          end)
        end,
        desc = "Attach board (sketch.yaml)",
        ft = "arduino",
      },
    },
  },
}
