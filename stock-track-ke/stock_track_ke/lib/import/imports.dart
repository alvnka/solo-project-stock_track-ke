//dart related imports
// Import dart:js only when the platform is web
// or else use an empty mock class
export 'package:flutter/foundation.dart'
    if (kIsWeb) 'dart:js' show context, JsObject;
//export 'dart:io';
//flutter related imports
export 'package:flutter/material.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:flutter/foundation.dart';
//export 'package:webview_flutter/webview_flutter.dart';
//pages imports
export 'package:stock_track_ke/Login_page/login_page.dart';
export 'package:stock_track_ke/HomePage/home_page.dart';
export 'package:stock_track_ke/SignUpPage/Sign_up.dart';
export 'package:stock_track_ke/main.dart';
export 'package:stock_track_ke/auth/signUpAuth.dart';
export 'package:stock_track_ke/auth/loginAuth.dart';
export 'package:stock_track_ke/Drawer/drawer.dart';
export 'package:stock_track_ke/trading_symbols/trading_symbols.dart';
export 'package:stock_track_ke/TrackingPages/CompanyDetails.dart';
//firebase imports
export 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:stock_track_ke/firebase_options.dart';
export 'package:firebase_database/firebase_database.dart' hide Query, Transaction, TransactionHandler;
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:flutterfire_ui/auth.dart' hide PhoneVerificationFailed;

//importing google sign in
export 'package:google_sign_in/google_sign_in.dart';
