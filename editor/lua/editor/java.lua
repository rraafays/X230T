local M = {}

local project_markers = {
  "mvnw",
  "gradlew",
  "settings.gradle",
  "settings.gradle.kts",
  ".git",
  "build.xml",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
}

function M.configure_lsp()
  vim.lsp.config("jdtls", {
    root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      if fname == "" then
        return on_dir(nil)
      end

      local root = vim.fs.root(fname, project_markers)
      if root then
        return on_dir(root)
      end

      -- Standalone .java: treat the file's directory as the project root.
      return on_dir(vim.fs.dirname(fname))
    end,
    settings = {
      java = {
        references = { includeDecompiledSources = true },
        eclipse = { downloadSources = true },
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        completion = {
          enabled = true,
          importOrder = { "", "javax", "java", "#" },
          overwrite = true,
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          generateComments = true,
        },
        configuration = {
          updateBuildConfiguration = "automatic",
        },
        import = {
          maven = { enabled = true },
          gradle = { enabled = true },
        },
        format = { enabled = true },
      },
    },
  })
end

return M
