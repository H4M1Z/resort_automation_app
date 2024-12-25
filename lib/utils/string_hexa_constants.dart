class DeviceCommands {
  // Fan Commands
  static const String fanOn = "0x0101"; // Turn Fan ON
  static const String fanOff = "0x0100"; // Turn Fan OFF
  static const String fanFrequency25 = "0x0119"; // Fan Frequency 25%
  static const String fanFrequency50 = "0x0132"; // Fan Frequency 50%
  static const String fanFrequency75 = "0x014B"; // Fan Frequency 75%
  static const String fanFrequency100 = "0x0164"; // Fan Frequency 100%

  // Bulb Commands
  static const String bulbOn = "0x0201"; // Turn Bulb ON
  static const String bulbOff = "0x0200"; // Turn Bulb OFF
  static const String bulbBrightness25 = "0x0219"; // Bulb Brightness 25%
  static const String bulbBrightness50 = "0x0232"; // Bulb Brightness 50%
  static const String bulbBrightness75 = "0x024B"; // Bulb Brightness 75%
  static const String bulbBrightness100 = "0x0264"; // Bulb Brightness 100%

  // Other Devices (Add more as needed)
  // Example: Air Conditioner (AC)
  static const String acOn = "0x0301"; // Turn AC ON
  static const String acOff = "0x0300"; // Turn AC OFF
  static const String acCooling25 = "0x0319"; // AC Cooling 25%
  static const String acCooling50 = "0x0332"; // AC Cooling 50%
  static const String acCooling75 = "0x034B"; // AC Cooling 75%
  static const String acCooling100 = "0x0364"; // AC Cooling 100%

  // Utility Method to Print All Commands
  static void printAllCommands() {
    print("Fan Commands:");
    print("  ON: $fanOn, OFF: $fanOff");
    print("  Frequency 25%: $fanFrequency25, 50%: $fanFrequency50");
    print("  Frequency 75%: $fanFrequency75, 100%: $fanFrequency100");
    print("\nBulb Commands:");
    print("  ON: $bulbOn, OFF: $bulbOff");
    print("  Brightness 25%: $bulbBrightness25, 50%: $bulbBrightness50");
    print("  Brightness 75%: $bulbBrightness75, 100%: $bulbBrightness100");
    print("\nAC Commands:");
    print("  ON: $acOn, OFF: $acOff");
    print("  Cooling 25%: $acCooling25, 50%: $acCooling50");
    print("  Cooling 75%: $acCooling75, 100%: $acCooling100");
  }
}

void main() {
  // Example Usage
  print(DeviceCommands.fanOn); // Outputs: 0x0101
  DeviceCommands.printAllCommands(); // Prints all commands
}
