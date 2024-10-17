local Collisions = {}


-- https://stackoverflow.com/questions/401847/circle-rectangle-collision-detection-intersection/402010#402010
function Collisions.CircleAndRectangleOverlap(cx, cy, cr, rx, ry, rw, rh)
    local circle_distance_x = math.abs(cx - rx - rw / 2)
    local circle_distance_y = math.abs(cy - ry - rh / 2)

    -- Check if both center are too far away to interect
    if circle_distance_x > (rw / 2 + cr) or circle_distance_y > (rh / 2 + cr) then
        return false


        -- Check if the circle is already inside the rectangle
    elseif circle_distance_x <= (rw / 2) or circle_distance_y <= (rh / 2) then
        return true
    end
    -- Check the distance from the center of the circle and the corner and then verify that the distance is not more than the radius of the circle
    return (math.pow(circle_distance_x - rw / 2, 2) + math.pow(circle_distance_y - rh / 2, 2)) <= math.pow(cr, 2)
end

-- Check Distance between the circle center and the coordinate point
-- If the distance is less than the circle radius, it means they are overlapping
function Collisions.CircleAndPointOverlap(cx, cy, cr, px, py)
    local dist = math.sqrt((cx - px) ^ 2 + (cy - py) ^ 2)
    return dist <= cr
end

-- Check Distance between the 2 cricle's center
-- If the distance is less than the radii, it means they are overlapping
function Collisions.CircleCollision(circleA, circleB)
    local dist = math.sqrt((circleA.x - circleB.x) ^ 2 + (circleA.y - circleB.y) ^ 2)
    return dist <= circleA.radius + circleB.radius
end

function Collisions.ClickOnPauseButton(mx, my, bx, by, bw, bh)
    if mx <= bx + bw and mx >= bx and my <= by + bh and my >= by then
        return true
    end
    return false
end

return Collisions
