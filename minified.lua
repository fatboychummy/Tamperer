local a=require("cc.expect").expect;local b={}b.X,b.Y=term.getSize()b.bigY=b.Y-2;b.startY=4;local c=0;if pocket then c=1;b.nameLen=8;b.infoLen=16;b.items=11 elseif turtle then c=2;b.nameLen=12;b.infoLen=25;b.items=4 else c=3;b.nameLen=16;b.infoLen=32;b.items=10 end;local d={}for e,f in pairs(colors)do d[e]=f;d[f]=e end;for e,f in pairs(colours)do d[e]=f;d[f]=e end;local g,h=term.getSize()local function i(j,k)term.clear()term.setCursorPos(1,1)print("Grabbing a file that is required to display this page...")k=fs.combine(shell.dir(),fs.combine("modules",k))print(j,"==>",k)if fs.exists(k)or pcall(require,k)then return end;local l=http.get(j)if l then print("Connected.")local m=l.readAll()l.close()local n=io.open(k,'w')if n then n:write(m):close()print("Complete.")else error("Failed to open "..tostring(k).." for writing.",2)end else error("Failed to connect to "..tostring(j),2)end end;local function o(p,q)p=p or""local r=string.len(p)+1;local s,t=term.getCursorPos()local g=term.getSize()local u=false;local v=-1;local w=false;term.setCursorBlink(true)while true do local x=type(q)=="string"and string.rep(q:sub(1,1),string.len(p))or p;term.setCursorPos(s,t)io.write(string.rep(' ',g-s+1))term.setCursorPos(s,t)local y=r-(g-s+1)if y>=0 then io.write(string.sub(x,y+1))else io.write(x)end;local z=s+r-1;if z>g then z=g end;term.setCursorPos(z,t)if w then local A=term.getBackgroundColor()term.setBackgroundColor(colors.white)io.write(' ')term.setBackgroundColor(A)end;local B={os.pullEvent()}local C=B[1]if C=="char"then local D=B[2]if u then p=string.sub(p,1,r-1)..D..string.sub(p,r+1)else p=string.sub(p,1,r-1)..D..string.sub(p,r)end;r=r+1 elseif C=="key"then local E=B[2]if E==keys.backspace then local F=r-2;if r-2<0 then F=0 end;p=string.sub(p,1,F)..string.sub(p,r)r=r-1;if r<1 then r=1 end elseif E==keys.enter then term.setCursorBlink(false)print()return p elseif E==keys.right then r=r+1;if r>string.len(p)+1 then r=string.len(p)+1 end elseif E==keys.left then r=r-1;if r<1 then r=1 end elseif E==keys.up then r=1 elseif E==keys.down then r=string.len(p)+1 elseif E==keys.delete then p=string.sub(p,1,r-1)..string.sub(p,r+1)elseif E==keys.insert then if u then u=false;term.setCursorBlink(true)os.cancelTimer(v)v=-1;w=false else u=true;term.setCursorBlink(false)v=os.startTimer(0.4)end end elseif C=="paste"then local G=B[2]if u then p=string.sub(p,1,r-1)..G..string.sub(p,r+#G)else p=string.sub(p,1,r-1)..G..string.sub(p,r)end;r=r+#G elseif C=="timer"then local H=B[2]if H==v then w=not w;v=os.startTimer(0.4)end end end end;local function I(J,K,L,M)if type(J)~=K then error(L.." (expected "..K..", got "..type(J)..")",M and M+1 or 3)end end;local function N(J,K,k,M)if type(J)~="string"then error("Check failure: not string",2)end;if string.len(J)>K then error("Page layout string "..k.." is too long (max: "..tostring(K)..", at: "..tostring(string.len(J))..")",M and M+1 or 3)end end;local function O(P)I(P,"table","Page layout is not a table.")I(P.name,"string","Page: name is of wrong type.")local Q="Page "..P.name..": %s is of wrong type."I(P.platform,"string",string.format(Q,"platform"))if P.platform=="all"then elseif pocket and P.platform~="pocket"or turtle and P.platform~="turtle"or not pocket and not turtle and(P.platform=="pocket"or P.platform=="turtle")then error("Menu is designed for a different platform ("..P.platform..").",2)end;N(P.name,b.nameLen,"page.name")I(P.info,"string",string.format(Q,"info"))N(P.info,b.infoLen,"page.info")I(P.bigInfo,"string",string.format(Q,"bigInfo"))term.setCursorPos(1,1)local R=write(P.bigInfo)if R>2 then error("Page "..P.name..": bigInfo is too long and prints too many ".."lines.",2)end;I(P.colors,"table",string.format(Q,"colors"))I(P.colors.bg,"table",string.format(Q,"colors.bg"))local S={"main"}for T=1,#S do I(P.colors.bg[S[T]],"string",string.format(Q,"colors.bg."..S[T]))end;I(P.colors.fg,"table",string.format(Q,"colors.fg"))S={"error","main","title","info","listInfo","listTitle","bigInfo","selector","arrowDisabled","arrowEnabled","input"}for T=1,#S do I(P.colors.fg[S[T]],"string",string.format(Q,"colors.fg."..S[T]))end;if P.selections then for T=1,#P.selections do local U=P.selections[T]local V="Page "..P.name..", selection "..tostring(T)..": %s is of wrong type."local W="page.settings["..tostring(T).."].%s"I(U.title,"string",string.format(V,"title"))N(U.title,b.nameLen,string.format(W,"title"))I(U.info,"string",string.format(V,"info"))N(U.info,b.infoLen,string.format(W,"info"))I(U.bigInfo,"string",string.format(V,"bigInfo"))term.setCursorPos(1,1)local R=write(U.bigInfo)if R>2 then error("Page "..P.name..", selection "..tostring(T)..": bigInfo is too long and prints too many ".."lines (Unknown max length).",2)end end else P.selections={}end;if P.settings then for T=1,#P.settings do local U=P.settings[T]local V="Page "..P.name..", setting "..tostring(T)..": %s is of wrong type."local W="page.settings["..tostring(T).."].%s"I(U.title,"string",string.format(V,"title"))N(U.title,b.nameLen,"title")I(U.bigInfo,"string",string.format(V,"bigInfo"))term.setCursorPos(1,1)local R=write(U.bigInfo)if R>2 then error("Page "..P.name..", setting "..tostring(T)..": bigInfo is too long and prints too many ".."lines (Unknown max length).",2)end;I(U.setting,"string",string.format(V,"setting"))I(U.tp,"string",string.format(V,"tp"))if U.min then I(U.min,"number",string.format(V,"min"))end;if U.max then I(U.max,"number",string.format(V,"max"))end;if U.tp=="password"then I(U.store,"string",string.format(V,"store"))if U.store~="plain"and U.store~="sha256"and U.store~="sha256salt"and U.store~="kristwallet"then error(string.format("Page %s, setting %d: store is not of allowed ".."values (plain, sha256, sha256salt, kristwallet)",P.name,T),2)elseif U.store~="plain"then i("https://pastebin.com/raw/6UV4qfNF","sha256.lua")end end end else P.settings={}end;if P.subPages then for T=1,#P.subPages do local U=P.subPages[T]local V="Subpage %d: %s is of wrong type."I(U.name,"string",string.format(V,T,"name"))I(U.info,"string",string.format(V,T,"info"))I(U.bigInfo,"string",string.format(V,T,"bigInfo"))term.setCursorPos(1,1)local R=write(U.bigInfo)if R>2 then error("Page "..P.name..", subpage "..tostring(T)..": bigInfo is too long and prints too many ".."lines (Unknown max length).",2)end end else P.subPages={}end;term.clear()end;local function X(Y,T)local Z=#Y.selections;local _=#Y.settings;local a0=#Y.subPages;if T>Z then if T>Z+_ then if T==Z+_+a0+1 then return 1,{title=Y.final or"Go back.",info="",bigInfo=""}end;if T>Z+_+a0 then return 0 end;return 3,Y.subPages[T-Z-_]end;return 2,Y.settings[T-Z]end;return 1,Y.selections[T]end;local function a1(Y)return#Y.selections+#Y.settings+#Y.subPages end;local function a2(a3,a4,a5,a6)term.setCursorPos(b.nameLen+3,b.startY+a4)term.write(string.rep(' ',g-(b.nameLen+3)))term.setCursorPos(b.nameLen+3,b.startY+a4)local a7=term.getTextColor()term.setTextColor(d[a6])term.write(a3)term.setTextColor(a7)os.sleep(a5)end;local function a8(Y,a9,aa)local G=tostring(settings.get(a9.setting))if G=="nil"then G="0"end;while true do term.setCursorPos(b.nameLen+3,b.startY+aa)io.write(string.rep(' ',g-14))term.setCursorPos(b.nameLen+3,b.startY+aa)local ab=tonumber(o(G))if not ab then a2("Not a number",aa,2,Y.colors.fg.error)else local ac=true;if a9.min and ab<a9.min then ac=false;a2(string.format("Minimum: %d",a9.min),aa,2,Y.colors.fg.error)G=tostring(a9.min)end;if a9.max and ab>a9.max then ac=false;a2(string.format("Maximum: %d",a9.max),aa,2,Y.colors.fg.error)G=tostring(a9.max)end;if ac then return ab end end end end;local function ad(Y,a9,aa)local G=tostring(d[settings.get(a9.setting)])if G=="nil"then G="?"end;while true do term.setCursorPos(b.nameLen+3,b.startY+aa)io.write(string.rep(' ',g-14))term.setCursorPos(b.nameLen+3,b.startY+aa)local ab=o(G)local ae=tonumber(ab)if d[ae]then return ae elseif d[ab]then return d[ab]else a2("Not a color.",aa,2,Y.colors.fg.error)end end end;local function af(Y,a9,aa)while true do term.setCursorPos(2,b.startY+aa)io.write(string.rep(' ',g-1))term.setCursorPos(2,b.startY+aa)term.setTextColor(d[Y.colors.fg.listTitle])io.write("Password:")term.setCursorPos(b.nameLen+3,b.startY+aa)io.write(string.rep(' ',g-14))term.setCursorPos(b.nameLen+3,b.startY+aa)term.setTextColor(d[Y.colors.fg.input])local ag=o("",'*')term.setCursorPos(2,b.startY+aa)io.write(string.rep(' ',g-1))term.setCursorPos(2,b.startY+aa)term.setTextColor(d[Y.colors.fg.listTitle])io.write("Repeat:")term.setCursorPos(b.nameLen+3,b.startY+aa)io.write(string.rep(' ',g-14))term.setCursorPos(b.nameLen+3,b.startY+aa)term.setTextColor(d[Y.colors.fg.input])local ah=o("",'*')if ag==ah then local ai;if a9.store=="sha256"or a9.store=="sha256salt"or a9.store=="kristwallet"then local aj=require("sha256")if a9.store=="sha256salt"then ai=math.random(1,100000)ag=tostring(ai)..","..ag end;if a9.store=="kristwallet"then ag="KRISTWALLET"..ag end;ag=aj.digest(ag):toHex()if a9.store=="kristwallet"then ag=ag.."-000"end end;return ag,ai else a2("Not matching!",aa,2,Y.colors.fg.error)end end end;local function ak(Y,a9,aa)local al=false;term.setTextColor(d[Y.colors.fg.listTitle])term.setCursorPos(2,b.startY+aa)io.write(string.rep(' ',g-1))term.setCursorPos(2,b.startY+aa)io.write("You sure?")while true do term.setCursorPos(b.nameLen+3,b.startY+aa)io.write(string.rep(' ',g-14))term.setCursorPos(b.nameLen+3,b.startY+aa)term.setTextColor(d[Y.colors.fg.input])io.write(al and"[ YES ] NO"or"  YES [ NO ]")local B,E=os.pullEvent("key")if E==keys.right or E==keys.left or E==keys.tab then al=not al elseif E==keys.enter then return al end end end;local function am(an)local ao=fs.combine(fs.getDir(shell.getRunningProgram()),".TampererLongData")if not fs.exists(ao)then fs.makeDir(ao)end;if not fs.exists(fs.combine(ao,an))then local ac,L=io.open(fs.combine(ao,an),'w'):write(""):close()end;term.setBackgroundColor(colors.gray)for ap=3,b.Y-3 do term.setCursorPos(1,ap)term.write(string.rep(' ',b.X))end;local aq=window.create(term.current(),2,4,b.X-2,b.Y-7)local ar={shell.openTab,shell.switchTab}shell.openTab=nil;shell.switchTab=nil;local as=term.redirect(aq)os.run({shell=shell},shell.resolveProgram"edit","/"..fs.combine(ao,an))term.redirect(as)shell.openTab=ar[1]shell.switchTab=ar[2]return io.lines(fs.combine(ao,an))()or""end;local function at(Y,T,aa)local au,a9=X(Y,T)local av;if au~=2 then error("Dawg something happened!",2)end;term.setCursorPos(b.nameLen+3,b.startY+aa)term.setTextColor(colors[Y.colors.fg.input])if a9.tp=="string"then local aw=o(settings.get(a9.setting))settings.set(a9.setting,aw)settings.save(Y.settings.location)av=aw elseif a9.tp=="number"then local ax=a8(Y,a9,aa)settings.set(a9.setting,ax)settings.save(Y.settings.location)av=ax elseif a9.tp=="color"then local ay=ad(Y,a9,aa)settings.set(a9.setting,ay)settings.save(Y.settings.location)av=ay elseif a9.tp=="boolean"then local az=settings.get(a9.setting)if az==nil then az=true else az=not az end;settings.set(a9.setting,az)settings.save(Y.settings.location)av=az elseif a9.tp=="password"then if ak(Y,a9,aa)then local ag,ai=af(Y,a9,aa)settings.set(a9.setting,ag)if ai then settings.set(a9.setting..".salt",ai)end;settings.save(Y.settings.location)end;av=settings.get(a9.setting)elseif a9.tp=="longstring"then local az=settings.get(a9.setting)az=am(a9.setting,az)settings.set(a9.setting,az)settings.save(Y.settings.location)else a2(string.format("Cannot edit type '%s'.",a9.tp),aa,2,Y.colors.fg.error)end;return Y.settings.location,a9.setting,av,Y end;local function aA(Y,aB,aC)a(1,Y,"table")a(2,aB,"function","nil")a(3,aC,"number","nil")aB=aB or function()end;local aD=1;local aE=1;local aF=1;local aG={}local aH=false;local aI;local aJ;O(Y)if not Y.settings.location then Y.settings.location=".settings"end;settings.load(Y.settings.location)if aC then aI=os.startTimer(aC)end;local function aK()while true do local aL,aM;local function aN()term.setBackgroundColor(colors[Y.colors.bg.main])term.setTextColor(colors[Y.colors.fg.title])term.clear()term.setCursorPos(1,1)io.write(Y.name)term.setCursorPos(1,2)term.setTextColor(colors[Y.colors.fg.info])io.write(Y.info)for T=0,b.items-1 do local aO,U=X(Y,aF+T)term.setCursorPos(2,5+T)if aO==1 then term.setTextColor(colors[Y.colors.fg.listTitle])io.write(U.title)term.setCursorPos(b.nameLen+3,5+T)term.setTextColor(colors[Y.colors.fg.listInfo])io.write(U.info)elseif aO==2 then local a9=settings.get(U.setting)if type(a9)=="string"and string.len(a9)>b.infoLen then a9=a9:sub(1,b.infoLen-3)a9=a9 .."..."end;term.setTextColor(colors[Y.colors.fg.listTitle])io.write(U.title)term.setCursorPos(b.nameLen+3,5+T)term.setTextColor(colors[Y.colors.fg.listInfo])if U.tp=="string"or U.tp=="number"then io.write(a9 or"Error: empty")elseif U.tp=="boolean"then if a9==true then io.write("  false [ true ]")elseif a9==false then io.write("[ false ] true")else io.write("? false ? true ?")end elseif U.tp=="color"then io.write(a9 and string.format("%s (%d)",d[a9],a9)or"? (nil)")elseif U.tp=="password"then local aP={plain="Plaintext",sha256="sha256",sha256salt="sha256 + salt",kristwallet="Kristwallet"}if pocket then io.write(a9 and aP[U.store]or"Not yet set")else io.write(a9 and"Stored as "..aP[U.store]or"Not yet set")end elseif U.tp=="longstring"then io.write(a9 and string.format(string.format("\%.%ds\%s",#tostring(a9)>b.infoLen and b.infoLen-3 or b.infoLen),a9,#tostring(a9)>b.infoLen and"..."or"")or"")else io.write(pocket and"Unsupported"or"Unsupported type.")end elseif aO==3 then term.setTextColor(colors[Y.colors.fg.listTitle])io.write(U.name)term.setTextColor(colors[Y.colors.fg.listInfo])term.setCursorPos(b.nameLen+3,5+T)io.write(U.info)elseif aO~=0 then io.write("Broken.")end end;aL,aM=X(Y,aD)term.setTextColor(colors[Y.colors.fg.bigInfo])term.setCursorPos(1,b.Y-2)io.write(aM.bigInfo)term.setCursorPos(1,b.startY+aE)term.setTextColor(colors[Y.colors.fg.selector])io.write(">")term.setCursorPos(1,b.startY+b.items+1)if aF+b.items>a1(Y)+1 then term.setTextColor(colors[Y.colors.fg.arrowDisabled])else term.setTextColor(colors[Y.colors.fg.arrowEnabled])end;io.write(string.char(31))term.setCursorPos(1,b.startY)if aF>1 then term.setTextColor(colors[Y.colors.fg.arrowEnabled])else term.setTextColor(colors[Y.colors.fg.arrowDisabled])end;io.write(string.char(30))end;aN()local function aQ()aD=aD-1;if aE==1 then aF=aF-1 end;if aF<1 then aF=1 end;aE=aE-1;if aE<1 then aE=1 end;if aD<1 then aD=a1(Y)+1;aE=a1(Y)+1<b.items and a1(Y)+1 or b.items;aF=aD-b.items+1;if aF<1 then aF=1 end end end;local function aR()aD=aD+1;if aE==b.items then aF=aF+1 end;aE=aE+1;if aE>b.items then aE=b.items end;if aD>a1(Y)+1 then aD=1;aF=1;aE=1 end end;local C=table.pack(os.pullEvent())if C[1]=="key"then aH=true;local B,E=table.unpack(C,1,2)if E==keys.up then aQ()elseif E==keys.down then aR()elseif E==keys.enter then if aL==1 then aJ=aD;return elseif aL==2 then local aS,aT,aU,aV=at(Y,aD,aE)aN()local aW="Bad callback return value %d: Expected %s, got %s."local aX,aY,aZ=aB(aS,aT,aU,aV)assert(type(aX)=="boolean"or type(aX)=="nil",string.format(aW,1,"boolean or nil",type(aX)))if aX then assert(type(aY)=="string",string.format(aW,2,"string",type(aY)))assert(type(aZ)=="number"or type(aZ)=="nil",string.format(aW,3,"number or nil",type(aZ)))a2(aY,aE,aZ or 2,Y.colors.fg.error)end;settings.save(aS)elseif aL==3 then local T,U=X(Y,aD)if not U.colors then U.colors=Y.colors end;if not U.platform then U.platform=Y.platform end;if not U.settings then U.settings={location=Y.settings.location}end;if not U.settings.location then U.settings.location=Y.settings.location end;aA(U,aB)end end elseif C[1]=="mouse_scroll"then aH=true;if C[2]==-1 then aQ()else aR()end elseif C[1]=="timer"and C[2]==aI and not aH then aJ=1;return end end end;local function a_()if aI then local b0;for T=aC,1,-1 do b0=T;local b1=tostring(T)term.setTextColor(colors.white)term.setBackgroundColor(colors.black)term.setCursorPos(b.X-#tostring(T+1),3)io.write(string.rep(' ',#tostring(T+1)))term.setCursorPos(b.X-#b1,3)io.write(b1)if aH then break end;os.sleep(1)end;term.setCursorPos(b.X-#tostring(b0+1),3)term.setBackgroundColor(colors.black)io.write(string.rep(' ',#tostring(b0+1)))end;while true do os.pullEvent("Nonexistant")end end;parallel.waitForAny(aK,a_)if aJ then return aJ end;printError("This shouldn't happen.")printError("Please report to le github with your layout file.")os.sleep(30)end;local function b2(b3,b4)a(1,b3,"string")a(2,b4,"number","nil")b4=b4 or 0;local l=io.open(b3,'r')if l then local b5=l:read("*a")l:close()local b6,aY=load("return "..tostring(b5),sFilename)if not b6 then error(string.format("Failed to load file:\n%s",aY),2+b4)end;return b6 else error(string.format("No file '%s'.",b3),2)end end;local function b7(b3,aB,b8)a(1,b3,"string")a(2,aB,"function","nil")a(3,b8,"number","nil")return aA(b2(b3,1)(),aB,b8)end;local function b9(ba,bb)a(1,ba,"table")a(2,bb,"string")if ba.subPages then for T=1,#ba.subPages do if ba.subPages[T].name==bb then return ba.subPages[T]end end;for T=1,#ba.subPages do local bc=b9(ba.subPages[T],bb)if bc then return bc end end end end;local function bd()i("https://pastebin.com/raw/6UV4qfNF","sha256.lua")end;return{display=aA,displayFile=b7,loadFile=b2,getSubPage=b9,getDependencies=bd}
