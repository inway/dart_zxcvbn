part of 'zxcvbn.dart';

class AdjacencyGraph {
  final Map<String, List<String?>> graph;

  const AdjacencyGraph(this.graph);
}

abstract interface class AdjacencyGraphs {
  abstract final AdjacencyGraph azerty;
  abstract final AdjacencyGraph qwerty;
  abstract final AdjacencyGraph qwertz;
  abstract final AdjacencyGraph dvorak;
  abstract final AdjacencyGraph keypad;
  abstract final AdjacencyGraph keypadMac;
}
