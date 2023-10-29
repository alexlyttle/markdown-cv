--[[
highlight-authors – highlight authors of your choice appearing in the bibliography

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
local authors = nil
local Highlight = pandoc.Strong  -- default highlight type is bold
local pattern = "^refs[-_]?([-_%w]*)$"  -- Assume same pattern as in multibib.lua
-- Supported highlight types
local highlight_types = {
  bold = pandoc.Strong,
  italic = pandoc.Emph,
  underline = pandoc.Underline,
  smallcaps = pandoc.SmallCaps
}

local highlight_author_filter = {
  Para = function(elem)
    if elem.t ~= "Para" then return elem end
    for _, author in ipairs(authors) do
      for k, _ in ipairs(elem.content) do
        local n = 0
        -- Assume the author is a list of Str and Space elements and always starts and ends in a Str element
        for i, a in ipairs(author) do
          -- This assumes name has only string and space. Check other types of elements
          if not (
            (elem.content[k+i-1].t == "Str" and a.t == "Str" and elem.content[k+i-1].text:find(a.text, 1, true)) 
            or (elem.content[k+i-1].t == "Space" and a.t == "Space")
          ) then break end
          n = i
        end
        -- If we reached the end, then the author was found
        if #author == n then
          local s, _ = elem.content[k].text:find(author[1].text, 1, true)  -- ensure plain text search with plain=true
          local _, e = elem.content[k+n-1].text:find(author[n].text, 1, true)  -- the 1 means start at the beginning of string
          local srest = elem.content[k].text:sub(1, s-1)   -- string before author
          local erest = elem.content[k+n-1].text:sub(e+1)  -- string after author
          table.insert(elem.content, k, srest)
          table.insert(elem.content, k+1, Highlight { pandoc.Str(pandoc.utils.stringify(author)) } )
          table.insert(elem.content, k+2, erest)
          for i = 1, n do
            table.remove(elem.content, k+3)
          end
        end
      end
    end
  return elem
  end
}

local function compare_lists(a, b)
  -- Function to compare the length of authors
  return #a > #b
end

local function get_meta(meta)
  authors = meta["highlightauthors"] or authors
  if authors ~= nil then
    table.sort(authors, compare_lists)
  end
  local highlight_type = meta["highlighttype"]
  if highlight_type and highlight_type[1].t == "Str" then
    -- If the specified highlight type is a string then attempt to find equivalent pandoc type
    -- If not found, then use default highlight type
    Highlight = highlight_types[highlight_type[1].text] or Highlight
  end
end

local function highlight_authors (div)
    if not authors then return nil end  -- don't bother if no authors
    if string.match(div.identifier, pattern) then
      return pandoc.walk_block(div, highlight_author_filter)
    end
    return nil
end

return {
  {Meta = get_meta},
  {Div = highlight_authors}
}
