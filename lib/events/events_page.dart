import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// GLOBAL DATE FORMAT
final dateFormat = DateFormat('dd/MM/yyyy');

/// ===============================
/// EVENT MODEL
/// ===============================
class EventItem {
  final String id;
  String title;
  String location;
  DateTime date;
  String description;

  EventItem({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.description,
  });
}

/// ===============================
/// EVENT PROVIDER
/// ===============================
class EventProvider extends ChangeNotifier {

  final List<EventItem> _events = [

    EventItem(
      id: "E001",
      title: "Fundraising Gala",
      location: "Town Hall",
      date: DateTime.now().add(const Duration(days: 14)),
      description: "Annual fundraising event for the orphanage.",
    ),

    EventItem(
      id: "E002",
      title: "Community Picnic",
      location: "Central Park",
      date: DateTime.now().add(const Duration(days: 30)),
      description: "Fun day with the community and children.",
    ),

  ];

  List<EventItem> get events => _events;

  List<EventItem> get upcomingEvents {
    final sorted = [..._events];
    sorted.sort((a, b) => a.date.compareTo(b.date));
    return sorted;
  }

  void addEvent(EventItem event) {
    _events.add(event);
    notifyListeners();
  }

  void updateEvent(String id, EventItem updatedEvent) {
    final index = _events.indexWhere((e) => e.id == id);

    if (index != -1) {
      _events[index] = updatedEvent;
      notifyListeners();
    }
  }

  EventItem? getEvent(String id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// ===============================
/// EVENTS PAGE (ENTRY PAGE)
/// ===============================
class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  final EventProvider provider = EventProvider();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Events"),
        backgroundColor: Colors.deepPurple,
      ),

      body: AnimatedBuilder(
        animation: provider,

        builder: (_, __) {

          return Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(
                  "Upcoming Events",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [

                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("Add Event"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEventPage(provider: provider),
                          ),
                        );

                      },
                    ),

                    const SizedBox(width: 10),

                    OutlinedButton.icon(
                      icon: const Icon(Icons.list),
                      label: const Text("Event List"),
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventListPage(provider: provider),
                          ),
                        );

                      },
                    ),

                  ],
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Card(
                    elevation: 4,

                    child: ListView.builder(
                      itemCount: provider.upcomingEvents.length,

                      itemBuilder: (context, index) {

                        final event = provider.upcomingEvents[index];

                        return ListTile(

                          title: Text(event.title),

                          subtitle: Text(
                            "${event.location} • ${dateFormat.format(event.date)}",
                          ),

                          trailing: const Icon(Icons.arrow_forward_ios),

                          onTap: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventDetailPage(
                                  provider: provider,
                                  eventId: event.id,
                                ),
                              ),
                            );

                          },
                        );

                      },
                    ),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}

/// ===============================
/// ADD EVENT PAGE
/// ===============================
class AddEventPage extends StatefulWidget {

  final EventProvider provider;

  const AddEventPage({super.key, required this.provider});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {

  final formKey = GlobalKey<FormState>();

  String title = "";
  String location = "";
  String description = "";

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text("Add Event")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            children: [

              TextFormField(
                decoration: const InputDecoration(labelText: "Event Title"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter title" : null,
                onSaved: (value) => title = value!,
              ),

              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: "Location"),
                onSaved: (value) => location = value ?? "",
              ),

              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (value) => description = value ?? "",
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                child: const Text("Create Event"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),

                onPressed: () {

                  if (formKey.currentState!.validate()) {

                    formKey.currentState!.save();

                    final event = EventItem(
                      id: "E${DateTime.now().millisecondsSinceEpoch}",
                      title: title,
                      location: location,
                      date: date,
                      description: description,
                    );

                    widget.provider.addEvent(event);

                    Navigator.pop(context);
                  }
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// EVENT LIST PAGE
/// ===============================
class EventListPage extends StatelessWidget {

  final EventProvider provider;

  const EventListPage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text("All Events")),

      body: ListView.builder(
        itemCount: provider.events.length,

        itemBuilder: (context, index) {

          final event = provider.events[index];

          return ListTile(

            title: Text(event.title),

            subtitle: Text(
              "${event.location} • ${dateFormat.format(event.date)}",
            ),

            trailing: const Icon(Icons.arrow_forward_ios),

            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventDetailPage(
                    provider: provider,
                    eventId: event.id,
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }
}

/// ===============================
/// EVENT DETAIL PAGE
/// ===============================
class EventDetailPage extends StatelessWidget {

  final EventProvider provider;
  final String eventId;

  const EventDetailPage({
    super.key,
    required this.provider,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {

    final event = provider.getEvent(eventId);

    if (event == null) {
      return const Scaffold(
        body: Center(child: Text("Event not found")),
      );
    }

    return Scaffold(

      appBar: AppBar(title: Text(event.title)),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              event.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text("Location: ${event.location}"),
            Text("Date: ${dateFormat.format(event.date)}"),

            const SizedBox(height: 10),

            Text(event.description),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Edit Event"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),

              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditEventPage(
                      provider: provider,
                      eventId: event.id,
                    ),
                  ),
                );

              },
            )

          ],
        ),
      ),
    );
  }
}

/// ===============================
/// EDIT EVENT PAGE
/// ===============================
class EditEventPage extends StatefulWidget {

  final EventProvider provider;
  final String eventId;

  const EditEventPage({
    super.key,
    required this.provider,
    required this.eventId,
  });

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {

  final formKey = GlobalKey<FormState>();

  late String title;
  late String location;
  late String description;
  late DateTime date;

  @override
  void initState() {
    super.initState();

    final event = widget.provider.getEvent(widget.eventId)!;

    title = event.title;
    location = event.location;
    description = event.description;
    date = event.date;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text("Edit Event")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            children: [

              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: "Title"),
                onSaved: (value) => title = value!,
              ),

              const SizedBox(height: 10),

              TextFormField(
                initialValue: location,
                decoration: const InputDecoration(labelText: "Location"),
                onSaved: (value) => location = value ?? "",
              ),

              const SizedBox(height: 10),

              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (value) => description = value ?? "",
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                child: const Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),

                onPressed: () {

                  formKey.currentState!.save();

                  final updatedEvent = EventItem(
                    id: widget.eventId,
                    title: title,
                    location: location,
                    date: date,
                    description: description,
                  );

                  widget.provider.updateEvent(widget.eventId, updatedEvent);

                  Navigator.pop(context);
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}