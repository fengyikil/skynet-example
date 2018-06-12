local skynet = require "skynet"

function test_time(  )
	print("timeout")
end


function loop_timeout(ti, func)
	local handle={}
	local function t_start()
		if func then
			func()
			skynet.timeout(ti,t_start)
		end
	end

	local function t_stop()
		func = nil
	end
handle.start=t_start
handle.stop =t_stop
return handle
end


skynet.start(function()
	skynet.error("Server start.............jjj")
	h = loop_timeout(100, test_time)
	h.start()
	--skynet.exit()
	end)
