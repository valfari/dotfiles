-- quarto-nvim only auto-activates (LSP injection via otter.nvim) for `quarto` filetype buffers;
-- jupytext converts .ipynb to plain markdown, so activate it here too
require('quarto').activate()
