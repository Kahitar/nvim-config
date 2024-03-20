return {
    {
        "github/copilot.vim",
        config = function()
        end
    },
    {
        "David-Kunz/gen.nvim",
        opts = {
            model = "mistral", -- The default model to use.
            host = "localhost", -- The host running the Ollama service.
            port = "11434", -- The port on which the Ollama service is listening.
            display_mode = "float", -- The display mode. Can be "float" or "split".
            show_prompt = false, -- Shows the Prompt submitted to Ollama.
            show_model = false, -- Displays which model you are using at the beginning of your chat session.
            quit_map = "q", -- set keymap for quit
            no_auto_close = false, -- Never closes the window automatically.
            init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
            -- Function to initialize Ollama
            command = function(options)
                return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
            end,
            -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
            -- This can also be a command string.
            -- The executed command must return a JSON object with { response, context }
            -- (context property is optional).
            -- list_models = '<omitted lua function>', -- Retrieves a list of model names
            debug = false -- Prints errors and the command which is run.
        }
    },
    {
        "Kahitar/ChatGPT.nvim",
        dir = "C:/dev/nvim/ChatGPT.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim",
            "nvim-telescope/telescope.nvim"
        },
        config = function()
            local get_api_key = function()
                local get_key_cmd_str = ""
                if package.config:sub(1,1) == "\\" then
                    -- Command string for windows
                    get_key_cmd_str = "az keyvault secret show --vault-name NiklasPersonalSecrets -n ChatGPT-Personal-Neovim-Key | jq .value"
                else
                    -- Command string for linux
                    get_key_cmd_str = "bash -c 'source /c/users/user/.bash_functions && secret NiklasPersonalSecrets ChatGPT-Personal-Neovim-Key'"
                end
                local api_key = io.popen(get_key_cmd_str):read("*all")
                return api_key:gsub('^%s*"', ''):gsub('"%s*$', ''):gsub("\n", "")
            end
            vim.keymap.set("n", "<leader>gp", '<cmd>ChatGPT<CR>')
            vim.keymap.set("v", "<leader>gp", '<cmd>ChatGPTEditWithInstructions<CR>')
            require("chatgpt").setup({
                api_key_cmd =  "echo " .. get_api_key(),
                api_host_cmd = 'echo -n ""',
                api_type_cmd = 'echo azure',
                azure_api_base_cmd = 'echo https://{your-resource-name}.openai.azure.com',
                azure_api_engine_cmd = 'echo chat',
                azure_api_version_cmd = 'echo 2023-05-15',
                yank_register = "+",
                edit_with_instructions = {
                    diff = false,
                    keymaps = {
                        close = "<C-c>",
                        accept = "<C-y>",
                        toggle_diff = "<C-d>",
                        toggle_settings = "<C-o>",
                        toggle_help = "<C-h>",
                        cycle_windows = "<Tab>",
                        use_output_as_input = "<C-i>",
                    },
                },
                chat = {
                    welcome_message = [[
     If you don't ask the right questions,
        you don't get the right answers.
                                      ~ Robert Half
]],
                    loading_text = "Loading, please wait ...",
                    question_sign = "", -- 🙂
                    answer_sign = "ﮧ", -- 🤖
                    border_left_sign = "",
                    border_right_sign = "",
                    max_line_length = 120,
                    sessions_window = {
                        active_sign = "  ",
                        inactive_sign = "  ",
                        current_line_sign = "",
                        border = {
                            style = "rounded",
                            text = {
                                top = " Sessions ",
                            },
                        },
                        win_options = {
                            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                        },
                    },
                    keymaps = {
                        close = "<C-c>",
                        yank_last = "<C-y>",
                        yank_last_code = "<C-k>",
                        scroll_up = "<C-u>",
                        scroll_down = "<C-d>",
                        new_session = "<C-n>",
                        cycle_windows = "<Tab>",
                        cycle_modes = "<C-f>",
                        next_message = "<C-j>",
                        prev_message = "<C-k>",
                        select_session = "<Space>",
                        rename_session = "r",
                        delete_session = "d",
                        draft_message = "<C-r>",
                        edit_message = "e",
                        delete_message = "d",
                        toggle_settings = "<C-o>",
                        toggle_sessions = "<C-p>",
                        toggle_help = "<C-h>",
                        toggle_message_role = "<C-r>",
                        toggle_system_role_open = "<C-s>",
                        stop_generating = "<C-x>",
                    },
                },
                popup_layout = {
                    default = "center",
                    center = {
                        width = "80%",
                        height = "80%",
                    },
                    right = {
                        width = "30%",
                        width_settings_open = "50%",
                    },
                },
                popup_window = {
                    border = {
                        highlight = "FloatBorder",
                        style = "rounded",
                        text = {
                            top = " ChatGPT ",
                        },
                    },
                    win_options = {
                        wrap = true,
                        linebreak = true,
                        foldcolumn = "1",
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                    buf_options = {
                        filetype = "markdown",
                    },
                },
                system_window = {
                    border = {
                        highlight = "FloatBorder",
                        style = "rounded",
                        text = {
                            top = " SYSTEM ",
                        },
                    },
                    win_options = {
                        wrap = true,
                        linebreak = true,
                        foldcolumn = "2",
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                },
                popup_input = {
                    prompt = "  ",
                    border = {
                        highlight = "FloatBorder",
                        style = "rounded",
                        text = {
                            top_align = "center",
                            top = " Prompt ",
                        },
                    },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                    submit = "<C-Enter>",
                    submit_n = "<Enter>",
                    max_visible_lines = 20,
                },
                settings_window = {
                    setting_sign = "  ",
                    border = {
                        style = "rounded",
                        text = {
                            top = " Settings ",
                        },
                    },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                },
                help_window = {
                    setting_sign = "  ",
                    border = {
                        style = "rounded",
                        text = {
                            top = " Help ",
                        },
                    },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                },
                openai_params = {
                    model = "gpt-3.5-turbo",
                    frequency_penalty = 0,
                    presence_penalty = 0,
                    max_tokens = 300,
                    temperature = 0,
                    top_p = 1,
                    n = 1,
                },
                openai_edit_params = {
                    model = "gpt-4",
                    frequency_penalty = 0,
                    presence_penalty = 0,
                    temperature = 0,
                    top_p = 1,
                    n = 1,
                },
                use_openai_functions_for_edits = false,
                actions_paths = {},
                show_quickfixes_cmd = "Trouble quickfix",
                predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
                highlights = {
                    help_key = "@symbol",
                    help_description = "@comment",
                },
            })
        end,
    }
}
