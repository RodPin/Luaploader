local lfs = require("lfs")
local helpers = {}

function helpers.buildFilePath(uploadDir, filename)
	return uploadDir .. "/" .. filename
end

function helpers.serve_static_file(filePath)
	print("serving file.. " .. filePath)
	-- Check if file exists
	local file = io.open(filePath, "rb")
	if not file then
		return nil, "File not found"
	end

	-- Read file content
	local file_content = file:read("*all")
	file:close()

	return file_content
end

function helpers.directoryExists(path)
	local attributes = lfs.attributes(path)
	if attributes and attributes.mode == "directory" then
		return true
	else
		return false
	end
end
return helpers
