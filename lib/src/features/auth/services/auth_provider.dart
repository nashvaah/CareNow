import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  // 🔹 Firebase instances
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  Locale _currentLocale = const Locale('en');
  bool _isFirstLaunch = true;
  bool _isLoading = true;
  double _textScaleFactor = 1.0;

  // Getters
  User? get currentUser => _currentUser;
  Locale get currentLocale => _currentLocale;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  double get textScaleFactor => _textScaleFactor;

  AuthProvider() {
    _loadState();
  }

  // 🔹 Load state
  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Language
    final langCode = prefs.getString('language_code');
    if (langCode != null) {
      _currentLocale = Locale(langCode);
      _isFirstLaunch = false;
    }

    // Load Text Scale
    final scale = prefs.getDouble('text_scale_factor');
    if (scale != null) {
      _textScaleFactor = scale;
    }

    // Check Firebase Auth State
    // _firebaseAuth.authStateChanges().listen((fb.User? firebaseUser) async {
    //   if (firebaseUser == null) {
    //     _currentUser = null;
    //     _isLoading = false;
    //     notifyListeners();
    //   } else {
    //     await _fetchUserProfile(firebaseUser.uid);
    //   }
    // });
      _firebaseAuth.authStateChanges().listen((fb.User? firebaseUser) async {
  try {
    if (firebaseUser == null) {
      _currentUser = null;
    } else {
      await _fetchUserProfile(firebaseUser.uid);
      return; // _fetchUserProfile already sets isLoading=false
    }
  }
  catch (e) {
    _currentUser = null;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
});

 }


  Future<void> _fetchUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        _currentUser = User.fromMap(data);

        // Sync language from Firestore if available
        // BLOCKED: Per user request, do not overwrite local language with DB language on login.
        // We only save to DB, but prioritize local session choice.
        /*
        if (data.containsKey('language') && data['language'] != null) {
             final savedLang = data['language'] as String;
             _currentLocale = Locale(savedLang);
             final prefs = await SharedPreferences.getInstance();
             await prefs.setString('language_code', savedLang);
        }
        */

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_role', _currentUser!.role.name);
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Set language
  Future<void> setLanguage(Locale locale) async {
    _currentLocale = locale;
    _isFirstLaunch = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);

    // Save to Firestore if logged in
    if (_currentUser != null) {
      await _firestore.collection('users').doc(_currentUser!.id).update({
        'language': locale.languageCode
      });
    }

    notifyListeners();
  }

  // 🔹 Toggle Elderly Mode (Text Scale)
  Future<void> toggleElderlyMode(bool enable) async {
    _textScaleFactor = enable ? 1.3 : 1.0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('text_scale_factor', _textScaleFactor);
    notifyListeners();
  }

  // 🔹 Register with Firebase
  Future<void> register(String email, String password, String name, UserRole role, [Map<String, dynamic>? additionalData]) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Firebase create user
      fb.UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      String? uniqueId;
      if (role == UserRole.elderly) {
        // Generate Unique ID for Elderly: ELD-<Last4DigitsOfUID>
        uniqueId = "ELD-${uid.substring(0, 4).toUpperCase()}";
      }

      // Create User Object
      final newUser = User(
        id: uid,
        name: name,
        email: email,
        role: role,
        uniqueId: uniqueId,
      );

      // Prepare data for Firestore
      final userData = newUser.toMap();

      // Save Preferred Language
      userData['language'] = _currentLocale.languageCode;
      userData['isActive'] = true; // Default active

      if (additionalData != null) {
        // --- CAREGIVER: RESOLVE ELDERLY LINK ---
        if (role == UserRole.caregiver && additionalData.containsKey('elderlyLinkOf')) {
           final linkId = additionalData['elderlyLinkOf'];
           // Find the elderly user with this uniqueId
           final query = await _firestore.collection('users').where('uniqueId', isEqualTo: linkId).limit(1).get();
           if (query.docs.isNotEmpty) {
             final elderlyUid = query.docs.first.id;
             userData['linkedElderlyIds'] = [elderlyUid];
           } else {
             // Optional: Fail registration or just ignore?
             // For now, we ignore but maybe we should warn logic in UI.
             // But to prevent blocking registration, we simply proceed without linking.
           }
        }

        userData.addAll(additionalData);
      }

      // Save to Firestore
      await _firestore.collection('users').doc(uid).set(userData);

      _currentUser = newUser;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', role.name);

      _isFirstLaunch = false;

    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw "emailAvailable";
      }
      throw e.message ?? "registrationFailed";
    } catch (e) {
      throw "unexpectedError";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Login with Name & Password (Custom Logic)
  Future<void> loginByName(String name, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // 1. Query Firestore for user with this name
      final querySnapshot = await _firestore
          .collection('users')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw "userNotRegistered";
      }

      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();

      // Check if account is active
      if (userData['isActive'] == false) {
        throw "accountDisabled";
      }

      // Check for Admin Approval (Hospital Staff)
      if (userData['role'] == 'hospitalStaff' && userData['isApproved'] == false) {
        throw "accountDisabled";
      }

      final email = userData['email'] as String;

      // 2. Sign in with the retrieved email
      fb.UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // 3. Fetch full profile
      await _fetchUserProfile(userCredential.user!.uid);

    } on fb.FirebaseAuthException catch (e) {
       if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw "incorrectPassword";
      }
      if (e.code == 'user-disabled') {
        throw "accountDisabled";
      }
      throw e.message ?? "Login failed";
    } catch (e) {
      if (e.toString().contains("userNotRegistered") || e.toString().contains("User not found")) {
        throw "userNotRegistered";
      }
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    notifyListeners();
  }

  // 🔹 Reset Password Link (Email)
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw "Could not send reset link. Check email.";
    }
  }

  // 🔹 Change Password (In App)
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = _firebaseAuth.currentUser;
    final email = user?.email;

    if (user != null && email != null) {
      // Re-authenticate first
      fb.AuthCredential credential = fb.EmailAuthProvider.credential(email: email, password: currentPassword);
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } else {
      throw "User not logged in";
    }
  }

  // 🔹 Caregiver: Manage Linked Elderly
  Future<void> updateLinkedElderly(List<String> newIds) async {
    if (_currentUser == null) return;

    // Update local state is tricky because User is final, so we refetch
    final uid = _currentUser!.id;
    await _firestore.collection('users').doc(uid).update({'linkedElderlyIds': newIds});
    await _fetchUserProfile(uid);
  }

  // 🔹 Fetch Linked Elderly Profiles
  Future<List<User>> fetchLinkedElderlyProfiles() async {
    if (_currentUser == null || _currentUser!.linkedElderlyIds.isEmpty) {
      return [];
    }

    try {
      final List<User> profiles = [];
      // Firestore 'in' query supports up to 10 items. If more, we need batching, but for now 5 is limit.
      // 1. Try fetching by Document ID (Standard behavior)
      var snapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: _currentUser!.linkedElderlyIds)
          .get();

      // 2. If no results found, or partial results, it likely means the stored IDs are 'uniqueId' (e.g., ELD-XXXX)
      //    instead of Document IDs (UIDs). We should try querying by 'uniqueId' field.
      if (snapshot.docs.isEmpty) {
         snapshot = await _firestore
            .collection('users')
            .where('uniqueId', whereIn: _currentUser!.linkedElderlyIds)
            .get();
      }

      for (var doc in snapshot.docs) {
        profiles.add(User.fromMap(doc.data()));
      }
      return profiles;
    } catch (e) {
      print("Error fetching linked profiles: $e");
      return [];
    }
  }
}

