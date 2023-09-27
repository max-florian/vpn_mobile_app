import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

int _countdown = 10;
Timer? _timer;

OverlayEntry? _overlayEntry;

// You can use your own images and texts here
List<String> _images = [
  'https://i.imgur.com/1QgrNNw.png',
  'https://i.imgur.com/6qyCwQ9.png',
  'https://i.imgur.com/2f9L5wZ.png',
  'https://i.imgur.com/8DK0gsl.png',
  'https://i.imgur.com/5tjN9xj.png',
  'https://i.imgur.com/dwK0H2I.png',
  'https://i.imgur.com/Vo5mFZJ.png',
  'https://i.imgur.com/Dg7ZWop.png',
  'https://i.imgur.com/9jEzwoh.png',
  'https://i.imgur.com/IvPjMzM.png',
];

List<String> _texts = [
  'Server 1',
  'Server 2',
  'Server 3',
  'Server 4',
  'Server 5',
  'Server 6',
  'Server 7',
  'Server 8',
  'Server 9',
  'Server 10',
];

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirstClick = true;
  String _chosenServer = 'Choose Server';
  // Define a global key for the scaffold widget
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Define a method to toggle the navigation drawer
  void _toggleDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // Define a method to perform an action when the power button is pressed
  void _onPowerPressed() {
    // You can write your own logic here, such as connecting to a server or showing a message
    print('Connect button pressed');
    // Show the floating view
    _showOverlay();
    // Start the timer
    _startTimer();
  }

  void _onClosePressed() {
    // You can write your own logic here, such as hiding the floating view or canceling the connection
    print('Close button pressed');
    // Hide the floating view
    _hideOverlay();
  }

  void _startTimer() {
    // Cancel any existing timer
    _timer?.cancel();
    // Reset the countdown value to 10
    setState(() {
      _countdown = 10;
    });
    // Create a new timer that runs every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Update the countdown value by subtracting one
      setState(() {
        _countdown--;
      });
      // If the countdown reaches zero, stop the timer and perform an action
      if (_countdown == 0) {
        timer.cancel();
        // You can write your own logic here, such as connecting to a server or showing a message
        print('Countdown finished');
      }
    });
  }

  void _stopTimer() {
    // Cancel any existing timer
    _timer?.cancel();
    // Reset the countdown value to 10
    setState(() {
      _countdown = 10;
    });
  }

  void _onChooseServerPressed() {
    //_showNotificationAlert();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServerListScreen(
          onServerChosen: (server) {
            setState(() {
              _chosenServer = server;
            });
          },
        ),
      ),
    );
  }

  void _onFloatingPressed() {
    // You can write your own logic here, such as showing a message or opening a new screen
    print('Floating button pressed');
  }

  void _showOverlay() {
    // Create the overlay entry object if it is null
    _overlayEntry ??= _createOverlayEntry();
    // Insert the overlay entry object into the overlay of the current context
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    // Remove the overlay entry object from the overlay of the current context if it is not null
    _overlayEntry?.remove();
    // Set the overlay entry object to null
    _overlayEntry = null;
  }

  void _showNotificationAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Receive Notifications'),
          content: Text('Do you want to receive notifications?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                print('User has cancelled the notification request');
              },
            ),
            TextButton(
              child: Text('Accept'),
              onPressed: () {
                Navigator.of(context).pop();
                print('User has accepted the notification request');
                // You can add your logic here to handle the notification acceptance
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Return a scaffold widget that provides the basic structure for your app
    return Scaffold(
      // Assign the global key to the scaffold widget
      key: _scaffoldKey,
      // Define an app bar widget that shows the title and an icon button to open the drawer
      appBar: AppBar(
        title: Text('Free VPN'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.menu),
        //     onPressed: _toggleDrawer,
        //   ),
        // ],
      ),
      // Define a drawer widget that shows the navigation items
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // You can add your own drawer items here, such as ListTile widgets
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlogScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // You can write your own logic here, such as navigating to another screen or closing the drawer
                print('Item 2 tapped');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          'S',
          style: TextStyle(
            fontSize: 30, // You can adjust this value to change the text size
          ),
        ),
        onPressed: _onFloatingPressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // Define a body widget that shows the power button in the center of the screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text(
                _chosenServer,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: _onChooseServerPressed,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Container(
                width:
                    200, // You can adjust this value to change the width of the button
                height:
                    200, // You can adjust this value to change the height of the button
                alignment: Alignment
                    .center, // This will center the text inside the button
                child: Text(
                  'Connect',
                  style: TextStyle(
                    fontSize:
                        30, // You can adjust this value to change the text size
                  ),
                ),
              ),
              onPressed: _onPowerPressed,
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(), // This will make the button round
                padding: EdgeInsets
                    .zero, // This will remove any extra padding around the button
              ),
            ),
            SizedBox(height: 20),
            Text(
              '$_countdown',
              style: TextStyle(
                color: Colors.black,
                fontSize: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBlogPost(BlogPost post) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(post.image),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              post.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'By ${post.author} on ${post.date}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              post.body,
              style: TextStyle(fontSize: 16),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBlogList(List<BlogPost> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return buildBlogPost(posts[index]);
      },
    );
  }

  OverlayEntry _createOverlayEntry() {
    // Return an overlay entry object
    return OverlayEntry(
      // Use a container widget for its child
      builder: (context) => Container(
        // Set the width and height to match the screen size
        width: MediaQuery.of(context).size.width *
            0.8, // This will make the container 80% of the screen width
        height: MediaQuery.of(context).size.height * 0.8,
        // Add a color property and set its value to Colors.white
        color: Colors.white,
        // Use a stack widget to position the text and the button inside the container
        child: Stack(
          // Use two positioned widgets for the stack's children
          children: [
            // Use a positioned widget to place the text in the center of the screen
            Positioned(
              left: 0,
              right: 0,
              // Set the top and bottom properties to null
              top: null,
              bottom: null,
              // Use a text widget to display a text
              child: Text(
                'Connecting...',
                style: TextStyle(
                  fontSize:
                      30, // You can adjust this value to change the text size
                ),
                textAlign:
                    TextAlign.center, // This will center the text horizontally
              ),
            ),

            // Use a positioned widget to place the button in the top right corner of the screen
            Positioned(
              right:
                  10, // You can adjust this value to change the horizontal position of the button
              top:
                  10, // You can adjust this value to change the vertical position of the button
              // Use an elevated button widget to display a button with an "X" icon
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ), // Replace with your icon
                label: Text(''), // Empty text
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onClosePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServerListScreen extends StatelessWidget {
  final ValueChanged<String> onServerChosen;

  ServerListScreen({required this.onServerChosen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server List'),
      ),
      body: ListView.builder(
        itemCount: _texts.length,
        itemBuilder: (context, index) {
          return ListTile(
            // Use an image.network widget to display an image from a URL
            leading: Image.network(_images[index]),

            title: Text(_texts[index]),
            onTap: () {
              onServerChosen(_texts[index]);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

class BlogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          // Add your search logic here
          onChanged: (value) {
            print('Search text: $value');
          },
        ),
      ),
      body: Center(
        child: Text('BlogScreen Content'),
      ),
    );
  }
}

class BlogPost {
  final String title;
  final String author;
  final String date;
  final String image;
  final String body;

  BlogPost(
      {this.title = 'titulo',
      this.author = 'autor',
      this.date = 'fecha',
      this.image = 'imagen',
      this.body = 'body'});

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      title: json['title'],
      author: json['author'],
      date: json['date'],
      image: json['image'],
      body: json['body'],
    );
  }
}

Future<List<BlogPost>> fetchBlogPosts() async {
  final response = await http.get(Uri.parse('https://example.com/api/blog'));
  if (response.statusCode == 200) {
    // If the server returns a OK response, then parse the JSON.
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((json) => BlogPost.fromJson(json)).toList();
  } else {
    // If the server did not return a OK response,
    // then throw an exception.
    throw Exception('Failed to load blog posts');
  }
}
