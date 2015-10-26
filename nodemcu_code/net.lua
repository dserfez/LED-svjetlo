print("Configuring LED...")
gpio.mode(LED1_PIN, gpio.OUTPUT)
gpio.write(LED1_PIN, gpio.LOW)

blinkstatus = 0
prev_wifi_status = 1

function blink()
  if ( blinkstatus == 0 ) then
    gpio.write(LED1_PIN, gpio.HIGH)
    blinkstatus = 1
  else
    gpio.write(LED1_PIN, gpio.LOW)
    blinkstatus = 0
  end
end

function not_connected( info )
    print("Wifi status: " .. info)
    tmr.stop(2)
    tmr.alarm( 1, NOWIFIBLINK, 1, blink )
    --prev_wifi_status = wifi_status
end

function checkWifi()
--  print("Configuring WIFI....")
  wifi_status = wifi.sta.status()
  if ( wifi_status == 1 ) then --STATION_CONNECTING
    --print("Wifi status: " .. wifi_status .. " (CONNECTING)")
    not_connected("CONNECTING")
    --tmr.stop(2)
    --tmr.alarm( 1, NOWIFIBLINK, 1, blink )
    prev_wifi_status = wifi_status
  elseif ( wifi_status == 2 ) then --STATION_WRONG_PASSWORD
    --print("Wifi status: " .. wifi_status .. " (WRONG_PASSWORD)")
    not_connected("WRONG_PASSWORD")
    --tmr.stop(2)
    --tmr.alarm( 1, NOWIFIBLINK*2, 1, blink )
    prev_wifi_status = wifi_status
  elseif ( wifi_status == 3 ) then --STATION_NO_AP_FOUND
    wifi.setmode(wifi.STATION)
    wifi.sta.config(SSID, SSIDKEY)
    --print("Wifi status: " .. wifi_status .. " (NO_AP_FOUND)")
    not_connected("NO_AP_FOUND")
    --tmr.stop(2)
    --tmr.alarm( 1, NOWIFIBLINK, 1, blink )
    prev_wifi_status = wifi_status
  elseif ( wifi_status == 4 ) then --STATION_CONNECT_FAIL
    --print("Wifi status: " .. wifi_status .. " (CONNECT_FAIL)")
    not_connected("CONNECT_FAIL")
    --tmr.stop(2)
    --tmr.alarm( 1, NOWIFIBLINK, 1, blink )
    prev_wifi_status = wifi_status
  elseif ( wifi_status == 5 ) then

--print("Wifi status:          "..wifi_status)
--print("PREVIOUS Wifi status: "..prev_wifi_status)

    if prev_wifi_status == wifi_status then
        prev_wifi_status = wifi_status
    else
        tmr.stop(1)
        print("Wifi connected, got IP address: "..wifi.sta.getip())
        gpio.write(LED1_PIN, gpio.LOW)
        blinkstatus = 0
        prev_wifi_status = wifi_status
        dofile(CMDFILE)
    end
  else
    print("Wifi status: " .. wifi_status)
    tmr.alarm( 1, NOWIFIBLINK, 1, blink )
    prev_wifi_status = wifi_status
  end  
end

checkWifi()

tmr.alarm( 0, WIFI_WATCHDOG_INTERVAL, 1, checkWifi )

