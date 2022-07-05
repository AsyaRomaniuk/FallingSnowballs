require "tk"

class Snowball
	attr_accessor :cx, :cy, :id
    def initialize(cx, cy, r, dx, dy, speed)
        @cx, @cy = cx, cy
        @r = r
        @dx, @dy = dx, dy
        @speed = speed
        @id = nil
	end

    def draw_on_canvas
        @id = TkcOval.new($c, @cx + @r, @cy + @r, @cx - @r, @cy - @r,
                                "fill"=>"snow", "outline"=>"snow")
	end

    def move_on_canvas
        $c.move(@id, @dx*@speed, @dy*@speed)
        @cx, @cy = $c.coords(@id)[0]+@r, $c.coords(@id)[1]+@r
	end
end


def is_out_of_bounds?(cx, cy)
    if cx < 0 or cx > $W or cy > $H
        return true
    else
        return false
	end
end


def create_snowballs(min_k, max_k, min_r, max_r, min_speed, max_speed)
    amount = rand(min_k..max_k)
    $snowballs_count += amount
    $txt_snowballs_count.configure("text"=>$snowballs_count.to_s)
    for i in (0..amount-1)
        r = rand(min_r..max_r)
        x, y = rand(0..$W), -r
        dx, dy = (-rand())**rand(1..2), rand()
        speed = rand(min_speed..max_speed)
        $snowballs.insert(0, Snowball.new(x, y, r, dx, dy, speed))
        $snowballs[0].draw_on_canvas
	end
end


def move_snowballs
    create_snowballs(0, 10, 1, 15, 5, 25)
    for snowball in $snowballs
        snowball.move_on_canvas
        if is_out_of_bounds?(snowball.cx, snowball.cy)
			$c.delete(snowball.id)
            $snowballs.delete_at($snowballs.index(snowball))
            $snowballs_count -= 1
		end
	end
    $root.after($time, proc{move_snowballs})
end


$time = 10
$snowballs = Array.new
$snowballs_count = 0
$root = TkRoot.new
$root.attributes("topmost" => true, "fullscreen" => true,
  				 "transparentcolor" => "SystemButtonFace")
$W, $H = $root.winfo_screenwidth, $root.winfo_screenheight
$c = TkCanvas.new($root)
$txt_snowballs_count = TkLabel.new($root){ text $snowballs_count.to_s}
$txt_snowballs_count.pack
create_snowballs(0, 10, 1, 15, 5, 25)
$c.pack("fill"=>"both", "expand"=>true)
$root.after($time, proc{move_snowballs})
$root.mainloop
