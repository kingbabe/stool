// make a path into regex

/// use this patter to match like '/:id' path params pattern
RegExp ParamPattern = new RegExp('(/:[a-z0-9]*)');
const PatternReplace = '/([a-z0-9]*)';

class PathToRegex {

  String path;
  List<String> paramName = [];
  bool containsPathParam = false;
  RegExp pattern;

  PathToRegex(path) {
    this.path = path;
    _searchParamPatterns();
  }

  void _searchParamPatterns() {
    Iterable<Match> matches = ParamPattern.allMatches(this.path);
    if (matches.length == 0) {
      this.pattern = new RegExp(this.path);
      return;
    }
    this.containsPathParam = true;
    var targetPattern = this.path;
    matches.forEach((match) {
      var pattern = match.group(1);
      this.paramName.add(pattern.replaceAll('/:', ''));
      targetPattern.replaceAll(pattern, PatternReplace);
    });
    this.pattern = new RegExp(targetPattern);
  }

  /// judge if given path full matches this patter
  bool match(Uri url) {
    Iterable<Match> matches = this.pattern.allMatches(url.path);
    if (matches.length == 0) {
      return false;
    }
    Match fullMatch = matches.first;
    return fullMatch.start == 0 && fullMatch.end == url.path.length;
  }

  /// get params from path
  Map<String, String> getPathParams(Uri url) {
    Iterable<Match> matches = this.pattern.allMatches(url.path);
    Match match = matches.first;
    if (match == null) {
      return null;
    }
    Map<String, String> params = {};
    int count = match.groupCount;
    for (var i = 1; i <= count; i++) {
      var value = match.group(i);
      params[this.paramName[i]] = value;
    }
    return params;
  }

}