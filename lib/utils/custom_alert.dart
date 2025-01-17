import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';

void displayAlert(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    String message) {
  if (kIsWeb) {
    // Web-specific alert
    webAlert(context, message);
  } else {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Android-specific alert
        androidSnackBar(context, scaffoldKey, message);
        break;
      case TargetPlatform.iOS:
        // iOS-specific alert
        debugPrint("iOSAlertView");
        iOSAlertView(context, message);
        break;
      default:
        // Fallback for other platforms
        debugPrint("Platform not supported");
        genericAlert(context, message);
        break;
    }
  }
}

// Example of web alert function
void webAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void androidSnackBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      textScaleFactor: 1,
    ),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void iOSAlertView(BuildContext context, String message) {
  showDialog(
    barrierColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      content: Text(
        message,
        textScaleFactor: 1,
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text(
            "Close",
            textScaleFactor: 1,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

void genericAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Container getProgressDialog() {
  if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
    return Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
      ),
      child: const Center(child: CupertinoActivityIndicator(radius: 20)),
    );
  } else {
    // Default progress indicator for unsupported platforms
    return Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

void displayProgress(BuildContext context) {
  showDialog(
    barrierColor: Colors.transparent,
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: getProgressDialog().child,
        ),
      );
    },
  );
}

void hideProgress(BuildContext context) {
  Navigator.pop(context);
}

Widget displayActivityIndicator() {
  if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
    return const CircularProgressIndicator();
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return const CupertinoActivityIndicator(radius: 20);
  } else {
    // Default progress indicator for unsupported platforms
    return const CircularProgressIndicator();
  }
}

void hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}
