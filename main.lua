--some config variables
STATE = "menu"

BALL_X = 100
BALL_Y = 100
BALL_WIDTH = 25
BALL_HEIGHT = 25
BALL_VX = 300
BALL_VY = 300

PADDLE_HEIGHT = 150
PADDLE_WIDTH = 25

PADDLE_RIGHT_X = 750
PADDLE_RIGHT_Y = 100
PADDLE_RIGHT_SPEED = 250

PADDLE_LEFT_X = 30
PADDLE_LEFT_Y = 300
PADDLE_LEFT_SPEED = 200

STAGE_WIDTH = love.graphics.getWidth()
STAGE_HEIGHT = love.graphics.getHeight()


LEFT_SCORE = 0
RIGHT_SCORE = 0

SINGLE_PLAYER = true


menu_line_y = 280

--drawing objects
function love.draw() 
	love.graphics.setColor(255,255,255)
	
	if STATE == "menu" then
		love.graphics.rectangle("fill", 340,menu_line_y, 100, 1) --underline choice

		love.graphics.printf("ONE PLAYER", 7 * (STAGE_WIDTH / 16),7 * (STAGE_HEIGHT / 16), 200)
		love.graphics.printf("TWO PLAYER", 7 * (STAGE_WIDTH / 16), 8 * (STAGE_HEIGHT / 16), 200)

		if	love.keyboard.isDown("down") then
			menu_line_y = 320
			SINGLE_PLAYER = false
		elseif	love.keyboard.isDown("up") then
			menu_line_y = 280
			SINGLE_PLAYER = true
		end

		if love.keyboard.isDown("return") then
			STATE = "game"
		end
	end

	if STATE == "game" then 
		love.graphics.rectangle("fill",
			BALL_X, BALL_Y, BALL_WIDTH, BALL_HEIGHT
		)

		--a line in the middle 
		love.graphics.rectangle("fill",STAGE_WIDTH/2,0,1,STAGE_HEIGHT)

		love.graphics.rectangle("fill", PADDLE_RIGHT_X, PADDLE_RIGHT_Y, PADDLE_WIDTH, PADDLE_HEIGHT)
		love.graphics.rectangle("fill", PADDLE_LEFT_X, PADDLE_LEFT_Y, PADDLE_WIDTH, PADDLE_HEIGHT)


		-- Draw the score at the top of the screen
		love.graphics.printf(tostring(LEFT_SCORE), 3 * (STAGE_WIDTH / 8) , 10, 30)
		love.graphics.printf(tostring(RIGHT_SCORE), 5 * (STAGE_WIDTH / 8), 10, 30)
	end
end


--dt = time between each frame
function love.update(dt)

	if STATE == "menu" then
		if love.keyboard.isDown("down") then
		elseif love.keyboard.isDown("up") then
		end
	end 

	if STATE == "game" then		
		-- V is for velocity
		BALL_X = BALL_X + (BALL_VX * dt)
		BALL_Y = BALL_Y + (BALL_VY * dt)

		--the wall sides
		if BALL_X + 25 > (STAGE_WIDTH + 100) then
			LEFT_SCORE = LEFT_SCORE + 1
		    BALL_X = 400
		    BALL_Y = 300
		    if math.abs(math.random(2)) == 1 then
		    	BALL_VX = -BALL_VX
	    	end
	    elseif BALL_X < -100 then
	    	RIGHT_SCORE = RIGHT_SCORE + 1
		    BALL_X = 400
		    BALL_Y = 300
		    if math.abs(math.random(2)) == 1 then
		    	BALL_VX = -BALL_VX
	    	end
		elseif BALL_Y + 25 > 600 then
			BALL_Y = BALL_Y - 5
			BALL_VY = -BALL_VY
		elseif BALL_Y < 0 then
			BALL_Y = BALL_Y + 5
			BALL_VY = -BALL_VY 
		end


		if love.keyboard.isDown("down") and PADDLE_RIGHT_Y < (STAGE_HEIGHT - PADDLE_HEIGHT) then
	  		PADDLE_RIGHT_Y = PADDLE_RIGHT_Y + PADDLE_RIGHT_SPEED * dt
		elseif love.keyboard.isDown("up") and PADDLE_RIGHT_Y > 0 then
	  		PADDLE_RIGHT_Y = PADDLE_RIGHT_Y - PADDLE_RIGHT_SPEED * dt
		end


		if SINGLE_PLAYER == true then
			if(PADDLE_LEFT_Y + (PADDLE_HEIGHT / 2) < BALL_Y) then 
				PADDLE_LEFT_Y = PADDLE_LEFT_Y + 4
			elseif PADDLE_LEFT_Y + (PADDLE_HEIGHT / 2) > BALL_Y then
				PADDLE_LEFT_Y = PADDLE_LEFT_Y - 4
			end
		else 
			if love.keyboard.isDown("s") and PADDLE_LEFT_Y < (STAGE_HEIGHT - PADDLE_HEIGHT) then
		  		PADDLE_LEFT_Y = PADDLE_LEFT_Y + PADDLE_LEFT_SPEED * dt
			elseif love.keyboard.isDown("w") and PADDLE_LEFT_Y > 0 then
		  		PADDLE_LEFT_Y = PADDLE_LEFT_Y - PADDLE_LEFT_SPEED * dt
			end
		end

		-- Make the ball bounce against the right paddle
		-- Is the ball far enough to the right to touch the paddle?
		if BALL_X + BALL_WIDTH  > PADDLE_RIGHT_X and BALL_X <= PADDLE_RIGHT_X + PADDLE_WIDTH
			-- Is the ball above the bottom of the paddle?
			and BALL_Y + BALL_HEIGHT  >= PADDLE_RIGHT_Y
			-- Is the ball below the top of the paddle?
			and BALL_Y <= PADDLE_RIGHT_Y + PADDLE_HEIGHT
			then
				BALL_X = BALL_X - 5
				BALL_VX = -BALL_VX
		end


		-- Make the ball bounce against the left paddle
		if BALL_X <= PADDLE_LEFT_X + PADDLE_WIDTH
			and BALL_X >= PADDLE_LEFT_X
			and BALL_Y >= PADDLE_LEFT_Y
			and BALL_Y <= PADDLE_LEFT_Y + PADDLE_HEIGHT
			then
			-- Bounce!
			BALL_X = BALL_X + 5
			BALL_VX = -BALL_VX
		end
	end
end

