import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      title: 'Tradespecifix App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: theme.textTheme.copyWith(
          bodyText1: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
            textStyle: theme.textTheme.bodyText1,
          ),
          bodyText2: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
            textStyle: theme.textTheme.bodyText2,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Edit Profile'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final List<Country> countries;
  final buttonEnabled = ValueNotifier<bool>(false);
  final selectedCountry = ValueNotifier<Country>(Country('Canada'));
  bool _fNameChanged = false;
  bool _lNameChanged = false;
  bool _passChanged = false;

  @override
  void initState() {
    countries = [Country('Canada'), Country('USA'), Country('England')];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          onFieldSubmitted: (name) => _onSubmit(),
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (name) {
                            _fNameChanged = true;
                            _onChanged();
                          },
                          validator: (name) {
                            if (name!.isEmpty && _fNameChanged) {
                              return 'Firstname must not be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            labelText: 'First Name',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          onFieldSubmitted: (name) => _onSubmit(),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (name) {
                            _lNameChanged = true;
                            _onChanged();
                          },
                          validator: (name) {
                            if (name!.isEmpty && _lNameChanged) {
                              return 'Lastname must not be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            labelText: 'Last Name',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          onFieldSubmitted: (pass) => _onSubmit(),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (pass) {
                            _passChanged = true;
                            _onChanged();
                          },
                          validator: (pass) {
                            if (pass!.isEmpty && _passChanged) {
                              return 'Password must not be empty';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ValueListenableBuilder(
                          valueListenable: selectedCountry,
                          builder: (context, Country country, child) =>
                              DropdownButtonFormField(
                            value: country,
                            isExpanded: true,
                            onChanged: (Country? country) {
                              if (country == null) return;
                              selectedCountry.value = country;
                              _onChanged();
                            },
                            onSaved: (Country? country) => _onSubmit(),
                            validator: (Country? country) {
                              if (country == null) {
                                return 'Can\'t empty';
                              }
                              if (country.name != 'Canada') {
                                return 'Should residents in Canada';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelText: 'Select One Country',
                            ),
                            items: countries.map((country) {
                              return DropdownMenuItem(
                                value: country,
                                child: Text(country.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: buttonEnabled,
              builder: (context, bool status, child) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50)),
                child: const Text('Change password'),
                onPressed: formKey.currentState == null
                    ? null
                    : status
                        ? () => _onSubmit()
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onChanged() {
    buttonEnabled.value = formKey.currentState!.validate() &&
        _fNameChanged &&
        _lNameChanged &&
        _passChanged &&
        selectedCountry.value == Country('Canada');
  }

  void _onSubmit() {
    if (formKey.currentState!.validate()) {}
  }
}

class Country {
  Country(this.name);

  String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
