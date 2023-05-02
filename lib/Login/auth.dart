bool localAuth({
  required String login,
  required String password,
}) {
  if (login == 'admin' && password == '123') {
    return true;
  }else if (login == 'sajid' && password == '123') {
    return true;
  }else if (login == 'nadeem' && password == '123') {
    return true;
  } else {
    return false;
  }
}