import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pdoc/store/events/effects.dart';
import 'package:pdoc/store/delete-event/actions.dart';
import 'package:pdoc/store/index.dart';
import 'package:redux/redux.dart';
import 'package:pdoc/extensions/dio.dart';

import 'actions.dart';

Function loadDeleteEventThunk = ({
  required String eventId,
  required BuildContext ctx,
}) =>
    (Store<RootState> store) async {
      store.dispatch(LoadDeleteEvent());
      try {
        await Dio().authenticatedDio(ctx: ctx).delete('/event/$eventId');

        store.dispatch(LoadDeleteEventSuccess());
        store.dispatch(loadEventsThunk(ctx: ctx));
        Navigator.of(ctx).pop();
        Navigator.of(ctx).pop();
      } on DioError catch (e) {
        final String errorMsg = e.getResponseError(ctx: ctx);
        e.showErrorSnackBar(ctx: ctx, errorMsg: errorMsg);
        store.dispatch(LoadDeleteEventFailure(payload: errorMsg));
      }
    };
