class Item {
  const Item(this.name);
  final String name;
}

class Scheme {
  const Scheme(this.schemes);
  final String schemes;
}

class Department {
  const Department(this.departments);
  final String departments;
}

class Year {
  const Year(this.years);
  final String years;
}

List<Item> users = <Item>[
  const Item('Faculty'),
  const Item('Student'),
];

List<Scheme> scheme = <Scheme>[
  const Scheme("A"),
  const Scheme("B"),
  const Scheme("C"),
  const Scheme("D"),
  const Scheme("E"),
  const Scheme("F"),
  const Scheme("G"),
  const Scheme("H"),
  const Scheme("I"),
];

List<Department> departments = <Department>[
  const Department("Mechanical Engineering"),
  const Department("Chemical Engineering"),
  const Department("Computer Engineering"),
  const Department("Information Technology"),
  const Department("Electronics Engineering"),
  const Department("Civil Engineering"),
];

List<Year> year = <Year>[
  const Year("I"),
  const Year("II"),
  const Year("III"),
  const Year("IV"),
  const Year("V"),
  const Year("VI"),
];
