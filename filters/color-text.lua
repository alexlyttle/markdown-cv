--[[
color-text.lua - Color text by adding the [text]{color="colorname"} attribute to 'text'. 

Source: https://bookdown.org/yihui/rmarkdown-cookbook/font-color.html#lua-color
License: https://creativecommons.org/licenses/by-nc-sa/4.0/
Reference: Xie, Y., Dervieux, C., & Riederer, E. (2021). R markdown cookbook. C&H/CRC Press. Accessed: October 27, 2023
]]
Span = function(el)
    color = el.attributes['color']
    -- if no color attribute, return unchanged
    if color == nil then return el end
    
    -- transform to <span style="color: red;"></span>
    if FORMAT:match 'html' then
      -- remove color attributes
      el.attributes['color'] = nil
      -- use style attribute instead
      el.attributes['style'] = 'color: ' .. color .. ';'
      -- return full span element
      return el
    elseif FORMAT:match 'latex' then
      -- remove color attributes
      el.attributes['color'] = nil
      -- encapsulate in latex code
      table.insert(
        el.content, 1,
        pandoc.RawInline('latex', '\\textcolor{'..color..'}{')
      )
      table.insert(
        el.content,
        pandoc.RawInline('latex', '}')
      )
      return el.content
    else
      -- for other format return unchanged
      return el
    end
  end
