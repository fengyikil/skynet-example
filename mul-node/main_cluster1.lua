local skynet = require "skynet"
local cluster = require "cluster"
local snax = require "snax"

skynet.start(function()
    cluster.open("cluster1")
    --cluster.open("cluster2")

    skynet.newservice("cluster1Server")
end)