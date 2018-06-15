package.cpath = "luaclib/?.so"
package.path = "lualib/?.lua;skynet-example/proto/?.lua"


local sproto = require "sproto"
local print_r = require "print_r"

local sp = sproto.parse [[
.Person {
	name 0 : string
	id 1 : integer
	email 2 : string
}


Rjj 1 {
	 request
	 {
	        orq 0 : boolean

	}
    response {	
            ors 0 : boolean
    }
}



]]

print(sp:exist_type("Person"))
print(sp:exist_proto("Rjj"))

print_r(sp:default("Person"))


local t1 = {
			name = nil,
			id = 0.02,
			email = ""
}
local t2= {
			name = "jjj",
			id = 5,
			email = ""
}

-- local en_t1 = sp:encode("Person", t1)
-- local de_t1 = sp:decode("Person", en_t1)
-- print_r(t1)
-- print_r(de_t1)
print_r(t2)
local en_t2 = sp:encode("Person", t2)
local de_t2 = sp:decode("Person", en_t2)
print_r(de_t2)
print_r(type(en_t2))