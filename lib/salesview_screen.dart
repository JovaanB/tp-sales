import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp_sales/dashboard_screen.dart';
import 'package:tp_sales/detail_sale_screen.dart';

class SalesViewScreen extends StatefulWidget {
  const SalesViewScreen({ Key? key }) : super(key: key);

  @override
  State<SalesViewScreen> createState() => _SalesViewScreenState();
}

class _SalesViewScreenState extends State<SalesViewScreen> {
  final db = FirebaseFirestore.instance;
  List<dynamic> _sales = [];

  Future getUserSales() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    var data = await db
      .collection("sales")
      .where('userId', isEqualTo: uid)
      .orderBy("timestamp", descending: true)
      .get();

    setState(() {
      _sales = List.from(data.docs.map((doc) => Sale.fromSnapShot(doc)));
    });    
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserSales();
  }

  @override
  Widget build(BuildContext context) {
   return WillPopScope(
     onWillPop: () async {
       return true;
     },
     child: Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Sales"),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: ListView.builder(
        itemCount: _sales.length,
        itemBuilder: (context, index) {
          return SaleItem(sale: _sales[index] as Sale);
        }
      )
    )
   );
  }
}

class SaleItem extends StatelessWidget {
  final Sale sale;

  const SaleItem({
    required this.sale,
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailSaleScreen(sale: sale),
            ),
          );
        },
        child: Container(
            color: Colors.black12,
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(sale.client, style: const TextStyle(fontSize: 30))  
                    )
                  ],
                ),
                Row(
                  children: [
                    Text("${sale.amount} €", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                  ],
                )
              ],
            ),
        )
      ) 
    );
  }
}