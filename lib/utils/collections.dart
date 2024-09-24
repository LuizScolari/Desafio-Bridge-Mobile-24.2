/// Returns the next element in the list after the given element.
/// If the element is the last element in the list, the first element is returned.
T cycleNext<T>(T element, List<T> list) {
  final nextIndex = (list.indexOf(element) + 1) % list.length;
  return list[nextIndex];
}
