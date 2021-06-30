

//import 'dart:js';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_baber_taolaymay/cloud_firestore/all_salon_ref.dart';
import 'package:flutter_baber_taolaymay/cloud_firestore/user_ref.dart';
import 'package:flutter_baber_taolaymay/model/barber_model.dart';
import 'package:flutter_baber_taolaymay/model/booking_model.dart';
import 'package:flutter_baber_taolaymay/model/city_model.dart';
import 'package:flutter_baber_taolaymay/model/salon_model.dart';
import 'package:flutter_baber_taolaymay/state/state_management.dart';
import 'package:flutter_baber_taolaymay/utils/utils.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserHistory extends ConsumerWidget {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context, watch) {
    var watchRefresh = watch(deleteFlagRefresh).state;
    return SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text('User History'), backgroundColor: Color(0xFF383838),),
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xFFFDF9EE),

          body: Padding(
            padding: const EdgeInsets.all(12), child: displayUserHistory(),),
        ));
  }

  displayUserHistory() {
    return FutureBuilder(
        future: getUserHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else {
            var userBookings = snapshot.data as List<BookingModel>;
            if (userBookings == null || userBookings.length == 0)
              return Center(child: Text('Cannot load Booking information'),);
            else
              return FutureBuilder(
                  future: syncTime(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),);
                    else {
                      var syncTime = snapshot.data as DateTime;
                      return ListView.builder(
                          itemCount: userBookings.length,
                          itemBuilder: (context, index) {
                            var isExpried = DateTime.fromMillisecondsSinceEpoch(
                                userBookings[index].timeStamp)
                                .isBefore(syncTime);
                            return Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(22))),
                              child: Column(
                                children: [
                                  Padding(padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Row(mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text('Date', style: GoogleFonts
                                                    .robotoMono(),),
                                                Text(DateFormat("dd/MM/yyyy")
                                                    .format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                        userBookings[index]
                                                            .timeStamp)
                                                ),
                                                  style: GoogleFonts.robotoMono(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight
                                                          .bold),),
                                              ],),
                                            Column(
                                              children: [
                                                Text('Time', style: GoogleFonts
                                                    .robotoMono(),),
                                                Text(TIME_SLOT.elementAt(
                                                    userBookings[index].slot),
                                                  style: GoogleFonts.robotoMono(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight
                                                          .bold),),
                                              ],)
                                          ],

                                        ),
                                        Divider(thickness: 1,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text('${userBookings[index]
                                                    .salonName}',
                                                  style: GoogleFonts.robotoMono(
                                                      fontSize: 20),
                                                ),
                                                Text('${userBookings[index]
                                                    .barberName}',
                                                  style: GoogleFonts.robotoMono(
                                                      fontSize: 20),
                                                )
                                              ],),
                                            Text('${userBookings[index]
                                                .salonAddress}',
                                              style: GoogleFonts.robotoMono(
                                                  fontSize: 15),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap:  (userBookings[index].done || isExpried )
                                        ? null : () {
                                    Alert(
                                        context: context,
                                        type: AlertType.warning,
                                        title: 'DELETE BOOKING',
                                        desc: 'Please delete also in your Calendar too',
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              'CANCEL',
                                              style: GoogleFonts.robotoMono(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            color: Colors.blueAccent,
                                          ),
                                          DialogButton(
                                            child: Text(
                                              'DELETE',
                                              style: GoogleFonts.robotoMono(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              cancelBooking(
                                                  context, userBookings[index]);
                                            },
                                            color: Colors.redAccent,
                                          )
                                        ]

                                    ).show();
                                  }, child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(22),
                                          bottomLeft: Radius.circular(22)
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          userBookings[index].done
                                              ? 'FINISH'
                                              : isExpried
                                              ? 'EXPRIED'
                                              : 'CANCEL',
                                          style: GoogleFonts.robotoMono(
                                              color: isExpried
                                                  ? Colors.grey
                                                  : Colors.white),),)
                                    ],),
                                  ),)
                                ],
                              ),
                            );
                          });
                    }
                  });
          }
        });
  }

  void cancelBooking(BuildContext context, BookingModel bookingModel) {
    var batch = FirebaseFirestore.instance.batch();
    var barberBooking = FirebaseFirestore.instance
        .collection('ALLSalon')
        .doc(bookingModel.cityBook)
        .collection('branch')
        .doc(bookingModel.salonId)
        .collection('barber')
        .doc(bookingModel.barberId) // Fixed
        .collection(DateFormat('dd_MM_yyyy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp)))
        .doc(bookingModel.slot.toString());
        var userBooking = bookingModel.reference;

        //Delete
        batch.delete(userBooking);
        batch.delete(barberBooking);

        batch.commit().then((value){

          //Referesh Data
          context.read(deleteFlagRefresh).state =! context.read(deleteFlagRefresh).state;
        });
    

  }
}
