local a=require("cc.expect").expect local b={}b.X,b.Y=term.getSize()b.bigY=b.Y-2 b.startY=4 local c=0 if pocket then c=1 b.nameLen=8 b.infoLen=16 b.items=11 elseif turtle then c=2 b.nameLen=12 b.infoLen=25 b.items=4 else c=3 b.nameLen=16 b.infoLen=32 b.items=10 end local d={}for t,u in pairs(colors)do d[t]=u d[u]=t end for t,u in pairs(colours)do d[t]=u d[u]=t end local function e(t,u)term.clear()term.setCursorPos(1,1)print("Grabbing a file that is required to display this page...")print(t,"==>",u)if fs.exists(u)then return end local v=http.get(t)if v then print("Connected.")local w=v.readAll()v.close()local x=io.open(u,'w')if x then x:write(w):close()print("Complete.")else error("Failed to open "..tostring(u).." for writing.",2)end else error("Failed to connect to "..tostring(t),2)end end local function f(t,u)t=t or""local v=string.len(t)+1 local w,x=term.getCursorPos()local y=term.getSize()local z=false local A=-1 local B=false term.setCursorBlink(true)while true do local C=type(u)=="string"and string.rep(u:sub(1,1),string.len(t))or t term.setCursorPos(w,x)io.write(string.rep(' ',y-w+1))term.setCursorPos(w,x)local D=v-(y-w+1)if D>=0 then io.write(string.sub(C,D+1))else io.write(C)end local E=w+v-1 if E>y then E=y end term.setCursorPos(E,x)if B then local H=term.getBackgroundColor()term.setBackgroundColor(colors.white)io.write(' ')term.setBackgroundColor(H)end local F={os.pullEvent()}local G=F[1]if G=="char"then local H=F[2]if z then t=string.sub(t,1,v-1)..H..string.sub(t,v+1)else t=string.sub(t,1,v-1)..H..string.sub(t,v)end v=v+1 elseif G=="key"then local H=F[2]if H==keys.backspace then local I=v-2 if v-2<0 then I=0 end t=string.sub(t,1,I)..string.sub(t,v)v=v-1 if v<1 then v=1 end elseif H==keys.enter then term.setCursorBlink(false)print()return t elseif H==keys.right then v=v+1 if v>string.len(t)+1 then v=string.len(t)+1 end elseif H==keys.left then v=v-1 if v<1 then v=1 end elseif H==keys.up then v=1 elseif H==keys.down then v=string.len(t)+1 elseif H==keys.delete then t=string.sub(t,1,v-1)..string.sub(t,v+1)elseif H==keys.insert then if z then z=false term.setCursorBlink(true)os.cancelTimer(A)A=-1 B=false else z=true term.setCursorBlink(false)A=os.startTimer(0.4)end end elseif G=="timer"then local H=F[2]if H==A then B=not B A=os.startTimer(0.4)end end end end local function g(t,u,v,w)if type(t)~=u then error(v.." (expected "..u..", got "..type(t)..")",w and w+1 or 3)end end local function h(t,u,v,w)if type(t)~="string"then error("Check failure: not string",2)end if string.len(t)>u then error("Page layout string "..v.." is too long (max: "..tostring(u)..", at: "..tostring(string.len(t))..")",w and w+1 or 3)end end local function i(t)g(t,"table","Page layout is not a table.")g(t.name,"string","Page: name is of wrong type.")local u="Page "..t.name..": %s is of wrong type."g(t.platform,"string",string.format(u,"platform"))if t.platform=="all"then elseif pocket and t.platform~="pocket"or turtle and t.platform~="turtle"or not pocket and not turtle and(t.platform=="pocket"or t.platform=="turtle")then error("Menu is designed for a different platform ("..t.platform..").",2)end h(t.name,b.nameLen,"page.name")g(t.info,"string",string.format(u,"info"))h(t.info,b.infoLen,"page.info")g(t.bigInfo,"string",string.format(u,"bigInfo"))term.setCursorPos(1,1)local v=write(t.bigInfo)if v>2 then error("Page "..t.name..": bigInfo is too long and prints too many ".."lines.",2)end g(t.colors,"table",string.format(u,"colors"))g(t.colors.bg,"table",string.format(u,"colors.bg"))local w={"main"}for x=1,#w do g(t.colors.bg[w[x]],"string",string.format(u,"colors.bg."..w[x]))end g(t.colors.fg,"table",string.format(u,"colors.fg"))w={"error","main","title","info","listInfo","listTitle","bigInfo","selector","arrowDisabled","arrowEnabled","input"}for x=1,#w do g(t.colors.fg[w[x]],"string",string.format(u,"colors.fg."..w[x]))end if t.selections then for x=1,#t.selections do local y=t.selections[x]local z="Page "..t.name..", selection "..tostring(x)..": %s is of wrong type."local A="page.settings["..tostring(x).."].%s"g(y.title,"string",string.format(z,"title"))h(y.title,b.nameLen,string.format(A,"title"))g(y.info,"string",string.format(z,"info"))h(y.info,b.infoLen,string.format(A,"info"))g(y.bigInfo,"string",string.format(z,"bigInfo"))term.setCursorPos(1,1)local B=write(y.bigInfo)if B>2 then error("Page "..t.name..", selection "..tostring(x)..": bigInfo is too long and prints too many ".."lines (Unknown max length).",2)end end else t.selections={}end if t.settings then for x=1,#t.settings do local y=t.settings[x]local z="Page "..t.name..", setting "..tostring(x)..": %s is of wrong type."local A="page.settings["..tostring(x).."].%s"g(y.title,"string",string.format(z,"title"))h(y.title,b.nameLen,"title")g(y.bigInfo,"string",string.format(z,"bigInfo"))term.setCursorPos(1,1)local B=write(y.bigInfo)if B>2 then error("Page "..t.name..", setting "..tostring(x)..": bigInfo is too long and prints too many ".."lines (Unknown max length).",2)end g(y.setting,"string",string.format(z,"setting"))g(y.tp,"string",string.format(z,"tp"))if y.min then g(y.min,"number",string.format(z,"min"))end if y.max then g(y.max,"number",string.format(z,"max"))end if y.tp=="password"then g(y.store,"string",string.format(z,"store"))if y.store~="plain"and y.store~="sha256"and y.store~="sha256salt"and y.store~="kristwallet"then error(string.format("Page %s, setting %d: store is not of allowed ".."values (plain, sha256, sha256salt, kristwallet)",t.name,x),2)elseif y.store~="plain"then e("https://pastebin.com/raw/6UV4qfNF","/sha256.lua")end end end else t.settings={}end if t.subPages then for x=1,#t.subPages do local y=t.subPages[x]local z="Subpage %d: %s is of wrong type."g(y.name,"string",string.format(z,x,"name"))g(y.info,"string",string.format(z,x,"info"))g(y.bigInfo,"string",string.format(z,x,"bigInfo"))term.setCursorPos(1,1)local A=write(y.bigInfo)if A>2 then error("Page "..t.name..", subpage "..tostring(x)..": bigInfo is too long and prints too many ".."lines (Unknown max length).",2)end end else t.subPages={}end term.clear()end local function j(t,u)local v=#t.selections local w=#t.settings local x=#t.subPages if u>v then if u>v+w then if u==v+w+x+1 then return 1,{title=t.final or"Exit",info="",bigInfo=""}end if u>v+w+x then return 0 end return 3,t.subPages[u-v-w]end return 2,t.settings[u-v]end return 1,t.selections[u]end local function k(t)return#t.selections+#t.settings+#t.subPages end local function l(t,u,v)local w=tostring(settings.get(u.setting))local x,y=term.getSize()if w=="nil"then w="0"end while true do term.setCursorPos(b.nameLen+3,b.startY+v)io.write(string.rep(' ',x-14))term.setCursorPos(b.nameLen+3,b.startY+v)local z=tonumber(f(w))if not z then term.setCursorPos(b.nameLen+3,b.startY+v)io.write(string.rep(' ',x-14))term.setCursorPos(b.nameLen+3,b.startY+v)local A=term.getTextColor()term.setTextColor(d[t.colors.fg.error])io.write("Not a number.")term.setTextColor(A)os.sleep(2)else local A=true if u.min and z<u.min then A=false term.setCursorPos(b.nameLen+3,b.startY+v)io.write(string.rep(' ',x-14))term.setCursorPos(b.nameLen+3,b.startY+v)local B=term.getTextColor()term.setTextColor(d[t.colors.fg.error])io.write(string.format("Minimum: %d",u.min))term.setTextColor(B)w=tostring(u.min)end if u.max and z>u.max then A=false term.setCursorPos(b.nameLen+3,b.startY+v)io.write(string.rep(' ',x-14))term.setCursorPos(b.nameLen+3,b.startY+v)local B=term.getTextColor()term.setTextColor(d[t.colors.fg.error])io.write(string.format("Maximum: %d",u.max))term.setTextColor(B)w=tostring(u.max)end if A then return z else os.sleep(2)end end end end local function m(t,u,v)local w=tostring(d[settings.get(u.setting)])local x,y=term.getSize()if w=="nil"then w="?"end while true do term.setCursorPos(b.nameLen+3,b.startY+v)io.write(string.rep(' ',x-14))term.setCursorPos(b.nameLen+3,b.startY+v)local z=f(w)local A=tonumber(z)if A then if d[A]then return A else term.setCursorPos(b.nameLen+3,b.startY+v)io.write(string.rep(' ',x-14))term.setCursorPos(b.nameLen+3,b.startY+v)local B=term.getTextColor()term.setTextColor(d[t.colors.fg.error])io.write("Not a color.")term.setTextColor(B)os.sleep(2)end else if d[z]then return d[z]else term.setCursorPos(b.nameLen+3,b.startY+v)io.write(string.rep(' ',x-14))term.setCursorPos(b.nameLen+3,b.startY+v)local B=term.getTextColor()term.setTextColor(d[t.colors.fg.error])io.write("Not a color.")term.setTextColor(B)os.sleep(2)end end end end local function n(t,u,v)local w,x=term.getSize()while true do term.setCursorPos(2,b.startY+v)io.write(string.rep(' ',w-1))term.setCursorPos(2,b.startY+v)term.setTextColor(d[t.colors.fg.listTitle])io.write("Password:")term.setCursorPos(b.nameLen+3,b.startY+v)io.write(string.rep(' ',w-14))term.setCursorPos(b.nameLen+3,b.startY+v)term.setTextColor(d[t.colors.fg.input])local y=f("",'*')term.setCursorPos(2,b.startY+v)io.write(string.rep(' ',w-1))term.setCursorPos(2,b.startY+v)term.setTextColor(d[t.colors.fg.listTitle])io.write("Repeat:")term.setCursorPos(b.nameLen+3,b.startY+v)io.write(string.rep(' ',w-14))term.setCursorPos(b.nameLen+3,b.startY+v)term.setTextColor(d[t.colors.fg.input])local z=f("",'*')if y==z then local A if u.store=="sha256"or u.store=="sha256salt"or u.store=="kristwallet"then local B=require(".sha256")if u.store=="sha256salt"then A=math.random(1,100000)y=tostring(A)..","..y end if u.store=="kristwallet"then y="KRISTWALLET"..y end y=B.digest(y):toHex()if u.store=="kristwallet"then y=y.."-000"end end return y,A else term.setCursorPos(b.nameLen+3,b.startY+v)io.write(string.rep(' ',w-14))term.setCursorPos(b.nameLen+3,b.startY+v)local A=term.getTextColor()term.setTextColor(d[t.colors.fg.error])io.write("Not matching!")term.setTextColor(A)os.sleep(2)end end end local function o(t,u,v)local w,x=term.getSize()local y=false term.setTextColor(d[t.colors.fg.listTitle])term.setCursorPos(2,b.startY+v)io.write(string.rep(' ',w-1))term.setCursorPos(2,b.startY+v)io.write("You sure?")while true do term.setCursorPos(b.nameLen+3,b.startY+v)io.write(string.rep(' ',w-14))term.setCursorPos(b.nameLen+3,b.startY+v)term.setTextColor(d[t.colors.fg.input])io.write(y and"[ YES ] NO"or"  YES [ NO ]")local z,A=os.pullEvent("key")if A==keys.right or A==keys.left or A==keys.tab then y=not y elseif A==keys.enter then return y end end end local function p(t,u,v)local w,x=term.getSize()local y,z=j(t,u)local A if y~=2 then error("Dawg something happened!",2)end term.setCursorPos(b.nameLen+3,b.startY+v)term.setTextColor(colors[t.colors.fg.input])if z.tp=="string"then local B=f(settings.get(z.setting))settings.set(z.setting,B)settings.save(t.settings.location)A=B elseif z.tp=="number"then local B=l(t,z,v)settings.set(z.setting,B)settings.save(t.settings.location)A=B elseif z.tp=="color"then local B=m(t,z,v)settings.set(z.setting,B)settings.save(t.settings.location)A=B elseif z.tp=="boolean"then local B=settings.get(z.setting)if B==nil then B=true else B=not B end settings.set(z.setting,B)settings.save(t.settings.location)A=B elseif z.tp=="password"then if o(t,z,v)then local B,C=n(t,z,v)settings.set(z.setting,B)if C then settings.set(z.setting..".salt",C)end settings.save(t.settings.location)end A=""else local B=term.getTextColor()term.setTextColor(d[t.colors.fg.error])io.write(string.format("Cannot edit type '%s'.",z.tp))term.setTextColor(B)os.sleep(2)end return t.settings.location,z.setting,A,t end local function q(t,u,v)a(1,t,"table")a(2,u,"function","nil")a(3,v,"number","nil")u=u or function()end local w=1 local x=1 local y=1 local z={}local A=false local B local C i(t)if not t.settings.location then t.settings.location=".settings"end settings.load(t.settings.location)if v then B=os.startTimer(v)end local function D()while true do term.setBackgroundColor(colors[t.colors.bg.main])term.setTextColor(colors[t.colors.fg.title])term.clear()term.setCursorPos(1,1)io.write(t.name)term.setCursorPos(1,2)term.setTextColor(colors[t.colors.fg.info])io.write(t.info)for K=0,b.items-1 do local L,M=j(t,y+K)term.setCursorPos(2,5+K)if L==1 then term.setTextColor(colors[t.colors.fg.listTitle])io.write(M.title)term.setCursorPos(b.nameLen+3,5+K)term.setTextColor(colors[t.colors.fg.listInfo])io.write(M.info)elseif L==2 then local N=settings.get(M.setting)if type(N)=="string"and string.len(N)>b.infoLen then N=N:sub(1,b.infoLen-3)N=N.."..."end term.setTextColor(colors[t.colors.fg.listTitle])io.write(M.title)term.setCursorPos(b.nameLen+3,5+K)term.setTextColor(colors[t.colors.fg.listInfo])if M.tp=="string"or M.tp=="number"then io.write(N or"Error: empty")elseif M.tp=="boolean"then if N==true then io.write("  false [ true ]")elseif N==false then io.write("[ false ] true")else io.write("? false ? true ?")end elseif M.tp=="color"then io.write(N and string.format("%s (%d)",d[N],N)or"? (nil)")elseif M.tp=="password"then local O={plain="Plaintext",sha256="sha256",sha256salt="sha256 + salt",kristwallet="Kristwallet"}if pocket then io.write(N and O[M.store]or"Not yet set")else io.write(N and"Stored as "..O[M.store]or"Not yet set")end else io.write(pocket and"Unsupported"or"Unsupported type.")end elseif L==3 then term.setTextColor(colors[t.colors.fg.listTitle])io.write(M.name)term.setTextColor(colors[t.colors.fg.listInfo])term.setCursorPos(b.nameLen+3,5+K)io.write(M.info)elseif L~=0 then io.write("Broken.")end end local F,G=j(t,w)term.setTextColor(colors[t.colors.fg.bigInfo])term.setCursorPos(1,b.Y-2)io.write(G.bigInfo)term.setCursorPos(1,b.startY+x)term.setTextColor(colors[t.colors.fg.selector])io.write(">")term.setCursorPos(1,b.startY+b.items+1)if y+b.items>k(t)+1 then term.setTextColor(colors[t.colors.fg.arrowDisabled])else term.setTextColor(colors[t.colors.fg.arrowEnabled])end io.write(string.char(31))term.setCursorPos(1,b.startY)if y>1 then term.setTextColor(colors[t.colors.fg.arrowEnabled])else term.setTextColor(colors[t.colors.fg.arrowDisabled])end io.write(string.char(30))local function H()w=w-1 if x==1 then y=y-1 end if y<1 then y=1 end x=x-1 if x<1 then x=1 end if w<1 then w=k(t)+1 x=(k(t)+1)<b.items and(k(t)+1)or b.items y=w-b.items+1 if y<1 then y=1 end end end local function I()w=w+1 if x==b.items then y=y+1 end x=x+1 if x>b.items then x=b.items end if w>k(t)+1 then w=1 y=1 x=1 end end local J=table.pack(os.pullEvent())if J[1]=="key"then A=true local K,L=table.unpack(J,1,2)if L==keys.up then H()elseif L==keys.down then I()elseif L==keys.enter then if F==1 then C=w return elseif F==2 then u(p(t,w,x))elseif F==3 then local M,N=j(t,w)if not N.colors then N.colors=t.colors end if not N.platform then N.platform=t.platform end if not N.settings then N.settings={location=t.settings.location}end if not N.settings.location then N.settings.location=t.settings.location end q(N,u)end end elseif J[1]=="mouse_scroll"then A=true if J[2]==-1 then H()else I()end elseif J[1]=="timer"and J[2]==B and not A then C=1 return end end end local function E()if B then local F for G=v,1,-1 do F=G local H=tostring(G)term.setTextColor(colors.white)term.setBackgroundColor(colors.black)term.setCursorPos(b.X-#tostring(G+1),3)io.write(string.rep(' ',#tostring(G+1)))term.setCursorPos(b.X-#H,3)io.write(H)if A then break end os.sleep(1)end term.setCursorPos(b.X-#tostring(F+1),3)term.setBackgroundColor(colors.black)io.write(string.rep(' ',#tostring(F+1)))end while true do os.pullEvent("Nonexistant")end end parallel.waitForAny(D,E)if C then return C end printError("This shouldn't happen.")printError("Please report to le github with your layout file.")os.sleep(30)end local function r(t,u)a(1,t,"string")a(2,u,"number","nil")u=u or 0 local v=io.open(t,'r')if v then local w=v:read("*a")v:close()local x,y=load("return "..tostring(w),sFilename)if not x then error(y,2+u)end return x else error(string.format("No file '%s'.",t),2)end end local function s(t,u,v)a(1,t,"string")a(2,u,"function","nil")a(3,v,"number","nil")return q(r(t,1)(),u,v)end return{display=q,displayFile=s,loadFile=r}