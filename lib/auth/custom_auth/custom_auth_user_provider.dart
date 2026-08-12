import 'package:rxdart/rxdart.dart';

import 'custom_auth_manager.dart';

class ProcardTesteDeMelhoriasAuthUser {
  ProcardTesteDeMelhoriasAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<ProcardTesteDeMelhoriasAuthUser>
    procardTesteDeMelhoriasAuthUserSubject =
    BehaviorSubject.seeded(ProcardTesteDeMelhoriasAuthUser(loggedIn: false));
Stream<ProcardTesteDeMelhoriasAuthUser>
    procardTesteDeMelhoriasAuthUserStream() =>
        procardTesteDeMelhoriasAuthUserSubject
            .asBroadcastStream()
            .map((user) => currentUser = user);
