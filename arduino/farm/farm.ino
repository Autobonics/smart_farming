//Soil sensor
#define s1Pin 34
#define s2Pin 35
#define s3Pin 32
#define s4Pin 33
#define s5Pin 25
int s1Value = 0;
int s2Value = 0;
int s3Value = 0;
int s4Value = 0;
int s5Value = 0;

//LED
#define l1Pin 15
#define l2Pin 4
#define l3Pin 18
#define l4Pin 19
#define l5Pin 21
int l1Value = 0;
int l2Value = 0;
int l3Value = 0;
int l4Value = 0;
int l5Value = 0;

//Wifi indicator led
#define wifiLed 2

//Firebase
#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
// Provide the token generation process info.
#include <addons/TokenHelper.h>
// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>
/* 1. Define the WiFi credentials */
#define WIFI_SSID "Autobonics_4G"
#define WIFI_PASSWORD "autobonics@27"
// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino
/* 2. Define the API Key */
#define API_KEY "AIzaSyD29qaXnEvgSp-3PgIWRmy4i2ajadiCG0c"
/* 3. Define the RTDB URL */
#define DATABASE_URL "https://smart-farming-42aea-default-rtdb.asia-southeast1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "device1@autobonics.com"
#define USER_PASSWORD "12345678"
// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
// Variable to save USER UID
String uid;
//Databse
String path;

unsigned long printDataPrevMillis = 0;

FirebaseData stream;
void streamCallback(StreamData data)
{
  Serial.println("NEW DATA!");

  String p = data.dataPath();

  Serial.println(p);
  printResult(data); // see addons/RTDBHelper.h

  // if(p == "/l1"){
  //   l1Value = data.intData();     
  //   digitalWrite(l1Pin, l1Value);    
  //   Serial.println("LED1");
  // } else if(p == "/l2"){
  //   l2Value = data.intData();     
  //   digitalWrite(l2Pin, l2Value); 
  //   Serial.println("LED2");
  // } else if(p == "/l3"){
  //   l3Value = data.intData();     
  //   digitalWrite(l3Pin, l3Value);  
  //   Serial.println("LED3");
  // } else if(p == "/l4"){
  //   l4Value = data.intData();     
  //   digitalWrite(l4Pin, l4Value);
  //   Serial.println("LED4");
  // } else if(p == "/l5"){
  //   l5Value = data.intData();     
  //   digitalWrite(l5Pin, l5Value);
  //   Serial.println("LED5");
  // }

  // Serial.println();
  FirebaseJson jVal = data.jsonObject();
  FirebaseJsonData l1;
  FirebaseJsonData l2;
  FirebaseJsonData l3;
  FirebaseJsonData l4;
  FirebaseJsonData l5;
  jVal.get(l1, "l1");
  jVal.get(l2, "l2");
  jVal.get(l3, "l3");
  jVal.get(l4, "l4");
  jVal.get(l5, "l5");
  // if (l1.success && l2.success && l3.success && l4.success && l5.success)
  // {
  //   Serial.println("Success data");
  //   l1Value = l1.to<int>();
  //   l2Value = l2.to<int>();
  //   l3Value = l3.to<int>();
  //   l4Value = l4.to<int>();
  //   l5Value = l5.to<int>();   
  // }

  if (l1.success)
  {
    Serial.println("Success data");
    l1Value = l1.to<int>();   
  }  
  if (l2.success)
  {
    Serial.println("Success data");
    l2Value = l2.to<int>();   
  }
  if (l3.success)
  {
    Serial.println("Success data");
    l3Value = l3.to<int>();
  }
  if (l4.success)
  {
    Serial.println("Success data");
    l4Value = l4.to<int>();
  }
  if (l5.success)
  {
    Serial.println("Success data");
    l5Value = l5.to<int>();   
  }
  
  digitalWrite(l1Pin, l1Value);  
  digitalWrite(l2Pin, l2Value);  
  digitalWrite(l3Pin, l3Value);  
  digitalWrite(l4Pin, l4Value);  
  digitalWrite(l5Pin, l5Value);  
}

void streamTimeoutCallback(bool timeout)
{
  if (timeout)
    Serial.println("stream timed out, resuming...\n");

  if (!stream.httpConnected())
    Serial.printf("error code: %d, reason: %s\n\n", stream.httpCode(), stream.errorReason().c_str());
}

void setup() {

  Serial.begin(115200);
  // //Soil water level
  pinMode(s1Pin, INPUT);
  pinMode(s2Pin, INPUT);
  pinMode(s3Pin, INPUT);
  pinMode(s4Pin, INPUT);
  pinMode(s5Pin, INPUT);
  
  pinMode(l1Pin, OUTPUT);
  pinMode(l2Pin, OUTPUT);
  pinMode(l3Pin, OUTPUT);
  pinMode(l4Pin, OUTPUT);
  pinMode(l5Pin, OUTPUT);

  pinMode(wifiLed, OUTPUT);
  digitalWrite(wifiLed, LOW);
 
  //WIFI
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  unsigned long ms = millis();
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  digitalWrite(wifiLed, HIGH);
  Serial.println();

  //FIREBASE
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  // Comment or pass false value when WiFi reconnection will control by your code or third party library
  Firebase.reconnectWiFi(true);

  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;

  // Getting the user UID might take a few seconds
  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }
  // Print user UID
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);

  path = "devices/" + uid + "/reading";

  //Stream setup
  if (!Firebase.beginStream(stream, "devices/" + uid + "/data"))
    Serial.printf("sream begin error, %s\n\n", stream.errorReason().c_str());

  Firebase.setStreamCallback(stream, streamCallback, streamTimeoutCallback);

}

void loop() {
    readSoil();
    // printData();
    if (Firebase.ready()){
      updateData();
    }
}

void updateData() {
  if ((millis() - sendDataPrevMillis > 5000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();
    FirebaseJson json;
    json.set("s1", s1Value);
    json.set("s2", s2Value);
    json.set("s3", s3Value);
    json.set("s4", s4Value);
    json.set("s5", s5Value);
    json.set(F("ts/.sv"), F("timestamp"));
    Serial.printf("Set json... %s\n", Firebase.RTDB.set(&fbdo, path.c_str(), &json) ? "ok" : fbdo.errorReason().c_str());
    Serial.println("");
  }
}

void printData() {
  if (millis() - printDataPrevMillis > 2000 || printDataPrevMillis == 0)
  {
    printDataPrevMillis = millis();
    Serial.print("S1: ");
    Serial.println(s1Value);
    Serial.print("S2: ");
    Serial.println(s2Value);
    Serial.print("S3: ");
    Serial.println(s3Value);
    Serial.print("S4: ");
    Serial.println(s4Value);
    Serial.print("S5: ");
    Serial.println(s5Value);
  }
}



void readSoil() {
  s1Value = analogRead(s1Pin);
  s2Value = analogRead(s2Pin);
  s3Value = analogRead(s3Pin);
  s4Value = analogRead(s4Pin);
  s5Value = analogRead(s5Pin);
}




