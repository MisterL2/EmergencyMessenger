import 'dart:math';

class SecureRandomiser {
  static generateRandomString(int length, {String alphabet}) {
    var secureRandom = Random.secure();
    alphabet = alphabet ?? "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!";
    String generated = '';

    for(int i=0; i<length; i++) {
      int index = secureRandom.nextInt(alphabet.length-1);
      if(index+1 == alphabet.length) { //Avoid out-of-index issue
        generated += alphabet.substring(index);
      } else {
        generated += alphabet.substring(index,index+1);
      }

    }

    return generated;
  }
}