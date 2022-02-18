# flterm.lua

A simple Lua plugin to display terminal in the floating window.

## Usage

quic start
~~~vim
" quic start flterm
lua require('flterm').setup();


FlTermOpen          " open the flterm by reusing buffer.
FlTermOpen!         " open the flterm with create buffer.

FlTermClose         " close the flterm.
FlTermClose!        " close the flterm and delete buffer.

FlTermToggle        " toggle flterm.
FlTermToggle!       " toggle flterm using FlTermOpen! and FlTermClose!.

FlTermRun {command} " run the command on the flterm.

" Type <C-t> to toggle flterm.
nnormap <C-t> <Cmd>FlTermToggle<CR>
tnormap <C-t> <Cmd>FlTermToggle<CR>
~~~

## Configuration

You can configure layout of flterm by passing the following table to the setup function.

This table can have variables and functions, respectively.
Finally, it is passed to the `nvim_open_win` function.

The screenshot shows the sl command being executed.

~~~lua
-- this is the default configuration

local width = function () return math.floor(vim.o.columns*(math.sqrt(2)/2)) end;
local height = function () return math.floor(vim.o.lines*(math.sqrt(2)/2)) end;
local opts = {
        relative = 'editor';
        width = width;
        height = height;
        col = function () return math.floor((vim.o.columns-width()/2)) end;
        row = function () return math.floor((vim.o.lines-height()/2)) end;
        anchor = 'NW';
        style = 'minimal';
};

require('flterm').setup(opts);

vim.api.nvim_set_keymap('n','<C-t>','<Cmd>FlTermToggle<CR>');
vim.api.nvim_set_keymap('t','<C-t>','<Cmd>FlTermToggle<CR>');
~~~

![flterm_default](https://user-images.githubusercontent.com/84013946/153116445-11aad054-56aa-450d-9d65-4ef79b38fdc9.png)

---


This way, you can add a border.

~~~lua

local opts = {
        border = 'rounded';
};

require('flterm').setup(opts);

vim.api.nvim_set_keymap('n','<C-t>','<Cmd>FlTermToggle<CR>');
vim.api.nvim_set_keymap('t','<C-t>','<Cmd>FlTermToggle<CR>');
~~~

![flterm_borderd](https://user-images.githubusercontent.com/84013946/153116434-5fee43cf-9342-4c96-afc5-bdccb38ab241.png)

---


This way, you can customize winhighlight.

~~~lua

local opts = {
        border = 'rounded';
};

require('flterm').setup(opts);

vim.api.nvim_set_keymap('n','<C-t>','<Cmd>FlTermToggle<CR><Cmd>setlocal winhighlight=Normal:Normal,FloatBorder:VertSplit<CR>');
vim.api.nvim_set_keymap('t','<C-t>','<Cmd>FlTermToggle<CR>');
~~~

![flterm_conf](https://user-images.githubusercontent.com/84013946/153116451-a75783c6-717a-4a66-b25b-21dfbf74fea0.png)
