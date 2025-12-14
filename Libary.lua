-- MyLibrary.lua
local MyLibrary = {}

function MyLibrary:HelloWorld()
    print("Hello from MyLibrary!")
end

function MyLibrary:CreateWindow(options)
    print("Creating window with title:", options.Title)
    -- return a fake window object
    return {Title = options.Title}
end

return MyLibrary
