// lib/inventory/inventory_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// ===============================
/// INVENTORY MODEL
/// ===============================
class InventoryItem {
  final String id;
  String name;
  String category;
  int quantity;
  String unit;
  String supplier;
  DateTime? expiryDate;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.supplier,
    this.expiryDate,
  });
}

/// ===============================
/// INVENTORY PAGE
/// ===============================
class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List<InventoryItem> _allItems = [
    InventoryItem(
        id: '1',
        name: 'Rice',
        category: 'Food',
        quantity: 50,
        unit: 'kg',
        supplier: 'ABC Suppliers',
        expiryDate: DateTime.now().add(Duration(days: 180))),
    InventoryItem(
        id: '2',
        name: 'Milk Powder',
        category: 'Food',
        quantity: 20,
        unit: 'kg',
        supplier: 'Dairy Supplies',
        expiryDate: DateTime.now().add(Duration(days: 90))),
    InventoryItem(
        id: '3',
        name: 'T-Shirts',
        category: 'Clothing',
        quantity: 5,
        unit: 'pcs',
        supplier: 'Cloth World'),
  ];

  List<InventoryItem> _filteredItems = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allItems);
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // --------------------------
  // ADD ITEM
  // --------------------------
  void _addItem() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController unitController = TextEditingController();
    final TextEditingController supplierController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Inventory Item'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
              TextField(controller: categoryController, decoration: InputDecoration(labelText: 'Category')),
              TextField(controller: quantityController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Quantity')),
              TextField(controller: unitController, decoration: InputDecoration(labelText: 'Unit')),
              TextField(controller: supplierController, decoration: InputDecoration(labelText: 'Supplier')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty) return;
              final newItem = InventoryItem(
                id: DateTime.now().toString(),
                name: nameController.text,
                category: categoryController.text,
                quantity: int.tryParse(quantityController.text) ?? 0,
                unit: unitController.text.isEmpty ? 'pcs' : unitController.text,
                supplier: supplierController.text.isEmpty ? 'Unknown' : supplierController.text,
              );
              setState(() {
                _allItems.add(newItem);
                _filterItems(_searchController.text); // Refresh filter
                _listKey.currentState?.insertItem(_filteredItems.indexOf(newItem));
              });
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  // --------------------------
  // DELETE ITEM
  // --------------------------
  void _deleteItem(int index) {
    InventoryItem removedItem = _filteredItems[index];
    setState(() {
      _filteredItems.removeAt(index);
      _allItems.removeWhere((item) => item.id == removedItem.id);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: _buildListItem(removedItem, index),
        ),
      );
    });
  }

  // --------------------------
  // EDIT ITEM
  // --------------------------
  void _editItem(int index) {
    InventoryItem item = _filteredItems[index];
    TextEditingController nameController = TextEditingController(text: item.name);
    TextEditingController quantityController =
        TextEditingController(text: item.quantity.toString());
    TextEditingController supplierController =
        TextEditingController(text: item.supplier);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
              TextField(controller: quantityController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Quantity')),
              TextField(controller: supplierController, decoration: InputDecoration(labelText: 'Supplier')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  item.name = nameController.text;
                  item.quantity = int.tryParse(quantityController.text) ?? item.quantity;
                  item.supplier = supplierController.text;
                });
                Navigator.pop(context);
              },
              child: Text('Save')),
        ],
      ),
    );
  }

  // --------------------------
  // FILTER ITEMS
  // --------------------------
  void _filterItems(String query) {
    setState(() {
      _filteredItems = _allItems
          .where((item) =>
              item.name.toLowerCase().contains(query.toLowerCase()) ||
              item.category.toLowerCase().contains(query.toLowerCase()) ||
              item.supplier.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // --------------------------
  // SUMMARY CARD
  // --------------------------
  Widget _buildSummaryCard(String title, String value, Color color) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(16),
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(value, style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(InventoryItem item, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        tileColor: item.quantity == 0
            ? Colors.red[50]
            : item.quantity < 10
                ? Colors.orange[50]
                : null,
        title: Text(item.name),
        subtitle: Text(
            '${item.category} • Supplier: ${item.supplier} • Quantity: ${item.quantity} ${item.unit}' +
                (item.expiryDate != null
                    ? ' • Exp: ${DateFormat('yyyy-MM-dd').format(item.expiryDate!)}'
                    : '')),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editItem(index),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteItem(index),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Inventory Management',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // Summary Cards
            Row(
              children: [
                _buildSummaryCard(
                    'Total Items', _allItems.length.toString(), Colors.green),
                SizedBox(width: 16),
                _buildSummaryCard(
                    'Low Stock',
                    _allItems.where((i) => i.quantity < 10 && i.quantity > 0).length.toString(),
                    Colors.orange),
                SizedBox(width: 16),
                _buildSummaryCard(
                    'Out of Stock',
                    _allItems.where((i) => i.quantity == 0).length.toString(),
                    Colors.red),
              ],
            ),
            SizedBox(height: 30),

            // Search bar and Add button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Filter by name, category, or supplier',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterItems,
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _addItem, // ✅ Now works
                  icon: Icon(Icons.add),
                  label: Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Animated List
            AnimatedList(
              key: _listKey,
              initialItemCount: _filteredItems.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index, animation) {
                final item = _filteredItems[index];
                return SizeTransition(
                  sizeFactor: animation,
                  child: _buildListItem(item, index),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}