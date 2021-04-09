// firestorePlacesInstance.collection("places").get().then(
//   (querySnapshot) {
//     print("All places & datetime ::");
//     querySnapshot.docs.forEach(
//       (value) {
//         temp_place = value.get("place");
//         temp_start = value.get("start");
//         allplaces[value.get("start")] = value.get("place");
//
//       },
//     );
//     print(allplaces);
//   },
// );
// var tp;
// if (allplaces.isNotEmpty) {
//   allplaces.forEach(
//     (k, v) => {
//       if (allplaces.containsKey(start.millisecondsSinceEpoch))
//         {
//           print("DateTime >>>>>>> NOOOOOOOOOOOO"),
//           tp = allplaces[k],
//           if (allplaces[k] == tp)
//             {
//               print("DateTime >>>>>>> NOOOOOOOOOOOO"),
//               print(allplaces.values),
//             }
//           else
//             {
//               print("DateTime >>>>>>> YESSSSSSSSSSSS"),
//               print(allplaces.keys),
//             }
//         },
//     },
//   );
// } else {
//   print(">>>>>>>>>>>>>>>>>>> All Places Empty <<<<<<<<<<<<<<<<<<<");
// }
// if (allplaces.containsKey(start.millisecondsSinceEpoch)) {
//   if (allplaces[start.millisecondsSinceEpoch] == _place) {
//     print("DateTime >>>>>>> NOOOOOOOOOOOO");
//     print(allplaces.values);
//   }
//   print("DateTime >>>>>>> YESSSSSSSSSSSS");
//   print(allplaces.keys);
// }

// } else if (allplaces.containsKey(start.millisecondsSinceEpoch)) {
//   print("DateTime >>>>>>> YESSSSSSSSSSSS");
//   print(allplaces.keys);
//   // showAlertDialog(
//   //   context,
//   //   title: 'Place & Date Time Conflicts',
//   //   content: 'Please choose a different Place & Date Time',
//   //   defaultActionText: 'OK',
//   // );
// } else if (allplaces.containsValue(_place)) {
//   print("Place >>>>>>>>>> YESSSSSSSSSSSS");
//   print(allplaces.values);
//   // showAlertDialog(
//   //   context,
//   //   title: 'Place & Date Time Conflicts',
//   //   content: 'Please choose a different Place & Date Time',
//   //   defaultActionText: 'OK',
//   // );

// if (allplaces.containsKey(start.millisecondsSinceEpoch) && allplaces.containsValue(_place)) {
//   showAlertDialog(
//     context,
//     title: 'Place & Date Time Conflicts',
//     content: 'Please choose a different Place & Date Time',
//     defaultActionText: 'OK',
//   );
// }
// else{
//   Navigator.of(context).pop();
// }

//Future<bool> getCloudFirestorePlaces() async {
  //   firestoreInstance.collection("places").get().then((querySnapshot) {
  //     print("All places & datetime ::");
  //     querySnapshot.docs.forEach((value) {
  //       allplaces[value.get("start")] = value.get("place");
  //       allplaces.entries.forEach((e) {
  //         print('{ key: ${e.key}, value: ${e.value} }');
  //       });
  //       // if (allplaces.containsKey(DateTime(_startDate.year, _startDate.month,
  //       //     _startDate.day, _startTime.hour, _startTime.minute))) {
  //       //   if (allplaces.containsValue(_place)) {
  //       //     return true;
  //       //   } else {
  //       //     return false;
  //       //   }
  //       // } else {
  //       //   return false;
  //       // }
  //     });
  //   }).catchError((onError) {
  //     print("ERROR");
  //     print(onError);
  //   });
  // }
  // Future getCloudFirestorePlaces() async {
  //   firestoreInstance.collection("places").add({
  //     "place" : "Helloo",
  //   });
  //   firestoreInstance.collection("places").get().then((querySnapshot) {
  //     print("users: results: length: " + querySnapshot.docs.length.toString());
  //     querySnapshot.docs.forEach((value) {
  //       print("users: results: value");
  //       places.add(value.get("place"));
  //       print(places.contains("Kathlal") ? "Yes" : "No");
  //       print(places);
  //
  //     });
  //   }).catchError((onError) {
  //     print("getCloudFirestoreUsers: ERROR");
  //     print(onError);
  //   });
  //   //return documents;
  //   // print(documents.contains("(Kathlal)") ? "Yes" : "No");
  // }