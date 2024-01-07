import 'dart:typed_data';

import 'package:flutter/material.dart';

@immutable
class ProfilePhotoCacheModel {
  const ProfilePhotoCacheModel({
    required this.name,
    required this.photo,
  });
  final String name;
  final Uint8List photo;
  @override
  bool operator ==(Object other) {
    if (other is ProfilePhotoCacheModel && other.runtimeType == runtimeType) {
      if (other.name == name) {
        return true;
      }
    }
    return false;
  }

  @override

  ///hashcode is given as name since comparison is made in the
  ///"Profile Photo Cache Avatar" widget.
  ///Because the model sent for comparison has an empty uint8list value.
  int get hashCode => name.hashCode;
}
