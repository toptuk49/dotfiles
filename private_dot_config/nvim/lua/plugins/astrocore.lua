-- if true then
-- 	return {}
-- end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
	"AstroNvim/astrocore",
	---@type AstroCoreOpts
	opts = {
		-- Configure core features of AstroNvim
		features = {
			large_buf = { size = 1024 * 256, lines = 10000 },          -- set global limits for large files for disabling features like treesitter
			autopairs = true,                                          -- enable autopairs at start
			cmp = true,                                                -- enable completion at start
			diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
			highlighturl = true,                                       -- highlight URLs at start
			notifications = true,                                      -- enable notifications at start
		},
		-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
		diagnostics = {
			virtual_text = true,
			underline = true,
		},
		-- passed to `vim.filetype.add`
		filetypes = {
			-- see `:h vim.filetype.add` for usage
			extension = {
				foo = "fooscript",
			},
			filename = {
				[".foorc"] = "fooscript",
			},
			pattern = {
				[".*/etc/foo/.*"] = "fooscript",
			},
		},
		-- vim options can be configured here
		options = {
			opt = {              -- vim.opt.<key>
				relativenumber = true, -- sets vim.opt.relativenumber
				number = true,     -- sets vim.opt.number
				spell = false,     -- sets vim.opt.spell
				signcolumn = "yes", -- sets vim.opt.signcolumn to yes
				wrap = false,      -- sets vim.opt.wrap
			},
			g = {                -- vim.g.<key>
				-- configure global vim variables (vim.g)
				-- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
				-- This can be found in the `lua/lazy_setup.lua` file
			},
		},
		-- Mappings can be configured through AstroCore as well.
		-- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
		mappings = {
			-- first key is the mode
			n = {
				-- second key is the lefthand side of the map

				-- navigate buffer tabs
				["]b"] = {
					function()
						require("astrocore.buffer").nav(vim.v.count1)
					end,
					desc = "Next buffer",
				},
				["[b"] = {
					function()
						require("astrocore.buffer").nav(-vim.v.count1)
					end,
					desc = "Previous buffer",
				},

				-- mappings seen under group name "Buffer"
				["<Leader>bd"] = {
					function()
						require("astroui.status.heirline").buffer_picker(function(bufnr)
							require("astrocore.buffer").close(bufnr)
						end)
					end,
					desc = "Close buffer from tabline",
				},

				-- tables with just a `desc` key will be registered with which-key if it's installed
				-- this is useful for naming menus
				-- ["<Leader>b"] = { desc = "Buffers" },

				-- setting a mapping to false will disable it
				-- ["<C-S>"] = false,

				["<Leader>m"] = { desc = "My commands" },

				["<Leader>mn"] = {
					function()
						local cwd = vim.fn.getcwd()
						local handle = io.popen('find "' .. cwd .. '" -type d -maxdepth 2')
						if not handle then
							return
						end

						local dirs = {}
						for line in handle:lines() do
							table.insert(dirs, line)
						end
						handle:close()

						vim.ui.select(dirs, {
							prompt = "Select folder:",
							format_item = function(item)
								return item:gsub(cwd .. "/", "")
							end,
						}, function(folder_choice)
							if not folder_choice then
								return
							end

							local filename = vim.fn.input("File name: ", folder_choice .. "/", "file")
							if filename ~= "" then
								vim.cmd("edit " .. filename)
							end
						end)
					end,
					desc = "Create file in specified project folder",
				},

				["<Leader>mc"] = {
					function()
						local current_file = vim.fn.expand("%:p")
						if current_file == "" then
							vim.notify("There is no opened file to copy!", vim.log.levels.WARN)
							return
						end

						local file = io.open(current_file, "r")
						if not file then
							vim.notify("Failed to open current file to copy!", vim.log.levels.ERROR)
							return
						end

						local content = file:read("*a")
						file:close()

						local cwd = vim.fn.getcwd()
						local relative_path = vim.fn.fnamemodify(current_file, ":~:.")
						local filename = vim.fn.fnamemodify(current_file, ":t")
						local extension = vim.fn.fnamemodify(current_file, ":e")

						local result = "`" .. relative_path .. "`:\n"
						result = result .. "```" .. extension .. "\n"
						result = result .. content
						if content:sub(-1) ~= "\n" then
							result = result .. "\n" -- Add newline if missing
						end
						result = result .. "```\n"

						-- Copy to clipboard
						vim.fn.setreg("+", result)
						vim.fn.setreg("*", result)
						vim.fn.setreg('"', result) -- and to unnamed register

						vim.notify(
							"Current file is successfully copied! (" .. relative_path .. ")",
							vim.log.levels.INFO
						)
					end,
					desc = "Copy current file in markdown format",
				},

				["<Leader>mm"] = {
					function()
						local builtin = require("telescope.builtin")
						builtin.find_files({
							attach_mappings = function(prompt_bufnr, map)
								local actions = require("telescope.actions")
								local action_state = require("telescope.actions.state")
								local picker = action_state.get_current_picker(prompt_bufnr)

								-- Multi-selection
								map("i", "<Tab>", function()
									actions.toggle_selection(prompt_bufnr)
								end)

								map("i", "<CR>", function()
									local selections = picker:get_multi_selection()
									local entries = {}

									if #selections > 0 then
										-- Multiple selection
										entries = selections
									else
										-- Single file
										local entry = action_state.get_selected_entry()
										if entry then
											entries = { entry }
										end
									end

									actions.close(prompt_bufnr)

									if #entries == 0 then
										return
									end

									local cwd = vim.fn.getcwd()
									local results = {}

									for _, entry in ipairs(entries) do
										local file = io.open(entry.path, "r")
										if file then
											local content = file:read("*a")
											file:close()

											local relative_path = vim.fn.fnamemodify(entry.path, ":~:.")
											local extension = vim.fn.fnamemodify(entry.path, ":e")

											table.insert(results, "`" .. relative_path .. "`:")
											table.insert(results, "```" .. extension)
											table.insert(results, content)
											if content:sub(-1) ~= "\n" then
												table.insert(results, "") -- Add empty line if no newline
											end
											table.insert(results, "```")
											table.insert(results, "") -- Empty line between files
										end
									end

									-- Remove last empty line if present
									if results[#results] == "" then
										table.remove(results)
									end

									local result = table.concat(results, "\n")

									-- Copy to all buffers
									vim.fn.setreg("+", result)
									vim.fn.setreg("*", result)
									vim.fn.setreg('"', result)

									-- Show statistics
									local line_count = #vim.split(result, "\n")
									local char_count = #result
									vim.notify(
										string.format(
											"Copied %d files (%d lines, %d characters)",
											#entries,
											line_count,
											char_count
										),
										vim.log.levels.INFO
									)
								end)

								return true
							end,
						})
					end,
					desc = "Copy multiple files in markdown format",
				},
			},
		},
	},
}
