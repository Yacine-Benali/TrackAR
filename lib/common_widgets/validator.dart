abstract class StringValidator {
  String validate(String value);
}

class IpAddressValidator implements StringValidator {
  @override
  String validate(String value) {
    Pattern pattern =
        r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'please enter a valid ip address';
    else
      return null;
  }
}

class PortValidator implements StringValidator {
  @override
  String validate(String value) {
    Pattern pattern =
        r'^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'please enter a valid port';
    else
      return null;
  }
}

class IpAddressAndPortValidator {
  final StringValidator ipAdressValidator = IpAddressValidator();
  final StringValidator portValidator = PortValidator();
}
