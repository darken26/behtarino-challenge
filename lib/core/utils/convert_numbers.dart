class Converter {

  convertToPersianNumbers(str) {
    String newString = str;
    const persianNumbers = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    if (newString.runtimeType == String) {
      for (int i = 0; i < 10; i++) {
        newString = newString.replaceAll(i.toString(), persianNumbers[i]);
      }
    }
    return newString;
  }

  convertToEnglishNumber(str) {
    String newString = str;
    const persianNumbers = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    if (newString.runtimeType == String) {
      for (int i = 0; i < 10; i++) {
        newString = newString.replaceAll(persianNumbers[i], i.toString());
      }
    }
    return newString;
  }

}