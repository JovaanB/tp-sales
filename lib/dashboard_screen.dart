import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tp_sales/main.dart';
import 'package:tp_sales/salesview_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({ Key? key }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class Sale {
  String client;
  String amount;
  String status;

  Sale(this.client, this.amount, this.status);

  Sale.fromSnapShot(snapShot)
    : client = snapShot.data()['client'],
      amount = snapShot.data()['amount'],
      status = snapShot.data()['status'];
}

class SaleDAO {
  final firestoreInstance = FirebaseFirestore.instance;

  void saveSale(Sale sale) {
    firestoreInstance.collection("sales").add(<String, dynamic>{
        'client': sale.client,
        'amount': sale.amount,
        'status': "sold",
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'name': FirebaseAuth.instance.currentUser!.displayName,
        'userId': FirebaseAuth.instance.currentUser!.uid
        }).then((value){
          print(value.id);
        });
  }

  void updateSale(String uid, values) {
    firestoreInstance
      .collection("sales")
      .doc(uid)
      .set(values)
      .catchError((e) {
      print(e);
    });
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final _formKey = GlobalKey<FormState>(debugLabel: '_DashboardScreenState');
  final _clientController = TextEditingController();
  final _amountController = TextEditingController();

  void _onAddSale() {
    final saleDAO = SaleDAO();
    final sale = Sale(_clientController.text, _amountController.text, "sold");
    saleDAO.saveSale(sale);
  }

  void signOut () async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            signOut();
          },
        ),
        title: const Text("Sales"),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: Padding(
      padding: const EdgeInsets.all(16.0), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Sales", style: TextStyle(color: Colors.black38, fontSize: 28.0, fontWeight: FontWeight.bold )),
          const Text("Nouvelle vente", style: TextStyle(color: Colors.black, fontSize: 44.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24.0),
          Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField( 
                        controller: _clientController, 
                        keyboardType: TextInputType.text, 
                        decoration: const InputDecoration(
                          hintText: "Nom",
                          prefixIcon: Icon(
                            Icons.account_circle, 
                            color: Colors.black
                            )
                        ),
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrer le nom du client';
                            }
                            return null;
                          },
                      ),
                      const SizedBox(width: 8),
                      TextFormField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            hintText: 'Montant',
                            prefixIcon: Icon(Icons.money, color: Colors.black,)
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrer le montant';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(width: 8),
                      RawMaterialButton(
                        constraints: BoxConstraints(maxWidth: 105.0, minHeight: 40.0),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _onAddSale();
                            _amountController.clear();
                            _clientController.clear();
                          }
                        },
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        child: Row(
                          children: const [
                            Icon(Icons.send),
                            SizedBox(width: 4),
                            Text('VALIDER'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child:
                RawMaterialButton(
                  onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SalesViewScreen()));
                  },
                  fillColor: Colors.blue,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                  child: const Text("Voir mes ventes", style: TextStyle(color: Colors.white, fontSize: 18.0),)
                ),
            )
          )]
        )
      ),
    );
  }
}