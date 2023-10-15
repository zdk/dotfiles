---@type MappingsTable
local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
	},
	v = {
		[">"] = { ">gv", "indent" },
	},
}

-- more keybinds!

M.dap = {
	plugin = true,
	n = {
		["<leader>dc"] = {
			"<cmd> DapContinue <CR>",
			"Continue",
		},
		["<leader>db"] = {
			"<cmd> DapToggleBreakpoint <CR>",
			"Add breakpoint at line",
		},
		["<leader>do"] = {
			"<cmd> DapStepOver <CR>",
			"Step Over",
		},
		["<leader>dO"] = {
			"<cmd> DapStepOut <CR>",
			"Step Out",
		},
		["<leader>dt"] = {
			"<cmd> DapTerminate <CR>",
			"Terminate",
		},
		["<leader>dus"] = {
			function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end,
			"Open debugging sidebar",
		},

		--    ["<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
		--    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
		--    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
		--    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
		--    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
		--    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
		--    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
		--    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
		--    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
		--    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
		--    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
		--    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
		--    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
		--    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
		--    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
		--    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
	},
}

M.dap_go = {
	plugin = true,
	n = {
		["<leader>dgt"] = {
			function()
				require("dap-go").debug_test()
			end,
			"Debug go test",
		},
		["<leader>dgl"] = {
			function()
				require("dap-go").debug_last()
			end,
			"Debug last go test",
		},
	},
}

M.gopher = {
	plugin = true,
	n = {
		["<leader>gsj"] = {
			"<cmd> GoTagAdd json <CR>",
			"Add json struct tags",
		},
		["<leader>gsy"] = {
			"<cmd> GoTagAdd yaml <CR>",
			"Add yaml struct tags",
		},
	},
}

return M
