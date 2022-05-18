import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition){
    super.onTransition(bloc, transition);
    print('OnTransition: ${bloc.state}');
  }

  @override
  void onEvent(Bloc bloc, Object? event){
    super.onEvent(bloc, event);
    print('OnEvent: $event');
  }

  @override
  void onChange(BlocBase blocBase, Change change) {
    super.onChange(blocBase, change);
    print('OnChange: ${blocBase.state}');
  }

  @override
  void onError(BlocBase blocBase, Object error, StackTrace stackTrace) {
    super.onError(blocBase, error, stackTrace);
    print('OnError: $error');
  }
}