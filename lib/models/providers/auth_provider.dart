import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'dart:async';
import '../../utility/firebase_utility.dart' as firebase;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _userID;
  String? _idToken;
  DateTime? _expiryDate;

  String? get userID => _userID;
  String? get idToken => _idToken;

  Timer? _authTimer;

  bool get isAuthenticated {
    if (_idToken != null &&
        _userID != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signIn(
      {required String emailAddress, required String password}) async {
// call the firebase
    try {
      final _result = await firebase.FirebaseUtility()
          .signInUser(emailAddress: emailAddress, password: password);

      _parseResponse(result: _result);
      //saveto device
      await _saveToDevice();
      _autoLogout();
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  _decodeTokenFromDevice() async {
    try {
      //store the token in the device!
      final _preferences = await SharedPreferences.getInstance();
      if (!_preferences.containsKey('userPrefs')) {
        return;
      }
      //save the data
      final _prefs = _preferences.getString('userPrefs');
      final Map<String, Object> _decoded =
          jsonDecode(_prefs!) as Map<String, Object>;
    } catch (err) {
      rethrow;
    }
  }

//Code to save to the Device!
  Future<void> _saveToDevice() async {
    try {
      //store the token in the device!
      final _preferences = await SharedPreferences.getInstance();
      final _userPrefs = jsonEncode({
        'userID': _userID,
        'token': _idToken,
        'expiryDate': _expiryDate?.toIso8601String()
      });
      print('Saving $_userPrefs into devicestorage ');
      //save the data
      _preferences.setString('userPrefs', _userPrefs);
    } catch (err) {
      rethrow;
    }
  }

/*
{
  "idToken": "[ID_TOKEN]",
  "email": "[user@example.com]",
  "refreshToken": "[REFRESH_TOKEN]",
  "expiresIn": "3600",
  "localId": "tRcfmLH7..."
}
*/
  Future<void> signUp(
      {required String emailAddress, required String password}) async {
// call the firebase
    try {
      final _result = await firebase.FirebaseUtility()
          .signUpUser(emailAddress: emailAddress, password: password);

      _parseResponse(result: _result);

      //saveto device
      await _saveToDevice();
      _autoLogout();
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  void _parseResponse({required Map<String, dynamic> result}) {
    //set
    _userID = result['localId'];
    _idToken = result['idToken'];
    _expiryDate = DateTime.now().add(
      Duration(
        //   seconds: 2,
        seconds: int.parse(
          result['expiresIn'],
        ),
      ),
    );
  }

  void logout() {
    //reset all
    _idToken = _userID = _expiryDate = null;
    _authTimer?.cancel();
    _authTimer = null;
    notifyListeners();
    print('logout is called');
  }

  void _autoLogout() {
    print('Auto logout is called');
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final _timeToDifff = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _timeToDifff!), logout);
  }
}
