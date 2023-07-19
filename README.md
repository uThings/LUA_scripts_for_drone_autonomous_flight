# LUA script for drone autonomous flight
This repo contains a Lua script developed as part of a Bachelor's thesis project by the student Davide Altamura in collaboration with Professor Pier Luca Montessoro.

## Introduction
The script makes your drone execute three possible figures (square, circle and eight) by pressing a specific button on your radio. All the movements are performed using the GPS sensor, making them smooth and precise.
It is fully compatible with [Ardupilot](https://github.com/ArduPilot)'s copter autopilot and it has been developed using a safety-first approach. The drone's state depends on a control switch with the following positions: 
- Position 1: manual mode;
- Position 2: guided mode (only in this mode the drone can execute all the figures);
- Position 3: brake mode (hover using GPS).

## Prerequisites
Before using the Lua script, ensure that the following prerequisites are met:

- The drone should be equipped with a compatible flight controller running ArduPilot firmware. Refer to the ArduPilot documentation for installation and setup instructions [here](https://ardupilot.org/copter/docs/initial-setup.html);
- Enable Lua Scripts in Ardupilot, instructions [here](https://ardupilot.org/copter/docs/common-lua-scripts.html);
- Assign two different 3-position switches to CH13 and CH14 of your radio (if you already have those channels set, you need to change the source code accordingly);
- The script is ready to use with a Radiomaster TX16s radio, depending on what radio you have you may need to change pwm values in the source code.

## Configuration
You can change the following values in the source code:
- `takeoff_altitude` to start figures at different heights;
- `sq_dimension` to make squares of different dimensions - by default it is set to 10 (10x10);
- `controlch` to change the channel number set for the control switch - by default it is set to 14;
- `figurech` to change the channel number set to choose which figure to do - by default it is set to 13;
- `angle_increase` to increase or decrease the circle diameter;
- all the PWM values can be changed depending on what radio you have.

## Troubleshooting
If you are running Lua scripts on a PixHawk4 you may need to set the parameter `SCR_HEAP_SIZE` to around 74000.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/uThings/LUA_scripts_for_drone_autonomous_flight/blob/main/LICENSE) file for details.

## Acknowledgments
- Big thank you to Professor Pier Luca Montessoro for collaborating to this project;
- Thanks to the Ardupilot community for delivering such a great product.

## Contact Information
For any questions, feedback, or additional information, please contact [@TheMaxi7](https://github.com/TheMaxi7)

## Videos

### Square
![ezgif-5-7d4c0f2f37](https://github.com/uThings/LUA_scripts_for_drone_autonomous_flight/assets/102146744/9b19db63-34d8-4034-9d08-d7f1165c3119)

### Circle
![ezgif-5-3aebaa9384](https://github.com/uThings/LUA_scripts_for_drone_autonomous_flight/assets/102146744/9c256224-3ea4-4e20-a240-263cfff00447)

### Eight
![ezgif-5-1eccc180bf](https://github.com/uThings/LUA_scripts_for_drone_autonomous_flight/assets/102146744/1b329058-52ee-4111-a10a-3b88b883fda3)

