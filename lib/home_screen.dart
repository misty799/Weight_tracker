import 'package:flutter/material.dart';
import 'package:flutter_application/auth_service.dart';
import 'package:flutter_application/models/weight_data.dart';
import 'package:flutter_application/providers/data_provider.dart';
import 'package:flutter_application/sign_in_page.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DataProvider provider;
  late double weight;
  @override
  void didChangeDependencies() {
    provider = Provider.of(context, listen: false);
    provider.fetchWeight();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addWeightDialog();
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
                onPressed: () async {
                  await AuthService.authService.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return const SignInPage();
                  }), (route) => false);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Consumer<DataProvider>(builder: (context, value, child) {
          if (value.dataList.isNotEmpty) {
            List<WeightData> data = value.dataList;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) {
                  return Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: ListTile(
                          leading: Text((i + 1).toString() + "."),
                          subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Weight"),
                                ElevatedButton(
                                    onPressed: () async {
                                      await provider
                                          .deleteWeight(data[i].docId!);
                                    },
                                    child: const Text('delete'))
                              ]),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              editWeightDialog(data[i].weight, data[i].docId!);
                            },
                          ),
                          title: Text(data[i].weight.toString())));
                });
          } else {
            return const Center(child: Text("Please add weight using + !!"));
          }
        }));
  }

  void addWeightDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Add Weight'),
            content: TextFormField(
              onChanged: (value) {
                weight = double.parse(value);
              },
              maxLines: 1,
              decoration: InputDecoration(
                  labelText: 'Weight in kg',
                  contentPadding: const EdgeInsets.all(20.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  )),
                  prefixIcon: Icon(Icons.star, color: Colors.yellow[500])),
            ),
            actions: [
              TextButton(
                child: const Text('cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('add'),
                onPressed: () async {
                  provider.addWeight(weight);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void editWeightDialog(double w, String docId) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Edit Weight'),
            content: TextFormField(
              initialValue: w.toString(),
              onChanged: (value) {
                weight = double.parse(value);
              },
              maxLines: 1,
              decoration: InputDecoration(
                  labelText: 'Weight in kg',
                  contentPadding: const EdgeInsets.all(20.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  )),
                  prefixIcon: Icon(Icons.star, color: Colors.yellow[500])),
            ),
            actions: [
              TextButton(
                child: const Text('cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('edit'),
                onPressed: () async {
                  await provider.editWeight(weight, docId);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
