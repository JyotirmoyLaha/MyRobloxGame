--[[
    MoneyFormatter.luau
    ====================
    NUMBER FORMATTING UTILITY FOR MONEY DISPLAY
    
    📍 Location: ReplicatedStorage
    📝 Type: ModuleScript (Shared)
    
    🎯 PURPOSE:
    Formats large money numbers into human-readable abbreviations:
      - 999      → "999"
      - 1,500    → "1.50K"
      - 2,300,000 → "2.30M"
      - 5,000,000,000 → "5B"
      - 1,200,000,000,000 → "1.20T"
    
    🔧 HOW TO USE:
      local MoneyFormatter = require(ReplicatedStorage.MoneyFormatter)
      local text = MoneyFormatter:Format(1500) -- Returns "1.50K"
    
    💡 Numbers below 1K show no decimals.
    💡 Whole numbers at any tier show no decimals (e.g., 2M not 2.00M).
]]

local MoneyFormatter = {}

function MoneyFormatter:Format(amount)
    if amount >= 1000000000000 then -- T (Trillion)
        local trillion = amount / 1000000000000
        if trillion % 1 == 0 then
            return tostring(math.floor(trillion)) .. "T"
        else
            return string.format("%.2f", trillion) .. "T"
        end
    elseif amount >= 1000000000 then -- B (Billion)
        local billion = amount / 1000000000
        if billion % 1 == 0 then
            return tostring(math.floor(billion)) .. "B"
        else
            return string.format("%.2f", billion) .. "B"
        end
    elseif amount >= 1000000 then -- M (Million)
        local million = amount / 1000000
        if million % 1 == 0 then
            return tostring(math.floor(million)) .. "M"
        else
            return string.format("%.2f", million) .. "M"
        end
    elseif amount >= 1000 then -- K (Thousand)
        local thousand = amount / 1000
        if thousand % 1 == 0 then
            return tostring(math.floor(thousand)) .. "K"
        else
            return string.format("%.2f", thousand) .. "K"
        end
    else
        -- NO DECIMALS for numbers below 1K
        return tostring(math.floor(amount))
    end
end

return MoneyFormatter
