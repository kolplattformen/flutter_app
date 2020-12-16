import 'package:flutter/material.dart';
import 'package:skolplattformen/login_screen.dart';

import 'api.dart';
import 'api_model.dart';

class ChildDetailsScreen extends StatefulWidget {
  final Child child;
  final ApiModel apiModel;

  ChildDetailsScreen(this.child, this.apiModel);

  @override
  _ChildDetailsScreenState createState() => _ChildDetailsScreenState();
}

class _ChildDetailsScreenState extends State<ChildDetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  int tabCount = 0;

  bool hasCalendars = false;
  bool hasNotifications = false;
  bool hasNews = false;

  @override
  void initState() {
    super.initState();
    final child = widget.child;
    final calendars = widget.apiModel.childCalendar[child.id];
    final news = widget.apiModel.childNews[child.id];
    final notifications = widget.apiModel.childNotifications[child.id];
    hasNotifications = notifications != null && notifications.length > 0;
    if (hasNotifications) {
      tabCount++;
    }
    hasCalendars = calendars != null && calendars.length > 0;
    if (hasCalendars) {
      tabCount++;
    }
    hasNews = news != null && news.length > 0;
    if (hasNews) {
      tabCount++;
    }
    _tabController =
        TabController(initialIndex: 0, length: tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final news = widget.apiModel.childNews[widget.child.id];
    final calendars = widget.apiModel.childCalendar[widget.child.id];
    final notifications = widget.apiModel.childNotifications[widget.child.id];
    final tabs = List<Tab>();
    final tabViews = List<Widget>();
    if (hasNews) {
      tabs.add(Tab(text: 'Nyheter'));
      tabViews.add(ListView.builder(
          itemCount: news.length,
          itemBuilder: (context, index) => NewsItem(news[index])));
    }
    if (hasCalendars) {
      tabs.add(Tab(text: 'Kalender'));
      tabViews.add(ListView.builder(
          itemCount: calendars.length,
          itemBuilder: (context, index) => CalendarItem(calendars[index])));
    }
    if (hasNotifications) {
      tabs.add(Tab(text: 'Notiser'));
      tabViews.add(ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) => NotificationItem(childNotification: notifications[index])));
    }

    if (hasNews || hasCalendars) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.child.name),
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: tabViews,
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.child.name),
          actions: [
            IconButton(icon: Icon(Icons.logout), onPressed: () async {
              await widget.apiModel.logout();
              Navigator.pop(context);
              await Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => LoginScreen(widget.apiModel),
              ));
            })
          ],
        ),
        body: Center(child: Text('Ingen information tillgänglig!')),
      );
    }
  }
}

class CalendarItem extends StatelessWidget {
  final CalendarEvent calendarEvent;

  CalendarItem(this.calendarEvent);

  @override
  Widget build(BuildContext context) {
    var dateText = '';
    if (calendarEvent.startDate != null) {
      dateText = '(${calendarEvent.startDate}';
      if (calendarEvent.endDate != null &&
          calendarEvent.startDate != calendarEvent.endDate) {
        dateText += ' till ${calendarEvent.endDate}';
      }
      dateText += ')';
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (calendarEvent.title ?? '') + ' ' + dateText,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(calendarEvent.description ?? '',
              style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final News news;

  NewsItem(this.news);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(news.header, style: Theme.of(context).textTheme.subtitle1),
          Text(news.intro, style: Theme.of(context).textTheme.bodyText2),
          Text(news.body, style: Theme.of(context).textTheme.bodyText1)
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final ChildNotification childNotification;

  const NotificationItem({Key key, this.childNotification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(childNotification.message, style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }
}
