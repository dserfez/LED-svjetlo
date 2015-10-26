print("Wifi connected, starting to do some work")

pub_sem = 0

function read_and_publish_data()
    --print("Reading data..")
    message = read_data()
    --print("About to publish message..")
    publish_data(message)
end

function read_data()
    --gpio.write(LED1_PIN, gpio.HIGH)
    status,temp,humi,temp_decimial,humi_decimial = dht.read11(DHT11_PIN)
    --tmr.delay(100000)
    --gpio.write(LED1_PIN, gpio.LOW)
    if( status == dht.OK ) then
      --print("{\"temperature\":\""..temp.."\",".."\"humidity\":\""..humi.."\"}")
      message = "{\"sensor\":\""..CLIENTID.."\",\"temperature\":\""..temp.."\",".."\"humidity\":\""..humi.."\"}"
      --print( "Read data: ".. message );
      return message
    elseif( status == dht.ERROR_CHECKSUM ) then
      print( "DHT Checksum error." );
    elseif( status == dht.ERROR_TIMEOUT ) then
      print( "DHT Time out." );
    end
end

function publish_data(message)
--print("pub_sem: "..pub_sem);
   if pub_sem == 0 then  -- Is the semaphore set=
     pub_sem = 1  -- Nop. Let's block it
     m:publish(TOPIC,message,0,0, function(conn) 
        --print("Sending message: " .. message)
        pub_sem = 0  -- Unblock the semaphore
     end)
   end  
end

print "Connecting to MQTT broker. Please wait..."
m = mqtt.Client( CLIENTID, 120)
m:connect( BROKER , BRPORT, 0, function(conn)
     print("Connected to MQTT:" .. BROKER .. ":" .. BRPORT .." as " .. CLIENTID )
     read_and_publish_data()
     tmr.alarm(2, DATA_READ_INTERVAL, 1, read_and_publish_data )
end)
