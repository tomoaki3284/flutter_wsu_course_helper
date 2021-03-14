import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:wsu_course_helper/Logger.dart';
import 'package:wsu_course_helper/Model/AppUser.dart';

class Database {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseReference usersRef =
      FirebaseDatabase.instance.reference().child('users');

  /// return true if registration succeed, if not then return false
  Future<bool> registerNewUser(AppUser user) async {
    Logger.LogDetailed('Database', 'registerNewUser()',
        'email - ${user.email}, password - ${user.password}');

    var uc = await _firebaseAuth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
    final User firebaseUser = uc.user;

    if (firebaseUser != null) {
      usersRef.child(firebaseUser.uid).set(user.getAppUserDataMap());
      return true;
    } else {
      Logger.LogDetailed(
          'Database.dart', 'registerNewUser()', 'err: firebase is null');
      return false;
    }
  }

  /// return user if log in succeed, if not then return null
  Future<AppUser> loginAndAuthenticateUser(
      {String email, String password}) async {
    Logger.LogDetailed('Database', 'loginAndAuthenticateUser()',
        'email - $email, password - $password');

    final UserCredential uc = (await _firebaseAuth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((err) {
      print(err.toString());
    }));

    final User firebaseUser = uc.user;
    // firebaseUser != null, successfully created, if null, not created
    if (firebaseUser != null) {
      // save user info to database
      AppUser result;
      await usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          result = AppUser.fromDatabase(snap.value);
        } else {
          _firebaseAuth.signOut();
          Logger.LogDetailed('Database.dart', 'LoginAndAuthenticateUser()',
              'err: snap.value is null');
        }
      });
      return result;
    } else {
      // show error
      Logger.LogDetailed('Database.dart', 'LoginAndAuthenticateUser()',
          'err: firebase is null');
      return null;
    }
  }

  Future<AppUser> _loginByUserUid(String uid) async {
    Logger.LogDetailed('Database', '_loginByUserUid()', 'method called');
    AppUser result;
    await usersRef.child(uid).once().then((DataSnapshot snap) {
      if (snap.value != null) {
        result = AppUser.fromDatabase(snap.value);
      } else {
        _firebaseAuth.signOut();
        Logger.LogDetailed('Database.dart', 'LoginAndAuthenticateUser()',
            'err: snap.value is null');
      }
    });
    return result;
  }

  /// if user logged in session reminded from last time, return that user, if not then return null
  Future<AppUser> checkoutCurrentUser() async {
    Logger.LogDetailed('Database', 'checkoutCurrentUser()', 'checking out');
    if (_firebaseAuth.currentUser != null) {
      User firebaseUser = _firebaseAuth.currentUser;
      AppUser user = await _loginByUserUid(firebaseUser.uid);
      Logger.LogDetailed(
          'Database', 'checkoutCurrentUser()', 'we have current user = $user');
      // _firebaseAuth.signOut();
      return user;
    } else {
      Logger.LogDetailed(
          'Database', 'checkoutCurrentUser()', 'no current session user');
      return null;
    }
  }

  Future<String> _getUidByAppUser(AppUser appUser) async {
    Logger.LogDetailed('Database', '_getUidByUser()', 'method called');
    final UserCredential uc = (await _firebaseAuth
        .signInWithEmailAndPassword(
      email: appUser.email,
      password: appUser.password,
    )
        .catchError((err) {
      print(err.toString());
    }));
    final User firebaseUser = uc.user;
    return firebaseUser.uid;
  }

  void updateUser(AppUser user) async {
    Logger.LogDetailed('Database', 'updateUser()', 'method called');
    if (user == null || user.email.length == 0) {
      Logger.LogDetailed('Database', 'updateUser()', 'but do not update');
      return;
    }
    String uid = await _getUidByAppUser(user);
    assert(uid != null);
    // update user info
    if (uid != null) {
      usersRef.child(uid).set(user.getAppUserDataMap());
    }
  }
}
