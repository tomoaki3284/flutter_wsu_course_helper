class Logger {

  static void LogDetailed (String className, String method, String message) {
    print("-----------> $className :: $method >> $message <-----------");
  }

  static void LogException (var ex) {
    print('''*************\nException occurs :: \n$ex\n*************''');
  }

}