
class BaseData{
  DateTime date;
  List<String> thoughts;
  int mark;

  BaseData(DateTime dateTime, List<String> list, int m)
  {
    this.date = new DateTime(dateTime.year,dateTime.month,dateTime.day);
    this.thoughts=list;
    this.mark=(m/100.0).round();
  }
}