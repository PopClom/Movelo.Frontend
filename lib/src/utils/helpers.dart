import 'package:dio/dio.dart';
import 'dart:math';

List<String> splitName(String fullName) {
  if (fullName == null)
    return ['', ''];

  List<String> splitFullName = fullName.split(' ');

  if (splitFullName.length == 1)
    return [splitFullName.first, ''];

  String lastName = splitFullName.removeLast();
  String firstName = splitFullName.join(' ');
  return [firstName, lastName];
}

bool is4xxError(error) {
  if (error is DioError &&
      error.type == DioErrorType.RESPONSE &&
      error.response != null &&
      error.response.statusCode >= 400 && error.response.statusCode < 500) {
      return true;
    }
  return false;
}

String generatePassword(bool _isWithLetters, bool _isWithUppercase,
    bool _isWithNumbers, bool _isWithSpecial, double _numberCharPassword) {

  //Define the allowed chars to use in the password
  String _lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
  String _upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  String _numbers = "0123456789";
  String _special = "@#=+!£\$%&?[](){}";

  //Create the empty string that will contain the allowed chars
  String _allowedChars = "";

  //Put chars on the allowed ones based on the input values
  _allowedChars += (_isWithLetters ? _lowerCaseLetters : '');
  _allowedChars += (_isWithUppercase ? _upperCaseLetters : '');
  _allowedChars += (_isWithNumbers ? _numbers : '');
  _allowedChars += (_isWithSpecial ? _special : '');

  int i = 0;
  String _result = "";

  //Create password
  while (i < _numberCharPassword.round()) {
    //Get random int
    int randomInt = Random.secure().nextInt(_allowedChars.length);
    //Get random char and append it to the password
    _result += _allowedChars[randomInt];
    i++;
  }

  return _result;
}
