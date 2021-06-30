
import 'package:flutter_baber_taolaymay/model/service_model.dart';
import 'package:ntp/ntp.dart';

enum LOGIN_STATE {LOGGED , NOT_LOGIN}

const TIME_SLOT ={
  '6:00-6:30',
  '6:30-7:00',
  '7:00-7:30',
  '7:30-8:00',
  '8:30-9:00',
  '9:00-9:30',
  '9:30-10:00',
  '10:00-10:30',
  '10:30-11:00',
  '11:00-11:30',
  '11:30-12:00',
  '12:00-12:30',
  '12:30-13:00',
  '13:00-14:00',
  '14:00-15:00',
  '15:00-16:00',
  '16:00-17:00',
  '18:00-19:00',
  '19:00-20:00',
  '20:00-21:00',
  '21:00-22:00',
  '22:00-23:00',
  '23:00-00:00',


};
Future<int> getMaxAvailableTimeSlot(DateTime dt) async{
  DateTime now = dt.toLocal();
  int offset = await NTP.getNtpOffset(localTime: now); // sync time with server
  DateTime syncTime = now.add(Duration(milliseconds: offset));
  //Compare syncTime with local to time slot
  if( syncTime.isBefore(DateTime(now.year, now.month , now.day,6,30)) )
    return 0; // return next slot available
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,6,0)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,6,30)) )
    return 1; // return next slot available
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,6,30)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,7,00)) )
    return 2;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,7,30)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,8,00)) )
    return 3;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,8,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,8,30)) )
    return 4;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,8,30)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,9,00)) )
    return 5;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,9,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,9,30)) )
    return 6;// return next slot available
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,9,30)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,10,00)) )
    return 7;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,10,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,10,30)) )
    return 8;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,10,30)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,11,00)) )
    return 9;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,11,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,11,30)) )
    return 10;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,11,30)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,12,00)) )
    return 11;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,12,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,12,30)) )
    return 12;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,12,30)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,13,00)) )
    return 13;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,13,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,14,00)) )
    return 14;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,14,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,15,00)) )
    return 15;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,15,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,16,00)) )
    return 16;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,16,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,17,00)) )
    return 17;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,17,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,18,00)) )
    return 18;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,18,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,19,00)) )
    return 19;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,19,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,20,00)) )
    return 20;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,20,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,21,00)) )
    return 21;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,21,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,22,00)) )
    return 22;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,22,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,23,00)) )
    return 23;
  else if(syncTime.isAfter(DateTime(now.year, now.month , now.day,23,00)) && syncTime.isBefore(DateTime(now.year, now.month , now.day,00,00)) )
    return 24;
  else return 25;
}

Future<DateTime> syncTime() async{
  var now = DateTime.now();
  var offset = await NTP.getNtpOffset(localTime: now);
  return now.add(Duration(milliseconds: offset));
}

String convertServices(List<ServiceModel> services)
{
  String result = '';
  if(services != null && services.length > 0)
    {
      services.forEach((element) {
        result += '${element.name},';
      });

    }
  return result.substring(0,result.length-2);
}