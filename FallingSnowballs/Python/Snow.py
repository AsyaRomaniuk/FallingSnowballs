from tkinter import *
import random

class Snowball(object):
    def __init__(self, cx, cy, r, dx, dy, speed):
        self.cx, self.cy = cx, cy
        self.r = r
        self.dx, self.dy = dx, dy
        self.speed = speed
        self.id = None


    def draw_on_canvas(self):
        self.id = c.create_oval(self.cx + self.r, self.cy + self.r, self.cx - self.r, self.cy - self.r,
                                fill="snow", outline="snow")

    def move_on_canvas(self):
        c.move(self.id, self.dx*self.speed, self.dy*self.speed)
        self.cx, self.cy = c.coords(self.id)[0]+self.r, c.coords(self.id)[1]+self.r


    def __del__(self):
        c.delete(self.id)


def is_out_of_bounds(cx, cy) -> bool:
    if any((cx < 0, cx > W, cy > H)):
        return True
    else:
        return False


def create_snowballs(min_k, max_k, min_r, max_r, min_speed, max_speed):
    amount = random.randint(min_k, max_k)
    global snowballs_count
    snowballs_count += amount
    txt_snowballs_count.config(text=str(snowballs_count))
    for i in range(amount):
        r = random.randint(min_r, max_r)
        x, y = random.randint(0, W), -r
        dx, dy = (-random.random())**random.randint(1, 2), random.random()
        speed = random.randint(min_speed, max_speed)
        snowballs.insert(0, Snowball(x, y, r, dx, dy, speed))
        snowballs[0].draw_on_canvas()


def move_snowballs():
    global snowballs_count
    create_snowballs(0, 10, 1, 15, 5, 25)
    for snowball in snowballs:
        snowball.move_on_canvas()
        if is_out_of_bounds(snowball.cx, snowball.cy):
            snowballs.remove(snowball)
            snowballs_count -= 1
    root.after(time, move_snowballs)


if __name__ == "__main__":
    time = 10
    snowballs = []
    snowballs_count = 0
    root = Tk()
    root.attributes("-topmost", True, "-fullscreen", True,
                    "-transparentcolor", "SystemButtonFace")
    W, H = root.winfo_screenwidth(), root.winfo_screenheight()
    c = Canvas(root)
    txt_snowballs_count = Label(root, text=str(snowballs_count))
    txt_snowballs_count.pack()
    create_snowballs(0, 10, 1, 15, 5, 25)
    c.pack(fill=BOTH, expand=True)
    root.after(time, move_snowballs)
    root.mainloop()
