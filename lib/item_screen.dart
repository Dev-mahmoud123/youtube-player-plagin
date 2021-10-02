import 'package:flutter/material.dart';

import 'data.dart';
import 'home_screen.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Item${ids[index].no}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          ids: ids[index].url,
                        )));
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 10.0,
              ),
          itemCount: ids.length),
    );
  }
}
