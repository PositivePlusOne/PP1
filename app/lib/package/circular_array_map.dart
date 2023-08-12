class CircularArrayMap<T> {
  final int length;
  int front = 0;
  int rear = 0;
  late List<T?> data;
  Map<String, int> records = {};

  CircularArrayMap(this.length) {
    data = List.filled(length, null, growable: false); // Initialize with fixed length.
  }

  void put(String key, T value) {
    if (isFull()) {
      removeOldestRecord();
    }

    data[rear] = value;
    records[key] = rear;
    rear = (rear + 1) % length;
  }

  T? get(String key) {
    if (!records.containsKey(key)) {
      return null;
    }

    int? index = records[key];
    if (index == null) {
      // Handle potential nulls.
      return null;
    }

    records[key] = rear;
    rear = (rear + 1) % length;
    return data[index];
  }

  void removeOldestRecord() {
    String key = records.keys.first;
    records.remove(key);
    data[front] = null;
    front = (front + 1) % length;
  }

  bool isFull() => (rear + 1) % length == front;

  bool isEmpty() => front == rear;
}
