# Directory Tree
A Dart library for creating a Dart object to represent directory trees.


# Getting Started
Import and initialize package

```dart
import 'package:dir_tree/dir_tree.dart';
```

# Documentation
## Limits

Get a Directory Tree
```dart
final files = await DirectoryTree.get(
      path: '.',
      options: DirectoryTreeOptions(
        extensions: [
          '.dart',
        ],
      ),
    );
```