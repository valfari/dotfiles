# Mnemonics

`<leader>` = `<Space>`

---

## Toggle (`<leader>t*`)

State-flipping keys. Each prints the new state on toggle.

| Key | Action |
|-----|--------|
| `<leader>tu` | UI theme (cycles through theme list) |
| `<leader>tc` | Comment type (line ↔ block; acts as operator, needs motion) |
| `<leader>tg` | Git blame (inline current-line blame via gitsigns) |
| `<leader>td` | Diff word-level (gitsigns word diff) |
| `<leader>ts` | Spell check |
| `<leader>tv` | Virtual lines (diagnostic display: virtual text ↔ virtual lines) |

---

## Yank (`<leader>y*`)

| Key | Action |
|-----|--------|
| `<leader>yp` | [Y]ank [P]ath (full path of current file) |
| `<leader>yf` | [Y]ank [F]ilename (basename only) |
| `<leader>ya` | [Y]ank [A]ll (whole buffer contents) |

Also works in oil.nvim (yanks the entry under cursor).

---

## Diff (`<leader>d*`)

| Key | Action |
|-----|--------|
| `<leader>dc` | [D]iff vs [C]lipboard (opens split diff against `+` register) |
| `<leader>dt` | [D]iff algorithm [T]oggle (cycles myers → patience → histogram) |
| `<leader>dd` | [D]iffview open (working tree vs index) |
| `<leader>dh` | [D]iff file [H]istory (DiffviewFileHistory) |
| `<leader>dq` | [D]iff [Q]uit (close DiffviewOpen) |
| `<leader>db` | [D]iff [B]uffer vs ref (prompts for git ref; empty = vs index) |

---

## Replace (`<leader>r*`)

grug-far (find & replace) + LSP rename.

| Key | Action |
|-----|--------|
| `<leader>rr` | [R]eplace (open grug-far; visual mode = prefill selection) |
| `<leader>rw` | [R]eplace [W]ord under cursor |
| `<leader>rf` | [R]eplace in [F]ile |
| `<leader>rd` | [R]eplace in [D]irectory (current oil dir or file's dir) |
| `<leader>rb` | [R]eplace in [B]uffers (all listed buffers) |
| `<leader>rl` | [R]ename [L]SP symbol |

---

## Find (`<leader>f*`)

fff.nvim (frecency-ranked fuzzy finder).

| Key | Action |
|-----|--------|
| `<leader>fd` | [F]ind in [D]ir (current oil dir, or cwd) |
| `<leader>fD` | [F]ind in all [D]irs (global file search) |
| `<leader>ff` | [F]ind (live grep) |
| `<leader>fs` | [F]ind [S]election (grep visual selection) |

---

## Move (`<leader>m*`)

LSP navigation + project root.

| Key | Action |
|-----|--------|
| `<leader>md` | [M]ove to [D]efinition |
| `<leader>mD` | [M]ove to [D]eclaration |
| `<leader>mt` | [M]ove to [T]ype definition |
| `<leader>mi` | [M]ove to [I]mplementation |
| `<leader>mp` | [M]ove to [P]roject root (opens oil at root) |

---

## Show (`<leader>s*`)

LSP info + git blame.

| Key | Action |
|-----|--------|
| `<leader>sb` | [S]how [B]lame (full blame for current line) |
| `<leader>sr` | [S]how [R]eferences (LSP refs → quickfix with live preview) |
| `<leader>ss` | [S]how [S]ymbols (LSP document symbols) |
| `<leader>sa` | [S]how [A]ctions (LSP code actions; n + v) |

---

## Jupyter (`<leader>j*`)

molten-nvim kernel execution for `.ipynb` notebooks (opened via jupytext as markdown; code cells get LSP via quarto-nvim/otter.nvim).

| Key | Action |
|-----|--------|
| `<leader>ji` | [J]upyter [I]nit (start kernel for current buffer) |
| `<leader>je` | [J]upyter [E]valuate operator (normal mode) / selection (visual mode) |
| `<leader>jl` | [J]upyter evaluate [L]ine |
| `<leader>jr` | [J]upyter [R]e-evaluate current cell |
| `<leader>jo` | [J]upyter show [O]utput |
| `<leader>jd` | [J]upyter [D]elete cell output |

---

## Other leader keys

| Key | Action |
|-----|--------|
| `<leader>u` | Toggle Undotree |
| `<leader>dc` | Diff vs clipboard (see Diff section) |
| `<leader>el` | [E]xecute [L]ua (visual selection) |
| `<leader>?` | which-key: show buffer-local keymaps |

---

## Non-leader keys

| Key | Action |
|-----|--------|
| `s` / `S` | Flash jump / Flash treesitter select |
| `-` | Open oil.nvim (parent directory) |
| `;` | Arrow bookmarks |
| `m` | Arrow buffer-local marks |
| `K` | LSP hover documentation |
| `<C-k>` (insert) | LSP signature help |
| `[d` / `]d` | Diagnostic prev / next |
| `[g` / `]g` | Git hunk prev / next |
| `ih` | Select hunk (text object, o/x modes) |
| `<A-,>` / `<A-.>` | barbar: prev / next buffer |
| `<A-1..9>` | barbar: go to buffer N |
| `<A-0>` | barbar: go to last buffer |
| `<A-p>` / `<A-c>` | barbar: pin / close buffer |
| `<A-h/j/k/l>` | Resize window |
| `<A-Up/Down>` | Move line / selection up / down |
| `<C-h/j/k/l>` | Move focus between windows |

---

## Built-in Vim operators (no plugin)

| Key | Action |
|-----|--------|
| `gc` / `gb` | Comment line / block (operator, Neovim 0.10+) |
| `gu` / `gU` | Lowercase / uppercase (operator) |
| `gw` | Reformat text (operator) |
| `gf` | Go to file under cursor |
| `]s` / `[s` | Next / prev misspelled word |
| `z=` | Spell suggestions |
| `zg` / `zw` | Add word to good / wrong list |
