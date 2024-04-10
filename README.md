# NITC Attendify :sparkles:

Streamline attendance tracking with a touch of RFID magic! :books: :wave:

## Table of Contents

Overview: #overview
Features: #features
Hardware Setup: #hardware-setup
Software Setup: #software-setup
Android App: #android-app
Usage: #usage
Contributing: #contributing
## Overview :eyes:

NITC Attendify is an attendance management system designed to simplify and automate attendance tracking using RFID technology. It's built with a powerful tech stack:

RFID MFRC522 module for contactless card scanning
ESP8266 microcontroller for wireless communication
Express and Node.js server for data handling
MySQL database for secure data storage
Flutter-based Android app for real-time attendance monitoring and student notifications
## Features :star:

Live login/logout tracking with timestamps
Individual student and teacher logins
Attendance calculation and reports
Email notifications for students from within the app
Unknown RFID blocking for enhanced security
Seamless integration with existing student databases
Wi-Fi connectivity for the ESP8266, eliminating wired setup
## Hardware Setup :wrench:

Connect the RFID MFRC522 module to the ESP8266 as follows:

SDA pin → GPIO5
SCK pin → GPIO14
MOSI pin → GPIO13
MISO pin → GPIO12
IRQ pin → Not used
GND pin → GND
RST pin → GPIO0
3.3V pin → 3.3V
Power up the ESP8266 using a suitable power source.

## Software Setup :computer:

Clone this repository onto your development machine.
Install the required Node.js dependencies:
Bash
npm install
Use code with caution.
Configure your MySQL database connection in the server/config.js file.
Start the server:
Bash
node server/index.js
Use code with caution.
## Android App :iphone:

Clone the Flutter app repository (link provided in the project).
Follow the Flutter setup instructions to build and run the app on your Android device or emulator.
## Usage :rocket:

Once the server and app are running:
Scan student RFID cards with the ESP8266 module.
View real-time login/logout updates in the app.
Access attendance reports and manage student notifications from the app.
## Contributing :heart:

We welcome contributions! Feel free to open issues or pull requests to make this project even better. :tada:

Let's create a more efficient and engaging attendance experience! :books: :rocket:
