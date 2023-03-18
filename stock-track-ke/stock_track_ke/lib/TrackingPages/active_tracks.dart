import 'package:intl/intl.dart';
import 'package:stock_track_ke/import/imports.dart';

class ActiveTracksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Active Tracks")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("active_tracks")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          Map? data = snapshot.data?.data();
          if (data == null) {
            return Center(child: Text("No active tracks."));
          }
          print(snapshot.data?.data().toString());
          List<Widget> trackList = [];
          data.forEach((key, value) {
            if (value != null && key != "name") {
              var timeString = DateTime.fromMillisecondsSinceEpoch(int.parse(key));
              double price = value;
              trackList.add(
                Dismissible(
                  key: Key(key),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // Delete the track from the database
                    FirebaseFirestore.instance
                        .collection("active_tracks")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({key: null});
                  },
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(data['name'].toString()),
                      subtitle: ListTile(
                        title: Wrap(
                          direction: Axis.vertical,
                          spacing: 4,
                          children: [
                            Text("Price target set at Ksh. : $value"),
                            Text("set on${DateFormat("EEEE dd MMM yyy").format(timeString)}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          });
          return ListView(children: trackList);
        },
      ),
    );
  }
}
