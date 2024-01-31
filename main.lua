local testdata = {
    str = "Hello, World!",
    num = 123,
    bool = true,
    arr = {1, 2, 3},
    obj = {a = 1, b = 2, c = 3},
}
json = require("json")

--[[ local jpegdata = love.filesystem.read("test.jpg")
local encodedjson = json.encode(testdata)

-- write the json to the jpeg data to keep hidden data
local encodedjpeg = jpegdata .. "--JSON_START--" .. encodedjson .. "--JSON_END--"

-- write the encoded jpeg to a file
love.filesystem.write("encoded.jpg", encodedjpeg)

-- read the encoded jpeg from a file
local encodedjpeg = love.filesystem.read("encoded.jpg")

-- find the start and end of the json
local start = encodedjpeg:find("--JSON_START--")
local end_ = encodedjpeg:find("--JSON_END--")

-- extract the json from the jpeg
local encodedjson = encodedjpeg:sub(start + 14, end_ - 1)
print(encodedjson)

-- decode the json
local testdata = json.decode(encodedjson)

-- print the decoded json
for k, v in pairs(testdata) do
    print(k, v)
end
 ]]

function love.keypressed(key)
    -- when space is pressed, take a screenshot and encode the json into it and save it
    if key == "space" then
        love.graphics.captureScreenshot(function(data)
            local newdata = data:encode("png")
            love.filesystem.write("encoded.png", newdata)
            newdata = love.filesystem.read("encoded.png")
            local encodedjson = json.encode(testdata)
            local start = newdata:find("IEND") - 1
            local end_ = newdata:len()
            local encodedpng = newdata:sub(1, start) .. "--JSON_START--" .. encodedjson .. "--JSON_END--" .. newdata:sub(end_)
            love.filesystem.write("encoded.png", encodedpng)
        end)

        -- when enter is pressed, read the encoded png and extract the json from it
    elseif key == "return" then
        local encodedpng = love.filesystem.read("encoded.png")
        local start = encodedpng:find("--JSON_START--")
        local end_ = encodedpng:find("--JSON_END--")
        local encodedjson = encodedpng:sub(start + 14, end_ - 1)
        local testdata = json.decode(encodedjson)
        for k, v in pairs(testdata) do
            print(k, v)
        end
    end
end