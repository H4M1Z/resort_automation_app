//Global Maping function
String getDeviceAttributeAccordingToDeviceType(String deviceType) {
  switch (deviceType) {
    case "Fan":
      return "Speed";
    case "Bulb":
      return "Brightness";
    default:
      return "";
  }
}

String mapDeviceType(String deviceType) {
  switch (deviceType) {
    case "Fan":
      return "0x0101";
    case "Bulb":
      return "0x0201";
    default:
      return "Off";
  }
}

String getCommand(String action) {
  return bulbCommands[action] ?? "Unknown";
}

const Map<String, String> fanCommands = {
  "On": "0x0101",
  "Off": "0x0100",
  "0": "0x0110",
  "25": "0x0119",
  "50": "0x0132",
  "75": "0x014B",
  "100": "0x0164",
};

const Map<String, String> bulbCommands = {
  "On": "0x0201",
  "Off": "0x0200",
  "0": "0x0210",
  "25": "0x0219",
  "50": "0x0232",
  "75": "0x024B",
  "100": "0x0264",
};
