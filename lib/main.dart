import 'package:provider/provider.dart';
import 'package:reminder_app/providers/app_theme_provider.dart';

import '/utils/appRoutes.dart';
import '/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      builder:(context,_) => MaterialApp(
        themeMode: (Provider.of<ThemeProvider>(context).obj.isDark) ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          backgroundColor: Color(0XFFf6fafb),
          primaryColor: Color(0xffff7461),
          disabledColor: Color(0XFF4b5165),
          splashColor: Colors.white,
        ),
        darkTheme: ThemeData(
          backgroundColor: Color(0XFF4b5165),
          primaryColor: Color(0xffff7461),
          disabledColor: Colors.white,
          splashColor: Color(0XFF3e4653),
        ),
        debugShowCheckedModeBanner: false,
        title: "Astrology App",
        //home: HomePage(),
        initialRoute: AppRoutes().homePage,
        routes: routes,
      ),
    );
  }
}
