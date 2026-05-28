--[[

░█░░░▀█▀░█▀▀░█░█░░░█▀▀░█▀█░█▀▀░█░█░█▀▀░▀█▀      
░█░░░░█░░█▀▀░▄▀▄░░░▀▀█░█░█░█░░░█▀▄░█▀▀░░█░      
░▀▀▀░▀▀▀░▀▀▀░▀░▀░░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░░▀░      
░█▀█░█▀▄░█▀▀░█░█░█▀▀░█▀▀░▀█▀░█▀▄░█▀█░▀█▀░█▀█░█▀▄
░█░█░█▀▄░█░░░█▀█░█▀▀░▀▀█░░█░░█▀▄░█▀█░░█░░█░█░█▀▄
░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░░▀░░▀░▀░▀░▀░░▀░░▀▀▀░▀░▀

Beta 0.1
]]


if getgenv().RemoteSocket.Status == true then
    return warn("Socket is already exist close it first by using:\nSocket:CloseSession()")
end
getgenv().RemoteSocket.Status = true
--------------------------------------------------------------------
loadstring(game:HttpGet("https://raw.githubusercontent.com/Asepthegoat/LIUDEX-Z/refs/heads/main/script/tools/functions.lua"))() --LIB DON'T REMOVE THIS
local rs = import.RunService
local Players = import.Players
local HttpService = import.HttpService
--[[
work flow no nword count without skid gui
":;:" its used for invoke server
" | " its use for firesocket
"InvokeServer" used only for firing server to run code on server and didnt affected to client
or you can use POST method to invoke server
"FireSocket" used only for firing all client(reciver) to run code from sender and didnt affected annything on server

--[DISCLAIMER]--
+ may i will use json later but for now im using url encode style
+ all string gsub function format is not from me it stolen from other script or chat gpt make it
    - lets improve this to together
+ it is recommended to add a prefix to your remote name, for example ldxbring instead of just bring.
+ client Script reciever require to be same Script or Code to each other
+ you can only send string use serialize script to make your string looks like normal code and run it with  if you want
+ oprator
 - @all to fire all client that connect
 - @server to fire all client that connect and in same server(placeid and gameid) with you server
+ remote Example:
+ Socket:FireSocket(remote,target or oprator,args)
[ Developed By Lorem Ipsum Familia Developer ]

]]

local isclosed = false
local TextChatService = import.TextChatService
local function fakeChat(target,msg)
    local plr = target 
    local channel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
    if typeof(plr):lower() == "instance" and plr:IsA("Player") and plr == Players:FindFirstChild(plr.Name) then
        channel:DisplaySystemMessage('<font color="rgb(255,0,0)">' .. plr.Name .. ': </font>' .. msg)
        local ovhead = plr.Character
        TextChatService:DisplayBubble(ovhead, msg)
    else
        msg = tostring(msg)
        channel:DisplaySystemMessage('<font color="rgb(80, 47, 201)">[Server]: </font>' .. msg)
    end
end

getgenv().Socket = {}

local RemoteSocket = getgenv().RemoteSocket

function Socket:SetMain(url)
    RemoteSocket.MainUrl = url
    if not RemoteSocket.Status then
        RemoteSocket.Status = true
        RemoteSocket.RemoteCom = {}
        RemoteSocket.Invoker = {}
        RemoteSocket.ClientId = getplayer().UserId
    end
end
Socket:SetMain("wss://xochitl-superexacting-unconcentrically.ngrok-free.dev")
repeat
task.wait(0.2)    
until getgenv().RemoteSocket.MainUrl ~= ""

