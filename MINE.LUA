--[[
@title 2d Minecraft
@param n Gamemode
@default n 1
@values n Survival Creative
@param o Load World
@default o 2
@values o Yes No
@param a blockX
@default a 0
@param b blockY
@default b 0
--]]
-- About above comment: CHDK's script parameter must have a @default assign or else they will be displayed wrong.
-- The Load World option default is No,because,the players haven't a vaild map.

map = {}

-- use local variables for speed and mem
-- maybe this should in init()
if o == 0 then -- load existing map
worldPath = file_browser("A/CHDK/SCRIPTS") -- maybe in "A/CHDK/GAMES" ?
local rawSave = io.open(world)   --("A/CHDK/SCRIPTS/TESTG.TXT","r")
-- world1 is not easier to understand code,prev should use worldPath(java style,lower Camel Case,:))
world = rawSave:read("*line")
for i = 1,1100 do
map[i] = tonumber(world:sub(i,i))
end
rawSave:close()
end

lookX=0
lookY=0
play=1
h=1
l=1
load=1
blockX = a
blockY = b
blocks={"air","dirt","stone","planks","wood","leaves","sand"}
texture={266,94,23,92,95,263,174}
inv={0,0,0,0,0,0,0}
invnt={}
for i=1,27 do
invnt[i]={0,0}
end
holding=(blocks[h])
pi=0
po=0
ps=0
z=1
mode="move"
change=0
items={"planks"}

function updateInv()
for i=1,6 do
if inv[i+1]<65 then
invnt[i]={i+1,inv[i+1]}
end
end
end
updateInv()

function block()
if n==0 and holding=="air" then
inv[map[l]]=(inv[map[l]])+1
map[l]=1
ps=1
render()
end
if h~=1 and n==0 and inv[h]~=0 then
map[l]=(h)
inv[h]=(inv[h])-1
render()
end
if n==1 then
map[l]=(h)
render()
end
end

function breakBlock(s)
if n==0 then
if (s==200) then
block()
end
else
block()
end
end

function inventory()
updateInv()
cursorX=0
cursorY=0
draw_rect_filled(48,30,311,210,17,17,1)
i=0
for y=0,2 do
for x=0,8 do
i=i+1
draw_rect_filled(x*28+2+53,y*27+102,x*28+27+53,y*27+126,22,22,1)
if invnt[i][1]~=0 and invnt[i][1]~=nil and invnt[i][2]~=0 then
draw_rect_filled(x*28+5+53,y*27+5+100,x*28+24+53,y*27+23+100,texture[invnt[i][1]],texture[invnt[i][1]],1)
if (invnt[i][2]/10) < 1 then
draw_string(x*28+19+53,y*27+13+100,invnt[i][2],258,22)
else
draw_string(x*28+13+53,y*27+13+100,invnt[i][2],258,22)
end
end
end
end
end

function hotbar()
draw_rect_filled(40,190,311,215,17,17,1)
end

function saveW()
print(world)
save=io.open(world,"w")--("A/CHDK/SCRIPTS/TESTG.TXT","w")
for i=1,1100 do
if map[i]==nil then
map[i]=1
end
save:write(tostring(map[i]))
--save:write("\n")
end
save:close()
print "saved"
end

function key()
if (mode=="look") then
if (is_pressed"right") and (lookX<340) then
lookX=lookX+blockX
l=l+1
render()
end
if (is_pressed"left") and (lookX>0) then
lookX=lookX-blockX
l=l-1
render()
end
if is_pressed"up" then
lookY=lookY-blockY
l=l-100
render()
end
if is_pressed"down" then
lookY=lookY+blockY
l=l+100
render()
end
else
if is_pressed"left" and load>1 then
l=l-1
load=load-1
render()
end
if is_pressed"right" and load<83 then
l=l+1
load=load+1
render()
end
end
if is_pressed"set" and ps==0 then
if (map[l]==1) then
block()
else
if (holding=="air") then
sleep (10)
z=z+1
breakBlock(z)
end
end
end
if (is_pressed "set"==false) then
z=0
ps=0
end
if is_pressed"zoom_in" then
if (pi==0) then
if h==7 then
h=0
end
if h<7 then
h=h+1
pi=1
holding=blocks[h]
hold()
end
end
end
if is_pressed"zoom_in"==false then
pi=0
end
if is_pressed"zoom_out" then
if po==0 then
if h==1 then
h=8
end
if h>1 then
h=h-1
po=1
holding=blocks[h]
hold()
end
end
end
if is_pressed"zoom_out"==false then
po=0
end
if is_pressed"menu" then
saveW()
end
if is_pressed"display" then
if (mode=="move") then
if change==0 then
change=1
mode="look"
end
end
if (mode=="look") then
if change==0 then
change=1
mode="move"
end
end
else
change=0
end
if is_pressed"face" then
inventory()
end
end

if o==1 then
for i=0,1099 do
map[d]=1
d=d+1
end
end

function render()
--hotbar()
i=load
for y=0,10 do
for x=0,17 do
X=x*blockX
Y=y*blockY
c=(texture[map[i]])
if map[i]==nil then
map[i]=1
c=texture[1]
end
if (map[i]~=2) or (map[i]==2 and map[i-100]~=1) then
draw_rect_filled(X,Y,X+(blockX-1),Y+(blockY-1),c,c,1)
draw_rect(lookX,lookY,lookX+(blockX-1),lookY+(blockY-1),257,2)
--draw_rect_filled(187,125,192,140,170,170,1)
end

if ((i>100) and (blocks[map[i]]=="dirt") and (blocks[map[i-100]]=="air")) then
draw_rect_filled(X,Y,X+(blockX-1),Y+blockY/4,160,160,1)
draw_rect_filled(X,Y+(blockY/4)+1,X+(blockX-1),Y+(blockY-1),c,c,1)
end

if ((i<1001) and (blocks[map[i]]=="sand") and (blocks[map[i+100]]=="air")) then
map[i]=1
map[i+100]=7
draw_rect_filled(X,Y,X+(blockX-1),Y+(blockY-1),174,174,1)
sleep(75)
draw_rect_filled(X,Y,X+(blockX-1),Y+(blockY-1),266,266,1)
end
i=i+1
end
i=i+82
end
hold()
--hotbar()
end

function hold()
draw_rect_filled(215,220,360,235,256,256,1)
draw_string(215,220,holding,258,259)
if n==0 and h~=1 then
draw_string(270,220,inv[h],258,259)
end
end

render()

while play==1 do
key()
--print ("")
end
