class UnixTimeStringGenerator {
  String generateTimeStringOf(int unixTime) {
    String day;
    String time;

    DateTime current = DateTime.now();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime);

    int today = DateTime(current.year, current.month, current.day).millisecondsSinceEpoch; //Uses milliseconds (and not microseconds) to be consistent with the backend
    if(unixTime>today) {
      day = "Today";
    } else if(unixTime > (today - 518400000)) { //This week, as in "within the 6 days before today 0:00", i.e. if it is currently Sunday 13:45, then it will go back until Monday 0:01
      day = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"][dateTime.weekday-1]; // weekday 1 = Monday, 7 = Sunday
    } else { //Display as DD.MM.YYYY without time
      return  _format(dateTime.day, dateTime.month,'.') + '.' + dateTime.year.toString();
    }
    time = _format(dateTime.hour, dateTime.minute,':');
    return day + " " + time;
  }

  String _format(int hours, int minutes, String separator) {
    return hours.toString().padLeft(2,'0') + separator + minutes.toString().padLeft(2,'0');
  }
}