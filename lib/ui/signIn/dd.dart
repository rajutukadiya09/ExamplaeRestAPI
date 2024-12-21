import 'package:flutter/material.dart';

class GridListToggleView extends StatefulWidget {
  @override
  _GridListToggleViewState createState() => _GridListToggleViewState();
}

class _GridListToggleViewState extends State<GridListToggleView> {
  // Flag to track the current view (Grid or List)
  bool isGridView = true;

  // Sample data (You can replace this with your actual data model)
  final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid/List Toggle View'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              // Toggle between grid and list views
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // Fill the screen height
          child: isGridView
              ? GridView.builder(
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 10, // Horizontal spacing
              mainAxisSpacing: 10, // Vertical spacing
            ),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_present, // Sample icon, replace with logic for your data
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      items[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
              : ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(
                  Icons.file_present, // Sample icon, replace with logic for your data
                  color: Colors.grey,
                ),
                title: Text(items[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GridListToggleView(),
  ));
}
