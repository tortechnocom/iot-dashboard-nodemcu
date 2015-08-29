--Demo Server on Google Cloud
url="146.148.85.203"
user="tortechnocom"
password="9bdc6ffed51612b01afc7af7fa8161914bcb0afa"
thingId1 = "55caf790fb9feee2580b138e"
clientId="t:"..thingId1
--Local test
--url="192.168.0.74" --Local Server
--user="testuser"
--password="23331067a6699247d017e4adf6fab8c8d2bb0508"
--thingId1 = "55ae701798fbe0d719687d6f"
--clientId="t:"..thingId1

port="1883"
topic1="iot/"..thingId1 --gpio 1
connected = false
switch1 = 0

--print("clientId: "..clientId)
--print("topic1: "..topic1)
--print("url: "..url)
--print("port: "..port)

--m=mqtt.Client(clientId,20,user,password)
m=mqtt.Client(clientId,120, user, password)
m:on("connect",function(m)
    print("connected "..node.chipid()) 
    m:subscribe(topic1,0,function(m) print("Subscribed") end)
    connected = true
    end)
m:on("offline", function(conn)
    print("Disconnect to broker...")
    connected = false
    m:connect(url,port,0,nil)
end)
m:on("message", function(conn, topic, data)
  if data ~= nil then
    print(topic .. " : "..data)
    pin = ""
    if string.match(topic, thingId1) then
        pin = 1
    elseif string.match(topic, thingId2) then
        pin = 3
    end
    if pin == 1 then
        if data == "OFF" then
            gpio.mode(pin,gpio.OUTPUT)
            gpio.write(pin,gpio.LOW)
            switch1 = 0
        else
            gpio.mode(pin,gpio.OUTPUT)
            gpio.write(pin,gpio.HIGH)
            switch1 = 1
        end
    end
  end
end)
m:connect(url,1883,0,nil)
function trigPin(level)
    if connected == true then
        if switch1 == 1 then
            payload = "OFF"
        else
            payload = "ON"
        end
        m:publish(topic1, payload, 0, 0, nil)
    end
end
gpio.mode(2,gpio.INT)
gpio.trig(2, "both", trigPin)
