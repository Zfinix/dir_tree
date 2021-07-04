import 'package:dir_tree/dir_tree.dart';

void main(List<String> args) async {
  /// Get directory list
  final red = await DirectoryTree.get(path: '../lib/src/util');

  if (red != null) {
    var json = jsonPretty(red.toMap());
    print(json);
  }
}
