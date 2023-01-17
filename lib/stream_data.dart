class StreamData {
  final String key;
  final dynamic value;
  final dynamic oldValue;

  const StreamData({
    required this.key,
    required this.value,
    required this.oldValue,
  });

  @override
  String toString() {
    return 'StreamData{key: $key, value: $value, oldValue: $oldValue}';
  }
}
