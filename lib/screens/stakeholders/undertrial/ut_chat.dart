import 'package:flutter/material.dart';

void main() {
  runApp(const MenuApp());
}

class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Today\'s Menu'),
        ),
        body: MenuScreen(),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  final Map<String, Map<String, List<MenuItem>>> menuData = {
    'Monday': {
      'Breakfast': [
        MenuItem('Poori with White Channa', 'assets/images/poori_chana.jpeg'),
        MenuItem(
            'Idli , Sambar and Groundnut Chutney', 'assets/images/idli.jpeg'),
        MenuItem('Vada', 'assets/images/vada.jpeg'),
        MenuItem('Bread , Butter and Jam', 'assets/images/breadjam.jpeg'),
        MenuItem('Tea/Coffee', 'assets/images/teacoffee.jpeg'),
      ],
      'Lunch': [
        MenuItem('Oil Chapathi', 'assets/images/oilchapati.jpeg'),
        MenuItem('Aloo Peas', 'assets/images/aloo_peas.jpeg'),
        MenuItem('Tomato Rice', 'assets/images/tomatorice.jpeg'),
        MenuItem('White Rice', 'assets/images/white_rice.jpeg'),
        MenuItem('Sambar', 'assets/images/sambar.jpeg'),
        MenuItem('Curd', 'assets/images/curd.jpeg'),
        MenuItem('Rasam', 'assets/images/rasam.jpeg'),
        MenuItem('Parupu Podi', 'assets/images/parupu_podi.jpeg'),
        MenuItem('Fruits', 'assets/images/fruits.jpeg'),
      ],
      'Snacks': [
        MenuItem('Tea/Coffee', 'assets/images/food_item_4.jpg'),
        MenuItem('Samosa', 'assets/images/food_item_5.jpg'),
      ],
      'Dinner': [
        MenuItem('Dinner Item 1', 'assets/images/food_item_6.jpg'),
      ],
    },
    'Tuesday': {
      'Breakfast': [
        MenuItem('Breakfast Item 1', 'assets/images/food_item_1.jpg'),
        MenuItem('Breakfast Item 2', 'assets/images/food_item_2.jpg'),
      ],
      'Lunch': [
        MenuItem('Lunch Item 1', 'assets/images/food_item_3.jpg'),
      ],
      'Snacks': [
        MenuItem('Snacks Item 1', 'assets/images/food_item_4.jpg'),
        MenuItem('Snacks Item 2', 'assets/images/food_item_5.jpg'),
      ],
      'Dinner': [
        MenuItem('Dinner Item 1', 'assets/images/food_item_6.jpg'),
      ],
    },
    'Wednesday': {
      'Breakfast': [
        MenuItem('Breakfast Item 1', 'assets/images/food_item_1.jpg'),
        MenuItem('Breakfast Item 2', 'assets/images/food_item_2.jpg'),
      ],
      'Lunch': [
        MenuItem('Lunch Item 1', 'assets/images/food_item_3.jpg'),
      ],
      'Snacks': [
        MenuItem('Tea/Coffee', 'assets/images/teacoffee.jpeg'),
        MenuItem('Samosa', 'assets/images/samosa.jpg'),
      ],
      'Dinner': [
        MenuItem('Oil Chapathi', 'assets/images/oilchapati.jpeg'),
        MenuItem('Aloo Peas', 'assets/images/aloo_peas.jpeg'),
        MenuItem('Tomato Rice', 'assets/images/tomatorice.jpeg'),
        MenuItem('White Rice', 'assets/images/white_rice.jpeg'),
        MenuItem('Sambar', 'assets/images/sambar.jpeg'),
        MenuItem('Curd', 'assets/images/curd.curd'),
        MenuItem('Rasam', 'assets/images/rasam.jpeg'),
        MenuItem('Parupu Podi', 'assets/images/parupu_podi.jpeg'),
        MenuItem('Fruits', 'assets/images/fruits.jpeg'),
      ],
    },
    'Friday': {
      'Breakfast': [
        MenuItem('Breakfast Item 1', 'assets/images/food_item_1.jpg'),
        MenuItem('Breakfast Item 2', 'assets/images/food_item_2.jpg'),
      ],
      'Lunch': [
        MenuItem('Lunch Item 1', 'assets/images/food_item_3.jpg'),
      ],
      'Snacks': [
        MenuItem('Snacks Item 1', 'assets/images/food_item_4.jpg'),
        MenuItem('Snacks Item 2', 'assets/images/food_item_5.jpg'),
      ],
      'Dinner': [
        MenuItem('Dinner Item 1', 'assets/images/food_item_6.jpg'),
      ],
    },
    'Saturday': {
      'Breakfast': [
        MenuItem('Breakfast Item 1', 'assets/images/food_item_1.jpg'),
        MenuItem('Breakfast Item 2', 'assets/images/food_item_2.jpg'),
      ],
      'Lunch': [
        MenuItem('Lunch Item 1', 'assets/images/food_item_3.jpg'),
      ],
      'Snacks': [
        MenuItem('Snacks Item 1', 'assets/images/food_item_4.jpg'),
        MenuItem('Snacks Item 2', 'assets/images/food_item_5.jpg'),
      ],
      'Dinner': [
        MenuItem('Dinner Item 1', 'assets/images/food_item_6.jpg'),
      ],
    },
    'Sunday': {
      'Breakfast': [
        MenuItem('Breakfast Item 1', 'assets/images/3526220.pngjpg'),
        MenuItem('Breakfast Item 2', 'assets/images/3526220.png'),
        MenuItem('Breakfast Item 2', 'assets/images/3526220.png'),
        MenuItem('Breakfast Item 2', 'assets/images/3526220.png'),
        MenuItem('Breakfast Item 2', 'assets/images/3526220.png'),
      ],
      'Lunch': [
        MenuItem('Lunch Item 1', 'assets/images/food_item_3.jpg'),
      ],
      'Snacks': [
        MenuItem('Snacks Item 1', 'assets/images/food_item_4.jpg'),
        MenuItem('Snacks Item 2', 'assets/images/food_item_5.jpg'),
      ],
      'Dinner': [
        MenuItem('Dinner Item 1', 'assets/images/food_item_6.jpg'),
      ],
    },
  };

  MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentDay = getCurrentDay();
    final currentMealType = getCurrentMealType();
    final menuItems = menuData[currentDay]?[currentMealType] ?? [];

    return ListView(
      children: [
        MenuCard(
          title: currentMealType,
          menuItems: menuItems,
        ),
      ],
    );
  }

  String getCurrentDay() {
    final now = DateTime.now();
    switch (now.weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  String getCurrentMealType() {
    final now = DateTime.now();
    if (now.hour >= 7 && now.hour < 9) {
      return 'Breakfast';
    } else if (now.hour >= 12 && now.hour < 14) {
      return 'Lunch';
    } else if (now.hour >= 17 && now.hour < 18) {
      return 'Snacks';
    } else if (now.hour >= 19 && now.hour < 21) {
      return 'Dinner';
    } else {
      if (now.hour < 7) {
        return 'Breakfast';
      } else if (now.hour < 12) {
        return 'Lunch';
      } else if (now.hour < 17) {
        return 'Snacks';
      } else {
        return 'Breakfast';
      }
    }
  }
}

class MenuItem {
  final String foodItem;
  final String imageAsset;

  MenuItem(this.foodItem, this.imageAsset);
}

class MenuCard extends StatelessWidget {
  final String title;
  final List<MenuItem> menuItems;

  MenuCard({required this.title, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: EdgeInsets.all(8.0),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: menuItems
                  .asMap()
                  .entries
                  .map((entry) => MenuItemCard(
                        index: entry.key,
                        menuItem: entry.value,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemCard extends StatefulWidget {
  final int index;
  final MenuItem menuItem;

  MenuItemCard({required this.index, required this.menuItem});

  @override
  _MenuItemCardState createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Delay the fade-in animation.
    Future.delayed(Duration(milliseconds: widget.index * 500), () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Card(
        margin: EdgeInsets.all(8.0),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Image.asset(
              widget.menuItem.imageAsset,
              fit: BoxFit.cover,
              height: 100,
            ),
            ListTile(
              title: Text(
                widget.menuItem.foodItem,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
