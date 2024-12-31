class GerenrateNumberFromHexa {
  static String getDeviceAttributeAccordingToDeviceType(String deviceType) {
    switch (deviceType) {
      case "Fan":
        return "Speed";
      case "Bulb":
        return "Brightness";
      default:
        return "";
    }
  }

  static String hexaIntoStringAccordingToDeviceType(
      String deviceType, String action) {
    if (deviceType == "Fan") {
      return hexaIntoStringForFan(action);
    } else {
      return hexaIntoStringForBulb(action);
    }
  }

  static String hexaIntoStringForFan(String hexa) {
    switch (hexa) {
      case "0x0101":
        return "On";
      case "0x0100":
        return "Off";
      case "0x0110":
        return "0";
      case "0x0119":
        return "25";
      case "0x0132":
        return "50";
      case "0x014B":
        return "75";
      case "0x0164":
        return "100";
      default:
        return "";
    }
  }

  static String hexaIntoStringForBulb(String hexa) {
    switch (hexa) {
      case "0x0201":
        return "On";
      case "0x0200":
        return "Off";
      case "0x0210":
        return "0";
      case "0x0219":
        return "25";
      case "0x0232":
        return "50";
      case "0x024B":
        return "75";
      case "0x0264":
        return "100";
      default:
        return "";
    }
  }
}
