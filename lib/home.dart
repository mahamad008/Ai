import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
runApp(HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Somali AI ',
theme: ThemeData(
primarySwatch: Colors.green,
),
home: AIHomePage(),
);
}
}

class AIHomePage extends StatefulWidget {
  const AIHomePage({super.key});

@override
_AIHomePageState createState() => _AIHomePageState();
}

class _AIHomePageState extends State<AIHomePage> {
final TextEditingController _controller = TextEditingController();
String _response = '';
bool _isLoading = false;

Future<void> _getAIResponse(String userInput) async {
const String apiKey = "AIzaSyDbN-IUt4s-LfyrZjW9hOEhhmnWpeCQx8k"; // Replace with your actual API key
final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';




setState(() {
  _isLoading = true;
});

try {
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      "contents": [
        {
          "role": "user",
          "parts": [{"text": userInput}]
        }
      ],
      "generationConfig": {
        "temperature": 1,
        "topK": 64,
        "topP": 0.95,
        "maxOutputTokens": 8192,
        "responseMimeType": "text/plain"
      }
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    setState(() {
      _response = data['candidates'][0]['content']['parts'][0]['text'];
    });
  } else {
    setState(() {
      _response = 'Error: ${response.reasonPhrase}';
    });
  }
} catch (e) {
  setState(() {
    _response = 'An error occurred: $e';
  });
} finally {
  setState(() {
    _isLoading = false;
  });
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Somali AI'),
),
body: Padding(


    padding: const EdgeInsets.all(0),
    
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
      
            ),
   child: SingleChildScrollView(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                      _response.isEmpty ? 'Fariintu halkan ayay ka soo muqan doontaa..' : _response,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      
      Container(
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(100),
border: Border.all(color: Colors.deepPurple, width: 1.5),

),
child: ListTile(
contentPadding: const EdgeInsets.only(left: 8,right: 8),
title: Container(
decoration: BoxDecoration(
color: Colors.transparent, 
borderRadius: BorderRadius.circular(10),
),
child: TextField(
controller: _controller,
decoration: const InputDecoration(
hintText: 'Enter Anything You want',
border: InputBorder.none,
contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
),
maxLines: 1,
textInputAction: TextInputAction.done,
),
),
trailing: IconButton(
icon: const Icon(Icons.send, color: Colors.deepPurple),
onPressed: () {
if (_controller.text.isNotEmpty) {
_getAIResponse(_controller.text);
_controller.clear();
}
},
),
),
)



      ],
    ),
  ),
);
}
}