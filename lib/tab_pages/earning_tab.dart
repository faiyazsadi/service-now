import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';
import '../splash_screen/splash_screen.dart';

class EarningsTabPage extends StatefulWidget {
  String urlImage;
  EarningsTabPage({required this.urlImage});
  //const EarningsTabPage({super.key});

  @override
  State<EarningsTabPage> createState() => _EarningsTabPageState(urlImage);
}

class _EarningsTabPageState extends State<EarningsTabPage> {
  String urlImage;
  _EarningsTabPageState(this.urlImage);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(

          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('This is a snackbar')));

          leading: Builder(
            builder: (BuildContext context) {
              return CircleAvatar(
                backgroundColor: Colors.red.shade900,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.3, color: Colors.white),
                      shape: BoxShape.circle,
                    ),
                    child: urlImage != null ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(500),
                        child: Image.network(urlImage,
                          height: 35,
                          width: 35,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : Icon(Icons.person,
                      size: 15,
                      color: Colors.black,)
                ),
                radius: 5.0,
              );
            },
          ),

          title: Text("Dashboard",
            style: TextStyle(
              fontSize: 25,
              fontFamily: "Ubuntu",
            ),),
          centerTitle: false,
          backgroundColor: Colors.red.shade900,
          foregroundColor: Colors.white,
          elevation: 25,
          toolbarHeight: 60,
          actions: <Widget>[
            IconButton(
              onPressed: (){
                showDialog(context: context, builder: (BuildContext contest){return AlertDialog(
                  title: Text("Warning !!",
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.red.shade900,
                      fontFamily: "FredokaOne",
                    ),),
                  content: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0, top: 10.0),
                    child: Text('Are you sure to sign out?',
                      style: TextStyle(
                        fontSize: 23.0,
                        color: Colors.black45,
                        fontFamily: "Ubuntu",
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
                          driversRef.child(currentFirebaseuser!.uid).update({"isActive": false});
                          fAuth.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const MySplashScreen())));
                        },
                        child: Text(
                          "YES",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.red.shade900,
                            fontFamily: "Ubuntu",
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    ),
                    TextButton(onPressed:(){
                      Navigator.of(context).pop();
                    },
                        child: Text(
                          "No",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.red.shade900,
                            fontFamily: "Ubuntu",
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    ),
                    SizedBox(width: 0,)
                  ],
                );});
              },
              icon: Icon(Icons.logout_rounded,
                size: 30,),
              // onPressed: () {
              //   DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
              //   driversRef.child(currentFirebaseuser!.uid).update({"isActive": false});
              //   fAuth.signOut();
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: ((context) => const MySplashScreen())));
              // },

            ),
            SizedBox(width: 15,),
          ],
        ),
        body: SingleChildScrollView(
    child: Container(
    padding: const EdgeInsets.only(left:10, right: 10),
    child: Column(
    //padding: const EdgeInsets.all(8),
    children: <Widget>[
      SizedBox(height: 55,),
      Padding(
    padding: const EdgeInsets.all(15.0),
    child: Container(
    decoration: BoxDecoration(
    border: Border(
    bottom: BorderSide(width: 1, color: Colors.grey),
    )
    ),
    child: Column(
    children: [
    Center(
    child: Text('Total Service Completed',
    style: TextStyle(
    fontSize: 20,
    fontFamily: "Ubuntu",
    fontWeight: FontWeight.bold,
    color: Colors.black54,
    ),
    ),
    ),
    SizedBox(height: 13,),
    Center(
    child: Text("12345",
    style: TextStyle(
    fontSize: 40,
    fontFamily: "Ubuntu",
      color: Colors.red.shade900,
    ),
    ),
    ),
    SizedBox(height: 10,),
    ],
    ) ,
    ),
    ),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey),
              )
          ),
          child: Column(
            children: [
              Center(
                child: Text('Service Completed This Month',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Ubuntu",
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 13,),
              Center(
                child: Text("12",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: "Ubuntu",
                    color: Colors.red.shade900,
                  ),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ) ,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey),
              )
          ),
          child: Column(
            children: [
              Center(
                child: Text('Due Payment',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Ubuntu",
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 13,),
              Center(
                child: Text("12345 BDT",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: "Ubuntu",
                    color: Colors.red.shade900,
                  ),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ) ,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey),
              )
          ),
          child: Column(
            children: [
              Center(
                child: Text('User Rating',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Ubuntu",
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 13,),
              Center(
                child: Text("4.3/5",
                  style: TextStyle(
                    fontSize: 70,
                    fontFamily: "FredokaOne",
                    color: Colors.red.shade900,
                  ),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ) ,
        ),
      ),


      SizedBox(height: 60,),
    ]
    ),
    ),
    ),


        // Center(
        //   child: Column(
        //     children: [
        //       SizedBox(height: 80,),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 20.0, right: 20),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             Container(
        //               height: 30,
        //               width: 230,
        //               // decoration: BoxDecoration(
        //               //   border: Border.all(width: 2, color: Colors.black45),
        //               // ),
        //               child: Text("Total Service Completed",
        //                 style: TextStyle(
        //                   fontSize: 22,
        //                   fontFamily: "Ubuntu",
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.black45,
        //                 ),),
        //             ),
        //             Container(
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(20),
        //                 boxShadow: [BoxShadow(blurRadius: 10, color: Colors.blueGrey, spreadRadius: 0)],
        //               ),
        //               height: 80,
        //               width: 120,
        //               child: Container(
        //                 height: 80,
        //                 width: 120,
        //                 decoration: BoxDecoration(
        //                   border: Border.all(width: 0, color: Colors.black45),
        //                   borderRadius: BorderRadius.circular(20),
        //                   color: Colors.white,
        //                 ),
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(10.0),
        //                   child: Container(
        //                     height: 80,
        //                     width: 120,
        //                     child:  Text("123",
        //                       style: TextStyle(
        //                         fontSize: 50,
        //                         fontFamily: "Ubuntu",
        //                         fontWeight: FontWeight.bold,
        //                         color: Colors.red.shade900,
        //                       ),),
        //                   ),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //       SizedBox(height: 30,),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 20.0, right: 20),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             Container(
        //               height: 30,
        //               width: 230,
        //               child: Text("This month ",
        //                 style: TextStyle(
        //                   fontSize: 22,
        //                   fontFamily: "Ubuntu",
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.black45,
        //                 ),),
        //             ),
        //             Container(
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(20),
        //                 boxShadow: [BoxShadow(blurRadius: 10, color: Colors.blueGrey, spreadRadius: 0)],
        //               ),
        //               height: 80,
        //               width: 120,
        //               child: Container(
        //                 height: 80,
        //                 width: 120,
        //                 decoration: BoxDecoration(
        //                   border: Border.all(width: 0, color: Colors.black45),
        //                   borderRadius: BorderRadius.circular(20),
        //                   color: Colors.white,
        //                 ),
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(10.0),
        //                   child: Container(
        //                     height: 80,
        //                     width: 120,
        //                     child:  Text("123",
        //                       style: TextStyle(
        //                         fontSize: 50,
        //                         fontFamily: "Ubuntu",
        //                         fontWeight: FontWeight.bold,
        //                         color: Colors.red.shade900,
        //                       ),),
        //                   ),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //       SizedBox(height: 30,),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 20.0, right: 20),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             Container(
        //               height: 30,
        //               width: 230,
        //               child: Text("Due payment",
        //                 style: TextStyle(
        //                   fontSize: 22,
        //                   fontFamily: "Ubuntu",
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.black45,
        //                 ),),
        //             ),
        //             Container(
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(20),
        //                 boxShadow: [BoxShadow(blurRadius: 10, color: Colors.blueGrey, spreadRadius: 0)],
        //               ),
        //               height: 80,
        //               width: 120,
        //               child: Container(
        //                 height: 80,
        //                 width: 120,
        //                 decoration: BoxDecoration(
        //                   border: Border.all(width: 0, color: Colors.black45),
        //                   borderRadius: BorderRadius.circular(20),
        //                   color: Colors.white,
        //                 ),
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(10.0),
        //                   child: Container(
        //                     height: 80,
        //                     width: 120,
        //                     child:  Text("123455",
        //                       style: TextStyle(
        //                         fontSize: 50,
        //                         fontFamily: "Ubuntu",
        //                         fontWeight: FontWeight.bold,
        //                         color: Colors.red.shade900,
        //                       ),),
        //                   ),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //       SizedBox(height: 30,),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 20.0, right: 20),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             Container(
        //               height: 30,
        //               width: 230,
        //               child: Text("User Rating",
        //                 style: TextStyle(
        //                   fontSize: 22,
        //                   fontFamily: "Ubuntu",
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.black45,
        //                 ),),
        //             ),
        //             Container(
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(20),
        //                 boxShadow: [BoxShadow(blurRadius: 10, color: Colors.blueGrey, spreadRadius: 0)],
        //               ),
        //               height: 80,
        //               width: 120,
        //               child: Container(
        //                 height: 80,
        //                 width: 120,
        //                 decoration: BoxDecoration(
        //                   border: Border.all(width: 0, color: Colors.black45),
        //                   borderRadius: BorderRadius.circular(20),
        //                   color: Colors.white,
        //                 ),
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(10.0),
        //                   child: Container(
        //                     height: 80,
        //                     width: 120,
        //                     child:  Text("3.5/5",
        //                       style: TextStyle(
        //                         fontSize: 50,
        //                         fontFamily: "Ubuntu",
        //                         fontWeight: FontWeight.bold,
        //                         color: Colors.red.shade900,
        //                       ),),
        //                   ),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //
        //     ],
        //   ),
        // ),
// <<<<<<< HEAD
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: [
        //       ElevatedButton(
        //         onPressed: () {
        //           notifyActiveDrivers();
        //         },
        //         child: const Text('Request Help'),
        //         style: ElevatedButton.styleFrom(
        //             // icon:
        //             backgroundColor: Colors.deepPurple[700],
        //       ),
        //       ),
        //       SizedBox(width: 200),
        //       FloatingActionButton(
        //         child: const Icon(Icons.location_searching),
        //         onPressed: () {
        //           getCurrentLocation(context);
        //           getActiveUsers(context);
        //         }
        //       ),
        //     ],
        //   ),
        // )
// =======
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
        )
    );
  }
}
