function iaroko.insert_all(dest, src)
    assert(dest ~= nil)
    if src == nil then return end
    for _, e in ipairs(src) do
        dest[e] = true
    end
end

function iaroko.table_to_array(tbl)
    local result = {}
    for k, _ in pairs(tbl) do
        table.insert(result, k)
    end
    return result
end

