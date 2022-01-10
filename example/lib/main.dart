import 'package:flutter/material.dart';
import 'package:nations/nations.dart';
import 'package:queen_validators/queen_validators.dart';

class LangConfig extends NationsConfig {
  @override
  List<NationsLoader> get loaders => [
        const QueenValidatorsNationsLoaders(),
      ];
}

Future<void> main() async {
  await Nations.boot(LangConfig());

  runApp(
    MaterialApp(
      title: 'Queen Validators 👑',
      debugShowCheckedModeBanner: false,
      supportedLocales: Nations.supportedLocales,
      locale: Nations.locale,
      localizationsDelegates: Nations.delegates,
      home: HomePage(),
      theme: ThemeData.light(),
    ),
  );
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Queen Validators 👑 ${Nations.locale}'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          final isFormValid = _formKey.currentState!.validate();
          if (isFormValid) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('the form is valid ✔'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('not valid form ❌'),
              ),
            );
          }
        },
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'IsRequired'),
                validator: qValidator([
                  // if textFeild trimmed value lenght > 0 it will pass
                  IsRequired(),
                ]),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'IsOptional'),
                validator: qValidator([
                  // if the textField contains value the rest of the validators will run
                  // else it will pass the validation with checking them
                  IsOptional(),

                  /// the input value must be a valid (`well formatted`) email address
                  const IsEmail(),
                ]),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'IsRequired AND IsEmail'),
                validator: qValidator([
                  IsRequired(),

                  /// the input value must be a valid (`well formatted`) email address
                  const IsEmail(),
                ]),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'MinLenght AND IsEmail'),
                validator: qValidator([
                  IsRequired(),

                  /// the input min length must be >= 5
                  MinLength(10),

                  /// the input max length must be <= 10
                  MaxLength(15),
                ]),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'IsIn AND IsNotIn'),
                validator: qValidator([
                  IsRequired(),
                  IsIn(['white', 'black', 'gray']),
                  IsNotIn(['red', 'blue', 'orange']),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
