local skynet = require "skynet"

function test_time(  )
	print("timeout")
end

--[[ 
名称： 创建定时器
参数说明：
	time :  time * 0.01s 后触发
	func :  定时器绑定的函数
	flag :  模式标志   0：单次 1：循环
返回说明：
	timer : 返回一个定时器对象，start() 方法启动定时器，stop()方法结束定时器
举例：
	myTimer = newTimer(100, test_time,1)
	myTimer.start()
	.... --一段时间后
	myTimer.stop()
]]
function newTimer(time,func,flag)
	local timer={}
	local function do_once()
		if func then
			func()	
		end
	end
	local function do_loop()
		if func then
			func()
			skynet.timeout(time,do_loop)
		end
	end
    function timer.start()
		if flag == 1 then 
			skynet.timeout(time,do_loop)
		else
			skynet.timeout(time,do_once)
		end
	end
    function timer.stop()
		func = nil
	end
	return timer
end

--[[
	--创建定时器 低效率版
function commonTool.newTimer(time,func,flag)
	local isfirst= true
	local timer={}
	 function timer.start()
		if isfirst then
			isfirst = false
			skynet.timeout(time,start)
		else
			if func then
				func()
				if flag == 1 then 
					skynet.timeout(time,start)
				end
			end
		end
	end
    function timer.stop()
		func = nil
	end
	return timer
end
]]


skynet.start(function()
	skynet.error("Server start.............jjj")
	myTimer = newTimer(100, test_time,0)
	myTimer.start()
	--skynet.exit()
	end)
