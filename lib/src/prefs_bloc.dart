import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsBlocError extends Error {
  final String message;

  PrefsBlocError(this.message);
}

class PrefsState {
  final bool showWebView;
  const PrefsState(this.showWebView);
}

class PrefsBloc {
  final _currentPrefs = BehaviorSubject<PrefsState>(seedValue: PrefsState(false));

  final _showViewPref = StreamController<bool>();

  PrefsBloc() {
    _loadSharedPrefs();
    _showViewPref.stream.listen((bool) {
      _saveNewPrefs(PrefsState(bool));
    });
  }

  Stream<PrefsState> get currentPrefs => _currentPrefs.stream;

  Sink<bool> get showWebView => _showViewPref.sink;

  void close() {
    _showViewPref.close();
    _currentPrefs.close();
  }

  Future<void> _loadSharedPrefs()  async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final sharedWebView = sharedPrefs.getBool('showWebView') ?? true;
    _currentPrefs.add(PrefsState(sharedWebView));
    // await Future.delayed(Duration(seconds: 10), () {});
    // _currentPrefs.add(PrefsState(false));
  }

  Future<void> _saveNewPrefs(PrefsState newState) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool('showWebView', newState.showWebView);
    _currentPrefs.add(newState);
  }

}
