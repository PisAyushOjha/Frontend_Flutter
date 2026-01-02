import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_info_provider.dart';
import 'user_info_form.dart';

void main() {
  runApp(const UserInfoApp());
}

class UserInfoApp extends StatelessWidget {
  const UserInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserInfoProvider(),
      child: MaterialApp(
        theme: ThemeData.light(
          useMaterial3: true,
        ).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 214, 115, 155),
          ),
        ),
        home: const UserInfoForm(),
      ),
    );
  }
}
