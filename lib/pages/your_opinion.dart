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
      appBar: AppBar(title: const Text('Tu Opinión')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 48,
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
              leading: const Icon(Icons.coffee),
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
              leading: const Icon(Icons.coffee),
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
              leading: const Icon(Icons.coffee),
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
              children: questionsData!.entries.map((entry) {
                return buildCategory(entry.key, entry.value);
              }).toList(),
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
        Slider(
          value: (responses[title] ?? 0).toDouble(),
          min: 0,
          max: 5,
          divisions: 5,
          label: '${responses[title] ?? 0}',
          onChanged: (value) {
            setState(() {
              responses[title] = value.toInt();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width:
                  MediaQuery.of(context).size.width * 0.3, // Limits label width
              child: Text(
                minLabel,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              width:
                  MediaQuery.of(context).size.width * 0.3, // Limits label width
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
    // Start building the email body with a header
    String emailBody = 'Opinión del usuario:\n\n';

    // Iterate over the categories and their questions
    questionsData?.forEach((category, questions) {
      emailBody += '$category:\n'; // Add the category title

      // Iterate over each question in the category
      for (var question in questions) {
        final String title = question['titulo'];
        final int response =
            responses[title] ?? 0; // Get the response (default to 0)

        // Add the question and its response to the email body
        emailBody += '- $title: $response estrellas\n';
      }

      emailBody += '\n'; // Add a newline after each category
    });

    // Send the email
    final Email email = Email(
      body: emailBody,
      subject: 'Feedback de la CoffeeBook',
      recipients: ['cprovoste22@alumnos.utalca.cl'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}
