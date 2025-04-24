import 'package:flutter/material.dart';
import 'appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final items = List.generate(12, (i) => 'Appliance ${i + 1}');
    return Scaffold(
      appBar: const Appbar(),
      backgroundColor: const Color.fromARGB(255, 246, 245, 255),
      body: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(25),
            child: Container(
              width: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(62, 0, 0, 0),
                    blurRadius: 2,
                    offset: Offset(-.5, 1)
                  )
                ]
              ),
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  Text('Filter'),

                  SizedBox(height: 12),
                  
                ],
              ),
            )
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Appliances',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Image.asset(
                                  'web/icons/holderImage.png',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Padding(
                                padding: EdgeInsets.all(10),
                                  child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('title')
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
