import 'package:flutter/material.dart';
import 'package:tp_sales/dashboard_screen.dart';


class DetailSaleScreen extends StatefulWidget {
  DetailSaleScreen({Key? key, required this.sale}) : super(key: key);
  final Sale sale;

  @override
  State<DetailSaleScreen> createState() => _DetailSaleScreenState();
}

class _DetailSaleScreenState extends State<DetailSaleScreen> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_DetailSaleScreenState');

  final _clientController = TextEditingController();

  final _amountController = TextEditingController();

  String? selectedValue;

  final _dropdownFormKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> get dropdownItems{
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("Vendu"),value: "sold"),
    DropdownMenuItem(child: Text("Visite technique validée"),value: "technical_visit"),
    DropdownMenuItem(child: Text("Financement validé"),value: "validated_financing"),
    DropdownMenuItem(child: Text("Annulé"),value: "cancelled"),
  ];
  return menuItems;
}

  void _onUpdateSale() {
    final saleDAO = SaleDAO();
    final updateValues = { "client": _clientController.text, "amount": _amountController.text, "status": selectedValue };
    print(updateValues);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text("Sales"),
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
          const Text("Modifier la vente", style: TextStyle(color: Colors.black, fontSize: 44.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24.0),
          Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        TextFormField( 
                        initialValue: widget.sale.client,
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
                          initialValue: widget.sale.amount,
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
                      DropdownButton(
                        value: selectedValue,
                        items: dropdownItems,
                        onChanged: (String? newValue){
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      RawMaterialButton(
                        constraints: BoxConstraints(maxWidth: 105.0, minHeight: 40.0),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _onUpdateSale();
                          }
                        },
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        child: Row(
                          children: const [
                            Icon(Icons.send),
                            SizedBox(width: 4),
                            Text('MODIFIER'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        ]
        )
      ),
    );
  }
}