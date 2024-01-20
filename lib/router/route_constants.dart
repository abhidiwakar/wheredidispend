const rootRoute = '/';
const authRoute = '/auth';
const homeRoute = '/home';
const addTransactionRoute = '/add-transaction';
const attachmentsRoute = '/add-transaction';

enum AppRoute {
  root("/", "root"),
  update("/update", "update"),
  auth("/auth", "auth"),
  home("/home", "home"),
  addTransaction("/add-transaction", "addTransaction"),
  viewTransaction("/view-transaction/:id", "viewTransaction"),
  attachments("/attachments", "attachments"),
  profile("/profile", "profile");

  const AppRoute(this.route, this.name);
  final String route;
  final String name;
}
