typedef JsonMap = Map<String, Object?>;

extension JsonMapValue on JsonMap {
  bool getBool(String key, {bool defaultTo = false}) =>
      this[key] as bool? ?? defaultTo;

  List<T> getList<T>(String key) {
    final value = this[key] as List?;

    if (value == null) {
      return const [];
    }

    if (value is List<T>) {
      return value;
    }

    return value.cast<T>();
  }

  Map<K, V> getMap<K, V>(String key) {
    final value = this[key] as Map?;

    if (value == null) {
      return const {};
    }

    if (value is Map<K, V>) {
      return value;
    }

    return value.cast<K, V>();
  }

  List<JsonMap> getJsonList(String key) {
    final list = this[key] as List?;

    if (list == null) {
      return const [];
    }

    if (list is List<JsonMap>) {
      return list;
    }

    return list.map((m) => (m as Map).cast<String, Object?>()).toList();
  }

  JsonMap getJson(String key) => getMap<String, Object?>(key);

  JsonMap getJsonFromPath(List<String> path) {
    var map = this;

    for (final segment in path) {
      map = map.getMap<String, Object?>(segment);
    }

    return map;
  }

  void putOrRemoveList(String key, List value) {
    if (value.isEmpty) {
      remove(key);
    } else {
      this[key] = value;
    }
  }

  void putOrRemoveMap(String key, Map value) {
    if (value.isEmpty) {
      remove(key);
    } else {
      this[key] = value;
    }
  }

  void putOrRemove(String key, Object? value) {
    if (value == null) {
      remove(key);
    } else {
      this[key] = value;
    }
  }
}
