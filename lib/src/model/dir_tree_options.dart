class DirectoryTreeOptions {
  final bool normalizePath;
  final List<RegExp>? exclude;
  final List<String> extensions;
  final List<Object> attributes;

  DirectoryTreeOptions({
    this.normalizePath = false,
    this.exclude,
    this.extensions = const [],
    this.attributes = const [],
  });
}
