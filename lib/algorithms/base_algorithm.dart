import 'package:algorythm_app/domain/algorithm_step.dart';

abstract class Algorithm {
  List<AlgorithmStep> generateSteps(List<int> input);
}
