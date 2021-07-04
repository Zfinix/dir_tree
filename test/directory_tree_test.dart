import 'package:dir_tree/dir_tree.dart';
import 'package:test/test.dart';

void main() {
  test('Directory is not Empty', () async {
    final files = await DirectoryTree.get(
      path: './',
    );

    expect(files, isNotNull);
  });
  test('Finds only filtered Extension', () async {
    final files = await DirectoryTree.get(
      path: '.',
      options: DirectoryTreeOptions(
        extensions: [
          '.dart',
        ],
      ),
    );
    expect(files!.children!.length, greaterThan(1));
  });
}
