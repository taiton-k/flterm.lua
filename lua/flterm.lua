local api = vim.api;
local o = vim.o;
local cmd = vim.cmd;
local flterm = {};

local buf_handle = -1;
local win_handle = -1;

local win_opts = {
        relative = 'editor';
        width = function () return math.floor(o.columns*0.70710678) end;
        height = function () return math.floor(o.lines*0.70710678) end;
        col = function () return math.floor((o.columns-o.columns*0.70710678)/2) end;
        row = function () return math.floor((o.lines-o.lines*0.70710678)/2) end;
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


flterm.open_term = function ()
        if not api.nvim_buf_is_valid(buf_handle) then
                buf_handle = api.nvim_create_buf(true,true);
                if buf_handle == 0 then
                        api.nvim_err_writeln('[flTerm]Faild to create buffer.');
                end
        end

        if api.nvim_win_is_valid(win_handle) then
                api.nvim_err_writeln('[flterm]Failed to create window.Window is already opend.');
        else
                win_handle = api.nvim_open_win(buf_handle,true,gen_win_opts());
                if win_handle == 0 then
                        api.nvim_err_writeln('[flTerm]Faild to create window.')
                end
        end

        if o.buftype ~= 'terminal' then
                cmd('terminal');
        end
end

flterm['open_term!'] = function ()
        buf_handle = api.nvim_create_buf(true,true);
        if buf_handle == 0 then
                api.nvim_err_writeln('[flTerm]Faild to create buffer.');
        end

        if api.nvim_win_is_valid(win_handle) then
                api.nvim_err_writeln('[flterm]Failed to create window.Window is already opend.');
        else
                win_handle = api.nvim_open_win(buf_handle,true,gen_win_opts());
                if win_handle == 0 then
                        api.nvim_err_writeln('[flTerm]Faild to create window.')
                end
        end

        if o.buftype ~= 'terminal' then
                cmd('terminal');
        end
end





flterm.close_term = function ()
        if api.nvim_win_is_valid(win_handle) then
                api.nvim_win_close(win_handle,false);
        else
                api.nvim_err_writeln('[flterm]Failed to close window.Window is already closed.');
        end
end

flterm['close_term!'] = function ()
        if api.nvim_win_is_valid(win_handle) then
                api.nvim_win_close(win_handle,false);
                api.nvim_buf_delete(buf_handle);
        else
                api.nvim_err_writeln('[flterm]Failed to close window.Window is already closed.');
        end
end


flterm.toggle_term = function ()
        if api.nvim_win_is_valid(win_handle) then
                flterm.close_term();
        else
                flterm.open_term();
        end
end

flterm['toggle_term!'] = function ()
        if api.nvim_win_is_valid(win_handle) then
                flterm['close_term!']();
        else
                flterm['open_term!']();
        end
end



flterm.run_cmd = function (command)
        if not api.nvim_buf_is_valid(buf_handle) then
                buf_handle = api.nvim_create_buf(false,true);
                if buf_handle == 0 then
                        api.nvim_err_writeln('[flTerm]Faild to create buffer.');
                end
        end

        win_handle = api.nvim_open_win(buf_handle,true,gen_win_opts());
        if win_handle == 0 then
                api.nvim_err_writeln('[flTerm]Faild to create window.')
        end

        cmd('edit term://' .. command);
end




flterm.reset = function ()
        if api.nvim_win_is_valid(win_handle) then
                flterm.close_term();
        end

        api.nvim_buf_delete(buf_handle);
end



flterm.setup = function (opts)
        if opts then
                for i,v in pairs(opts) do
                        win_opts[i] = v;
                end
        end

       api.nvim_add_user_command('FlTermOpen','call v:lua.require("flterm")["open_term<bang>"]()',{bang = true});
       api.nvim_add_user_command('FlTermClose','call v:lua.require("flterm")["close_term<bang>"]()',{bang = true});
       api.nvim_add_user_command('FlTermToggle','call v:lua.require("flterm")["toggle_term<bang>"]()',{bang = true});
       api.nvim_add_user_command('FlTermRun','call v:lua.require("flterm").run_cmd("<args>")',{nargs = '+'});
       api.nvim_add_user_command('FlTermReset','call v:lua.require("flterm").reset()',{});
end

return flterm;
