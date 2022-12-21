abstract class DbEntity<T> {
  final T id;
  DbEntity({
    required this.id,
  });

  Map<String, dynamic> toMap();
}

extension DistinctById<T extends DbEntity> on Iterable<T> {
  Iterable<T> distinct() {
    final ids = <dynamic>{};
    var list = List<T>.from(this);
    list.retainWhere((e) => ids.add(e.id));
    return list;
  }
}
