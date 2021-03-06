local skynet = require "skynet"
require "skynet.queue"
local CS = skynet.queue()
local hotfix_util = require "server.common.hotfix_util"
local MODULE_NAME = "server.lualib.logon_helper"
local CMD_MODULE = require(MODULE_NAME)

skynet.start(function()
    skynet.dispatch("lua", function(session, _, command, ...)
        if command == "update" then
            CMD_MODULE = hotfix_util.update(MODULE_NAME, CMD_MODULE)
		end
        local f = CMD_MODULE[command]
        if not f then
            if session ~= 0 then
                skynet.ret(skynet.pack(nil))
            end
            return
        end
        if session == 0 then
            return CS(f, ...)
        end
        skynet.ret(skynet.pack(CS(f, ...)))
    end)
end)
