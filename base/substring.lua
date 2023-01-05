-- 
function mb_substring(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = sub_string_get_total_index(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = sub_string_get_total_index(str) + endIndex + 1;
    end

    if endIndex == nil then 
        return string.sub(str, sub_string_get_true_index(str, startIndex));
    else
        return string.sub(str, sub_string_get_true_index(str, startIndex), sub_string_get_true_index(str, endIndex + 1) - 1);
    end
end

function sub_string_get_total_index(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = sub_string_get_byte_by_count(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
end

function sub_string_get_true_index(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = sub_string_get_byte_by_count(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(curIndex >= index);
    return i - lastCount;
end

function sub_string_get_byte_by_count(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte>=192 and curByte<=223 then
        byteCount = 2
    elseif curByte>=224 and curByte<=239 then
        byteCount = 3
    elseif curByte>=240 and curByte<=247 then
        byteCount = 4
    end
    return byteCount;
end