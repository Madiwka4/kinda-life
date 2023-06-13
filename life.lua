life = Class{}

function life:init( y , x , fat, undead)
	self.RED = 255
	self.GREEN = 255
	self.BLUE = 255
	self.x = x 
	self.y = y 
	self.width = fat  
	self.height = fat  
    self.fat = fat 
    self.dead = false 
    self.multiplycounter = 1
    self.closest = 999999
    self.childrenCount = 0
    self.childThreshold = math.random(30, 100)
    self.childMaxThreshold = math.random(1, 5)
    self.hasRandomTarget = false
    self.sx = x 
    self.sy = y
    self.lifeSpan = math.random(50, 100)
    if undead then
        self.lifeSpan = undead
    end
end

function life:update(dt)
    if not self.dead then 
        self.lifeSpan = self.lifeSpan - dt*0.7
        print("LIFE: " .. self.lifeSpan)
        if self.fat <= 0 or self.lifeSpan <= 0 then 
            self.dead = true
        end 
        self.fat = self.fat - self.width*0.001*dt
        if not self:checkIfEating() then 
            self:lookForFood(dt)
        end
        if self.width > self.childThreshold and self.childrenCount < self.childMaxThreshold then 
            table.insert(bugs, life(self.y+self.width, self.x+self.width, self.fat/2+5))
            self.width = self.width/2 
            self.fat = self.fat/2-5
            self.childrenCount = self.childrenCount + 1
        end


    end
    print(self.fat) 
end 
function life:lookForFood(dt)
    self.closest = 9000000
    print("looking for food...")
    for i, food in ipairs(edibles) do 
        dist = math.sqrt((self.x - food.x)^2 + (self.y-food.y)^2)
        if dist < self.closest and dist < self.fat*20 then 
            self.closest = math.sqrt((self.x - food.x)^2 + (self.y-food.y)^2)
            self.sx, self.sy = food.x, food.y 
            print("going to " .. i)
            self.hasRandomTarget = true
        elseif not self.hasRandomTarget then
            self.sx, self.sy = math.floor(math.random(0, VIRTUAL_WIDTH)), math.floor(math.random(0, VIRTUAL_HEIGHT))
            print(self.sx)
            self.hasRandomTarget = true
        end
    end  
    if self.hasRandomTarget and math.abs(self.x - self.sx) < 5 and math.abs(self.y-self.sy) < 5 then 
        print("going random" .. self.sx.. " " .. self.sy)
        self.sx, self.sy = math.floor(math.random(0, VIRTUAL_WIDTH)), math.floor(math.random(0, VIRTUAL_HEIGHT))
        self.hasRandomTarget = false 
    end
    self:goTo(self.sx, self.sy, dt)
end 
function life:goTo(x, y, dt)
    self.speed = (10 + self.fat * 0.5 )
    if (x-self.x) ~= 0 then 
    self.m = (y-self.y)/(x-self.x)
    if y-self.y > 0 then 
        self.m = math.abs(self.m)
    elseif y-self.y < 0 and self.m > 0 then 
            self.m = -self.m
        end 
    else 
        if y-self.y > 0 then 
            self.m = 1
        elseif y-self.y < 0 then 
                self.m = -1 
        else 
            self.m = 0
        end
    end
    if self.m > 1 or self.m < -1 then 
        self.speed = math.abs(self.speed / (self.m))
    end
    if (self.x < x) then 
        self.x = self.x + self.speed * dt
        self.y = self.y + (self.speed* self.m * dt )
        print("go right" .. self.fat ..x .. " " ..y )
    elseif self.x > x then  
        self.x = self.x - self.speed* dt
        self.y = self.y + (self.speed* self.m * dt )
        print("go left" .. self.fat ..x .. " " ..y)
    else 
        self.y = self.y + (self.speed* self.m * dt )
        print("go vertical" .. self.fat ..x .. " " ..y)
    end
    --if (self.y < y) then 
    --    self.y = self.y + (10 * dt + self.fat * 0.5 * dt)
    --    print("go down" .. self.fat)
    --elseif self.y > y then  
    --    print("go up" .. self.fat)
    --    self.y = self.y - (10 * dt + self.fat * 0.5 * dt)
    --end 
    self.fat = self.fat - self.fat * self.width * 0.0003 * dt
    print(self.m .. " " .. self.speed * self.m)
    print((self.speed* self.m * dt ))
end 
function life:checkIfEating()
    for i, food in ipairs(edibles) do 
        if math.abs(self.x - food.x) < 10 and math.abs(self.y-food.y) < 10 then 
            self.fat = self.fat + food.fat
            self.width = self.width + food.fat/2
            table.remove(edibles, i)
            print("yum")
            return true 
        end
    end  
    return false 
end 

function life:render()
	love.graphics.setColor(self.RED, self.GREEN, self.BLUE, self.fat*20/200)
    love.graphics.circle('fill', self.x, self.y, self.width)
    love.graphics.setColor(255,255,255,255)
    love.graphics.printf(math.floor(self.lifeSpan), smallfont, self.x+self.width, self.y, self.width*10, 'left')
	love.graphics.setColor(255, 255, 255, 255)
end