local sockets = WebSocket.connect(RemoteSocket.MainUrl)
sockets.OnClose:Connect(function()
    warn("Session Clossed")
    if not isclosed then
    warn("Reconnecting...")
    sockets = WebSocket.connect(RemoteSocket.MainUrl)
    end
end)
--[[ LIEX BETA VERSION
sockets.OnMessage:Connect(function(msg)
    if not RemoteSocket.Status then
        RemoteSocket.Status = true
        print("Connected")
    end
    print("recive",msg)
    if msg == "|ConnectedToSocket|" then
        return
    end
    local args = string.split(msg," | ")
    local name = args[1]
    local id = args[2]
    local op = args[3]
    local func =  RemoteSocket.RemoteCom[name].func or RemoteSocket.RemoteCom["entry"].func
    local argue = table.concat(args,",",4)
    local argument = string.split(argue,",",1)
    for i,v in pairs(argument) do
        if v:match("%$(.-)$") then
            argument[i] = findPlayer(v:match("%$(.-)$")).Name
        end
    end
    local serverdata = args[3]:split(";")
    local job = serverdata[3]
    local place = serverdata[2]
    local selfop 
    if args[1] == "invoked" then
        func = RemoteSocket.Invoker[name].func
        func(unpack(args))
    end
    if op == "@all" or op == "@global" then
        func(id,unpack(argument))
    elseif op:find("@server") then
        local serverdat = op:split(";")
        local place = serverdat[2]
        local jobid = serverdat[3]
        if tonumber(place) == game.PlaceId and jobid == game.JobId then
            func(id,unpack(argument))
        end
    elseif import.Players[op:gsub("@","")] then
        selfop = getplayer().Parent[op:gsub("@","")]
    end
    if selfop then
        if compareinstances(selfop, getplayer()) then
            func(id,unpack(argument))
        end
    end
end)
]]

sockets.OnMessage:Connect(function(msg)
    if not RemoteSocket.Status then
        RemoteSocket.Status = true
        print("Connected")
    end
    print("recive",msg)
    if msg == "|ConnectedToSocket|" then
        return
    end
    if msg == "%GetUserData%" then
        sockets:Send(HttpService:JSONEncode({
            DeviceId = getdeviceid(),
            PlaceId = game.Placeid,
            JobId = game.JobId,
            Profile = "https://thumbnails.roblox.com/v1/users/avatar?size=420x420&isCircular=false&format=png&userIds=" .. getplayer().UserId

        }))
        return
    end
    local args = HttpService:JSONDecode(msg)
    local name = args['name']
    local id = args['id']
    local op = args['opr']
    if op == "@Manager" then
        return
    end
    local func =  RemoteSocket.RemoteCom[name].func or RemoteSocket.RemoteCom["entry"].func
    for i,v in pairs(args.args) do
        if v:match("%$(%S+)") then
            print("converted:",v:match("%$(%S+)"))
            args.args[i] = findPlayer(v:match("%$(%S+)")).Name
        end
    end
    if op:lower() == "@manager" then
        return
    end
    local serverdata = args['opr']:split(";")
    local job = serverdata['opr']
    local place = serverdata[2]
    local selfop 
    for i,v in pairs(args.args) do --for web
        if v:find("@self") then
            args.args[i] = v:gsub("@self",getplayer().Name)
        end
    end
    if args.name == "invoked" then
        func = RemoteSocket.Invoker[name].func
        func(unpack(args.args))
    end
    if op == "@all" or op == "@global" then
        func(id,unpack(args.args))
    elseif op:find("@server") then
        local serverdat = op:split(";")
        local place = serverdat[2]
        local jobid = serverdat[3]
        if tonumber(place) == game.PlaceId and jobid == game.JobId then
            func(id,unpack(args.args))
        end
    elseif import.Players[op:gsub("@","")] then
        selfop = getplayer().Parent[op:gsub("@","")]
    end
    if selfop then
        if compareinstances(selfop, getplayer()) then
            func(id,unpack(args.args))
        end
    end
end)


function Socket:CloseSession()
    sockets:Close()
    getgenv().RemoteSocket = nil
    warn("Clossed")
end

function Socket.new(name,func)
    if name and typeof(name) == "string" then
        if not RemoteSocket.RemoteCom[name] then
            local remote = {}
            remote.Id = RemoteSocket.ClientId
            remote.Name = name
            remote.func = func
            setmetatable(remote,{__index = Socket})
            RemoteSocket.RemoteCom[name] = remote
            return RemoteSocket.RemoteCom[name]
        end
        return error(tostring(name),"is alread exist")
    end
    error("name must be string")
