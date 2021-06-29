

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_baber_taolaymay/model/image_model.dart';



Future<List<ImageModel>> getLookbook() async{
  List<ImageModel> result = new List<ImageModel>.empty(growable: true);
  CollectionReference bannerRef = FirebaseFirestore.instance.collection('LookBook');
  QuerySnapshot snapshot = await bannerRef.get();
  snapshot.docs.forEach((element){
    result.add(ImageModel.fromJson(element.data()));

  });
  return result;

}
