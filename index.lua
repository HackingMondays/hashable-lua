Json = require('cjson')

print('hello')

function hashWord (word)
    -- TODO Your code here
    return string.len(word)
end


blue = '\x1b[34m'
red = '\x1b[31m'
green = '\x1b[32m'
white = '\x1b[37m'
yellow = '\x1b[33m'
cyan = '\x1b[36m'
reset = '\x1b[0m'

function len(arr)
    n = 0
    if arr == nil then
        return 0
    end
    for i, v in pairs(arr) do
        n = n + 1
    end
    return n
end

function timeKey(key)
    return key .. ' took ' .. blue
end

times = {}
function time(key)
    times[key] = os.clock()
end

function timeEnd(key)
    elapsed = os.clock() - times[key]
    print(timeKey(key) .. elapsed .. 'ms' .. reset)
end

function loadJson(filename)
    local contents = ''
    local myTable = {}
    local file, error = io.open(filename, 'r')
    if error then
        print(error)
    end
    if file then
        -- read all contents of file into a string
        local contents = file:read( '*a' )
        myTable = Json.decode(contents);
        io.close( file )
        return myTable
    end
    return myTable
end

function firstTen(arr)
    newArr = {}
    i = 0
    for key, value in pairs(arr) do
        newArr[key] = value
        i = i + 1
        if (i > 10) then
            return newArr
        end
    end
    return newArr
end

function arrToString(arr)
    s = ''
    for key, value in pairs(arr) do
        s = s .. ', ' .. value
    end
    return s
end

function testHash(hashFunction)
    time('load words')
    words = loadJson('words_dictionary.json')

    timeEnd('load words')

    print('You are about to work on ' .. green .. len(words) .. reset .. ' words')

    results = {}

    time('iterate over words')
    for word, i in pairs(words) do
        hash = hashFunction(word)
        actualWords = results[hash]
        if actualWords then
            table.insert(actualWords, word)
        else
            results[hash] = { word }
        end
    end
    timeEnd('iterate over words')

    if (len(results) < len(words)) then
        for hash, words in pairs(results) do
            if (len(words) > 1) then
                print(
                'Found:' .. white .. arrToString(firstTen(words)) .. reset .. ' for ' .. cyan .. hash .. reset ..
                ' so ' .. red .. len(words) .. reset .. 'collisions'
                )
            end
        end
        collisionCount = len(words) - len(results)
        print('There was a total of ' .. red .. collisionCount .. reset .. 'collisions')
    else
        print(green .. 'WOW, no collision' .. reset)
    end
end


testHash(hashWord)
