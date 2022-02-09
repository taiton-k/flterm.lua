# flterm.lua

A simple Lua plugin to display terminal in a floating window.

## Usage

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

Finally, it is passed to the nvim_open_win function.

~~~lua

-- this is default configuration

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

~~~
