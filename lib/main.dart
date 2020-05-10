import 'package:myapp/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'package:flare_flutter/flare_actor.dart';
void main() => runApp(Launch());

class Launch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),  
     );
  }
}
class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 12),() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
        }
      );
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlareActor("assets/animation.flr",
      alignment: Alignment.center,
      fit: BoxFit.fill,
      animation: "intro",
    )
   );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(
      value: AuthService().user, 
          child: MaterialApp(
                  debugShowCheckedModeBanner: false,

        home: Wrapper(),
      ),
    );
  }
}