// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
//
// part 'lang_event.dart';
// part 'lang_state.dart';
//
// class LangBloc extends Bloc<LangEvent, LangState> {
//   final LangState langState;
//
//   LangBloc({@required this.langState}): super(langState);
//
//   @override
//   Stream<LangState> mapEventToState(
//       LangEvent event,
//       ) async* {
//     if (event is ChangeLanguageEvent) {
//       yield LangState(currentLocale: event.locale);
//     }
//   }
// }