end

--[[ BETA VERSION
function Socket:FireSocket(op,...)
    local args = {...}
    for i,v in pairs(args) do
        if v == "@self" then
            v = getplayer().Name
        end
    end

    if op == "@server" then
        op = op .. ";" .. game.PlaceId .. ";" .. game.JobId
    elseif op == "@self" then
        op = "@" .. getplayer().Name
    elseif op:match("%$(.-)$") then
        local partial = op:match("%$(.-)$")
        op = findPlayer(partial).Name
    end
    local value = self.Name .. " | " .. tostring(self.Id) .. " | "  .. op .. " | " ..table.concat(args,",",1)
    sockets:Send(value)
end
]]

function Socket:FireSocket(op,...)
    local args = {...}
    for i,v in pairs(args) do
        if v == "@self" then
            args[i] = getplayer().Name
        end
    end
    if op == "@server" then
        op = op .. ";" .. game.PlaceId .. ";" .. game.JobId
    elseif op == "@self" then
        op = "@" .. getplayer().Name
    elseif op:match("%$(.-)$") then
        local partial = op:match("%$(.-)$")
        op = findPlayer(partial).Name
    end
    local value = {name = self.Name,id = tostring(self.Id), opr = op, args = {unpack(args)}}
    sockets:Send(HttpService:JSONEncode(value))
end
task.spawn(function()
    while true do
        task.wait(180)
        local value = {name= "ping",id=tostring(RemoteSocket.ClientId),opr="@Manager",args={
            ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() * 100) / 100,
            mem = math.floor(game:GetService("Stats").PerformanceStats.Memory:GetValue() * 100) / 100,
            gpu = math.floor(game:GetService("Stats").PerformanceStats.CPU:GetValue() * 100) / 100,
            fps = math.floor(game:GetService("Stats").FrameRateManager.AverageFPS:GetValueString() * 100) / 100
        }
        }
        sockets:Send(HttpService:JSONEncode(value))
    end
end)
Socket.FireServer = Socket.FireSocket

function Socket.newChannel(call)
    local name = uid()
    if name and typeof(name) == "string" then
        if not RemoteSocket.Invoker[name] then
            local remote = {}
            remote.Id = RemoteSocket.ClientId
            remote.Name = name
            remote.func = func
            setmetatable(remote,{__index = Socket})
            RemoteSocket.Invoker[name] = remote
            return RemoteSocket.Invoker[name]
        end
        return error(name .. "is alread exist")
    end
    error("name must be string")
end

getgenv().getSocketVersion = Socket.newChannel()


function Socket:InvokeServer(remote,client,...)
    local args = {...}
    local value = "Invoke" .. ":;:" .. "&" .. self.Name .. "&" .. ":;:"  .. tostring(client) .. ":;:" ..table.concat(args," ",1)
    sockets:Send(value)
end

function Socket:GetSocket(name)
    return RemoteSocket.RemoteCom[name]
end

function Socket:FormatBring(target)
    if typeof(target) == "Instance" then
        target = target.Position
    end
    return HttpService:JSONEncode({x=target.x,y=target.y,z=target.z})
end

function Socket:GetSockets()
    local s = {}
    for i,v in pairs(RemoteSocket.RemoteCom) do
        table.insert(s,v)
    end
    return s
end

--stetup starter socket dont remove
local say = Socket.new("say",function(...)
    print(...,"Connect to this Server")
end)

--require entry dont change annything here
local entry = Socket.new("entry",function(id,...) --do not remove this one it used to avoid double socket connection but you can change the function inside
    print(id,"Has Join this session")
end)

--built in you can change this one
getgenv().ldxcode = Socket.new("code",function(id,...) --its global so all script can use this
    local l = {...}
    local code = table.concat(l,"\n",1)
    loadstring(code)()
end)

getgenv().ldxclosegame = Socket.new("ldxclosegame",function(id,code) --its global so all script can use this
    ex:FC()
end)

