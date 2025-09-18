extension Validation on String{

  bool get isValidEmail {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return RegExp(pattern).hasMatch(this);
  }

  bool get isValidPassword {
    String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$';
    return RegExp(pattern).hasMatch(this);
  }

  bool get isValidPhoneNo {
    String pattern = r'^[6-9][0-9]{9}$';
    return RegExp(pattern).hasMatch(this);
  }

  String get trimString{
    return trim();
  }

  int get stringToInt{
    return int.parse(this);
  }

}