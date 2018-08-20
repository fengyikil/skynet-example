--[[
	时间最小单位：
	 1 ms
	定时器结构：
	{
		func --定时器函数
		args --定时器函数参数
		mode -- 0 单次触发，1 循环触发
		expiration_time --到期时间
		cycle_time   --循环时间，在循环模式下工作
	}
--]]
local jtime={}
jtime.list={}

function jtime.sleep(n)
   local t0 = os.clock()
   while os.clock() - t0 <= n do end
end

function jtime.createTime(name,func,args,mode,time)
	local t = {}
	t.func = func
	t.args = args
	t.mode = mode

	local now = os.clock() 
	t.cycle_time = time/1000000
	t.expiration_time = now + t.cycle_time

	jtime.list[name]=t
end

function jtime.removeTime(name)
	jtime.list[name] = nil
end

function jtime.exec()
    now = os.clock()
	for key,v in pairs(jtime.list) do
		if (now > v.expiration_time)
		then
        	v.func(v.args)
        	if (v.mode == 0)
        	then
        		jtime.list[key]=nil
        	else
        		v.expiration_time = now + v.cycle_time
        	end
        end
    end
end

return jtime