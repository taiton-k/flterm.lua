local api = vim.api;
local o = vim.o;
local cmd = vim.cmd;
local flterm = {};

local buf_handle = -1;
local win_handle = -1;


local win_width = function () return math.floor(o.columns*(math.sqrt(2)/2)) end;
local win_height = function () return math.floor(o.lines*(math.sqrt(2)/2)) end;

local win_opts = {
        relative = 'editor';
        width = win_width;
        height = win_height;
        col = function () return math.floor((o.columns-win_width())/2) end;
        row = function () return math.floor((o.lines-win_height())/2) end;
        anchor = 'NW';
        style = 'minimal';
};

local function gen_win_opts ()
        local opts = {};

        for i,v in pairs(win_opts) do
                if type(v) == 'function' then
                        opts[i] = v();
                else
                        opts[i] = v;
                end
        end

        return opts;
end

local function bufIsValid ()
        return api.nvim_buf_is_valid(buf_handle);
end

local function createBuffer ()
        buf_handle = api.nvim_create_buf(true,true);
        if buf_handle == 0 then
                api.nvim_err_writeln('[flTerm]Faild to create buffer.');
        end
end

local function winIsValid()
        return api.nvim_win_is_valid(win_handle);
end

local function createWindow ()
        if api.nvim_win_is_valid(win_handle) then
                api.nvim_err_writeln('[flterm]Failed to create window.Window is already opend.');
        else
                win_handle = api.nvim_open_win(buf_handle,true,gen_win_opts());
                if win_handle == 0 then
                        api.nvim_err_writeln('[flTerm]Faild to create window.')
                end
        end
end

local function openTermnal ()
        if o.buftype ~= 'terminal' then
                cmd('terminal');
        end
end

flterm.open_term = function ()
        if not bufIsValid() then
                createBuffer();
        end

        createWindow();

        openTermnal();
end

flterm['open_term!'] = function ()
        createBuffer();

        createWindow();

        openTermnal();
end





flterm.close_term = function ()
        if winIsValid() then
                api.nvim_win_close(win_handle,false);
        else
                api.nvim_err_writeln('[flterm]Failed to close window.Window is already closed.');
        end
end

flterm['close_term!'] = function ()
        if winIsValid() then
                api.nvim_win_close(win_handle,false);
                api.nvim_buf_delete(buf_handle);
        else
                api.nvim_err_writeln('[flterm]Failed to close window.Window is already closed.');
        end
end


flterm.toggle_term = function ()
        if winIsValid() then
                flterm.close_term();
        else
                flterm.open_term();
        end
end

flterm['toggle_term!'] = function ()
        if winIsValid() then
                flterm['close_term!']();
        else
                flterm['open_term!']();
        end
end



flterm.run_cmd = function (command)
        if not bufIsValid() then
                createBuffer();
        end

        createWindow();

        cmd('edit term://' .. command);
end



flterm.setup = function (opts)
        if opts then
                for i,v in pairs(opts) do
                        win_opts[i] = v;
                end
        end

       cmd([[
                command! -bang FlTermOpen call v:lua.require("flterm")["open_term<bang>"]()
                command! -bang FlTermClose call v:lua.require("flterm")["close_term<bang>"]()
                command! -bang FlTermToggle call v:lua.require("flterm")["toggle_term<bang>"]()
                command! -bang -nargs=+ FlTermRun call v:lua.require("flterm").run_cmd("<args>")
                command! FlTermReset call v:lua.require("flterm").reset()
        ]])
end

return flterm;
