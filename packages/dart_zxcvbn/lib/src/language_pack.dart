part of 'zxcvbn.dart';

abstract interface class LanguagePack {
  abstract final Dictionary dictionary;
  abstract final AdjacencyGraphsMixin? adjacencyGraphs;
  abstract final Translations? translations;
}
