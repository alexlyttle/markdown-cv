--[[
ads-metrics – Read metrics from JSON file and replace in text

Copyright (c) 2023 Alex Lyttle

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]
local metrics = {}
local fields = {
    papers = {"basic stats", "number of papers"},
    reads = {"basic stats", "total number of reads"},
    downloads = {"basic stats", "total number of downloads"},
    citing_papers = {"citation stats", "number of citing papers"},
    citations = {"citation stats", "total number of citations"},
    h_index = {"indicators", "h"},
    papers_ref = {"basic stats refereed", "number of papers"},
    reads_ref = {"basic stats refereed", "total number of reads"},
    downloads_ref = {"basic stats refereed", "total number of downloads"},
    citing_papers_ref = {"citation stats refereed", "number of citing papers"},
    citations_ref = {"citation stats refereed", "total number of citations"},
    h_index_ref = {"indicators refereed", "h"}
}

-- Read file content
local function read_file(filename)
    local file = io.open(filename, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

-- Get metrics from file
local function get_metrics(meta)
    if meta["metrics"] == nil then return end
    -- This is an Inlines so get the first element
    local filename = meta["metrics"][1].text
    if filename then
        local content = read_file(filename)
        if content then
            local data = pandoc.json.decode(content)
            -- Loop through fields and add to metrics
            for key, value in pairs(fields) do
                if data[value[1]] and data[value[1]][value[2]] then
                    metrics[key] = math.floor(data[value[1]][value[2]])
                end
            end
        end
    end
end

-- Replace metrics in text
local function replace_metrics(elem)
    for key, value in pairs(metrics) do
        local pattern = "{{" .. key .. "}}"
        if string.find(elem.text, pattern, 1, true) then
            -- Substitute value in place of key in text
            elem = pandoc.Str(string.gsub(elem.text, pattern, value))
        end
    end
    return elem
end

return {
    {Meta = get_metrics}, 
    {Str = replace_metrics}
}
