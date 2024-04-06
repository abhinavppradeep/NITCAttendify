#include <SPI.h>
#include <MFRC522.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

#define RST_PIN D3
#define SS_PIN  D4

MFRC522 mfrc522(SS_PIN, RST_PIN);

const String ssid = "BSNL_8A37";
const String password = "6238566421";
const char* serverAddress = "http://192.168.1.37:3000/api/tag-events";

bool isLogin = true;  // Initial state is login
bool prevState = true; // Track previous login state

String previousId = ""; // Store previously read ID

void setup() {
  Serial.begin(9600);
  SPI.begin();
  mfrc522.PCD_Init();
  WiFi.begin(ssid, password);
  Serial.println("Connecting to WiFi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnected to WiFi");
}

String getTimestamp() {
  unsigned long currentMillis = millis();
  unsigned long seconds = currentMillis / 1000;
  unsigned long minutes = seconds / 60;
  unsigned long hours = minutes / 60;
  unsigned long days = hours / 24;

  char timestamp[20];
  sprintf(timestamp, "%ld-%02ld-%02ld %02ld:%02ld:%02ld",
          1970 + days / 365,     // Year
          (days % 365) / 30 + 1,  // Month
          (days % 365) % 30 + 1,  // Day
          hours % 24,            // Hour
          minutes % 60,          // Minute
          seconds % 60);         // Second

  return String(timestamp);
}

void loop() {
  if (!mfrc522.PICC_IsNewCardPresent() || !mfrc522.PICC_ReadCardSerial()) {
    delay(50);
    return;
  }

  String currentId = "";
  for (byte i = 0; i < mfrc522.uid.size; i++) {
    currentId += String(mfrc522.uid.uidByte[i], HEX);
  }
  currentId.toUpperCase();

  // Check for ID change or initial read
  if (currentId != previousId || previousId.isEmpty()) {
    isLogin = !prevState; // Update login state based on previous
    prevState = isLogin;

    String eventType = isLogin ? "login" : "logout";  // Declare and assign value
    sendDataToServer(currentId, isLogin);

    Serial.println(currentId + "," + eventType + "," + getTimestamp());
  }

  mfrc522.PICC_HaltA();
  mfrc522.PCD_StopCrypto1();
  delay(3000); // Wait for 3 seconds before reading another card
}

void sendDataToServer(String id, bool loginState) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi not connected. Cannot send data.");
    return;
  }

  HTTPClient http;

  WiFiClient client;
  http.begin(client, serverAddress);
  http.addHeader("Content-Type", "application/json");

  // Use String concatenation (preferred)
  String jsonData = "{\"tagId\": \"" + id + "\", \"eventType\": \"" + (isLogin ? "login" : "logout") + "\", \"timestamp\": \"" + getTimestamp() + "\"}";

  int httpResponseCode = http.POST(jsonData);
  http.end();

  if (httpResponseCode == 201) {
    Serial.println("Data sent successfully.");
  } else {
    Serial.println("Failed to send data to server.");
  }
}
