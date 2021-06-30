
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_baber_taolaymay/model/service_model.dart';
import 'package:flutter_baber_taolaymay/state/state_management.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<ServiceModel>> getServices(BuildContext context) async{
  var services = List<ServiceModel>.empty(growable: true);
  CollectionReference serviceRef = FirebaseFirestore.instance.collection('services');
  QuerySnapshot snapshot = await serviceRef.where(
      context.read(selectedSalon).state.docId, isEqualTo: true)
      .get();
  snapshot.docs.forEach((element) {
    var serviceModel = ServiceModel.fromJson(element.data());
    serviceModel.docId = element.id;
    services.add(serviceModel);
  });
  return services;

}