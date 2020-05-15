## **Lamp Controller**

Control your room light with your mobile.

## ***-Hardware connection-***
**Components**

 1. ESP8266 Module
 2. BreadBoard
 3. LED
 4. Solid State Relay
 5. Mobile Charger
 6. Wires
![Low level Solid State Relay](https://imgaz2.staticbg.com/thumb/large/oaupload/banggood/images/21/DB/0567069d-a32d-4abc-85f1-552108b6ffa7.jpg)

## Connection

 - You can either use AC to DC converter and connect 5V output to Vin input in ESP8266 module or buy mobile charger and connect it with your module![enter image description here](https://uge-one.com/image/cache/catalog/catalog/0%200%200%20esp8266-node-mcu-pinout-550x550w.png)
 - Connect D7 (GPIO13) to trigger input of Solid state relay module (You can change it to whatever pin you want from int ledPin = 13; *Change 13 to pin and check the connection
 - ![Solid state relay Pinout](https://i.pinimg.com/originals/d3/8e/8f/d38e8f76381e689dd06dbece4fb1ca77.png)
 - You can put a LED in series with Signal port and you can neglect it
## Software
 
 - You can edit and upload ESP code with Arduino IDE
 - Change "wifiName" to your wifi SSID in this line const char* ssid = "wifiName";
 - Change "Password" to your wifi Password in this line const char* password = "password";
 - Server is working on port 800 (You can change it to whatever you want) 
 - FlutterApp discovers local IPs on Port 800 so you can discover it easily
 - Relay module works on Low triggering (Active low)
 - Discovering works on 192.168.1 (You can change it from the code)

