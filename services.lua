local base64 = require'base64'
local mime = require("mime")
local lfs = require "lfs"

local services = {}

local uploadDir = lfs.currentdir().."/uploads";

local function serve_static_file(filename)
    local file_path = uploadDir.."/"..filename
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

function directoryExists(path)
    local attributes = lfs.attributes(path)
    if attributes and attributes.mode == "directory" then
        return true
    else
        return false
    end
end

function services.getPhoto(captures, query, headers)
    local filename = captures[1]
    return serve_static_file(filename )
end



function services.photoUpload(captures, query, headers, body)
    if(body ~= nil and body ~= "")
        then
            local base64Data = body:match("base64,(.*)$")
            local decoded =  mime.unb64(base64Data)
            local filename = captures[1]
            if(not directoryExists(uploadDir))
                then
                    lfs.mkdir(uploadDir)
                end
            local file = io.open(uploadDir.."/"..filename, "wb")  -- Open file in binary mode
            if file then
                file:write(decoded)  -- Write the decoded binary data
                file:close()
                print("Image saved successfully as output.png")
            else
                print("Error: Unable to open file for writing")
            end
            return "SUCCESS"
        end

        return "ERROR"
    end


return services

