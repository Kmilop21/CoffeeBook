import 'dart:convert';
import 'package:coffeebook/pages/home_page.dart';
import 'package:coffeebook/pages/my_barista.dart';
import 'package:coffeebook/pages/my_recipes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class YourOpinionPage extends StatefulWidget {
  const YourOpinionPage({super.key});

  @override
  YourOpinionPageState createState() => YourOpinionPageState();
}

class YourOpinionPageState extends State<YourOpinionPage> {
  Map<String, dynamic>? questionsData;
  Map<String, int> responses = {};

  final TextEditingController _nameController = TextEditingController();
  String? _selectedGroup;
  final TextEditingController _relationshipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final String jsonString =
        await rootBundle.loadString('assets/opinion.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    // Initialize responses with default values (e.g., 0) for each question
    Map<String, int> initialResponses = {};
    data.forEach((category, questions) {
      for (var question in questions) {
        initialResponses[question['titulo']] =
            0; // Default value for each question
      }
    });

    setState(() {
      questionsData = data;
      responses = initialResponses; // Set the initial responses
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 197, 188, 161),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 146, 111, 102),
        title: const Text('Tu Opinión'),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 247, 232, 192),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.brown,
              ),
              child: const DrawerHeader(
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Mis recetas'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyRecipesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_cafe),
              title: const Text('Mi Barista'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyBaristaPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Tu opinión'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const YourOpinionPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: questionsData == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Información del usuario:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                        ),
                      ),
                      const SizedBox(height: 18),
                      DropdownButton<String>(
                        value: _selectedGroup,
                        hint: const Text('Selecciona tu grupo'),
                        onChanged: (value) {
                          setState(() {
                            _selectedGroup = value;
                          });
                        },
                        items: [
                          'Trabajando en sus propios pilotos',
                          'Trabajando en la misma área',
                          'Externo'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _relationshipController,
                        decoration: const InputDecoration(
                          labelText: 'Relación/Parentesco',
                        ),
                      ),
                    ],
                  ),
                ),
                // Wrap the result of map() in a Column widget
                Column(
                  children: questionsData!.entries.map((entry) {
                    return buildCategory(entry.key, entry.value);
                  }).toList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendEmail,
        child: const Icon(Icons.send),
      ),
    );
  }

  Widget buildCategory(String category, List questions) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category.toUpperCase(),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...questions.map((question) {
            return buildQuestion(
                question['titulo'], question['min'], question['max']);
          }),
        ],
      ),
    );
  }

  Widget buildQuestion(String title, String minLabel, String maxLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centers the stars
          children: List.generate(5, (index) {
            bool isSelected = (responses[title] ?? 0) > index;

            return IconButton(
              icon: Icon(
                isSelected ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  // If the first star is clicked twice, reset to 0
                  if (index == 0 && responses[title] != 0) {
                    responses[title] = 0; // Reset the rating to 0
                  } else {
                    responses[title] =
                        index + 1; // Set the rating to the current star value
                  }
                });
              },
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                minLabel,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                maxLabel,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Future<void> sendEmail() async {
    if (_nameController.text.isEmpty ||
        _selectedGroup == null ||
        _relationshipController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Por favor, completa todos los campos antes de enviar.'),
        ),
      );
    } else {
      String emailBody = 'Información del usuario:\n\n';
      emailBody += 'Nombre: ${_nameController.text}\n';
      emailBody += 'Grupo: $_selectedGroup\n';
      emailBody += 'Relación/Parentesco: ${_relationshipController.text}\n\n';

      emailBody += 'Opinión del usuario:\n\n';

      questionsData?.forEach((category, questions) {
        emailBody += '$category:\n';

        for (var question in questions) {
          final String title = question['titulo'];
          final int response = responses[title] ?? 0;

          emailBody += '- $title: $response estrellas\n';
        }

        emailBody += '\n';
      });

      final Email email = Email(
        body: emailBody,
        subject: 'Feedback de la CoffeeBook',
        recipients: ['cprovoste22@alumnos.utalca.cl'],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
    }
  }
}
