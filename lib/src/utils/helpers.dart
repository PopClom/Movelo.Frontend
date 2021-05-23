List<String> splitName(String fullName) {
  if (fullName == null)
    return ['', ''];

  List<String> splitFullName = fullName.split(' ');

  if (splitFullName.length == 1)
    return [splitFullName.first, ''];

  String lastName = splitFullName.removeLast();
  String firstName = splitFullName.join(' ');
  return [firstName, lastName];
}