edible = Class{}

function edible:init( y , x , fat )
	self.RED = 255
	self.GREEN = 255
	self.BLUE = 255
	self.x = x 
	self.y = y 
	self.width = fat  
	self.height = fat  
    self.fat = fat 
    self.dead = false 
end

function edible:update(dt)

end 


function edible:render()
	love.graphics.setColor(self.fat*20/200, 0, 0, 1)
    love.graphics.circle('line', self.x, self.y, self.fat)
	love.graphics.setColor(255, 255, 255, 255)
end