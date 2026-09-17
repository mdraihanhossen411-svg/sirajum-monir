import 'package:flutter/material.dart';

import '../services/family_storage_service.dart';
import '../services/family_activity_service.dart';
import '../services/family_backup_service.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final FamilyStorageService _storage = FamilyStorageService();
  final List<FamilyMember> _members = [];

  void _open(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final data = await _storage.loadMembers();

    if (!mounted) return;

    setState(() {
      _members
        ..clear()
        ..addAll(
          data.map(
            (item) => FamilyMember(
              name: item['name']?.toString() ?? '',
              relation: item['relation']?.toString() ?? 'অন্যান্য',
              age: int.tryParse(item['age']?.toString() ?? '') ?? 0,
            ),
          ),
        );
    });
  }

  Future<void> _saveMembers() async {
    await _storage.saveMembers(
      _members
          .map(
            (member) => {
              'name': member.name,
              'relation': member.relation,
              'age': member.age,
            },
          )
          .toList(),
    );
  }

  void _addMember() async {
    final member = await Navigator.push<FamilyMember>(
      context,
      MaterialPageRoute(
        builder: (_) => const FamilyAddMemberPage(),
      ),
    );

    if (member != null) {
      setState(() {
        _members.add(member);
      });
      await _saveMembers();
    }
  }

  void _editMember(int index) async {
    final updated = await Navigator.push<FamilyMember>(
      context,
      MaterialPageRoute(
        builder: (_) => FamilyAddMemberPage(
          member: _members[index],
        ),
      ),
    );

    if (updated != null) {
      setState(() {
        _members[index] = updated;
      });
    }
  }

  void _deleteMember(int index) {
    final member = _members[index];

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('সদস্য মুছে ফেলবেন?'),
          content: Text(
            '${member.name} সদস্যকে পরিবারের তালিকা থেকে মুছে ফেলা হবে।',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('বাতিল'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _members.removeAt(index);
                });
              },
              child: const Text('মুছে ফেলুন'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পরিবার'),
        backgroundColor: FamilyPage.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'পরিবারের সম্পর্ক',
            icon: const Icon(Icons.account_tree_outlined),
            onPressed: () => _open(
              FamilyTreePage(members: List.unmodifiable(_members)),
            ),
          ),
        ],
      ),
      body: Container(
        color: FamilyPage.cream,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FamilyHeader(),
              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.people_outline,
                      title: 'সদস্য',
                      value: '${_members.length}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: _SummaryCard(
                      icon: Icons.check_circle_outline,
                      title: 'আজকের আমল',
                      value: '০',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'পরিবারের সদস্য',
                    style: TextStyle(
                      color: FamilyPage.deepGreen,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addMember,
                    icon: const Icon(Icons.add),
                    label: const Text('সদস্য যোগ'),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (_members.isEmpty)
                _EmptyMembersCard(onAdd: _addMember)
              else
                ...List.generate(
                  _members.length,
                  (index) => _MemberCard(
                    member: _members[index],
                    onTap: () => _open(
                      FamilyMemberPage(member: _members[index]),
                    ),
                    onEdit: () => _editMember(index),
                    onDelete: () => _deleteMember(index),
                  ),
                ),

              const SizedBox(height: 24),

              const Text(
                'পারিবারিক ইসলামিক কার্যক্রম',
                style: TextStyle(
                  color: FamilyPage.deepGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _ActionCard(
                icon: Icons.mosque_outlined,
                title: 'নামাজ ও আমল',
                subtitle: 'পরিবারের দৈনন্দিন নামাজ ও আমলের কাঠামো',
                onTap: () => _open(const FamilySalahPage()),
              ),
              _ActionCard(
                icon: Icons.menu_book_outlined,
                title: 'কুরআন',
                subtitle: 'পারিবারিক কুরআন পাঠ ও অগ্রগতি',
                onTap: () => _open(const FamilyQuranPage()),
              ),
              _ActionCard(
                icon: Icons.volunteer_activism_outlined,
                title: 'দোয়া ও যিকির',
                subtitle: 'পরিবারের জন্য দোয়া ও যিকির',
                onTap: () => _open(const FamilyDuaDhikrPage()),
              ),
              _ActionCard(
                icon: Icons.school_outlined,
                title: 'ইসলামিক শিক্ষা',
                subtitle: 'পরিবারের সদস্যদের শেখার বিভাগ',
                onTap: () => _open(const FamilyLearningPage()),
              ),
              _ActionCard(
                icon: Icons.account_tree_outlined,
                title: 'পারিবারিক সম্পর্ক',
                subtitle: 'পরিবারের সম্পর্কের কাঠামো দেখুন',
                onTap: () => _open(
                  FamilyTreePage(
                    members: List.unmodifiable(_members),
                  ),
                ),
              ),
              _ActionCard(
                icon: Icons.event_note_outlined,
                title: 'পারিবারিক ইভেন্ট',
                subtitle: 'গুরুত্বপূর্ণ পারিবারিক বিষয় ও স্মরণিকা',
                onTap: () => _open(const FamilyEventsPage()),
              ),
              _ActionCard(
                icon: Icons.child_care_outlined,
                title: 'শিশু বিভাগ',
                subtitle: 'শিশুদের ইসলামিক শিক্ষা ও আমল',
                onTap: () => _open(const FamilyChildrenPage()),
              ),
              _ActionCard(
                icon: Icons.calendar_month_outlined,
                title: 'Family Calendar',
                subtitle: 'পারিবারিক ইসলামিক ক্যালেন্ডার',
                onTap: () => _open(const FamilyCalendarPage()),
              ),
              _ActionCard(
                icon: Icons.volunteer_activism_outlined,
                title: 'Family Sadaqah',
                subtitle: 'পারিবারিক সদকা ও দান',
                onTap: () => _open(const FamilySadaqahPage()),
              ),
              _ActionCard(
                icon: Icons.mosque_outlined,
                title: 'Hajj & Umrah',
                subtitle: 'হজ ও উমরাহ প্রস্তুতি',
                onTap: () => _open(const FamilyHajjUmrahPage()),
              ),

              _ActionCard(
                icon: Icons.dashboard_outlined,
                title: 'Family Dashboard',
                subtitle: 'পরিবারের কার্যক্রমের সারসংক্ষেপ',
                onTap: () => _open(const FamilyDashboardPage()),
              ),
              _ActionCard(
                icon: Icons.settings_outlined,
                title: 'পরিবারের সেটিংস',
                subtitle: 'Family notification ও অন্যান্য সেটিংস',
                onTap: () => _open(const FamilySettingsPage()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FamilyMember {
  final String name;
  final String relation;
  final int age;

  const FamilyMember({
    required this.name,
    required this.relation,
    required this.age,
  });
}

class FamilyMemberPage extends StatelessWidget {
  final FamilyMember member;

  const FamilyMemberPage({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সদস্যের প্রোফাইল'),
        backgroundColor: FamilyPage.green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: FamilyPage.cream,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: FamilyPage.deepGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: FamilyPage.gold,
                    size: 58,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    member.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    member.relation,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _InfoTile(
              icon: Icons.family_restroom,
              title: 'সম্পর্ক',
              value: member.relation,
            ),
            _InfoTile(
              icon: Icons.cake_outlined,
              title: 'বয়স',
              value: '${member.age} বছর',
            ),
            _InfoTile(
              icon: Icons.mosque_outlined,
              title: 'আজকের আমল',
              value: 'পরবর্তী ধাপে যুক্ত হবে',
            ),
          ],
        ),
      ),
    );
  }
}

class FamilyAddMemberPage extends StatefulWidget {
  final FamilyMember? member;

  const FamilyAddMemberPage({
    super.key,
    this.member,
  });

  @override
  State<FamilyAddMemberPage> createState() => _FamilyAddMemberPageState();
}

class _FamilyAddMemberPageState extends State<FamilyAddMemberPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;

  String? _relation;

  static const relations = [
    'বাবা',
    'মা',
    'স্বামী',
    'স্ত্রী',
    'ছেলে',
    'মেয়ে',
    'ভাই',
    'বোন',
    'দাদা',
    'দাদি',
    'নানা',
    'নানি',
    'অন্যান্য',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.member?.name ?? '',
    );
    _ageController = TextEditingController(
      text: widget.member?.age.toString() ?? '',
    );
    _relation = widget.member?.relation;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());

    if (name.isEmpty || _relation == null || age == null || age < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('নাম, সম্পর্ক ও সঠিক বয়স দিন।'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      FamilyMember(
        name: name,
        relation: _relation!,
        age: age,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.member != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'সদস্য সম্পাদনা' : 'সদস্য যোগ করুন'),
        backgroundColor: FamilyPage.green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: FamilyPage.cream,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 6),
              const Icon(
                Icons.person_add_alt_1,
                color: FamilyPage.green,
                size: 54,
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'নাম',
                  hintText: 'সদস্যের নাম লিখুন',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                initialValue: _relation,
                decoration: const InputDecoration(
                  labelText: 'সম্পর্ক',
                  prefixIcon: Icon(Icons.family_restroom),
                ),
                items: relations
                    .map(
                      (relation) => DropdownMenuItem(
                        value: relation,
                        child: Text(relation),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _relation = value;
                  });
                },
              ),

              const SizedBox(height: 14),

              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'বয়স',
                  hintText: 'বয়স লিখুন',
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: Icon(
                    editing ? Icons.save_outlined : Icons.person_add,
                  ),
                  label: Text(
                    editing ? 'পরিবর্তন সংরক্ষণ করুন' : 'সদস্য সংরক্ষণ করুন',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FamilyPage.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FamilyTreePage extends StatelessWidget {
  final List<FamilyMember> members;

  const FamilyTreePage({
    super.key,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পারিবারিক সম্পর্ক'),
        backgroundColor: FamilyPage.green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: FamilyPage.cream,
        padding: const EdgeInsets.all(16),
        child: members.isEmpty
            ? const Center(
                child: Text(
                  'Family Tree তৈরি করতে আগে পরিবারের সদস্য যোগ করুন।',
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'পরিবারের সদস্য',
                    style: TextStyle(
                      color: FamilyPage.deepGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: members.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 10),
                      itemBuilder: (_, index) {
                        final member = members[index];

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: FamilyPage.gold.withValues(
                                alpha: 0.45,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                color: FamilyPage.green,
                                size: 32,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.name,
                                      style: const TextStyle(
                                        color: FamilyPage.deepGreen,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${member.relation} • ${member.age} বছর',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _FamilyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FamilyPage.deepGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.family_restroom,
            color: FamilyPage.gold,
            size: 42,
          ),
          SizedBox(height: 12),
          Text(
            'আমার পরিবার',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'পরিবারের সদস্য ও পারিবারিক ইসলামিক কার্যক্রম একসাথে পরিচালনা করুন।',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: FamilyPage.gold.withValues(alpha: 0.45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(
              icon,
              color: FamilyPage.green,
              size: 30,
            ),
            const SizedBox(height: 7),
            Text(
              value,
              style: const TextStyle(
                color: FamilyPage.deepGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMembersCard extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyMembersCard({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: FamilyPage.gold.withValues(alpha: 0.45),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.people_outline,
              color: FamilyPage.green,
              size: 46,
            ),
            const SizedBox(height: 10),
            const Text(
              'এখনও কোনো সদস্য যোগ করা হয়নি।',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: FamilyPage.deepGreen,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('প্রথম সদস্য যোগ করুন'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MemberCard({
    required this.member,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: FamilyPage.gold.withValues(alpha: 0.35),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(
          Icons.person_outline,
          color: FamilyPage.green,
          size: 34,
        ),
        title: Text(
          member.name,
          style: const TextStyle(
            color: FamilyPage.deepGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${member.relation} • ${member.age} বছর',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: 'edit',
              child: Text('সম্পাদনা'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('মুছে ফেলুন'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          icon,
          color: FamilyPage.green,
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            color: FamilyPage.deepGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: FamilyPage.gold.withValues(alpha: 0.35),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: FamilyPage.green.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: FamilyPage.green,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: FamilyPage.deepGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            height: 1.4,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: FamilyPage.gold,
        ),
        onTap: onTap,
      ),
    );
  }
}


class FamilySalahPage extends StatelessWidget {
  const FamilySalahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FamilySectionPage(
      title: 'নামাজ ও আমল',
      icon: Icons.mosque_outlined,
      description: 'পরিবারের সদস্যদের দৈনন্দিন নামাজ ও আমলের কাঠামো।',
      items: [
        'ফজর',
        'যোহর',
        'আসর',
        'মাগরিব',
        'এশা',
        'দৈনন্দিন আমল',
      ],
    );
  }
}

class FamilyQuranPage extends StatelessWidget {
  const FamilyQuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FamilySectionPage(
      title: 'পারিবারিক কুরআন',
      icon: Icons.menu_book_outlined,
      description: 'পরিবারের সদস্যদের কুরআন পাঠ ও অগ্রগতি।',
      items: [
        'আজকের কুরআন পাঠ',
        'পাঠের লক্ষ্য',
        'ব্যক্তিগত অগ্রগতি',
        'পরিবারের অগ্রগতি',
      ],
    );
  }
}

class FamilyDuaDhikrPage extends StatelessWidget {
  const FamilyDuaDhikrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FamilySectionPage(
      title: 'দোয়া ও যিকির',
      icon: Icons.volunteer_activism_outlined,
      description: 'পরিবারের জন্য নির্বাচিত দোয়া ও যিকির।',
      items: [
        'সকাল-সন্ধ্যার যিকির',
        'খাবারের দোয়া',
        'ঘুমের দোয়া',
        'সফরের দোয়া',
        'অন্যান্য দোয়া',
      ],
    );
  }
}

class FamilyLearningPage extends StatelessWidget {
  const FamilyLearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FamilySectionPage(
      title: 'ইসলামিক শিক্ষা',
      icon: Icons.school_outlined,
      description: 'পরিবারের সদস্যদের জন্য ইসলামিক শিক্ষার বিভাগ।',
      items: [
        'আকিদা',
        'নামাজ শিক্ষা',
        'ওযু শিক্ষা',
        'দোয়া শিক্ষা',
        'কুরআন শিক্ষা',
        'ইসলামিক আদব',
      ],
    );
  }
}

class _FamilySectionPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final List<String> items;

  const _FamilySectionPage({
    required this.title,
    required this.icon,
    required this.description,
    required this.items,
  });

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: cream,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: deepGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      color: gold,
                      size: 42,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...items.map(
                (item) => Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: gold.withValues(alpha: 0.35),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.check_circle_outline,
                      color: green,
                    ),
                    title: Text(
                      item,
                      style: const TextStyle(
                        color: deepGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: gold,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'এই বিভাগের বিস্তারিত পরবর্তী ধাপে যুক্ত হবে।',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class FamilyEventsPage extends StatefulWidget {
  const FamilyEventsPage({super.key});

  @override
  State<FamilyEventsPage> createState() => _FamilyEventsPageState();
}

class _FamilyEventsPageState extends State<FamilyEventsPage> {
  final List<FamilyEvent> _events = [];
  final FamilyStorageService _storage = FamilyStorageService();

  Future<void> _addEvent() async {
    final event = await Navigator.push<FamilyEvent>(
      context,
      MaterialPageRoute(
        builder: (_) => const FamilyAddEventPage(),
      ),
    );

    if (event != null) {
      setState(() {
        _events.add(event);
      });
      await _saveEvents();
    }
  }

  void _deleteEvent(int index) {
    final event = _events[index];

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('ইভেন্ট মুছে ফেলবেন?'),
          content: Text(
            '${event.title} ইভেন্টটি মুছে ফেলা হবে।',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('বাতিল'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _events.removeAt(index);
                });
              },
              child: const Text('মুছে ফেলুন'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final data = await _storage.loadEvents();

    if (!mounted) return;

    setState(() {
      _events
        ..clear()
        ..addAll(
          data.map(
            (item) => FamilyEvent(
              title: item['title']?.toString() ?? '',
              date: DateTime.tryParse(
                    item['date']?.toString() ?? '',
                  ) ??
                  DateTime.now(),
              note: item['note']?.toString() ?? '',
            ),
          ),
        );
    });
  }

  Future<void> _saveEvents() async {
    await _storage.saveEvents(
      _events
          .map(
            (event) => {
              'title': event.title,
              'date': event.date.toIso8601String(),
              'note': event.note,
            },
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পারিবারিক ইভেন্ট'),
        backgroundColor: FamilyPage.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'ইভেন্ট যোগ',
            icon: const Icon(Icons.add),
            onPressed: _addEvent,
          ),
        ],
      ),
      body: Container(
        color: FamilyPage.cream,
        child: _events.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.event_note_outlined,
                        color: FamilyPage.green,
                        size: 60,
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'এখনও কোনো পারিবারিক ইভেন্ট নেই।',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: FamilyPage.deepGreen,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'গুরুত্বপূর্ণ পারিবারিক বিষয় ও স্মরণিকা এখানে রাখা যাবে।',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        onPressed: _addEvent,
                        icon: const Icon(Icons.add),
                        label: const Text('ইভেন্ট যোগ করুন'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FamilyPage.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _events.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final event = _events[index];

                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: FamilyPage.gold.withValues(alpha: 0.4),
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.event_note_outlined,
                        color: FamilyPage.green,
                        size: 32,
                      ),
                      title: Text(
                        event.title,
                        style: const TextStyle(
                          color: FamilyPage.deepGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${event.date.day}/${event.date.month}/${event.date.year}'
                        '${event.note.isEmpty ? '' : '\n${event.note}'}',
                      ),
                      isThreeLine: event.note.isNotEmpty,
                      trailing: IconButton(
                        tooltip: 'মুছে ফেলুন',
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => _deleteEvent(index),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: _events.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: FamilyPage.green,
              foregroundColor: Colors.white,
              onPressed: _addEvent,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class FamilyEvent {
  final String title;
  final DateTime date;
  final String note;

  const FamilyEvent({
    required this.title,
    required this.date,
    required this.note,
  });
}

class FamilyAddEventPage extends StatefulWidget {
  const FamilyAddEventPage({super.key});

  @override
  State<FamilyAddEventPage> createState() => _FamilyAddEventPageState();
}

class _FamilyAddEventPageState extends State<FamilyAddEventPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _save() {
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ইভেন্টের নাম লিখুন।'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      FamilyEvent(
        title: title,
        date: _selectedDate,
        note: note,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ইভেন্ট যোগ করুন'),
        backgroundColor: FamilyPage.green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: FamilyPage.cream,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(
                Icons.event_note_outlined,
                color: FamilyPage.green,
                size: 54,
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'ইভেন্টের নাম',
                  hintText: 'যেমন: পারিবারিক দোয়া',
                  prefixIcon: Icon(Icons.title),
                ),
              ),

              const SizedBox(height: 14),

              Card(
                elevation: 0,
                child: ListTile(
                  leading: const Icon(
                    Icons.calendar_month_outlined,
                    color: FamilyPage.green,
                  ),
                  title: const Text('তারিখ'),
                  subtitle: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                  trailing: const Icon(Icons.edit_calendar_outlined),
                  onTap: _pickDate,
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: _noteController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'নোট',
                  hintText: 'প্রয়োজনীয় অতিরিক্ত তথ্য লিখুন',
                  prefixIcon: Icon(Icons.notes_outlined),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('ইভেন্ট সংরক্ষণ করুন'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FamilyPage.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class FamilyDashboardPage extends StatefulWidget {
  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  const FamilyDashboardPage({super.key});

  @override
  State<FamilyDashboardPage> createState() => _FamilyDashboardPageState();
}

class _FamilyDashboardPageState extends State<FamilyDashboardPage> {
  final FamilyStorageService _storage = FamilyStorageService();
  final FamilyActivityService _activityService =
      FamilyActivityService();

  int _memberCount = 0;
  int _eventCount = 0;
  Map<String, int> _activity = {
    'salah': 0,
    'quran': 0,
    'duaDhikr': 0,
    'learning': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    final members = await _storage.loadMembers();
    final events = await _storage.loadEvents();
    final activity = await _activityService.loadToday();

    if (!mounted) return;

    setState(() {
      _memberCount = members.length;
      _eventCount = events.length;
      _activity = activity;
    });
  }

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Dashboard'),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: cream,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DashboardHeader(),
              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: _DashboardStat(
                      icon: Icons.people_outline,
                      title: 'সদস্য',
                      value: '$_memberCount',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DashboardStat(
                      icon: Icons.event_note_outlined,
                      title: 'ইভেন্ট',
                      value: '$_eventCount',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'আজকের পারিবারিক অগ্রগতি',
                style: TextStyle(
                  color: deepGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _ProgressCard(
                icon: Icons.mosque_outlined,
                title: 'নামাজ ও আমল',
                progress: (_activity['salah'] ?? 0) / 100,
              ),
              _ProgressCard(
                icon: Icons.menu_book_outlined,
                title: 'কুরআন পাঠ',
                progress: (_activity['quran'] ?? 0) / 100,
              ),
              _ProgressCard(
                icon: Icons.volunteer_activism_outlined,
                title: 'দোয়া ও যিকির',
                progress: (_activity['duaDhikr'] ?? 0) / 100,
              ),
              _ProgressCard(
                icon: Icons.school_outlined,
                title: 'ইসলামিক শিক্ষা',
                progress: (_activity['learning'] ?? 0) / 100,
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.45),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.insights_outlined,
                      color: green,
                      size: 30,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'সদস্যদের কার্যক্রম যুক্ত হলে এখানে পারিবারিক অগ্রগতির সারসংক্ষেপ দেখা যাবে।',
                        style: TextStyle(
                          color: deepGreen,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FamilyNotificationPage extends StatefulWidget {
  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);
  const FamilyNotificationPage({super.key});

  @override
  State<FamilyNotificationPage> createState() =>
      _FamilyNotificationPageState();
}

class _FamilyNotificationPageState extends State<FamilyNotificationPage> {
  bool prayer = true;
  bool quran = true;
  bool duaDhikr = true;
  bool learning = false;
  bool familyEvents = true;

  final FamilyStorageService _storage = FamilyStorageService();

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final settings = await _storage.loadNotificationSettings();

    if (!mounted) return;

    setState(() {
      prayer = settings['prayer'] ?? true;
      quran = settings['quran'] ?? true;
      duaDhikr = settings['duaDhikr'] ?? true;
      learning = settings['learning'] ?? false;
      familyEvents = settings['familyEvents'] ?? true;
    });
  }

  Future<void> _saveNotificationSettings() async {
    await _storage.saveNotificationSettings({
      'prayer': prayer,
      'quran': quran,
      'duaDhikr': duaDhikr,
      'learning': learning,
      'familyEvents': familyEvents,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Notification'),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: cream,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: deepGreen,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    color: gold,
                    size: 38,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'পারিবারিক রিমাইন্ডার',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'রিমাইন্ডার বিভাগ',
              style: TextStyle(
                color: deepGreen,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            _NotificationSwitch(
              icon: Icons.mosque_outlined,
              title: 'নামাজ ও আমল',
              subtitle: 'পারিবারিক নামাজ ও আমলের reminder',
              value: prayer,
              onChanged: (value) {
                setState(() => prayer = value);
                _saveNotificationSettings();
              },
            ),
            _NotificationSwitch(
              icon: Icons.menu_book_outlined,
              title: 'কুরআন',
              subtitle: 'কুরআন পাঠের reminder',
              value: quran,
              onChanged: (value) {
                setState(() => quran = value);
                _saveNotificationSettings();
              },
            ),
            _NotificationSwitch(
              icon: Icons.volunteer_activism_outlined,
              title: 'দোয়া ও যিকির',
              subtitle: 'দোয়া ও যিকিরের reminder',
              value: duaDhikr,
              onChanged: (value) {
                setState(() => duaDhikr = value);
                _saveNotificationSettings();
              },
            ),
            _NotificationSwitch(
              icon: Icons.school_outlined,
              title: 'ইসলামিক শিক্ষা',
              subtitle: 'শিক্ষার reminder',
              value: learning,
              onChanged: (value) {
                setState(() => learning = value);
                _saveNotificationSettings();
              },
            ),
            _NotificationSwitch(
              icon: Icons.event_note_outlined,
              title: 'পারিবারিক ইভেন্ট',
              subtitle: 'ইভেন্টের reminder',
              value: familyEvents,
              onChanged: (value) {
                setState(() => familyEvents = value);
                _saveNotificationSettings();
              },
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: gold.withValues(alpha: 0.4),
                ),
              ),
              child: const Text(
                'এই সেটিংস এখন UI পর্যায়ে রয়েছে। '
                'পরবর্তী integration ধাপে এগুলো existing notification system-এর সঙ্গে যুক্ত হবে।',
                style: TextStyle(
                  color: deepGreen,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FamilyDashboardPage.deepGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.dashboard_outlined,
            color: FamilyDashboardPage.gold,
            size: 42,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'পরিবারের সারসংক্ষেপ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardStat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DashboardStat({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(
              icon,
              color: FamilyDashboardPage.green,
              size: 30,
            ),
            const SizedBox(height: 7),
            Text(
              value,
              style: const TextStyle(
                color: FamilyDashboardPage.deepGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final double progress;

  const _ProgressCard({
    required this.icon,
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: FamilyDashboardPage.green,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: FamilyDashboardPage.deepGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    color: FamilyDashboardPage.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: SwitchListTile(
        secondary: Icon(
          icon,
          color: FamilyNotificationPage.green,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: FamilyNotificationPage.deepGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}


class FamilySettingsPage extends StatelessWidget {
  const FamilySettingsPage({super.key});

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পরিবারের সেটিংস'),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: cream,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _FamilySettingsTile(
              icon: Icons.notifications_active_outlined,
              title: 'Family Notification',
              subtitle: 'পারিবারিক রিমাইন্ডার ও নোটিফিকেশন',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FamilyNotificationPage(),
                  ),
                );
              },
            ),
            _FamilySettingsTile(
              icon: Icons.text_fields,
              title: 'ফন্ট ও লেখা',
              subtitle: 'Family section-এর লেখার আকার',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ফন্ট সেটিংস পরবর্তী ধাপে যুক্ত হবে।'),
                ),
              ),
            ),
            _FamilySettingsTile(
              icon: Icons.palette_outlined,
              title: 'Family Theme',
              subtitle: 'Family section-এর থিম',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Family Theme পরবর্তী ধাপে যুক্ত হবে।'),
                ),
              ),
            ),
            _FamilySettingsTile(
              icon: Icons.storage_outlined,
              title: 'Local Data',
              subtitle: 'Family data এই ডিভাইসেই সংরক্ষিত',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Local Storage সক্রিয় আছে।'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FamilySettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FamilySettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: ListTile(
        leading: const Icon(
          Icons.settings_outlined,
          color: FamilySettingsPage.green,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: FamilySettingsPage.deepGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: FamilySettingsPage.gold,
        ),
        onTap: onTap,
      ),
    );
  }
}


class FamilyChildrenPage extends StatelessWidget {
  const FamilyChildrenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FamilyFeaturePage(
      title: 'শিশু বিভাগ',
      icon: Icons.child_care_outlined,
      description: 'শিশুদের জন্য ইসলামিক শিক্ষা, আমল ও দৈনন্দিন অভ্যাস।',
      items: [
        'শিশুদের নামাজ শিক্ষা',
        'কুরআন শিক্ষা',
        'ছোট ছোট দোয়া',
        'ইসলামিক আদব',
        'ইসলামিক গল্প ও শিক্ষা',
        'দৈনিক আমল লক্ষ্য',
      ],
    );
  }
}

class FamilyCalendarPage extends StatelessWidget {
  const FamilyCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FamilyFeaturePage(
      title: 'Family Calendar',
      icon: Icons.calendar_month_outlined,
      description: 'পরিবারের জন্য ইসলামিক তারিখ ও গুরুত্বপূর্ণ দিনের কাঠামো।',
      items: [
        'আজকের তারিখ',
        'হিজরি তারিখ',
        'ইসলামিক গুরুত্বপূর্ণ দিন',
        'পারিবারিক ইভেন্ট',
        'রমজান',
        'হজ ও উমরাহ',
      ],
    );
  }
}

class FamilySadaqahPage extends StatelessWidget {
  const FamilySadaqahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FamilyFeaturePage(
      title: 'Family Sadaqah',
      icon: Icons.volunteer_activism_outlined,
      description: 'পরিবারের সদকা, দান ও কল্যাণমূলক কার্যক্রমের কাঠামো।',
      items: [
        'সদকা',
        'দান',
        'গোপন সদকা',
        'মসজিদে সহযোগিতা',
        'দরিদ্র ও অসহায়দের সহায়তা',
        'সদকার ইতিহাস',
      ],
    );
  }
}

class FamilyHajjUmrahPage extends StatelessWidget {
  const FamilyHajjUmrahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FamilyFeaturePage(
      title: 'Hajj & Umrah',
      icon: Icons.mosque_outlined,
      description: 'পরিবারের হজ ও উমরাহ প্রস্তুতি এবং শেখার কাঠামো।',
      items: [
        'হজের প্রস্তুতি',
        'উমরাহর প্রস্তুতি',
        'হজের গুরুত্বপূর্ণ আমল',
        'উমরাহর গুরুত্বপূর্ণ আমল',
        'প্রয়োজনীয় দোয়া',
        'চেকলিস্ট',
      ],
    );
  }
}

class FamilyActivityPage extends StatelessWidget {
  const FamilyActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FamilyFeaturePage(
      title: 'Family Activity',
      icon: Icons.insights_outlined,
      description: 'পরিবারের দৈনিক ইসলামিক কার্যক্রমের সারসংক্ষেপ।',
      items: [
        'নামাজ',
        'কুরআন পাঠ',
        'দোয়া ও যিকির',
        'ইসলামিক শিক্ষা',
        'সদকা',
        'আজকের অগ্রগতি',
        'সাপ্তাহিক অগ্রগতি',
      ],
    );
  }
}

class _FamilyFeaturePage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final List<String> items;

  const _FamilyFeaturePage({
    required this.title,
    required this.icon,
    required this.description,
    required this.items,
  });

  static const green = Color(0xFF087A3B);
  static const deepGreen = Color(0xFF063B25);
  static const gold = Color(0xFFC9A227);
  static const cream = Color(0xFFFFFCF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: cream,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: deepGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(icon, color: gold, size: 40),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                color: deepGreen,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            ...items.map(
              (item) => Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(
                    Icons.check_circle_outline,
                    color: green,
                  ),
                  title: Text(
                    item,
                    style: const TextStyle(
                      color: deepGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: gold,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$item — পরবর্তী ধাপে যুক্ত হবে।'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class FamilyActivityTrackingPage extends StatefulWidget {
  const FamilyActivityTrackingPage({super.key});

  @override
  State<FamilyActivityTrackingPage> createState() =>
      _FamilyActivityTrackingPageState();
}

class _FamilyActivityTrackingPageState
    extends State<FamilyActivityTrackingPage> {
  final FamilyActivityService _service = FamilyActivityService();

  Map<String, int> _activity = {
    'salah': 0,
    'quran': 0,
    'duaDhikr': 0,
    'learning': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadActivity();
  }

  Future<void> _loadActivity() async {
    final data = await _service.loadToday();

    if (!mounted) return;

    setState(() {
      _activity = data;
    });
  }

  Future<void> _update(String key, int value) async {
    await _service.setActivity(key, value);

    if (!mounted) return;

    setState(() {
      _activity[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Activity'),
        backgroundColor: const Color(0xFF087A3B),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFFFFFCF4),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'আজকের পারিবারিক আমল',
              style: TextStyle(
                color: Color(0xFF063B25),
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'পরিবারের দৈনিক ইসলামিক কার্যক্রমের অগ্রগতি এখানে সংরক্ষণ করুন।',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 20),
            _ActivitySlider(
              title: 'নামাজ ও আমল',
              icon: Icons.mosque_outlined,
              value: _activity['salah'] ?? 0,
              onChanged: (v) => _update('salah', v),
            ),
            _ActivitySlider(
              title: 'কুরআন পাঠ',
              icon: Icons.menu_book_outlined,
              value: _activity['quran'] ?? 0,
              onChanged: (v) => _update('quran', v),
            ),
            _ActivitySlider(
              title: 'দোয়া ও যিকির',
              icon: Icons.volunteer_activism_outlined,
              value: _activity['duaDhikr'] ?? 0,
              onChanged: (v) => _update('duaDhikr', v),
            ),
            _ActivitySlider(
              title: 'ইসলামিক শিক্ষা',
              icon: Icons.school_outlined,
              value: _activity['learning'] ?? 0,
              onChanged: (v) => _update('learning', v),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivitySlider extends StatelessWidget {
  final String title;
  final IconData icon;
  final int value;
  final ValueChanged<int> onChanged;

  const _ActivitySlider({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF087A3B),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF063B25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '$value%',
                  style: const TextStyle(
                    color: Color(0xFF087A3B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: value.toDouble(),
              min: 0,
              max: 100,
              divisions: 10,
              onChanged: (v) => onChanged(v.round()),
            ),
          ],
        ),
      ),
    );
  }
}

class FamilyBackupPage extends StatefulWidget {
  const FamilyBackupPage({super.key});

  @override
  State<FamilyBackupPage> createState() => _FamilyBackupPageState();
}

class _FamilyBackupPageState extends State<FamilyBackupPage> {
  final FamilyBackupService _backupService = FamilyBackupService();

  Future<void> _createBackup() async {
    final backup = await _backupService.createBackup();

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Backup তৈরি হয়েছে'),
        content: SelectableText(
          'Family backup data প্রস্তুত হয়েছে।\n\n'
          'বর্তমানে এটি নিরাপদভাবে local data হিসেবে তৈরি হচ্ছে। '
          'ফাইল export পরবর্তী ধাপে যুক্ত হবে.\n\n'
          'Data size: ${backup.length} characters',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ঠিক আছে'),
          ),
        ],
      ),
    );
  }

  Future<void> _restoreInfo() async {
    await showDialog<void>(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Restore'),
        content: Text(
          'Backup restore engine প্রস্তুত আছে। '
          'পরবর্তী ধাপে backup file নির্বাচন করে restore করার সুবিধা যুক্ত হবে।',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
        backgroundColor: const Color(0xFF087A3B),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFFFFFCF4),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _BackupTile(
              icon: Icons.backup_outlined,
              title: 'Family Backup',
              subtitle: 'Members, Events ও Settings-এর backup তৈরি করুন',
              onTap: _createBackup,
            ),
            _BackupTile(
              icon: Icons.restore_outlined,
              title: 'Family Restore',
              subtitle: 'আগের backup থেকে Family data ফিরিয়ে আনুন',
              onTap: _restoreInfo,
            ),
          ],
        ),
      ),
    );
  }
}

class _BackupTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _BackupTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Icon(
          icon,
          color: const Color(0xFF087A3B),
          size: 32,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF063B25),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFFC9A227),
        ),
        onTap: onTap,
      ),
    );
  }
}
