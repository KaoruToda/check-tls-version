description = [[
Check TLS version
]]
 
author = "Kaoru Toda";
license = "Apache License 2.0"
categories = {"default,safe"}
 
local shortport = require "shortport"
local stdnse = require "stdnse"
local tls = require "tls"
 
portrule = shortport.port_or_service ({443}, {"https"})

local function try_connect(host, port, protocol)
	client_hello = tls.client_hello({
		["protocol"] = protocol
	})

	sock = nmap.new_socket()
	status, err = sock:connect(host, port)
	if not status then
		sock:close()
		stdnse.print_debug("cannot send: %s", err)
		return false
	end
	status, err = sock:send(client_hello)
	if not status then
		stdnse.print_debug("cannot send: %s", err)
		sock:close()
		return false
	end
	status, err = tls.record_buffer(sock)
	if not status then
		stdnse.print_debug("cannot receive: %s", err)
		sock:close()
		return false
	end
	return true
end
 
action = function (host, port)
	local out = {}

	out["TLSv1.2"] = try_connect(host, port, "TLSv1.2")
	out["TLSv1.1"] = try_connect(host, port, "TLSv1.1")
	out["TLSv1.0"] = try_connect(host, port, "TLSv1.0")

	return out
end
