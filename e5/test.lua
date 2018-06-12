package.cpath = "luaclib/?.so"
package.path = "lualib/?.lua;myexample/e5/?.lua"

if _VERSION ~= "Lua 5.3" then
    error "Use lua 5.3"
end
local proto = require "proto"
local sproto = require "sproto"



function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end


local myTable = {
    firstName = "Fred",
    lastName = "Bob",
    phoneNumber = "(555) 555-1212",
    age = 30,
    favoriteSports = { "Baseball", "Hockey", "Soccer" },
    favoriteTeams  = { "Cowboys", "Panthers", "Reds" }
}

print_r(proto)

print_r(myTable)