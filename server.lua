local app = require("milua")
local services = require("services")
app.add_handler(
    "POST",
    "/photo/...", 
    services.photoUpload)

app.add_handler(
    "GET",
    "/photo/...", 
    services.getPhoto)

app.shutdown_hook(function()
    print("Shutting down...")
end)

app.start()



