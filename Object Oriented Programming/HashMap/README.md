# HashMap
HashMap - Year 1 OOP Assignment

**Requirements:**

- Collision resolution by chaining
- A key can have multiple values

*Required Methods:*
- `HashMap(const size_t& size = 1013);` - both constructor with no parameters and 1 parameter
- `HashMap(const HashMap& map);` - copy Constructor
- `HashMap operator=(const HashMap&);` -  = overload
- `void insert(const K&, const V&);` 
- `bool containsKey(const K&);`
- `void remove(const K&);` 
- `vector<V> getValues(const K&);` - returns a vector containing all values for a given key
- `unsigned getDistinctKeys();` - returns the number of distinct keys 
- `HashMap operator=(const HashMap&);` - returns the first value for a given key
- `friend ostream& operator<<(ostream& out, const HashMap& map)` - prints the map
