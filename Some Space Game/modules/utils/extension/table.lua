
unpack = unpack or table.unpack

function table.Copy( tbl )
    if tbl == nil then return nil end

    local tCopy = {}

    for k, v in pairs( tbl ) do
        tCopy[ k ] = v
    end

    return tCopy
end

function table.PrintElements( tbl )
    for k, v in pairs( tbl ) do
        print( k, "=" .. tostring( v ) )
    end
end
PrintTable = table.PrintElements

function table.HasValue( tbl, val )
    for k, v in pairs( tbl ) do
        if v == val then
            return true
        end
    end

    return false
end

function table.GetKeyFromValue( tbl, val )
    local keys = {}

    for k, v in pairs( tbl ) do
        if v == val then
            table.insert( keys, k )
        end
    end

    return unpack( keys )
end

function table.RemoveByValue( tbl, val )
    for k, v in pairs( tbl ) do
        if v == val then
            table.remove( tbl, k )
        end
    end
end

function table.GetKeys( tbl )
    local keys = {}

    for k, v in pairs( tbl ) do
        table.insert( keys, k )
    end

    return keys
end
