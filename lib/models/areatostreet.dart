List<String> areas() {
  return ['area1', 'area2'];
}

List<String> streets(String? area) {
  if (area == 'area1') {
    return ['street1', 'street2', 'street3'];
  } else if (area == 'area2') {
    return ['street4', 'street5'];
  } else {
    return ['street1', 'street2', 'street3', 'street4', 'street5'];
  }
}
