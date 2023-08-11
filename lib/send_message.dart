import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:nostr/nostr.dart';

class send_message {
  final channel = WebSocketChannel.connect(Uri.parse('wss://r.kojira.io'));
  String text;
  String item;
  String time;
  late String alltext;
  send_message(this.item, this.time, this.text);
  void sendMessage() {
    alltext = (item + "を" + time + "練習しました。" + "\n\n" + text);
    Event event = Event.from(
      kind: 1,
      content: alltext,
      privkey:
          "cad36caa1b5d5e80e835c21bf6f413b945a7599ea2c59b039dd9a82efb7eb746",
      tags: [],
    );
    channel.sink.add(event.serialize());
  }
}
