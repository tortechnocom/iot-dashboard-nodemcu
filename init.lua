if true then  --change to if true
	print("set up wifi mode")
	wifi.setmode(wifi.STATION)
	--please config ssid and password according to settings of your wireless router.
	wifi.sta.config("dicypang","icypang129")
    --wifi.sta.config("Lam dee","14072557")
    --wifi.sta.config("G2_6731","12345789")
    --wifi.sta.config("Tortechnocom","12345789")
	wifi.sta.connect()
	cnt = 0
	tmr.alarm(1, 1000, 1, function() 
	    if (wifi.sta.getip() == nil) and (cnt < 20) then 
	    	print("IP unavaiable, Waiting...")
	    	cnt = cnt + 1 
            print(wifi.sta.getmac())
	    else 
	    	tmr.stop(1)
	    	if (cnt < 20) then print("Config done, IP is "..wifi.sta.getip())
	    	    dofile("mqtt.lua")
                --dofile("mqtt-lelylan.lua")
                --dofile("mqtt-ibm.lua")
                --Test
	    	else
	    	    print("Wifi setup time more than 20s, Please verify wifi.sta.config() function. Then re-download the file.")
	    	end
	    end 
	 end)
else
	print("\n")
	print("Please edit 'init.lua' first:")
	print("Step 1: Modify wifi.sta.config() function in line 5 according settings of your wireless router.")
	print("Step 2: Change the 'if false' statement in line 1 to 'if true'.")
end
