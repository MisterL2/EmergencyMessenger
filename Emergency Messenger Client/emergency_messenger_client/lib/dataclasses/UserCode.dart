class UserCode {
  final String userCode;

  UserCode(this.userCode) {
    if(this.userCode.length!=100) { //Also checks for scenarios where userCode is null (as it crashes with Nullpointer on this call)
      throw Exception("UserCode needs to be length 100!");
    }
  }
}