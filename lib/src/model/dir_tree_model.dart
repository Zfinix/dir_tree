import 'dart:convert';
import 'package:equatable/equatable.dart';

class DirTreeModel with EquatableMixin {
  final String path;
  final String name;
  final int size;
  final String? ext;
  final String type;
  final List<DirTreeModel>? children;

  DirTreeModel({
    this.path = '',
    this.name = '',
    this.size = 0,
    this.ext,
    this.type = '',
    this.children = const [],
  });

  DirTreeModel copyWith({
    String? path,
    String? name,
    int? size,
    String? ext,
    String? type,
    List<DirTreeModel>? children,
  }) {
    return DirTreeModel(
      path: path ?? this.path,
      name: name ?? this.name,
      size: size ?? this.size,
      ext: ext ?? this.ext,
      type: type ?? this.type,
      children: children ?? this.children,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'name': name,
      'size': size,
      if (ext != null && ext!.isNotEmpty) 'extension': ext,
      'type': type,
      if (children != null && children!.length > 0)
        'children': children?.map((x) => x.toMap()).toList(),
    };
  }

  factory DirTreeModel.fromMap(Map<String, dynamic> map) {
    return DirTreeModel(
      path: map['path'],
      name: map['name'],
      size: map['size'],
      ext: map['extension'],
      type: map['type'],
      children: List<DirTreeModel>.from(
        map['children']?.map(
          (x) => DirTreeModel.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DirTreeModel.fromJson(String source) => DirTreeModel.fromMap(
        json.decode(source),
      );

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      path,
      name,
      size,
      ext ?? '',
      type,
      children ?? [],
    ];
  }
}
