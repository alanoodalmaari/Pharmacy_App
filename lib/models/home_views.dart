import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/map_view.dart';
import 'package:pharmacy_app/models//user_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Pharmacy On Map'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => UserModel(), // ← crea
        child: Builder(builder: (context) {
          final model = Provider.of<UserModel>(context);

          if (model.homeState == HomeState.Loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (model.homeState == HomeState.Error) {
            return Center(child: Text('An Error Occured ${model.message}'));
          }
          final users = model.users;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name),
                leading: CircleAvatar(
                  child: Text(user.name.substring(0, 1)),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MapView(user: user)));
                },
                subtitle: Text(user.email),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.map),
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MapView()));
          }),
    );
  }
}
