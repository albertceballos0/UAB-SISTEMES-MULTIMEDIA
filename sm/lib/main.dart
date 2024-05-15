import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/providers/userProvider.dart';

import 'login_screen.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => userProvider(),
            ),
          ],
          child: const MyApp()
      ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BotanicAPP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: ScreenLogIn(),
    );
  }
}