local attach = false
local attachkey 
local function deattachplr()
    if typeof(attachkey) == "Instance" then
        attachkey:Destroy()
    elseif attachkey ~= nil then
        attachkey:Disconnect()
    end
    attachkey = nil
    task.wait()
end

getgenv().followtarget = Socket.new("followtarget",function(id,type,target,attached)
    local hrp = getchar().HumanoidRootPart
    local hrp2 = Players[target].Character.HumanoidRootPart
    if attached == "true" then
        if attach then deattachplr() end
        if type == "Attach" then
            attachkey = import.RunService.Heartbeat:Connect(function()
                hrp.CFrame = hrp2.CFrame
            end)
            attach = true
        elseif type == "follow" then
            attachkey = import.RunService.Heartbeat:Connect(function()
                getchar().Humanoid:MoveTo(hrp2.Position)
            end)
            attach = true
        end
    else
        deattachplr()
    end
end)

getgenv().chat = Socket.new("chat",function(id,...) 
    local args = {...}
    local sender 
    if id == "0" or id == "@WebApp" then
        sender = id
        print(id,typeof(id))
    else
        sender = Players:GetPlayerByUserId(tonumber(id))
    end
    fakeChat(sender or "@WebApp",table.concat(args," ",1))
end)

getgenv().

entry:FireSocket("@Manager",getplayer().Name,tostring(getsessionid()))

--[[
you must format your data if straming mode enabled 
]]

getgenv().bring = Socket.new("bring",function(id,target,straming)
    if straming then 
        target = HttpService:JSONDecode(target)
        if typeof(target) ~= "table" then
            return error("target must be a table if you enable straming mode bring")
        end
        
        getrootpart().CFrame = CFrame.new(target.x,target.y,target.z)
        return
    end
    if Players[target].Character then
        getrootpart().CFrame = Players[target].Character.HumanoidRootPart.CFrame + Vector3.new(0,1,0) --cuz target is a string
    end
end)

getgenv().ldxrequire = Socket.new("require",function(id,target,url)
    print(id,target,url)
    loadstring(game:HttpGet(url):gsub("getplayer%(%)", 'game:GetService("Players")["' .. target .. '"]'):gsub("%.LocalPlayer", '["' .. target .. '"]'))()
end)

getgenv().bringtween = Socket.new("bringtween",function(id,target,speed)
    local subjt = Players[target].Character.HumanoidRootPart
    local time = (getchar().HumanoidRootPart.Position - subjt.Position).Magnitude / tonumber(speed)
    if Players[target].Character then
        gototarget(subjt,true,time + 0.0001)
    end
end)

getgenv().ldxAnnouncement = Socket.new("ldxAnnouncement",function(id,...)
    local args = {...}
    ldx:Announcement("Announcement",table.concat(args," ",1))
end)

getgenv().SendWebhookData = Socket.new("SendWebhookData",function(id,...)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Asepthegoat/LIUDEX-Z/refs/heads/main/script/tools/user-data.lua"))()
end)

getgenv().ldxhopto = Socket.new("hopto", function(id,goal,place,jobid)
    id = tonumber(id)
    jobid = jobid or "0"
    place = tonumber(place) or 0
    local plr = Players:GetPlayerByUserId(id)
    if goal == "RequestTeleport" then
        ldxhopto:FireSocket("@" .. plr.Name,"GoTo",tostring(game.PlaceId),game.JobId)
        return
    elseif goal == "HopAll" then
        ldxhopto:FireSocket("@all","GoTo",tostring(game.PlaceId),game.JobId)
        return
    end
    if goal == "GoTo" and id ~= getplayer().UserId and place ~= 0 and jobid ~= "0" then
        import.TeleportService:TeleportToPlaceInstance(tonumber(place),jobid,getplayer())
    end
end)

getgenv().getwssenv = Socket.new("getwssenv",function(id,...)
    return {...}
end)

return sockets
--bring:FireSocket("@all",import.HttpService:JSONEncode({x = -172.8151397705078,y = 3.226611852645874,z = -16.3127498626709}),"true")
