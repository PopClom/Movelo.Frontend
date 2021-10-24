import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> sendWhatsAppMessage(String destinationNumber, String message) async{
  var whatsappUrlAndroid = "whatsapp://send?phone=" + destinationNumber + "&text=${Uri.encodeQueryComponent(message)}";
  var whatappUrliOS ="https://wa.me/$destinationNumber?text=${Uri.encodeQueryComponent(message)}";

  if( await canLaunch(kIsWeb || Platform.isIOS ? whatappUrliOS : whatsappUrlAndroid) ){
    await launch(whatappUrliOS, forceSafariVC: false);
    return true;
  }else{
    return false;
  }
}