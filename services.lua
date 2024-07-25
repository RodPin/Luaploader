local mime = require("mime")
local lfs = require("lfs")
local helpers = require("helpers")

local services = {}

local uploadDir = lfs.currentdir() .. "/uploads"

function services.getPhoto(captures, query, headers)
	local filename = captures[1]
	local filepath = helpers.buildFilePath(uploadDir, filename)
	return helpers.serve_static_file(filepath)
end

function services.deletePhoto(captures, query, headers)
	local filename = captures[1]
	local filepath = helpers.buildFilePath(uploadDir, filename)
	os.remove(filepath)
	return "SUCCESS"
end

function services.photoUpload(captures, query, headers, body)
	if body ~= nil and body ~= "" then
		local base64Data = body:match("base64,(.*)$")
		local decoded = mime.unb64(base64Data)
		local filename = captures[1]
		if not helpers.directoryExists(uploadDir) then
			lfs.mkdir(uploadDir)
		end
		local filepath = helpers.buildFilePath(uploadDir, filename)
		local file = io.open(filepath, "wb")

		if file then
			file:write(decoded)
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
