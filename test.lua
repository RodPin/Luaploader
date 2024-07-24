

local socket = require("socket")
local http = require("socket.http")
local ltn12 = require("ltn12")
local lfs = require "lfs" 
local function serve_static_file(filename)
    local file_path = lfs.currentdir().."/"..filename
    print("file_path =>"..file_path)
    -- Check if file exists
    local file = io.open(file_path, "rb")
    if not file then
        return nil, "File not found"
    end

    -- Read file content
    local file_content = file:read("*all")
    file:close()

    return file_content
end

local function handle_request(client)
    -- Read request
    local request_line = client:receive()
    if not request_line then
        return
    end

    local method, path = request_line:match("(%a+)%s+(%S+)")
    if method ~= "GET" then
        client:send("HTTP/1.1 405 Method Not Allowed\r\n\r\n")
        return
    end

    -- Serve static files
    local filename = path:sub(2)  -- Remove leading slash
    local content, err = serve_static_file(filename)

    if not content then
        client:send("HTTP/1.1 404 Not Found\r\n\r\n")
    else
        client:send("HTTP/1.1 200 OK\r\nContent-Length: " .. #content .. "\r\n\r\n")
        client:send(content)
    end
end

local server = socket.bind("*", 8080)

print("Server listening at http://localhost:8080/")

while true do
    local client = server:accept()
    if client then
        handle_request(client)
        client:close()
    end
end

    print("filename",filename)
