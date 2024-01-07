import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fileease/core/bloc/firebase_core/firebase_core_bloc.dart';
import 'package:flutter_fileease/services/navigation_service.dart';

class FirebaseCoreNetwork {
  Future<void> initialize() async {
    await getSettingsCollectionFromFirebase();
  }

  Future<void> getSettingsCollectionFromFirebase() async {
    final collectionuser =
        FirebaseFirestore.instance.collection('settings').doc('settings');
    final docSnapshotuser = await collectionuser.get();
    final doc = docSnapshotuser.data();
    BlocProvider.of<FirebaseCoreBloc>(
      NavigationService.navigatorKey.currentContext!,
    ).setModel(
      doc,
    );
  }
}
