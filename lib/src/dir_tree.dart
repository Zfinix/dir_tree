import 'dart:io';

import 'package:path/path.dart' as PATH;

import 'model/dir_tree_model.dart';
import 'model/dir_tree_options.dart';

typedef DirectoryTreeFunc = Function(
  DirTreeModel item,
  String path,
  FileStat stats,
);

var constants = {
  FileSystemEntityType.directory: 'directory',
  FileSystemEntityType.file: 'file',
};

/// Gets Directory/Files as JSON Nodes
class DirectoryTree {
  ///
  /// Collects the files and folders for a directory path into an Object, subject
  /// to the options supplied, and invoking optional
  ///
  /// `String` path
  ///
  /// `DirectoryTreeOptions` options
  ///
  /// `DirectoryTreeFunc` onEachFile
  ///
  /// `DirectoryTreeFunc` onEachDirectory
  ///
  ///

  static Future<DirTreeModel?> get({
    required String path,
    DirectoryTreeOptions? options,
    DirectoryTreeFunc? onEachFile,
    DirectoryTreeFunc? onEachDirectory,
  }) async {
    var name = PATH.basename(path);

    path = options != null && options.normalizePath
        ? PATH.normalize(
            path,
          )
        : path;

    DirTreeModel item = DirTreeModel(
      name: name,
      path: PATH.normalize(
        path,
      ),
    );

    late FileStat stats;

    try {
      stats = await File(path).stat();
    } catch (e) {
      return null;
    }

    // Skip if it matches the exclude regex
    if (options != null && options.exclude != null) {
      for (var item in options.exclude!) {
        if (item.hasMatch(path)) {
          return null;
        }
      }
    }

    if (stats.type == FileSystemEntityType.file) {
      var ext = PATH.extension(path).toLowerCase();

      // Skip if it does not match the extension regex
      if (options != null && options.extensions.contains(ext) == false)
        return null;

      item = item.copyWith(
        size: stats.size,
        ext: ext,
        type: '${stats.type}',
      ); // File size in bytes

      if (onEachFile != null) {
        onEachFile(item, path, stats);
      }
    } else if (stats.type == FileSystemEntityType.directory) {
      var children = <DirTreeModel>[];

      var list = await Directory(path).list(recursive: true);

      await for (var e in list) {
        final item = await get(
          path: e.path,
          options: options,
          onEachFile: onEachFile,
          onEachDirectory: onEachDirectory,
        );

        if (item != null) {
          children.add(item);
        }
      }

      final size = children.length > 0
          ? children.map((e) => e.size).reduce(
                (a, b) => a + b,
              )
          : 0;

      item = item.copyWith(
        children: children,
        size: size,
        type: '${FileSystemEntityType.directory}',
      );

      if (onEachDirectory != null) {
        onEachDirectory(item, path, stats);
      }
    } else {
      return null; // Or set item.size = 0 for devices, FIFO and sockets ?
    }
    return item;
  }
}
