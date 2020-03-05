import 'package:flutter/material.dart';

typedef OnPage<T> = void Function(PageRoute<T> value);

class SimpleRouteObserver<T> extends RouteObserver<PageRoute<T>> {
  final OnPage<T> onPage;
  SimpleRouteObserver({OnPage<T> onPage}) : onPage = onPage ?? emptyOnPage;

  static void emptyOnPage<T>(PageRoute<T> page) {
    print("emptyOnPage: ${page.settings.name}");
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      onPage(route);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      onPage(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      onPage(previousRoute);
    }
  }
}
