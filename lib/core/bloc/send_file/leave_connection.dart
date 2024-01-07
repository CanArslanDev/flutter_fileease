import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/send_file/enums/send_file_request_enum.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_bloc.dart';
import 'package:flutter_fileease/core/bloc/send_file/send_file_utils.dart';
import 'package:flutter_fileease/core/user/requests/connected_user_model.dart';
import 'package:flutter_fileease/core/user/user_bloc.dart';
import 'package:flutter_fileease/services/navigation_service.dart';

class FirebaseSendFileLeaveConnection {
  bool exitedConnection = false;
  Future<void> leaveCurrentConnection() async {
    final sendFileBloc = BlocProvider.of<FirebaseSendFileBloc>(
      NavigationService.navigatorKey.currentContext!,
    )..setStatus(FirebaseSendFileRequestEnum.exited);
    final user = BlocProvider.of<UserBloc>(
      NavigationService.navigatorKey.currentContext!,
    );
    if (sendFileBloc.openedLeaveAlertDialog == true) {
      Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
      Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
    } else {
      Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
    }
    await user.updateFirebaseConnectedUser(
      ConnectedUserModel(token: '', userID: '', username: ''),
    );
    final defaultModel = FirebaseSendFileUtils().getDefaultModel()
      ..firebaseDocumentName = sendFileBloc.state.firebaseDocumentName;
    sendFileBloc.setModel(defaultModel);
    await sendFileBloc
        .getSendFileFirebase()
        .updateFirebaseConnectionsCollection(
          defaultModel,
          leaveConnection: true,
        );

    await sendFileBloc.getSendFileFirebase().disposeListenConnection();
    exitedConnection = false;
  }

  Future<void> leaveConnectionAlertDialog(BuildContext context) async {
    final sendFileBloc = BlocProvider.of<FirebaseSendFileBloc>(
      NavigationService.navigatorKey.currentContext!,
    )..openedLeaveAlertDialog = true;
    return showDialog<Object>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Leave Connection'),
          content: const Text('Are you sure you want to quit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                sendFileBloc.openedLeaveAlertDialog = false;
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                sendFileBloc.openedLeaveAlertDialog = false;
                await BlocProvider.of<FirebaseSendFileBloc>(
                  context,
                ).leaveConnection();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ).then((value) {
      sendFileBloc.openedLeaveAlertDialog = false;
    });
  }
}
