import 'package:algorythm_app/domain/array_frame.dart';

abstract class ArrayAlgorithm {
  const ArrayAlgorithm();

  List<ArrayFrame> generateFrames(List<int> input);
}
