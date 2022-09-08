import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum _MenuOptions {
  navigationDelegate,
  userAgent,
  javascriptChannel,
}

class Menu extends StatefulWidget {
  const Menu({Key key, this.controller}) : super(key: key);

  final Completer<WebViewController> controller;

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: widget.controller.future, // Modify
      builder: (context, controller) {
        return PopupMenuButton<_MenuOptions>(
          onSelected: (value) async {
            switch (value) {
              case _MenuOptions.navigationDelegate:
                await controller.data.loadUrl('https://youtube.com');
                break;
              // Add from here ...
              case _MenuOptions.userAgent:
                final userAgent = await controller.data
                    .evaluateJavascript('navigator.userAgent');

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(userAgent),
                ));
                break;
              // ... to here.
              // Add from here ...
              case _MenuOptions.javascriptChannel:
                await controller.data.evaluateJavascript('''
var req = new XMLHttpRequest();
req.open('GET', "https://api.ipify.org/?format=json");
req.onload = function() {
  if (req.status == 200) {
    let response = JSON.parse(req.responseText);
    SnackBar.postMessage("IP Address: " + response.ip);
  } else {
    SnackBar.postMessage("Error: " + req.status);
  }
}
req.send();''');
                break;
              // ... to here.
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.navigationDelegate,
              child: Text('Navigate to YouTube'),
            ),
            // Add from here ...
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.userAgent,
              child: Text('Show user-agent'),
            ),
            // ... to here.
            // Add from here ...
            const PopupMenuItem<_MenuOptions>(
              value: _MenuOptions.javascriptChannel,
              child: Text('Lookup IP Address'),
            ),
            // ... to here.
          ],
        );
      },
    );
  }
}
