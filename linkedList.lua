local LinkedList = {}

function LinkedList:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    
    instance.head = nil
    instance.previousNode = nil
    instance.length = 0
    
    return instance
end

function LinkedList:begin()
    if self.head then
        self.previousNode = nil
        self.currentNode = self.head
        return self.head.value
    end    
end

function LinkedList:next()
    if (self.currentNode and self.currentNode.nextNode) then
        self.previousNode = self.currentNode
        self.currentNode = self.currentNode.nextNode
        return self.currentNode.value
    end
    return nil
end

function LinkedList:last() 
    if self:begin() then
        while self:next() do end
        return self.currentNode.value
    end
    return nil
end

function LinkedList:push(obj)
    local node = {
        value = obj,
        nextNode = self.head,
        previousNode = nil
    }
    self.head = node
    self.length = self.length + 1
end

function LinkedList:popBack()
    if self:last() then
        local node = self.currentNode
        if (self.previousNode) then
            self.previousNode.nextNode = nil
        end
        self.length = self.length - 1
        if self.length == 0 then
            self.head = nil
            self.currentNode = nil
            self.previousNode = nil
        end
        return node.value
    end
    return nil
end

function LinkedList:removeHere()
    local current = self.currentNode
    if (not current) then return nil end
    
    local nextNode = current.nextNode
    local previous = self.previousNode
    if nextNode then
        if previous then --case: { o -> O -> o }
            previous.nextNode = nextNode
        else --case: { _ -> O -> o }
            self.head = nextNode
        end
        self.currentNode = nextNode
        current.nextNode = nil
    else
        if previous then --case: { o -> O -> _ }
            self.currentNode = previous
            current.nextNode = nil
            self.previousNode = nil

        else --case: { _ -> O -> _ }
            self.head = nil
            self.currentNode = nil
            self.previousNode = nil
        end
    end
    self.length = self.length - 1
    return current.value
end

function LinkedList:find(value) 
    local currentValue = self:begin()
    if (not currentValue) then return false end
    if currentValue == value then return true end
    
    currentValue = self:next()
    while currentValue do
        if currentValue == value then return true end
        currentValue = self:next()
    end

    return false
end
    
function LinkedList:toArray()
    if (not self:begin()) then return nil end
    local arr = { self.currentNode.value }
    while self:next() do
        arr.push(self.currentNode.value)
    end
    return arr
end

function LinkedList:toString()
    if (not self:begin()) then return nil end
    local str = "{ "..self.currentNode.value
    while self:next() do
        str = str..", "..self.currentNode.value
    end
    str = str.." }"
    return str
end