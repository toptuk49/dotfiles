return {
	"hakonharnes/img-clip.nvim",
	version = "*",
	keys = {
		{ "<leader>i", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
	},
	opts = {
		dir_path = "assets",
		file_name = "%Y-%m-%d-%H-%M-%S",
		use_absolute_path = false,
		template = "$FILE_PATH",
		drag_and_drop = {
			enabled = true,
			download_images = true,
		},
		templates = {
			markdown = "![$FILENAME]($FILE_PATH)",
			latex = [[
\begin{figure}[htbp]
    \centering
    \includegraphics{$FILE_PATH}
    \caption{$FILENAME}
    \label{fig:$FILENAME}
\end{figure}]],
			typst = '#image("$FILE_PATH")',
		},
		process_cmd = nil,
	},
	config = function(_, opts)
		require("img-clip").setup(opts)
	end,
}
