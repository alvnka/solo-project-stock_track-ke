import 'package:stock_track_ke/import/imports.dart';

class TrackPopup extends StatelessWidget {
  final String companyName;

  TrackPopup({required this.companyName});

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text("Track $companyName"),
      content: Container(
        height: 150,
        width: 200,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  hintText: "Set price to track",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue))),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Get the current user
                User? user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                // Get the price from the text field
                String? priceString = _controller.text;
                if (priceString == null || priceString.isEmpty) return;
                double price = double.tryParse(priceString) ?? 0.0;

                /* // Upload the information to Firebase Firestore
                FirebaseFirestore.instance
                    .collection("active_tracks")
                    .doc(user.uid)
                    .set({"timestamp": FieldValue.serverTimestamp()}, SetOptions(merge: true)); // create or update user document

                FirebaseFirestore.instance
                    .collection("active_tracks")
                    .doc(user.uid)
                    .collection(companyName)
                    .doc()
                    .set({
                      "price": price,
                      "timestamp": FieldValue.serverTimestamp(),
                    });
                 */

                var record = FirebaseFirestore.instance
                    .collection("active_tracks")
                    .doc(user.uid);

                record.set({
                  "name": companyName,
                  DateTime.now().millisecondsSinceEpoch.toString(): price,
                }, SetOptions(merge: true));

                // Close the pop-up window
                Navigator.pop(context);
              },
              child: Text("Track"),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
            )
          ],
        ),
      ),
    );
  }
}


/*class TrackPopup extends StatelessWidget {
  final String companyName;

  TrackPopup({required this.companyName});

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text("Track $companyName"),
      content: Container(
        height: 150,
        width: 200,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  hintText: "Set price to track",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue))),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle button press here
                Navigator.pop(context);
              },
              child: Text("Track"),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
            )
          ],
        ),
      ),
    );
  }
} */
