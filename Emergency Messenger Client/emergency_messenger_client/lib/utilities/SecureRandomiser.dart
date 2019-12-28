import 'dart:math';

class SecureRandomiser {
  static generateRandomString(int length) {
    var secureRandom = Random.secure();
    String alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#"; //The # at the end is not part of the alphabet, it is just used so that the upper (exclusive) bound of substring does not cause an error.

    String generated = '';

    for(int i=0; i<length; i++) {
      int index = secureRandom.nextInt(alphabet.length-1);
      generated += alphabet.substring(index,index+1);
    }

    return generated;
  }
}