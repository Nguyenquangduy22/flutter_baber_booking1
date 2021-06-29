

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_baber_taolaymay/model/barber_model.dart';
import 'package:flutter_baber_taolaymay/model/booking_model.dart';
import 'package:flutter_baber_taolaymay/model/city_model.dart';
import 'package:flutter_baber_taolaymay/model/salon_model.dart';
import 'package:flutter_baber_taolaymay/state/state_management.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


Future<BookingModel> getDetailBooking(BuildContext context,int timeSlot) async{
  CollectionReference userRef = FirebaseFirestore.instance
      .collection('ALLSalon')
      .doc(context.read(selectedCity).state.name)
      .collection('branch')
      .doc(context.read(selectedSalon).state.docId)
      .collection('barber')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection(
            DateFormat('dd_MM_yyyy').format(context.read(selectedDate).state));
  DocumentSnapshot snapshot = await userRef.doc(timeSlot.toString()).get();
  if(snapshot.exists)
    {
      var bookingModel =
          BookingModel.fromJson(json.decode(json.encode(snapshot.data())));
      bookingModel.docId = snapshot.id;
      //bookingModel.customerPhone = FirebaseAuth.instance.currentUser.phoneNumber;
      bookingModel.reference = snapshot.reference;
      context.read(selectedBooking).state = bookingModel;
      return bookingModel;
    }else
      return BookingModel();

}

Future<List<CityModel>> getCities() async{
  var cities = new List<CityModel>.empty(growable: true);
  var cityRef = FirebaseFirestore.instance.collection('ALLSalon');
  var snapshot = await cityRef.get();
  snapshot.docs.forEach((element) {
    cities.add(CityModel.fromJson(element.data()));
  });
  return cities;
}

Future<List<SalonModel>> getSalonByCity(String cityName) async{
  var salons = new List<SalonModel>.empty(growable: true);
  var salonRef = FirebaseFirestore.instance.collection('ALLSalon').doc(cityName.replaceAll(' ', '')).collection('branch');
  var snapshot = await salonRef.get();
  snapshot.docs.forEach((element) {
    var salon = SalonModel.fromJson(element.data());
    salon.docId = element.id;
    salon.reference = element.reference;
    salons.add(salon);
  });
  return salons;
}

Future<List<BarberModel>> getBarbersBySalon(SalonModel salon) async{
  var barbers = new List<BarberModel>.empty(growable: true);
  var barberRef = salon.reference.collection('barber');
  var snapshot = await barberRef.get();
  snapshot.docs.forEach((element) {
    var barber = BarberModel.fromJson(element.data());
    barber.docId = element.id;
    barber.reference = element.reference;
    barbers.add(barber);
  });
  return barbers;
}

Future<List<int>> getTimeSlotOfBarber(BarberModel barberModel,String date) async{
  List<int> result = new List<int>.empty(growable: true);
  var bookingRef = barberModel.reference.collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  snapshot.docs.forEach((element) {
    result.add(int.parse(element.id));
  });
  return result;
}

Future<bool> checkStaffOfThisSalon(BuildContext context) async{
  ///ALLSalon/Paris/branch/BhqSEZpEi7ZMPGBGSw6a/barber/hvsRNxFCdANUiTlMWz7f
  DocumentSnapshot barberSnapshot = await FirebaseFirestore.instance
      .collection('ALLSalon')
      .doc('${context.read(selectedCity).state.name}')
      .collection('branch')
      .doc('${context.read(selectedSalon).state.docId}')
      .collection('barber')
      .doc(FirebaseAuth.instance.currentUser.uid).get(); // Compare uid of this staff
  return barberSnapshot.exists;

}

Future<List<int>> getBookingSlotOfBarber(BuildContext context,String date) async{
  //var barberSnapshot = FirebaseFirestore.instance.collection('ALLSalon').doc(context.read(selectedCity).state.name)
  var barberDocument =  FirebaseFirestore.instance
      .collection('ALLSalon')
      .doc('${context.read(selectedCity).state.name}')
      .collection('branch')
      .doc('${context.read(selectedSalon).state.docId}')
      .collection('barber')
      .doc(FirebaseAuth.instance.currentUser.uid); // Compare uid of this staff
  List<int> result = new List<int>.empty(growable: true);
  var bookingRef = barberDocument.collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  snapshot.docs.forEach((element) {
    result.add(int.parse(element.id));
  });
  return result;
}