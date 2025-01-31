* 0.0.1: Initial release.
* 0.0.2: Fix.
* 0.0.4: Remove, get keys, get keys and values as Map, remove.
* 0.0.5: Encryption modes.
* 0.0.6: Support: double,int,boolean
* 0.0.7: listeners, stream, single listen, listen all prefs
* 0.1.0: listen single key
* 0.1.2: fix invoke listeners on clear(),remove()
* 0.4.0: SharedBuilder
* 0.5.3: Fix save empty string error
* 0.5.5: Remove Salsa20 algorithm
* 0.5.6: Add temporary solution for get() method, remove unnecessary Future from getKeys()
* 0.5.7: Add docs for methods, deprecate commit()
* 0.7.0: Add batch saving
* 0.7.3: Add removeWhere method
* 0.7.4: Add removeWhere method param notifyEach
* 0.7.5: Add defaultValue param
* 0.8.1: Add missing method setStringList()
* 0.8.2: Fix recursion error on SharedPreferencesAsync clear
* 0.8.3: Fixed #15
* 0.8.4: Added new methods getBool,setBool for better integration with SharedPreferences
* 0.8.6: Fix notify on clear, removeWhere
* 0.8.7: Update key value change notify logic(notify will be invoked only after key change), Fix tests
