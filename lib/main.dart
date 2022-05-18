import 'dart:io';

import 'package:behtarino/repositories/authentication/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'blocs/event/calendar_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'blocs/verify/verify_bloc.dart';
import 'core/bloc/bloc_observer.dart';
import 'core/utils/constants.dart';
import 'repositories/events/events_repository.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/splash/splash_screen.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {

  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  BlocOverrides.runZoned(
    () => runApp(MyApp()),
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AuthenticationRepository _authRepository = AuthenticationRepository(authenticationApiClient: AuthenticationApiClient(httpClient: http.Client()));
  final EventsRepository _eventsRepository = EventsRepository(eventsApiClient: EventsApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => LoginBloc(repository: _authRepository)),
        BlocProvider<VerifyBloc>(create: (_) => VerifyBloc(repository: _authRepository)),
        BlocProvider<CalendarBloc>(create: (_) => CalendarBloc(repository: _eventsRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: kAppName,
        theme: Theme.of(context).copyWith(
          appBarTheme: Theme
              .of(context)
              .appBarTheme
              .copyWith(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
            ),
            backgroundColor: Colors.white,
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/calendar': (context) => const CalendarScreen(),
        },
      ),
    );
  }
}