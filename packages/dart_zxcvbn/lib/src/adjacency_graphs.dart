part of 'zxcvbn.dart';

class AdjacencyGraph {
  final Map<String, List<String?>> graph;

  const AdjacencyGraph(this.graph);
}

mixin AdjacencyGraphsMixin {
  Map<String, AdjacencyGraph> get entries;
}
