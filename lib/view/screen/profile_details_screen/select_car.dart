import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/view_model/provider/from_provider/licence_provider.dart';

class SelectCar extends StatelessWidget {
  const SelectCar({super.key});

  @override
  Widget build(BuildContext context) {

    final carProvider = Provider.of<FromProvider>(context);

    return Scaffold(
        appBar: AppBar(title: const Text('Select Your Car')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Choose your car',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5,),
                    Text("*",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: carProvider.selectedCar,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  items: carProvider.carList
                      .map((car) => DropdownMenuItem(value: car, child: Text(car,style: TextStyle(color: AppColors.blue900,fontSize: 14),)))
                      .toList(),
                  onChanged: (value) {
                    carProvider.selectCar(value!);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await carProvider.saveCarToDatabase();
                  },
                  child: const Text('Save Car Selection',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
            ),
        );
    }
}