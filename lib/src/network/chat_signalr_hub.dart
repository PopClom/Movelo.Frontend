/*import 'package:fletes_31_app/src/utils/constants.dart' as Constants;
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/signalr_client.dart';

class ChatHub {
  static const String HUB_URL = Constants.HUBS_BASE_URL + 'chat/';

  String url;
  HubConnection connection;

  ChatHub(this.url) {
    connection = HubConnectionBuilder().withUrl(url, options: HttpConnectionOptions()).build();

    initializeConnection();
  }

  void initializeConnection() async {
    await connection.start();
  }
}*/