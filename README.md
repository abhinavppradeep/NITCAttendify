# NITCAttendify

NITCAttendify is an RFID-based attendance system developed using ESP8266 microcontroller, MFRC522 RFID module, Node.js, Express.js, MySQL, and Flutter. It allows users to efficiently manage attendance records, track login and logout times, calculate attendance percentages, and notify users via email. This README provides an overview of the project's features, components, and setup instructions.

## Features

- RFID-based attendance logging system.
- Integration with ESP8266 microcontroller for RFID detection and data transmission.
- Node.js backend using Express.js for handling HTTP requests and database operations.
- MySQL database for storing attendance records and user data.
- Flutter app for real-time attendance monitoring, individual and teacher login, and email notifications.
- Blocking unknown RFID tags by comparing with stored data in MySQL.

## Components

### Hardware

- ESP8266 microcontroller.
- MFRC522 RFID module.
- Compatible RFID tags/cards.

### Software

- Node.js and Express.js for backend server.
- MySQL database for data storage.
- Flutter for mobile app development.

## Setup Instructions

### Hardware Setup

1. Connect the MFRC522 RFID module to the ESP8266 microcontroller following the pinout diagram provided by your hardware documentation.
2. Ensure the connections are secure and the hardware is powered appropriately.

### Software Setup

1. Clone this repository to your local machine.

   ```bash
   git clone https://github.com/abhinavppradeep/NITCAttendify.git
