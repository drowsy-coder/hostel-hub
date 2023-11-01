import 'package:flutter/material.dart';
import 'package:law_help/screens/stakeholders/undertrial/ut%20map/no_food.dart';

void main() {
  runApp(const MenuApp());
}

class MenuApp extends StatelessWidget {
  const MenuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Today's Menu"),
          actions: [
            IconButton(
              icon: Icon(Icons.telegram),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoFoodScreen(),
                ));
              },
            ),
          ],
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
        MenuItem('Breakfast Item 1', 'assets/images/3526220.png'),
        MenuItem('Breakfast Item 2', 'assets/images/3526220.png'),
        MenuItem('Breakfast Item 2', 'assets/images/3526220.png'),
        MenuItem('Breakfast Item 2', 'assets/images/3526220.png'),
        MenuItem('Breakfast Item 2', 'assets/images/3526220.png'),
      ],
      'Lunch': [
        MenuItem('Lunch Item 1', 'assets/food_item_3.jpg'),
      ],
      'Snacks': [
        MenuItem('Snacks Item 1', 'assets/food_item_4.jpg'),
        MenuItem('Snacks Item 2', 'assets/food_item_5.jpg'),
      ],
      'Dinner': [
        MenuItem('Dinner Item 1', 'assets/food_item_6.jpg'),
      ],
    },
    'Tuesday': {
      'Breakfast': [
        MenuItem('Paneer', 'assets/images/Butter Paneer Low Res.jpeg'),
        MenuItem('Roti', 'assets/images/Simply Recipes Roti.jpg'),
        MenuItem('Dal and Rice', 'assets/images/instant-pot-dal-rice.jpg'),
        MenuItem('Papadam', 'assets/images/Papadams feature.webp'),
        MenuItem('Pickle', 'assets/images/Mekkekayi-Pickle-2-.png'),
      ],
      'Lunch': [
        MenuItem('Paneer', 'assets/images/Butter Paneer Low Res.jpeg'),
        MenuItem('Roti', 'assets/images/Simply Recipes Roti.jpg'),
        MenuItem('Dal and Rice', 'assets/images/instant-pot-dal-rice.jpg'),
        MenuItem('Papadam', 'assets/images/Papadams feature.webp'),
        MenuItem('Pickle', 'assets/images/Mekkekayi-Pickle-2-.png'),
      ],
      'Snacks': [
        MenuItem('Snacks Item 1', 'assets/food_item_4.jpg'),
        MenuItem('Snacks Item 2', 'assets/food_item_5.jpg'),
      ],
      'Dinner': [
        MenuItem('Dinner Item 1', 'assets/food_item_6.jpg'),
      ],
    },
    'Wednesday': {
      'Breakfast': [
        MenuItem('Breakfast Item 1', 'assets/food_item_1.jpg'),
        MenuItem('Breakfast Item 2', 'assets/food_item_2.jpg'),
      ],
      'Lunch': [
        MenuItem('Lunch Item 1', 'assets/food_item_3.jpg'),
      ],
      'Snacks': [
        MenuItem('Snacks Item 1', 'assets/food_item_4.jpg'),
        MenuItem('Snacks Item 2', 'assets/food_item_5.jpg'),
      ],
      'Dinner': [
        MenuItem('Dinner Item 1', 'assets/food_item_6.jpg'),
      ],
    },
    'Friday': {
      'Breakfast': [
        MenuItem('Breakfast Item 1', 'assets/food_item_1.jpg'),
        MenuItem('Breakfast Item 2', 'assets/food_item_2.jpg'),
      ],
      'Lunch': [
        MenuItem('Lunch Item 1', 'assets/food_item_3.jpg'),
      ],
      'Snacks': [
        MenuItem('Snacks Item 1', 'assets/food_item_4.jpg'),
        MenuItem('Snacks Item 2', 'assets/food_item_5.jpg'),
      ],
      'Dinner': [
        MenuItem('Dinner Item 1', 'assets/food_item_6.jpg'),
      ],
    },
    'Saturday': {
      'Breakfast': [
        MenuItem('Breakfast Item 1', 'assets/food_item_1.jpg'),
        MenuItem('Breakfast Item 2', 'assets/food_item_2.jpg'),
      ],
      'Lunch': [
        MenuItem('Lunch Item 1', 'assets/food_item_3.jpg'),
      ],
      'Snacks': [
        MenuItem('Snacks Item 1', 'assets/food_item_4.jpg'),
        MenuItem('Snacks Item 2', 'assets/food_item_5.jpg'),
      ],
      'Dinner': [
        MenuItem('Dinner Item 1', 'assets/food_item_6.jpg'),
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
        MenuItem('Lunch Item 1', 'assets/food_item_3.jpg'),
      ],
      'Snacks': [
        MenuItem('Snacks Item 1', 'assets/food_item_4.jpg'),
        MenuItem('Snacks Item 2', 'assets/food_item_5.jpg'),
      ],
      'Dinner': [
        MenuItem('Dinner Item 1', 'assets/food_item_6.jpg'),
      ],
    },
  };

  MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentDay = getCurrentDay();
    final currentMealType = getCurrentMealType();
    final menuItems = menuData[currentDay]?[currentMealType] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Menu"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.local_dining), // Cross symbol
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoFoodScreen(),
              ));
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          MenuCard(
            title: currentMealType,
            menuItems: menuItems,
          ),
        ],
      ),
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
              fit: BoxFit.fill,
              height: 200,
              width: 200,
            ),
            ListTile(
              title: Text(
                widget.menuItem.foodItem,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
