import 'package:flutter/cupertino.dart';
import 'package:reminder_app/models/notif_data_store.dart';

class NotifsOperation extends ChangeNotifier {
  final List<Notifs> _notifs = <Notifs>[];

  List<Notifs> get getnotifs {
    return _notifs;
  }

  void addNewNotif(String id, String id2) {
    Notifs notif = Notifs(
      id: id,
      id2: id2,
    );
    notif.save();
    //count.channelCounter++;
    _notifs.add(notif);
    notifyListeners();
  }

  void deleteNote(Notifs notifs) {
    _notifs.remove(notifs);
    notifs.delete();
    notifyListeners();
  }
}
// void addToCal() {
// if (dCont.text.isEmpty && cCont.text.isEmpty) {
//       return;
//     } else if (cCont.text.isNotEmpty && dCont.text.isNotEmpty ) {
//       return;
//     } else {
      
//     }
// }

